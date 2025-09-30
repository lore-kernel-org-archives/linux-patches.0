Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B69D1C862F;
	Tue, 30 Sep 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245935; cv=none; b=idTjq3KaOp1XA2SrWo5LMPaDYzE0A+z14twaMvliOUG8yBfzSp6ggOLwfFdONO4h3/NZzLqbe/FxbV1zzCPDg9jYtSCm4PWRjTM6Dwe9Uc1XhfOb0isUlfkO2+zALy/lXzrC+9T/cA12HVd9FGgtSaLXZORfkoDi7VQue4zx3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245935; c=relaxed/simple;
	bh=72mF+jZLtcXJyCidO79ilQSD3TZJ3l5BjJiqF9k9fN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz+1z2uc/7xSYp80bG1+ACE97nW9xKY296cFpVEYd2+bvnxtwgRsabTU8HBFZQ2gYPXx8U2hpnS8qBkQgexwPDd5UJttBn9uKSH3vc4PgCGNvgIpds58yW4/W4TddTpRe2Jy3I+MZsImXnpv2OJUqiMJAiQdXrQcwVY4wywn5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKjhPQxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKjhPQxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCF4C4CEF0;
	Tue, 30 Sep 2025 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245935;
	bh=72mF+jZLtcXJyCidO79ilQSD3TZJ3l5BjJiqF9k9fN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKjhPQxi4S/w8Z/NL0lVeajlfqdahd73pxylB33WEncVfRfatnFo2eVxUG/KoSxkN
	 laiAFIsJdseCK1bL1czfq7SawQTX114XyV/FR1on7Wlvl9Dm4uCwKeo17BhVigpTMa
	 s1F742zNILBHtW0gKR71vAVfX1TuOkGpxTbTmCaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+034246a838a10d181e78@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/91] futex: Prevent use-after-free during requeue-PI
Date: Tue, 30 Sep 2025 16:47:52 +0200
Message-ID: <20250930143823.392257689@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit b549113738e8c751b613118032a724b772aa83f2 ]

syzbot managed to trigger the following race:

   T1                               T2

 futex_wait_requeue_pi()
   futex_do_wait()
     schedule()
                               futex_requeue()
                                 futex_proxy_trylock_atomic()
                                   futex_requeue_pi_prepare()
                                   requeue_pi_wake_futex()
                                     futex_requeue_pi_complete()
                                      /* preempt */

         * timeout/ signal wakes T1 *

   futex_requeue_pi_wakeup_sync() // Q_REQUEUE_PI_LOCKED
   futex_hash_put()
  // back to userland, on stack futex_q is garbage

                                      /* back */
                                     wake_up_state(q->task, TASK_NORMAL);

In this scenario futex_wait_requeue_pi() is able to leave without using
futex_q::lock_ptr for synchronization.

This can be prevented by reading futex_q::task before updating the
futex_q::requeue_state. A reference on the task_struct is not needed
because requeue_pi_wake_futex() is invoked with a spinlock_t held which
implies a RCU read section.

Even if T1 terminates immediately after, the task_struct will remain valid
during T2's wake_up_state().  A READ_ONCE on futex_q::task before
futex_requeue_pi_complete() is enough because it ensures that the variable
is read before the state is updated.

Read futex_q::task before updating the requeue state, use it for the
following wakeup.

Fixes: 07d91ef510fb1 ("futex: Prevent requeue_pi() lock nesting issue on RT")
Reported-by: syzbot+034246a838a10d181e78@syzkaller.appspotmail.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Closes: https://lore.kernel.org/all/68b75989.050a0220.3db4df.01dd.GAE@google.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/requeue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex/requeue.c b/kernel/futex/requeue.c
index cba8b1a6a4cc2..7e43839ca7b05 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -223,18 +223,20 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	q->key = *key;
+	struct task_struct *task;
 
+	q->key = *key;
 	__futex_unqueue(q);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
 
 	q->lock_ptr = &hb->lock;
+	task = READ_ONCE(q->task);
 
 	/* Signal locked state to the waiter */
 	futex_requeue_pi_complete(q, 1);
-	wake_up_state(q->task, TASK_NORMAL);
+	wake_up_state(task, TASK_NORMAL);
 }
 
 /**
-- 
2.51.0



