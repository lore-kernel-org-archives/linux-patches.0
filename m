Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCAE17BED0;
	Sat, 17 Oct 2026 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254048; cv=none; b=XtuYt1sKtIkQzDG4iYabl7IdPkiqnqF7Cz9sfFNYoIbWl+JYPOwNyZVNZLmvKQwNROkGwy++5MPzzmURIiP9tMczmBR5qpAslU8wW/jXwSQW5GgkRuJm8/CT12JevB/wCUiHzYvrSL+QMxcyQ9AIYIBU7RRggv2wL8yxLQ4B/YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254048; c=relaxed/simple;
	bh=Tg4mfuS1WTiVeyLuZbIy+14vF4zMvzU5XWQsaOuKaFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twFtnWFepT8lDSh/UlscZPQYrr13zAKdrwRV2Qlv/7txFOgVkGb6KKFMCKDbTTF2mGuR+zw4RwMmGdLRGtCLdybH+K8GqH7L4Zb8n1oFsNqwxlyNn4qUgSKmxFWTTjCH1VCyaNpMtLIqTnvkuo8PXiqhGgwf1/2pn1MC1QHbKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLH8JLJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLH8JLJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983301F000C4;
	Sat, 17 Oct 2026 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254047;
	bh=Y7/p9a0vGAQWpHUKTJV75XI5Q84g6B1u1GJR7CK7QHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLH8JLJw3xIwoTktdnAzs2VuYGAJlAu4NmaMVKn3Env1dtAaNzBBRS1Wu6paUh+n9
	 u/6BzjQGPOEOGsS6xcXM7TFTfMopiKm7iNEAkX2ZjTbkoGkslngOoeqA6cCTv/ar+u
	 Xl+wspdwen7oFOcr6N2iB5x0R/lkVzInzgVMbTsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/869] wifi: mt76: Fix memory leak destroying device
Date: Sat, 17 Oct 2026 17:52:38 +0200
Message-ID: <20261017160045.202867580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6b470f36616e3448d44b0ef4b1de2a3e3a31b5be ]

All MT76 rx queues have an associated page_pool even if the queue is not
associated to a NAPI (e.g. WED RRO queues with WED enabled). Destroy the
page_pool running mt76_dma_cleanup routine during module unload.
Moreover returns pages to the page pool if WED is not enabled for WED RRO
queues.

Fixes: 950d0abb5cd94 ("wifi: mt76: mt7996: add wed rx support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251208-mt76-fix-memory-leak-v1-1-cba813fc62b8@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e02741c5892e6..872d39d46a332 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -769,7 +769,11 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 		if (!buf)
 			break;
 
-		if (!mt76_queue_is_wed_rro(q))
+		if (mtk_wed_device_active(&dev->mmio.wed) &&
+		    mt76_queue_is_wed_rro(q))
+			continue;
+
+		if (!mt76_queue_is_wed_rro_ind(q))
 			mt76_put_page_pool_buf(buf, false);
 	} while (1);
 
@@ -1033,10 +1037,6 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 	mt76_for_each_q_rx(dev, i) {
 		struct mt76_queue *q = &dev->q_rx[i];
 
-		if (mtk_wed_device_active(&dev->mmio.wed) &&
-		    mt76_queue_is_wed_rro(q))
-			continue;
-
 		netif_napi_del(&dev->napi[i]);
 		mt76_dma_rx_cleanup(dev, q);
 
-- 
2.53.0



