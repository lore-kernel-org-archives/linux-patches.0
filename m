Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82E5BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199E2C433EF;
	Tue,  7 Mar 2023 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214898;
	bh=yfnPnX6TfrFw54guY24pUae7JhX23F/1mVS0t+IrFrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V28iV9iiE4PcsZA25vEQwl7ntyGFwx6PnS1k+fTvP7/1EF1JDLk3ZPg4K6az6I0Yq
	 SclGH2afYLsx/IcGiRgE370ho2yJ6mOYaJFWSes0aAAOZYKjcbmDtNOrP0I1Eo9GJD
	 +bWgIVqZEUDJjBZoa/Y//MkH8sZXWvmAMhL6JEIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/567] wifi: wl3501_cs: dont call kfree_skb() under spin_lock_irqsave()
Date: Tue,  7 Mar 2023 17:57:00 +0100
Message-Id: <20230307165909.508262739@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 672f5d5f3f2c7..cb71b73853f4e 100644
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



