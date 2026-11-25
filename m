Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622396;
	b=yLrI+gGCNN9nu/nC5gckaFMKeHjqzsSeVlnRIHWd79uNBuHNPZFbuozpIhGL7laj7kcu
	 W+vrzyV6r+eqHvjux5UVVPkXBMXUBNnSOo4fDvRyJnx8JrKchXg1qdnskZHZ/xYCThLAC
	 d2mhlKr1PSzkumzVaVrYtnbPZdljf75adusqhX2V2izOBBK/W8uvFZFT3fq/kV/u+HBNR
	 L58mz/CzD+2SS1VGmxAsP/Zfjpl4Ae42W1Odrs9eZk6eEvcIEvUFkHOT6dZYsXNGE4Ho5
	 ENXnfC/x90NLx9UPkikT4yHZANEAtZVM6lon4ymXT1tql/2m+EY4aFomRdJPb8cbMXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uBtlrLLAmYGGb8QYWLatnvCN11LTo94Gf2J3QIdehzg=;
	b=nUBmE2DJ8XdkzoEcuo9+SNlmBzFHBU8FulUeCjsydf9ALRSQUPooJpOGIs1TPiAP1/y/
	 M9sV5Md0UX5p/5P44g4v4R8VjEWBGMYBQlBB4Er70UuHB5cSVsSxc1A9FRMbgCRkUKso9
	 6E6LNVRQD/KV2BNj3c6vhAgn+zDadEQaVvGzfSmwfkd0pMqzG5hE0T9PKCzkzW00vwBiN
	 cqa+DB81owj63Fy59GiRBu7LvmiRaY7uhiOaAfGNm6S3w0SvsWCQG07FmjL/H9EaFoWvq
	 aakVZh2g24JgJydcWD4+HTjUo31SA2ZeAgca8PoJoxDigwbhJHn98hdf/aYa2+ejxaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksvjbjAX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA54606A326;
	Wed, 25 Nov 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksvjbjAX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C6B1F000C4;
	Wed, 25 Nov 2026 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622396;
	bh=uBtlrLLAmYGGb8QYWLatnvCN11LTo94Gf2J3QIdehzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksvjbjAXpK2Llm1sZ7TE1fh9MZvNhp1TQIjLjA8uAXQqlgdNHG07Zg00ww5Ov0OHE
	 uMu/58Z74nZqMmyZvx3OjpcufFwumgPwlwWz/XSDeOC6dTbU5LnelEKPW0TYdCwmr5
	 BW3XP+Sy6KD4SnOb0+OKiBsvRK4Zu5zBeY7iPj2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/990] wifi: rtl8xxxu: unwind incomplete receive startup
Date: Wed, 25 Nov 2026 15:31:31 +0100
Message-ID: <20261125143834.369450570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Wooseok <5mghybrid@khu.ac.kr>

[ Upstream commit 4c58fb8944a2cfbe5506534de0cf58646408d31a ]

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, the error path frees the TX pool but leaves earlier RX
requests active. A partial TX or RX allocation failure can also leave
ret at zero, so start reports success despite the incomplete setup.

Allocate the RX pool before submitting any of it, and return ENOMEM
whenever a pool allocation fails. Pass start errors through
rtl8xxxu_stop(), including interrupt URB submission failures, so the
existing stop path cancels work and releases both active requests and
partially allocated pools.

Share the submission loop with the RX worker. Both callers keep requests
that fail with ENOMEM/EAGAIN. For a fatal error during startup, free the
rest of the unsubmitted batch and return the error so start can unwind.
In the worker, free only the failed request and continue with the rest
of the batch.

Keep the allocation loop in a small helper so the setup and error paths
in start remain easy to follow.

On an RTL8192EU, I exercised every error exit in rtl8xxxu_start()
except interrupt-URB allocation and submission failures, which this
adapter does not use.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260921-codex-rtl-rx-v3-submit-v4-2-eeb09fe8f791@khu.ac.kr
[ sashal: Replaced kmalloc_obj(struct ...) calls with the older kmalloc(sizeof(struct ...), GFP_KERNEL) form, since the kmalloc_obj macro doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 96 +++++++++++---------
 1 file changed, 54 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 0f3f10dbfc541..c7e46445545af 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -61,6 +61,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to di
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
 
+static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend);
 static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb);
 
