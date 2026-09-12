Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CAD2C032C;
	Sat, 12 Sep 2026 08:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201005; cv=none; b=Zv6dO1InuvqFVoiz6C6qQy90WPLho5WqJ5bI7BGPkimAV0CvDcLu+jTR3C2V7I+PmoAI68CAQz0cELGv/LrlJAHgTTpNUplxZLLknoa7Ap1WTcfbtiA8b30n2Qz3TgB6ZNVwnYm2LG+EzMwSu/tngIIg9xxzrKdl0dGbzhQxtJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201005; c=relaxed/simple;
	bh=5HQ4WKu/9tr/FlAdROo0fM5rMyqKHwewT2GCwAhgvEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDfEKA71eilKNj5wY90HbmdoRl4vy+Ja0p3MYJ6ZnNmtMrWZ5O1P0YvrcFIHUDh2EB7TFqYqcm50ojyfuLf7rmPl9nYy0R5rBrh1qj93jr0GGY12kzFIF9jBkeZfW0h6qjv30nkBaC3/vUk6IDpnFTcdMrrkteNtH2kfA5efwMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLKPBTh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLKPBTh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8591F000FF;
	Sat, 12 Sep 2026 08:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201004;
	bh=5K0kDAmsYo15PtxFTTA9omHhPuvAsHYgVYus0C4IJi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLKPBTh9kLPw6Y4XSzA7gKr7hwVCvKybDNGixuZsn81Yttno+El6l7ySbRhmngFFe
	 WPtxYCNV0uxamR0iWMZbyZFV6Fujuzg8azQ2fbzaGjWsKqjF3lqdDbxkMiM28qak7b
	 a7vjCn6F6ycp80mG/romX9lxKQPqUh5qjtgrRp1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0905/1815] wifi: mt76: only consume the WO drop bit on WED v2 devices
Date: Sat, 12 Sep 2026 08:44:15 +0200
Message-ID: <20260912065710.169193879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 1df54335590bb025c3bd706a9ba9c6e73a1d3000 ]

The RX path is handled by the WO MCU only on WED v2 hardware. On WED
v3 the same buf1 bit does not carry drop information, so evaluating it
there causes spurious RX drops.

Fixes: e4d2b8bcac11 ("wifi: mt76: drop the incorrect scatter and gather frame")
Link: https://patch.msgid.link/20260724124813.3961474-14-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1658c37835cf5..a67880a9281c5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -547,8 +547,13 @@ mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 		t->ptr = NULL;
 
 		mt76_put_rxwi(dev, t);
-		if (drop)
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+		/* the WO MCU owns the RX path only on WED v2, on newer
+		 * versions this buf1 bit carries no drop information
+		 */
+		if (drop && dev->mmio.wed.version == 2)
 			*drop |= !!(buf1 & MT_DMA_CTL_WO_DROP);
+#endif
 	} else {
 		dma_sync_single_for_cpu(dev->dma_dev, e->dma_addr[0],
 				SKB_WITH_OVERHEAD(q->buf_size),
-- 
2.53.0



