Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED3848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4115C433EF;
	Fri, 10 Mar 2023 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458469;
	bh=3ePIDLwD3Qu1A21fo0Q9MhMJmaacUPBYuEs5ui+dDu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqCamSS2gM6x2k+epfu+AUhY4o0YUUCVDqK5hsvUWeWFayge+D/5w++UqYa4oB5et
	 oFwkBoKtqSf0i6AR6LJ6oYPpETrfQ9IHpKI38GewpEzB5mBEI9F1244dve0mb5iLUi
	 BKiWVV0wZa6zSlXEA5vHdH455cbvNttyOyMk0LRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/357] wifi: rtl8xxxu: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:35:25 +0100
Message-Id: <20230310133735.598171680@linuxfoundation.org>
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

[ Upstream commit 4c2005ac87685907b3719b4f40215b578efd27c4 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called to free and drop the SKB when
it's shutdown, so replace it with dev_kfree_skb_irq(). Compile tested
only.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221208143517.2383424-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 0bc747489c55a..9278f4feff745 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5095,7 +5095,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 		pending = priv->rx_urb_pending_count;
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
-- 
2.39.2



