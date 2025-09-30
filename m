Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4E2266B65;
	Tue, 30 Sep 2025 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244836; cv=none; b=Hik/+MpyB+7b9x8qErrE5ByqC/N9vmCZDxqlujmwbOn6tcQqZUZJqE8dHKy/40RxnNhHNlZ7IQQK/Rf1+EyEAxH1xGKMj+EMzou3vch3Qmjb/W336a3pbodcncvNpVFDNcDqRfhPoRQcOC6j62RZECiMpmXrYEwcDmOS/KZtNGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244836; c=relaxed/simple;
	bh=WFT4vWF/dGfLZhnHFePq3u7whD+7AxDNILCC9xMwut4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpnmMRPQpMQPytnFTKeEoglPfkgOno+Veg0hZimMqCL6FffSan4ZMeH3R2Z+YqdGRGjWzCm88NWw69nYyXXt3SlcAcd2xdsviqvWYKtH/rwklQSanIdEYpnvzc2GXAjRx45Vq7nrzBkSY9qV6xixbkYdkMEm4fEtl72dQtTooZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVnAWhT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVnAWhT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52767C4CEF0;
	Tue, 30 Sep 2025 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244835;
	bh=WFT4vWF/dGfLZhnHFePq3u7whD+7AxDNILCC9xMwut4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVnAWhT3M1we88hsNpREwEWttq+RBhlDLdAK2KNsGdIWha3m8JQTK5etNXbR9ZtWP
	 +VtklLDOyZuPkNFb1vDQkuC20eWEl4GMtSXxnc2jyl5Y/gnYEh0VnKOK9aPT+1QlMJ
	 DSqw9k/FjdKkGuBsAlmswX7Na+WqAsNkUK3LcpWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+034246a838a10d181e78@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 087/143] futex: Prevent use-after-free during requeue-PI
Date: Tue, 30 Sep 2025 16:46:51 +0200
Message-ID: <20250930143834.697535572@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c716a66f86929..d818b4d47f1ba 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -230,8 +230,9 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	q->key = *key;
+	struct task_struct *task;
 
+	q->key = *key;
 	__futex_unqueue(q);
 
 	WARN_ON(!q->rt_waiter);
@@ -243,10 +244,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	futex_hash_get(hb);
 	q->drop_hb_ref = true;
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



