Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FFB37FF53;
	Sat, 12 Sep 2026 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230469; cv=none; b=rc2uQPOqSSy4/xRi+xvYZfv/uzKVHxSoG9IROVcsf8RiBE7ZeGCFzM5XIzdx1IHu61Zc9OVcscs6ZqHXIM5eQSvufsRHiv/G4XWUbg0qe2fcaPcLqn4bj7SsgPrcms+UqdC4GY08PtgbwcEQQ8vKCnewYzqx3Rh0mjBnF1ZFZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230469; c=relaxed/simple;
	bh=ERjNg+lcyBoo8G8Sm+CnQvzI4eK1NCpE+nTyL232Rag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKdFs0cgpviJbA3GLLhT9bFt3jbTrq0tdTiWPdtVDinMShYG4l8yaoHjh3mShniUXGsoGB2j7pqvljKg17NZ0RAk4GGRZLnLeOSkz1Spt2cUipsOB5WI0HHanELpNDmqNVhlp9xKHvHZbS6Ihobi4OkOEbP8CYAqEenVeZ6E7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrau6LC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrau6LC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16291F000FF;
	Sat, 12 Sep 2026 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230467;
	bh=XBRYrXXMzVgNKg5jfuAcS2dXW5XBYgTtgWgvMh724JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrau6LC6feC2OtBWjXqjgxmPVbPRNxqNSoiJwBD0DxXykl28DcAgL0xv+ToZW6L6g
	 mVlEWFa3wtVCfj9NDvIL6cYyOpP38uxT57M9/ksi/msUJor0Pdr4C5LmhmjM3soXHM
	 ULM1GbpBW1tQP3yDtFWZiEoHkNnFyJULS78Wq4as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <Eason.Lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0801/1191] wifi: mt76: mt792x: Fix memory leak in SDIO TX path
Date: Sat, 12 Sep 2026 08:58:49 +0200
Message-ID: <20260912065606.263298268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eason Lai <Eason.Lai@mediatek.com>

[ Upstream commit 808f2767d4217a5b96f674288573b9b89d432eed ]

When tx_prepare_skb() returns an error in the SDIO TX path, the
skb is not freed, leading to a memory leak. This can occur when
zero-length frames (such as WNM NULL frames) are dropped to prevent
potential hardware TX hangs.

Fix this by properly releasing the skb with ieee80211_tx_status_ext()
when tx_prepare_skb() fails.

Fixes: b747fa343817 ("mt76: mt7915: drop zero-length packet to avoid Tx hang")
Signed-off-by: Eason Lai <Eason.Lai@mediatek.com>
Link: https://patch.msgid.link/20260703005945.2244533-1-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 2a81c2f663449..0dcbaf825e2e5 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -519,6 +519,10 @@ mt76s_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   enum mt76_txq_id qid, struct sk_buff *skb,
 		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
+
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -530,8 +534,13 @@ mt76s_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 	skb->prev = skb->next = NULL;
 	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
-	if (err < 0)
+	if (err < 0) {
+		status.skb = tx_info.skb;
+		spin_lock_bh(&dev->rx_lock);
+		ieee80211_tx_status_ext(dev->hw, &status);
+		spin_unlock_bh(&dev->rx_lock);
 		return err;
+	}
 
 	q->entry[q->head].skb = tx_info.skb;
 	q->entry[q->head].buf_sz = len;
-- 
2.53.0



