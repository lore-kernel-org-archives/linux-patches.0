Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0763126982C;
	Sat, 12 Sep 2026 08:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201045; cv=none; b=YoJF0/CIbSlB189vr3UXyFqMIeqZFduvVQyoBz/orVqrSCfCwdzUMHe3Pm7VjIJ3nJfol7+CV7/gjSBiudRpbFMm1Nn9PTdwiiZPCPiDCF2d6fVusOcSm6FPEfNSuZ9MmP7nxGqJQdc1TlJfOW32VBd39SMVWs6ek5ejDwgV4Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201045; c=relaxed/simple;
	bh=BQ//Tej4VW6tcfLBdABZlQZuxCHlPG6Mrh48qtIa0wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOy+2v9Er3uHdfHwEpJDx+/3fAmEU6MvJ4a58NxmGqkZZ+xt+ynvnxcF672OHUqymPruuQ1Jq9KsZzbKciYW3xHIv0JFZg/aVcTwKrS7886wXIJbZyJ7Jvc3pn0G41wqh8cnO6KSk5UpOV/Uos7EN+l2defptwYjzq11uu0hp2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKkh+wAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKkh+wAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF771F000FF;
	Sat, 12 Sep 2026 08:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201043;
	bh=jjT4n67OSdFJwr4qelPpPIl8W4Sbu+N4SQ1u/h3ZsnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKkh+wAZ2iRtzgZ+8mBeiYcpukPRZwgGRvU3mCZHzWr6URSRVR2YPPWZLVUl7UGMe
	 g6aog9YW/HLApGCVHtUfZxw3diAk5iELZngYrEOuAPPZFvX72GddmGVyj2l0FtN1pg
	 DgBo3BHdrJXzFm+1HiIftwDJw8AJQznis6NdSJj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <Eason.Lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0872/1815] wifi: mt76: mt792x: Fix memory leak in SDIO TX path
Date: Sat, 12 Sep 2026 08:43:42 +0200
Message-ID: <20260912065709.393677942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8bae77c761bea..ba5f123f7e39d 100644
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



