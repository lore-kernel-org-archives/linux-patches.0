Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46344BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F162C433EF;
	Tue,  7 Mar 2023 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212326;
	bh=nfiPZBITQwwzYfDU1ad7LkVzxZhDOaYxUcVtx77DVUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c3Y+3JaQePzbc8lpXHrHbIcpUNDR7dHX+Rb+dXyePAFO1SEEo/Y35YH20HzxZ+Ge
	 mS5rcBIvH/4sBH3JHveaE06YRhgM+iL8rdRoUhqQGZXuzgxvvIyBWJOEnBxOjIEy/j
	 vTR4ttJVPSOkpUKLH5+VFvEzyyL9qOQDoDUy7ZCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/885] wifi: rtlwifi: rtl8188ee: dont call kfree_skb() under spin_lock_irqsave()
Date: Tue,  7 Mar 2023 17:50:53 +0100
Message-Id: <20230307170007.035960186@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 2611687fa7ffc84190f92292de0b80468de17220 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. All the SKBs have
been dequeued from the old queue, so it's safe to enqueue these
SKBs to a free queue, then free them after spin_unlock_irqrestore()
at once. Compile tested only.

Fixes: 7fe3b3abb5da ("rtlwifi: rtl8188ee: rtl8821ae: Fix a queue locking problem")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207141411.46098-3-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 58c2ab3d44bef..de61c9c0ddec4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -68,8 +68,10 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -79,10 +81,12 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
 						true, HW_DESC_TXBUFF_ADDR),
 				 skb->len, DMA_TO_DEVICE);
-		kfree_skb(skb);
+		__skb_queue_tail(&free_list, skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	__skb_queue_purge(&free_list);
 }
 
 static void _rtl88ee_disable_bcn_sub_func(struct ieee80211_hw *hw)
-- 
2.39.2



