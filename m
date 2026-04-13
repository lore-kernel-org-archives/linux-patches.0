Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F18D328255;
	Mon, 13 Apr 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099447; cv=none; b=mWFSfey2CFZcHzi1j6CjOYotYmXOj4G/z1ZhSu7aDV9EpjmRh/YVoAWe8TF7Qv9htMdd+0FUYBUGGG0Q1hG/c8f4iQJhhQAo+T3jZqOc1acCJhrBaaUkazXhQryGrswnsWc3eLgVE2Ygy6v67PkpwaH8QIpG1WsjEMRCIIQOauk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099447; c=relaxed/simple;
	bh=27rknvOs6r6Ei4ETSGt6AC2D0LqTfMmu8QGxEpoNEBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huQ/idsInCZxu8qQNoOnjgDiLUNTcoj5vhV2/P4qxWU8O0SwRIfBAMkenpw2hhBVCdS+CrrExb8H6odXzWXFctMhPc+NPhotdJ8SOGIFULJeuUU+zsrwlvoc2V0NQDr8fB9gG3VzwwnFSRA0BPiDI98R+3FrQfcwVDsysriOwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq73lOT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq73lOT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142AFC2BCAF;
	Mon, 13 Apr 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099447;
	bh=27rknvOs6r6Ei4ETSGt6AC2D0LqTfMmu8QGxEpoNEBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iq73lOT9HsZg/ad/p90RKxkvtkyBNA047lxEpzomFisd7ynxmxEC1MtAlXNekvwEU
	 g2Z2pRs6rmrFLcQCSxZbn0mI4OiUjlqVSsrNR9BWTFuRi3cnLYK4Pp9gb/FkCCA9fC
	 I4vwrSBj+ThUdF5SmAG+Th9M5drx0fWmaU0w4srU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.10 316/491] futex: Clear stale exiting pointer in futex_lock_pi() retry path
Date: Mon, 13 Apr 2026 17:59:21 +0200
Message-ID: <20260413155830.868557573@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

commit 210d36d892de5195e6766c45519dfb1e65f3eb83 upstream.

Fuzzying/stressing futexes triggered:

    WARNING: kernel/futex/core.c:825 at wait_for_owner_exiting+0x7a/0x80, CPU#11: futex_lock_pi_s/524

When futex_lock_pi_atomic() sees the owner is exiting, it returns -EBUSY
and stores a refcounted task pointer in 'exiting'.

After wait_for_owner_exiting() consumes that reference, the local pointer
is never reset to nil. Upon a retry, if futex_lock_pi_atomic() returns a
different error, the bogus pointer is passed to wait_for_owner_exiting().

  CPU0			     CPU1		       CPU2
  futex_lock_pi(uaddr)
  // acquires the PI futex
  exit()
    futex_cleanup_begin()
      futex_state = EXITING;
			     futex_lock_pi(uaddr)
			       futex_lock_pi_atomic()
				 attach_to_pi_owner()
				   // observes EXITING
				   *exiting = owner;  // takes ref
				   return -EBUSY
			       wait_for_owner_exiting(-EBUSY, owner)
				 put_task_struct();   // drops ref
			       // exiting still points to owner
			       goto retry;
			       futex_lock_pi_atomic()
				 lock_pi_update_atomic()
				   cmpxchg(uaddr)
					*uaddr ^= WAITERS // whatever
				   // value changed
				 return -EAGAIN;
			       wait_for_owner_exiting(-EAGAIN, exiting) // stale
				 WARN_ON_ONCE(exiting)

Fix this by resetting upon retry, essentially aligning it with requeue_pi.

Fixes: 3ef240eaff36 ("futex: Prevent exit livelock")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260326001759.4129680-1-dave@stgolabs.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -2785,9 +2785,9 @@ static int futex_lock_pi(u32 __user *uad
 			 ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to;
-	struct task_struct *exiting = NULL;
 	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
+	struct task_struct *exiting;
 	struct futex_q q = futex_q_init;
 	int res, ret;
 
@@ -2800,6 +2800,7 @@ static int futex_lock_pi(u32 __user *uad
 	to = futex_setup_timer(time, &timeout, FLAGS_CLOCKRT, 0);
 
 retry:
+	exiting = NULL;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, FUTEX_WRITE);
 	if (unlikely(ret != 0))
 		goto out;


