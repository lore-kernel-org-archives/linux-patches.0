Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A2B44103A;
	Tue, 16 Jun 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625646; cv=none; b=M9U3DhTqOceCoWQOLZfXYyXZpE24Do3HtLVo0PKwKZcznSQxxaem+Cx4uC9klZ6Z4x01ObHBNAyOF3IF0TnqLRUUufSjXeeyWVmcDcFj0R1FIvpso8h0/Y9TPNPE2W4mXboOTDnWsplGXESekUsuDmT38Jexd/R9dCWY5NmSeak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625646; c=relaxed/simple;
	bh=IEwh28yTjw16iIeoBFbKumjFa9q0lGWfq6mKceQGY38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I20QrwW1QU/OCNdDJC5AwFLFcoKcfVAeWLXGR3+tKPGm0/FvZQJCbg4vBYb62kztU9tzzCTNA4hWXgc9NK3YROZ3wbqw8AIcGn+Llh2zwHFRSs50JPYYWLf7m2EWk9BY8JO8/T0UnrqfUCpDn1QczwnVunrvHbbGOr0H6c9KQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nw4D66X5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nw4D66X5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651751F00A3A;
	Tue, 16 Jun 2026 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625645;
	bh=gnI2k/PLc6HAQlNn2c8oh9fRT4U73r49fcy5eByTbM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nw4D66X5fEEcr55TvJgPEEjmJ28tt4GLe/Nyk5xtiHwB8EmZpPCDimpIr6/lqNTMp
	 WQ4CHTGRiOsUieftzwo2RhyCxV9xg3lMPwFSLmfrfsg4GSpT6P36pRH6rFY/7tUbB5
	 +jb2P58U7IaoyexfRF2xWHpPf2Q6355LwPr3w3zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hopps <chopps@labn.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 6.18 173/325] xfrm: iptfs: fix ABBA deadlock in iptfs_destroy_state()
Date: Tue, 16 Jun 2026 20:29:29 +0530
Message-ID: <20260616145106.468142306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristmd@gmail.com>

commit c8a8a75b733467b00c08b91a38dbaf207a08ed6e upstream.

iptfs_destroy_state() calls hrtimer_cancel() while holding a spinlock
that the timer callback also acquires, leading to an ABBA deadlock on
SMP systems.

For the output timer (iptfs_timer):
  - iptfs_destroy_state() holds x->lock, calls hrtimer_cancel()
  - iptfs_delay_timer() callback takes x->lock

For the drop timer (drop_timer):
  - iptfs_destroy_state() holds drop_lock, calls hrtimer_cancel()
  - iptfs_drop_timer() callback takes drop_lock

Both timers use HRTIMER_MODE_REL_SOFT, so their callbacks run in softirq
context.  When hrtimer_cancel() is called for a soft timer that is
currently executing on another CPU, hrtimer_cancel_wait_running() spins
on softirq_expiry_lock -- the same lock held by the softirq running the
callback.  If the callback is blocked waiting for the spinlock held by
the caller of hrtimer_cancel(), a circular dependency forms:

  CPU 0: holds lock_A -> waits for softirq_expiry_lock
  CPU 1: holds softirq_expiry_lock -> waits for lock_A

Fix by calling hrtimer_cancel() before acquiring the respective locks.
hrtimer_cancel() is safe to call without holding any lock and will wait
for any in-progress callback to complete.  For the output timer, the
lock is still acquired afterwards to drain the packet queue.  For the
drop timer, the lock/unlock pair is removed entirely since it only
existed to serialize with the timer callback, which hrtimer_cancel()
already guarantees.

Found by source code audit.

Fixes: 4b3faf610cc6 ("xfrm: iptfs: add new iptfs xfrm mode impl")
Cc: Christian Hopps <chopps@labn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2731,8 +2731,9 @@ static void iptfs_destroy_state(struct x
 	if (!xtfs)
 		return;
 
-	spin_lock_bh(&xtfs->x->lock);
 	hrtimer_cancel(&xtfs->iptfs_timer);
+
+	spin_lock_bh(&xtfs->x->lock);
 	__skb_queue_head_init(&list);
 	skb_queue_splice_init(&xtfs->queue, &list);
 	spin_unlock_bh(&xtfs->x->lock);
@@ -2740,9 +2741,7 @@ static void iptfs_destroy_state(struct x
 	while ((skb = __skb_dequeue(&list)))
 		kfree_skb(skb);
 
-	spin_lock_bh(&xtfs->drop_lock);
 	hrtimer_cancel(&xtfs->drop_timer);
-	spin_unlock_bh(&xtfs->drop_lock);
 
 	if (xtfs->ra_newskb)
 		kfree_skb(xtfs->ra_newskb);


