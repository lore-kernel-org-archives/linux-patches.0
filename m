Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78409881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A203EC433A0;
	Fri, 10 Mar 2023 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459626;
	bh=CLrIDpY1AvUvg/+7PZJhkmOq5FDpaiQ2Q31wMp+HxoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhbGaJy1ON7VaTjGT6bEVarLFSBS15WRA12UNXRVJCixefqEWzIlm0GKMEc21k112
	 hFb+AMrfqi4whoETJNdXk4WORJemvqMt3uVLEBcK3Jd+rTaWNrFzvmj60BCJZOSrQY
	 x6V5xHJjTd4DtYRpC/g4BKzUUt8kIIkKM+CG/uDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/529] wifi: libertas: cmdresp: dont call kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:33:30 +0100
Message-Id: <20230310133808.083993708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 708a49a64237f19bd404852f297aaadbc9e7fee0 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: f52b041aed77 ("libertas: Add spinlock to avoid race condition")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150008.111743-5-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cmdresp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/cmdresp.c b/drivers/net/wireless/marvell/libertas/cmdresp.c
index cb515c5584c1f..74cb7551f4275 100644
--- a/drivers/net/wireless/marvell/libertas/cmdresp.c
+++ b/drivers/net/wireless/marvell/libertas/cmdresp.c
@@ -48,7 +48,7 @@ void lbs_mac_event_disconnected(struct lbs_private *priv,
 
 	/* Free Tx and Rx packets */
 	spin_lock_irqsave(&priv->driver_lock, flags);
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
2.39.2



