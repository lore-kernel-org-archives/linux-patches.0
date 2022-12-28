Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DFC1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C910C433EF;
	Wed, 28 Dec 2022 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240295;
	bh=I7nJACedxh6KJMSSqJkUwp5sqHO845JjgFB6MA02BMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq5Msx1u+Z8wcoWJUF4z0gGGlGAO7i9mjX2t/fUU3MpT6tu7hEzwu3Q/YjXPzdQxX
	 kjwi2u0S3qBgLxGBULSNod3g5qpajjyTkl/m5OHb1jIGyr2U/rtFDcp6zUz589NltH
	 FnAga+Uo3WflfM+odMKv4ETGkgKTSlFwKwDv4I5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/731] net: emaclite: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:37:20 +0100
Message-Id: <20221228144306.223146113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d1678bf45f21fa5ae4a456f821858679556ea5f8 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in xemaclite_tx_timeout() to
drop the SKB, when tx timeout, so replace it with dev_kfree_skb_irq().

Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 97c1d1ecba34..b1971c4d5313 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -543,7 +543,7 @@ static void xemaclite_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	xemaclite_enable_interrupts(lp);
 
 	if (lp->deferred_skb) {
-		dev_kfree_skb(lp->deferred_skb);
+		dev_kfree_skb_irq(lp->deferred_skb);
 		lp->deferred_skb = NULL;
 		dev->stats.tx_errors++;
 	}
-- 
2.35.1



