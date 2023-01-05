Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0C56ADF
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D95C433F0;
	Thu,  5 Jan 2023 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923697;
	bh=S5FNC1iDfujKv5/sd6WJLV5zFp+gmWZbzkXfNR2onME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmssJtgoOW2r5GlntSf+bgegWsNByztAeHqx1USliB5tf2VVo7BP32HcTfFtSHd7I
	 5qZf20i86ruP66er2mu6O8GOnwsjXMNkXisjrK4p26YyLkEKeLZuKj6KwDbbvZG1IX
	 I/ajDmqS0PnBa4afw672c40jFoLDdfKbWWbJ8r1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 104/251] net: emaclite: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Thu,  5 Jan 2023 13:54:01 +0100
Message-Id: <20230105125339.598484751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index cdcc86060749..99c7872504fe 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -537,7 +537,7 @@ static void xemaclite_tx_timeout(struct net_device *dev)
 	xemaclite_enable_interrupts(lp);
 
 	if (lp->deferred_skb) {
-		dev_kfree_skb(lp->deferred_skb);
+		dev_kfree_skb_irq(lp->deferred_skb);
 		lp->deferred_skb = NULL;
 		dev->stats.tx_errors++;
 	}
-- 
2.35.1



