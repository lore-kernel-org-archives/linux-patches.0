Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C45C3016F5;
	Tue, 31 Mar 2026 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976771; cv=none; b=FQj0L4Th85pRIM1kfBxbJgxGgbnupgI6SDCrpu/SaxIZO84LjQQIotCRn3K6XsgiWWribmm+nEjcBYvgP1tjSawIJi7G4A42kJHpxHXDMjT+F0Pv01v4SeD96i+9cYzY1/6SC7J69Lt+SKhNanaPPFKY+tBrIWaYWw6E4xxyMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976771; c=relaxed/simple;
	bh=ENUE9xtaYb1AlewVyyQ/Z5KJhTb9x6/ogTAzrKw6woY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGou0WKqs9+3h6bvjcOFiMwb7zxI/W2oK/7sN9+Gieh9hDhNlr9WAbPF8k1YNUYpZTa6Pv5oPvqaWVEbxI7OE/43kP2fY6g1mJ4sh4n1T4ffebgCMXQZQOIPoMU4qlV/viAPrvTfF9sJr95/TKFMwT1PEzGI6U3GEeMZV/KGw8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWt4/SYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWt4/SYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D1C19423;
	Tue, 31 Mar 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976771;
	bh=ENUE9xtaYb1AlewVyyQ/Z5KJhTb9x6/ogTAzrKw6woY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWt4/SYSQoVO/Qk90YZrwmrKzcTE2m9wazpv0Y4Oxktyp+FJCWV8W/V6e8aljxfGH
	 +obO0QHr3q5ykgu7+Mq9Iw+4CamGGDOw7A/ImO3qn/bKUX1SNXR//jekr8gDNd9b/4
	 vuirlhYx8kJwQHMnbXIIj6RceNIg0UjHg2y7Vkuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 221/309] net: macb: Use dev_consume_skb_any() to free TX SKBs
Date: Tue, 31 Mar 2026 18:22:04 +0200
Message-ID: <20260331161801.581452642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Kevin Hao <haokexin@gmail.com>

commit 647b8a2fe474474704110db6bd07f7a139e621eb upstream.

The napi_consume_skb() function is not intended to be called in an IRQ
disabled context. However, after commit 6bc8a5098bf4 ("net: macb: Fix
tx_ptr_lock locking"), the freeing of TX SKBs is performed with IRQs
disabled. To resolve the following call trace, use dev_consume_skb_any()
for freeing TX SKBs:
   WARNING: kernel/softirq.c:430 at __local_bh_enable_ip+0x174/0x188, CPU#0: ksoftirqd/0/15
   Modules linked in:
   CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 7.0.0-rc4-next-20260319-yocto-standard-dirty #37 PREEMPT
   Hardware name: ZynqMP ZCU102 Rev1.1 (DT)
   pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : __local_bh_enable_ip+0x174/0x188
   lr : local_bh_enable+0x24/0x38
   sp : ffff800082b3bb10
   x29: ffff800082b3bb10 x28: ffff0008031f3c00 x27: 000000000011ede0
   x26: ffff000800a7ff00 x25: ffff800083937ce8 x24: 0000000000017a80
   x23: ffff000803243a78 x22: 0000000000000040 x21: 0000000000000000
   x20: ffff000800394c80 x19: 0000000000000200 x18: 0000000000000001
   x17: 0000000000000001 x16: ffff000803240000 x15: 0000000000000000
   x14: ffffffffffffffff x13: 0000000000000028 x12: ffff000800395650
   x11: ffff8000821d1528 x10: ffff800081c2bc08 x9 : ffff800081c1e258
   x8 : 0000000100000301 x7 : ffff8000810426ec x6 : 0000000000000000
   x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
   x2 : 0000000000000008 x1 : 0000000000000200 x0 : ffff8000810428dc
   Call trace:
    __local_bh_enable_ip+0x174/0x188 (P)
    local_bh_enable+0x24/0x38
    skb_attempt_defer_free+0x190/0x1d8
    napi_consume_skb+0x58/0x108
    macb_tx_poll+0x1a4/0x558
    __napi_poll+0x50/0x198
    net_rx_action+0x1f4/0x3d8
    handle_softirqs+0x16c/0x560
    run_ksoftirqd+0x44/0x80
    smpboot_thread_fn+0x1d8/0x338
    kthread+0x120/0x150
    ret_from_fork+0x10/0x20
   irq event stamp: 29751
   hardirqs last  enabled at (29750): [<ffff8000813be184>] _raw_spin_unlock_irqrestore+0x44/0x88
   hardirqs last disabled at (29751): [<ffff8000813bdf60>] _raw_spin_lock_irqsave+0x38/0x98
   softirqs last  enabled at (29150): [<ffff8000800f1aec>] handle_softirqs+0x504/0x560
   softirqs last disabled at (29153): [<ffff8000800f2fec>] run_ksoftirqd+0x44/0x80

Fixes: 6bc8a5098bf4 ("net: macb: Fix tx_ptr_lock locking")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260321-macb-tx-v1-1-b383a58dd4e6@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1108,7 +1108,7 @@ static void macb_tx_unmap(struct macb *b
 	}
 
 	if (tx_skb->skb) {
-		napi_consume_skb(tx_skb->skb, budget);
+		dev_consume_skb_any(tx_skb->skb);
 		tx_skb->skb = NULL;
 	}
 }


