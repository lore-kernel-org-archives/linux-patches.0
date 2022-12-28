Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B51C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A77C433EF;
	Wed, 28 Dec 2022 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243779;
	bh=kDhZqVVieQ7PPbkPpid8jjAwTg/GQViheQJtOjGzJjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWx/LfUWIsj4ooRn11g61iywhsnhtbLBG3kuPW8Q2utmrHUuWeIUd6UNcatEhfIJp
	 jiZBtkpjztJh5MLb7+w4l2VfXfK1gEAU8J19snDJgb0tUEgKqZKtfyR82yd8FPzrHR
	 IUBiLHp2qRrzZ8+3FyjH8dxOiCBIkKiCqAwhR1QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0541/1146] net: ethernet: dnet: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:34:40 +0100
Message-Id: <20221228144344.867671199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit f07fadcbee2a5e84caa67c7c445424200bffb60b ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

In this case, the lock is used to protected 'bp', so we can move
dev_kfree_skb() after the spin_unlock_irqrestore().

Fixes: 4796417417a6 ("dnet: Dave DNET ethernet controller driver (updated)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 08184f20f510..151ca9573be9 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -550,11 +550,11 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	/* free the buffer */
 	dev_kfree_skb(skb);
 
-	spin_unlock_irqrestore(&bp->lock, flags);
-
 	return NETDEV_TX_OK;
 }
 
-- 
2.35.1



