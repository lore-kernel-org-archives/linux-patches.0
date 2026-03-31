Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C593FADEE;
	Tue, 31 Mar 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976003; cv=none; b=CUrc/hNA8UlHlCN750EX5koJJ1FzRGSoEQO0FTm5PNZnCLnI0YiIH288e7XJpUpqwHwPghzGdUc7E8NJE58zahqF0RBEAD4l02G18O0VI9WZ9sfTw9jX5LRImoZI1S+sup1OTQrlwjK0/kNODH2SozYvl1kkj2zZnbS1aQeoqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976003; c=relaxed/simple;
	bh=Xuk16ioh5O4EDLU9m8kgufJn9FCIHt3sgUgDvl3EmxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyKvkUlZlcdAI1Kc1gO4bT/aQTxq5bC9r7kfXkyaxLJgUmZ66ZKp5fqvcEUYfyD7n0iuU3/70rAHA3CioIM2cAVwlCJed2KUD1LiO5+/l5wL2HPCJF1XVu+9BpZGN9NrsYquIX379OWl/8kMA5Z4V2ETD+1MOe7XoyL7PBQIA9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKDic7zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKDic7zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274E4C19423;
	Tue, 31 Mar 2026 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976003;
	bh=Xuk16ioh5O4EDLU9m8kgufJn9FCIHt3sgUgDvl3EmxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKDic7zg6fJo9TBlcWu1qHXBr0bs7oQyufvlPVP/UfMGLphzznZp0CiR5ytrjLLo2
	 wOZ7q4wozKVlgVCs+Ss4CoWtKTsk0IkUOFVjwiK/2fiSdA2960m1QttRaxWT1I7SGU
	 kM2EHlnqC27RjV9YRzcX1vcmpEYOJTVee5ghgvOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 168/244] futex: Clear stale exiting pointer in futex_lock_pi() retry path
Date: Tue, 31 Mar 2026 18:21:58 +0200
Message-ID: <20260331161747.966509152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/futex/pi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -918,7 +918,7 @@ int fixup_pi_owner(u32 __user *uaddr, st
 int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to;
-	struct task_struct *exiting = NULL;
+	struct task_struct *exiting;
 	struct rt_mutex_waiter rt_waiter;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
@@ -933,6 +933,7 @@ int futex_lock_pi(u32 __user *uaddr, uns
 	to = futex_setup_timer(time, &timeout, flags, 0);
 
 retry:
+	exiting = NULL;
 	ret = get_futex_key(uaddr, flags, &q.key, FUTEX_WRITE);
 	if (unlikely(ret != 0))
 		goto out;


