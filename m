Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C81B29B8D0;
	Wed, 20 May 2026 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301495; cv=none; b=NnT5064bJgdGAFy1+MDbwPsT1+yylCDnWbobunWzp5wnoOJFkJJ1MyZl9V+VGicAn6skdM30rLjPf88k4D4ozmxyxa1sm1ApWExSa7nr3BZfI8MHiBHxJ0BJuhQz+PSOR6us32t+h4/0JwMczE9bvrSRonCpyAhqf0q9BMy7llQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301495; c=relaxed/simple;
	bh=3P4lfpQL9Wz2qOHqEPFA0Sfk+e+DZmomP7M+PwRObqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyq2ZGD1rpHF/DBEos5EnqHrG5pa+pMHj4z3KMMz+PB4Mjmcme1hsYOBsTVccZCR23ZxmAey28o+DgL5cdnOwclTEE10X0AG9Vx5CyslLqIn65qEC1ZNRZ1QDj/gcmCvzmD7XNQ7h9e4xztJzC/tPc1f++RoJSk9Q6WcKVoeWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHW4ybRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHW4ybRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A0E1F000E9;
	Wed, 20 May 2026 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301494;
	bh=/w8xr8WDzD/cu3hZkWQyY8b5c8aaUgPmECaYca8jtqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHW4ybRHR+WOezQYwtjzj4RL3fnFv0N9TnDS+wG4DdWpZUYWoM3DhEYPqwQkLUok8
	 f8f1RQT2NtaFpxW8gPPywefvba5mXvcnY8ZRYwyk8AzWe8k1JnI1qUqfERqnNhE2gX
	 EL7YjMFxhFZC60sIgTFRAA/1RpkE9GN2m6IUlwPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moritz Klammler <Moritz.Klammler@ferchau.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/666] futex: Prevent lockup in requeue-PI during signal/ timeout wakeup
Date: Wed, 20 May 2026 18:23:08 +0200
Message-ID: <20260520162123.773092756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

[ Upstream commit bc7304f3ae20972d11db6e0b1b541c63feda5f05 ]

During wait-requeue-pi (task A) and requeue-PI (task B) the following
race can happen:

     Task A                             Task B
  futex_wait_requeue_pi()
    futex_setup_timer()
    futex_do_wait()
                                   futex_requeue()
                                        CLASS(hb, hb1)(&key1);
                                        CLASS(hb, hb2)(&key2);
        *timeout*
    futex_requeue_pi_wakeup_sync()
        requeue_state = Q_REQUEUE_PI_IGNORE

    *blocks on hb->lock*

                                        futex_proxy_trylock_atomic()
                                          futex_requeue_pi_prepare()
                                            Q_REQUEUE_PI_IGNORE => -EAGAIN
                                        double_unlock_hb(hb1, hb2)
                                         *retry*

Task B acquires both hb locks and attempts to acquire the PI-lock of the
top most waiter (task B). Task A is leaving early due to a signal/
timeout and started removing itself from the queue. It updates its
requeue_state but can not remove it from the list because this requires
the hb lock which is owned by task B.

Usually task A is able to swoop the lock after task B unlocked it.
However if task B is of higher priority then task A may not be able to
wake up in time and acquire the lock before task B gets it again.
Especially on a UP system where A is never scheduled.

As a result task A blocks on the lock and task B busy loops, trying to
make progress but live locks the system instead. Tragic.

This can be fixed by removing the top most waiter from the list in this
case. This allows task B to grab the next top waiter (if any) in the
next iteration and make progress.

Remove the top most waiter if futex_requeue_pi_prepare() fails.
Let the waiter conditionally remove itself from the list in
handle_early_requeue_pi_wakeup().

Fixes: 07d91ef510fb1 ("futex: Prevent requeue_pi() lock nesting issue on RT")
Reported-by: Moritz Klammler <Moritz.Klammler@ferchau.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260428103425.dywXyPd3@linutronix.de
Closes: https://lore.kernel.org/all/VE1PR06MB6894BE61C173D802365BE19DFF4CA@VE1PR06MB6894.eurprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/requeue.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/requeue.c b/kernel/futex/requeue.c
index 559aae55792c6..f4a69942780f6 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -309,8 +309,11 @@ futex_proxy_trylock_atomic(u32 __user *pifutex, struct futex_hash_bucket *hb1,
 		return -EINVAL;
 
 	/* Ensure that this does not race against an early wakeup */
-	if (!futex_requeue_pi_prepare(top_waiter, NULL))
+	if (!futex_requeue_pi_prepare(top_waiter, NULL)) {
+		plist_del(&top_waiter->list, &hb1->chain);
+		futex_hb_waiters_dec(hb1);
 		return -EAGAIN;
+	}
 
 	/*
 	 * Try to take the lock for top_waiter and set the FUTEX_WAITERS bit
@@ -711,10 +714,12 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 
 	/*
 	 * We were woken prior to requeue by a timeout or a signal.
-	 * Unqueue the futex_q and determine which it was.
+	 * Conditionally unqueue the futex_q and determine which it was.
 	 */
-	plist_del(&q->list, &hb->chain);
-	futex_hb_waiters_dec(hb);
+	if (!plist_node_empty(&q->list)) {
+		plist_del(&q->list, &hb->chain);
+		futex_hb_waiters_dec(hb);
+	}
 
 	/* Handle spurious wakeups gracefully */
 	ret = -EWOULDBLOCK;
-- 
2.53.0



