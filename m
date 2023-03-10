Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D37847D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF2C433EF;
	Fri, 10 Mar 2023 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455954;
	bh=fYb8+l0hrrk0Jwm3RFGyewuODzOuVzizMzIt76nAau4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCDnYzjoDU0pZm8JReQfJhcQyiGQaA0fVdN+irVfufQMGCQQqnoB1VTxL4tR4hZVU
	 ppGsAsVcUS5b/R7+6fD6NP1aj5K28l4J1/l3kYpicdGufI8JbL7rX9AG/zqQkdxawq
	 mWZDWbuwqNlEZHC9G/AM3nw1jMmNvsrZhtSX987M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/193] wifi: libertas: main: dont call kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:36:52 +0100
Message-Id: <20230310133711.955602275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

[ Upstream commit f393df151540bf858effbd29ff572ab94e76a4c4 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: d2e7b3425c47 ("libertas: disable functionality when interface is down")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150008.111743-4-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index feb204cd74a9a..21816f0e9e930 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -216,7 +216,7 @@ int lbs_stop_iface(struct lbs_private *priv)
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->iface_running = false;
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
2.39.2



