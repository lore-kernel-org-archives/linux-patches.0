Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DCD2F5474;
	Tue, 11 Nov 2025 01:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825403; cv=none; b=sihvKAH0Qc+V7I1FI6QBeOLvkYKJHvHmZYYUqNV6g+F97D0lVvzI2Yz2hg42XHLEqnuaiTJ19OLew1aNBkxs4/coUSdHuxocHp8p+7YPdmhjhYW3VbW/7tbou+alUzYNbd3o2SbCj3sKrITXyULEjIcLzYqlMQ8aTeBw9c/IKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825403; c=relaxed/simple;
	bh=PaD6wkp3CaeF02jEslQpXRFDnQJQavtGamFX37ix8PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StLpkcRRrQNbdabmwWHiqC1zMoQiwbNKCWkOP+7hYMnwEx16T4zc3y/iOkwfPhD9Ny69zLmi5Iv0GVxQH2NROYjmK3j4X1/zZMCKAbmCogcIA11Tcc9eWrxK6O8ydm/amP9oJO2H80Gs9VOsxxRqa8yYrd7dunKE0YPsfAi+ewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEFQLsiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEFQLsiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F56C4CEFB;
	Tue, 11 Nov 2025 01:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825402;
	bh=PaD6wkp3CaeF02jEslQpXRFDnQJQavtGamFX37ix8PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEFQLsiEya7tFCkLIFQWJs5QoVbaR3RWuEUo3qlMo16D7tnvPJJ0r9NGz+KAERnIK
	 /aa+IaRFNG2J1cqvZTpQ5CedHpyqt7bx7R8AcgrBe4Y/EFkEDFDJJJrfR7GYPwX2wH
	 KxwRvM3mJaedqEB93QIGQapKjayQ2vUVDLOmb/BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 786/849] netpoll: Fix deadlock in memory allocation under spinlock
Date: Tue, 11 Nov 2025 09:45:56 +0900
Message-ID: <20251111004555.439027887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 327c20c21d80e0d87834b392d83ae73c955ad8ff ]

Fix a AA deadlock in refill_skbs() where memory allocation while holding
skb_pool->lock can trigger a recursive lock acquisition attempt.

The deadlock scenario occurs when the system is under severe memory
pressure:

1. refill_skbs() acquires skb_pool->lock (spinlock)
2. alloc_skb() is called while holding the lock
3. Memory allocator fails and calls slab_out_of_memory()
4. This triggers printk() for the OOM warning
5. The console output path calls netpoll_send_udp()
6. netpoll_send_udp() attempts to acquire the same skb_pool->lock
7. Deadlock: the lock is already held by the same CPU

Call stack:
  refill_skbs()
    spin_lock_irqsave(&skb_pool->lock)    <- lock acquired
    __alloc_skb()
      kmem_cache_alloc_node_noprof()
        slab_out_of_memory()
          printk()
            console_flush_all()
              netpoll_send_udp()
                skb_dequeue()
                  spin_lock_irqsave(&skb_pool->lock)     <- deadlock attempt

This bug was exposed by commit 248f6571fd4c51 ("netpoll: Optimize skb
refilling on critical path") which removed refill_skbs() from the
critical path (where nested printk was being deferred), letting nested
printk being called from inside refill_skbs()

Refactor refill_skbs() to never allocate memory while holding
the spinlock.

Another possible solution to fix this problem is protecting the
refill_skbs() from nested printks, basically calling
printk_deferred_{enter,exit}() in refill_skbs(), then, any nested
pr_warn() would be deferred.

I prefer this approach, given I _think_ it might be a good idea to move
the alloc_skb() from GFP_ATOMIC to GFP_KERNEL in the future, so, having
the alloc_skb() outside of the lock will be necessary step.

There is a possible TOCTOU issue when checking for the pool length, and
queueing the new allocated skb, but, this is not an issue, given that
an extra SKB in the pool is harmless and it will be eventually used.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: 248f6571fd4c51 ("netpoll: Optimize skb refilling on critical path")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251103-fix_netpoll_aa-v4-1-4cfecdf6da7c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 5f65b62346d4e..4ab154c614e33 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -228,19 +228,16 @@ static void refill_skbs(struct netpoll *np)
 {
 	struct sk_buff_head *skb_pool;
 	struct sk_buff *skb;
-	unsigned long flags;
 
 	skb_pool = &np->skb_pool;
 
-	spin_lock_irqsave(&skb_pool->lock, flags);
-	while (skb_pool->qlen < MAX_SKBS) {
+	while (READ_ONCE(skb_pool->qlen) < MAX_SKBS) {
 		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC);
 		if (!skb)
 			break;
 
-		__skb_queue_tail(skb_pool, skb);
+		skb_queue_tail(skb_pool, skb);
 	}
-	spin_unlock_irqrestore(&skb_pool->lock, flags);
 }
 
 static void zap_completion_queue(void)
-- 
2.51.0



