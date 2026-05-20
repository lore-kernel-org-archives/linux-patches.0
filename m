Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE775231842;
	Wed, 20 May 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297016; cv=none; b=rFMlS+lPPonq9BMITjZoygmDIT1uxK6HyGRR1DyO0YtRGPO7ghbqL2+SuQpwNs8zrllbohWwD/2apt2TMzAn8tNact9iCyjd0ZGb8o98AwG9z5NWJiX3RMxJfWz3RPClz8nCiw/68Zl/7/8o8ftGb+SNL1+KWjOodrsya3/tEB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297016; c=relaxed/simple;
	bh=B6/YJxuXHrs4Cpr/MeW21gxj6QN22aiDjVo028KzYU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgiAsWL5YVA4mz9DTVSjxqGxDz6+tpLUZ22++s62VVqjYkf2qfe5owJ8vUuliy7tlS8VnFsgcWKPLvmJwPMySstHRy3jf5guHbRdAqveZ25nocDoXNM63Yv0ZREVJM5vm5f19OoVsDoo7og5eAAgY5Id043BslLkWM7Rr9uIIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Fkm9U9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Fkm9U9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFD51F00893;
	Wed, 20 May 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297014;
	bh=h7RW88bCE9DR4E5HLOd2nrU7HQQ1RyutvVD8nMY+tus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Fkm9U9o1J3FsnrDSgn3fkOT7EbE41c2OiEzH7a+IN5vBEFjTXH4pFa7YqwuDDNgu
	 cP5Xfoc7Slvgk+8gRfDxPVdwTO0lFXYRWZOFrwZkFc+ZZ4UFeNGQc61ZVAC/8bpKRw
	 tDya00VorttRkO7vYTTc69+0jjrwyDYGT2Lwze3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moritz Klammler <Moritz.Klammler@ferchau.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1001/1146] futex: Prevent lockup in requeue-PI during signal/ timeout wakeup
Date: Wed, 20 May 2026 18:20:51 +0200
Message-ID: <20260520162210.887550220@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d818b4d47f1ba..b597cb3d17fc1 100644
--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -319,8 +319,11 @@ futex_proxy_trylock_atomic(u32 __user *pifutex, struct futex_hash_bucket *hb1,
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
@@ -722,10 +725,12 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 
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



