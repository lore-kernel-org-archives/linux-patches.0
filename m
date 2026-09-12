Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD58238DC59;
	Sat, 12 Sep 2026 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209153; cv=none; b=MoAOxyv5pmEfA+iT38K+21hPGPNp8P8LWeOBvRYSDm9fSG8a9G5AtlKV6mAN868J3ouJ/vDwBG2I/zUWfzjSIrrdXi2Pp/DtyMhRd0RvF+Pb8Vi0fn53eaLWL7yb+rdP+ywqvsGmayElBN4LzF3gBYvx+byhBJzF7AOlARKs6wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209153; c=relaxed/simple;
	bh=F2sPdH8fJ4maiifcvBLQo7CvmILpdlv0RBQtAN/8LWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgC+SyXAL/us7q1CM5ZG3EZAdfbsy5ldsXFuEiUsKRPwCO9sECr6SYJScBOA8QTc6RyXtvNFrWywZ4GKIkwrKQaaxJvFIoj6eF60YJQBhEa1Zdb+KeF0YBqsl4Ux4Cr5gAQzfyiIuIERgXZY2GkbXLG9AvtcixYZSq9/omOxpXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P12Gr2oi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P12Gr2oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E5A1F0089A;
	Sat, 12 Sep 2026 10:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209152;
	bh=cqE4pH6m+JdXYhvdX46oNHs2ykdNJE5r8xFebhOtP/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P12Gr2oi2fY8kUS2duoIn7euNoaYhDUPS5ukRzR6n562z1pUWd4HYXu3L/IUjkgMC
	 JwcKFs/6jN3gpJIZO1ZiyLSQPpNtwfguyIVb0g9llMo7ws42b0y4OMKven3kZ3RWl1
	 a/4HFYnjBcH0Oh2ZJnlXyAxe/F1XtKylNmtCHCb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0763/1518] wifi: mt76: only consume the WO drop bit on WED v2 devices
Date: Sat, 12 Sep 2026 08:48:52 +0200
Message-ID: <20260912065640.692683529@linuxfoundation.org>
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
index 13a3885a0a92d..a487887ef5444 100644
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