@@ -5880,6 +5881,28 @@ static void rtl8xxxu_free_rx_resources(struct rtl8xxxu_priv *priv)
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
+static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb;
+	int i;
+
+	/* No RX work is active until the complete pool has been allocated. */
+	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
+		rx_urb = kmalloc(sizeof(struct rtl8xxxu_rx_urb), GFP_KERNEL);
+		if (!rx_urb)
+			return -ENOMEM;
+
+		usb_init_urb(&rx_urb->urb);
+		INIT_LIST_HEAD(&rx_urb->list);
+		rx_urb->hw = priv->hw;
+
+		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
+		priv->rx_urb_pending_count++;
+	}
+
+	return 0;
+}
+
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb)
 {
@@ -5907,32 +5930,21 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
-static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 {
-	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
-	struct list_head local;
 	unsigned long flags;
+	LIST_HEAD(local);
 	int ret;
 
-	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
-	INIT_LIST_HEAD(&local);
-
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
-
 	list_splice_init(&priv->rx_urb_pending_list, &local);
 	priv->rx_urb_pending_count = 0;
-
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
 	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
 		list_del_init(&rx_urb->list);
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		/*
-		 * If out of memory or temporary error, put it back on the
-		 * queue and try again. Otherwise the device is dead/gone
-		 * and we should drop it.
-		 */
 		switch (ret) {
 		case 0:
 			break;
@@ -5941,11 +5953,29 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
+			usb_free_urb(&rx_urb->urb);
+			if (startup)
+				goto free_remaining;
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			usb_free_urb(&rx_urb->urb);
 		}
 	}
+
+	return 0;
+
+free_remaining:
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del(&rx_urb->list);
+		usb_free_urb(&rx_urb->urb);
+	}
+	return ret;
+}
+
+static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+{
+	struct rtl8xxxu_priv *priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+
+	rtl8xxxu_submit_rx_urbs(priv, false);
 }
 
 /*
@@ -7452,7 +7482,6 @@ static void rtl8xxxu_watchdog_callback(struct work_struct *work)
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	unsigned long flags;
 	int ret, i;
@@ -7467,14 +7496,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts) {
 		ret = rtl8xxxu_submit_int_urb(hw);
 		if (ret)
-			goto exit;
+			goto error_out;
 	}
 
 	for (i = 0; i < RTL8XXXU_TX_URBS; i++) {
 		tx_urb = kmalloc(sizeof(struct rtl8xxxu_tx_urb), GFP_KERNEL);
 		if (!tx_urb) {
-			if (!i)
-				ret = -ENOMEM;
+			ret = -ENOMEM;
 
 			goto error_out;
 		}
@@ -7485,31 +7513,21 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		priv->tx_urb_free_count++;
 	}
 
+	ret = rtl8xxxu_alloc_rx_urbs(priv);
+	if (ret)
+		goto error_out;
+
 	priv->tx_stopped = false;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
 	priv->shutdown = false;
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
-	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
-		rx_urb = kmalloc(sizeof(struct rtl8xxxu_rx_urb), GFP_KERNEL);
-		if (!rx_urb) {
-			if (!i)
-				ret = -ENOMEM;
-
-			goto error_out;
-		}
-		usb_init_urb(&rx_urb->urb);
-		INIT_LIST_HEAD(&rx_urb->list);
-		rx_urb->hw = hw;
-
-		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret)
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-	}
+	ret = rtl8xxxu_submit_rx_urbs(priv, true);
+	if (ret)
+		goto error_out;
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-exit:
 	/*
 	 * Accept all data and mgmt frames
 	 */
@@ -7522,13 +7540,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	return ret;
 
 error_out:
-	rtl8xxxu_free_tx_resources(priv);
-	/*
-	 * Disable all data and mgmt frames
-	 */
-	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
-	rtl8xxxu_write16(priv, REG_RXFLTMAP0, 0x0000);
-
+	rtl8xxxu_stop(hw, false);
 	return ret;
 }
 
-- 
2.53.0



