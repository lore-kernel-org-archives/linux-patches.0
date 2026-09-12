Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0916D39AD2A;
	Sat, 12 Sep 2026 12:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216859; cv=none; b=HF0V8zQxvff2sm9T6keoW1Vx/GdxG3MU+ItNoRorUMWCw6lrwMev8S7J0BgtVrp8Xt64/xLIFD5+NLxD038oZ2FG13+KjXHKy/Fc66e/i+FYXXQ5x+VNnZFaBbAKjZZeM8pN1ye8pGShre5hH4+V3xRCV2pQOMxVeXKs2ZYMQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216859; c=relaxed/simple;
	bh=PwPUyeoTlMNh79b8bbd8q+/xCc972VozhR/nGE2hwTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6S6ETCxqGX0WRcva6BG2DHXnUvHjASI/rSVDCcfndj5mQczKSSsjblThpHdJ2NRGSXI5F4X9TSSuGusVPw62wqinXg7whkrA/7oH3PqSJZy3Gl7hSZzTNtPfqZcTljgEg5f7vSLVYWtby9AkNsRVMi1ccMwiIxyHeenhXjhbvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPeJsdx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPeJsdx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D264B1F000FF;
	Sat, 12 Sep 2026 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216857;
	bh=EzAtbv0qRsEOJtNqS56nHHXW9ffIl1263JEmsORaIJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPeJsdx/iI9yvNBOFcn+jR/f1vY/5ToEAXK3t6Os6aumwowCS//rYJ6WGVOxSvjuY
	 LxOnRQcmJWifmtBw/WvLNakS7hz2LjaZUcyxnG6zI1HOh5LS5r5d4CbA6A3Mm+QpBF
	 0qD+STYkvgbEBU991nCOANRp9m2i3KsFewLzSyaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0821/1376] wifi: mt76: only consume the WO drop bit on WED v2 devices
Date: Sat, 12 Sep 2026 08:54:07 +0200
Message-ID: <20260912065625.845574264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7989edea8bc09..e02741c5892e6 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -459,8 +459,13 @@ mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
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



