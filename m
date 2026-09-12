Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201BC3ACA6F;
	Sat, 12 Sep 2026 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209051; cv=none; b=tA4loLyJosAhjLYig+8xLdkmYuxaSLIxqKdZ1lyKLY8jpSoKVCNdxARoq1MF4zeO2blk62wWzHjVoU5IYJBPYzlrsW0MrobtACZY/9gk9lcPYkq7ly/Mtf+D+6WBSuddIYsUYfjRAi8zBJPvbelGnG9OHSR6Dj4J/PY4IjJPpRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209051; c=relaxed/simple;
	bh=KyYPSFQxprX09BaKOh83068+pB//ISCZqgWbENWLoK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlvES6NkI+tD5EB7XRrVAYhx+s3qMCtiOg82IclUUvW7ORxI2cVRWDyavBa0w8a4+4mjl+HHJRAWeo4DPwZtSqqJN9YdmPQ27bGgohnYLYdLu0d3qIH3c0gZY3k5Y8Lng2knPjL5c3rSx9XnPfwRLMnE+jGU8gVJ27Azjy8XgkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bcjaTFd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bcjaTFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC5F1F000FF;
	Sat, 12 Sep 2026 10:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209050;
	bh=Y4Tt6/Bp4wYXuNEIW2YpZk0K0uLYvEtuFjgp2Mdggd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bcjaTFdGAHXJIpCkGh1mPCMDwkGPOEz6xWAYJ74b+OKUDpJGVFBaaDjQsXB21xHM
	 hK6JZ7vHoaFQhIIs9DOV7jmnm4KVfwFLPS5yZXNH0gOyvvAQ5pS3cDrrTg5ol48SNQ
	 nLfBmAKuxo1bPkJ1FfA1xW6qhUd0lzSfAp/3nj4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <Eason.Lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0735/1518] wifi: mt76: mt792x: Fix memory leak in SDIO TX path
Date: Sat, 12 Sep 2026 08:48:24 +0200
Message-ID: <20260912065640.063548003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e9576747052d..e4c3dcc34f68a 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -519,6 +519,10 @@ mt76s_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
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
@@ -531,8 +535,13 @@ mt76s_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 
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



