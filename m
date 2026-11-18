Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036353;
	b=fEfckTGmpYf6gBgPG36lgyyDznZfcdV9oT6C5Bnr6df0mRUkIqv8UYjpWKduTZi6zfEw
	 iqfnDbqzD2r437fRNFnqjf8dcBZGEMFvSRRVqg8DFm1KcMmPwGwHBKhF41PfNof5hPuVO
	 xwhJaF27UjStB8UCZuv75569JBmkRv6c2lDlURem7BOHdhJVZz+pn3NdLJWsCQX6oi55W
	 LmE7GBL6eJB7UaZhFLyxLlTgVhsYbNKb4MH1ZfTxea2O2UU4xs91YGDPxrzVzBq6x/8ws
	 SbEA2qoQ4rfLN/4Au0Ol/ydM2XWar/MDg4HlD0FGwnvzM44rAi79S8BNWbkqZZu2b/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6vYElWmXv8U5vQxVvDHt9QsNcNSLw+NTW6aQcAadVo=;
	b=XD05euIUFN1DHfACDdz5EJjbmyCbSQBZqjZvZzA5pNP3tK6c0CxfhSOlNae1Zl5immqh
	 qjxvMHDiXiJnlz9X5Sy2z2HrA7gEEWHKz0llRJZeIgCR4Br0HvRJ3SXGHFa+vb68XEcjB
	 J11tdo8PU2aJXrEDkGQ7KI6zES0txVXBVaJVL7mKd4VTH06bsJRwSuDyEXxYe8VReGAv/
	 Fab5VTSC08pmaSVBIyavoRhQqBgeUoKUzQtxvS+TRI9uwR085G2xVUWsDkLLFYpGsKQ7g
	 ppK7S7CHLfX1+P7MEFHHHJoQj56J+ef3WOt/E4pG1RVzMtgvLuTJbAKZf3bRXZGKUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6f2bwMw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0760A2616;
	Wed, 18 Nov 2026 21:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6f2bwMw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB5F1F000C5;
	Wed, 18 Nov 2026 21:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036352;
	bh=n6vYElWmXv8U5vQxVvDHt9QsNcNSLw+NTW6aQcAadVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6f2bwMwTwKoyNI3bRvOePjfA+vnQoaaVGwlXdozxvMADpZTbqhDaZc9O5nUmVn3s
	 OOJsV13e1A7UqLYJV5WmJZKKBV4lU1nwQrsNh9LYVA9DhEXNRkJ/ZgZKk7rQ9WMKU4
	 42T+qOsiTflYhHwoHFqA0aSU+yCX0/v/O9Q6dPKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Hans Buchheim <hbuchheim@gmail.com>,
	Sergei Melnichenko <sergei.melnichenko@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1030/3318] wifi: mt76: fix memory leak in USB TX path
Date: Wed, 18 Nov 2026 15:27:32 +0100
Message-ID: <20261118150350.789134427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eason Lai <eason.lai@mediatek.com>

[ Upstream commit 82856da2d3b6a30011f4db6ea5f34c13484e0ef8 ]

When errors occur in mt76u_tx_queue_skb(), the skb is not properly
freed, leading to memory leaks. This happens when:
- The queue is full
- tx_prepare_skb() drops zero-length frames (such as WMM NULL frames)
  to prevent hardware TX hangs
- Buffer setup fails

Fix by properly releasing the skb with ieee80211_tx_status_ext() when
the queue is full or tx_prepare_skb() fails, and using
mt76_tx_complete_skb() when mt76u_tx_setup_buffers() fails (since
tx_prepare_skb() has already succeeded and may have allocated resources
that need cleanup)

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Cc: stable@vger.kernel.org
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Closes: https://github.com/morrownr/mt76/issues/83
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
Tested-by: Hans Buchheim <hbuchheim@gmail.com>
Reported-by: Sergei Melnichenko <sergei.melnichenko@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260914021920.32246-3-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 31 ++++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a8f26583b51b2..14059231f4934 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -854,23 +854,36 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   enum mt76_txq_id qid, struct sk_buff *skb,
 		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
 	u16 idx = q->head;
 	int err;
 
-	if (q->queued == q->ndesc)
-		return -ENOSPC;
+	if (q->queued == q->ndesc) {
+		err = -ENOSPC;
+		goto err_free_skb;
+	}
 
 	skb->prev = skb->next = NULL;
 	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
 	if (err < 0)
-		return err;
+		goto err_free_skb;
 
 	err = mt76u_tx_setup_buffers(dev, tx_info.skb, q->entry[idx].urb);
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		/*
+		 * mt76_tx_status_skb_get() walks the idr and dereferences
+		 * a freed skb. This SKB is not counted in non-AQL counter
+		 * due to error return, so using 0xffff as wcid to keep
+		 * balanced.
+		 */
+		mt76_tx_complete_skb(dev, 0xffff, tx_info.skb);
+		goto err_ret;
+	}
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
 			    q->entry[idx].urb, mt76u_complete_tx,
@@ -882,6 +895,14 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	q->queued++;
 
 	return idx;
+
+err_free_skb:
+	status.skb = tx_info.skb;
+	spin_lock_bh(&dev->rx_lock);
+	ieee80211_tx_status_ext(dev->hw, &status);
+	spin_unlock_bh(&dev->rx_lock);
+err_ret:
+	return err;
 }
 
 static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
-- 
2.53.0



