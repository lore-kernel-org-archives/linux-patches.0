Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE9B2FB0BE;
	Tue, 30 Sep 2025 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246137; cv=none; b=F1xevtfcob/RSiwHrTJCdtlue+pzKKb6vhqxLNnwhJTZOH7qh4374tm0DcwaNynIJ4U7sRQluAxwZWN84G9u4pcb/CcMFp7sn/oXHXI8c6vfH5Bxah+jy70mSpNsoqTIErp7+af+0666v2d8ro3o7rs0IGrJQMH1npXrLe1Vd8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246137; c=relaxed/simple;
	bh=WWFJR2S29oQJboZFW6MIPfkp7YZp9lhp4sgl2xI3mmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ppp2qa+Sxd4mppO8+2Wxq0Nt3xCD5QCSZPN1XGUOu+SaCPcLlHKLS76Bx5uBJz/KyE5W8QGpaMt5qXYYaVxVSTEn2wBXBh7ztvxC2icpIi3lag4BZ3abgObh1Iu7+MLrVe+OboWG/FObpjrXyz6y/u5ijDgOhblvYhmhm71HYnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6DB9X38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6DB9X38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48553C4CEF0;
	Tue, 30 Sep 2025 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246137;
	bh=WWFJR2S29oQJboZFW6MIPfkp7YZp9lhp4sgl2xI3mmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6DB9X38FBaN/hhBwOcqcI6xyI6LnWJH9f9grNS4DsHc3HVBkhDrtYfLuFGi+iO6q
	 noVp6xz+aF7XdquLQZkWjgniTVc3Sapc6W3YyzWlpPnhjTnR/q+QJ0J7ol5NU1QtRk
	 8GeDk2ZzJ/mptQJiWApket/0+dNJbwwq2kjY+1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+034246a838a10d181e78@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 62/89] futex: Prevent use-after-free during requeue-PI
Date: Tue, 30 Sep 2025 16:48:16 +0200
Message-ID: <20250930143824.483244991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
index b47bb764b3520..559aae55792c6 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -225,18 +225,20 @@ static inline
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



