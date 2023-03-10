Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C12848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45690C4339B;
	Fri, 10 Mar 2023 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458530;
	bh=nkRve9aclC+qspXjZwuZGXgI3thVPZkEDpijKOSznV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTeUyJD8G7Xjv3C8EYhzpGoWpFmrWekkl4JUgJfl5d+/T8HHUueuxlG0uOs0OL3UH
	 8DFKd+n6M4SrBYRe8c35njeajGfDKjyXr0bsB2l881M8uu1XodfAjygjMhVn7V+1iX
	 NKLvA8InZoQtmSfVDEHWL9Gjc7622M6yBbp/TFjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/357] wifi: wl3501_cs: dont call kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:35:39 +0100
Message-Id: <20230310133736.170782513@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 44bacbdf9066c590423259dbd6d520baac99c1a8 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150453.114742-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/wl3501_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 122d36439319c..8638c7c72bc30 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1328,7 +1328,7 @@ static netdev_tx_t wl3501_hard_start_xmit(struct sk_buff *skb,
 	} else {
 		++dev->stats.tx_packets;
 		dev->stats.tx_bytes += skb->len;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 
 		if (this->tx_buffer_cnt < 2)
 			netif_stop_queue(dev);
-- 
2.39.2



