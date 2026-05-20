Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F166352016;
	Wed, 20 May 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294620; cv=none; b=fGqEYLD9CkM6zP17qC5k2BpeOFVAPW2yIpQJXhLsGLWPVVKRC2JLb6cgwnovmRjJnB4IQxIBoZ3viSFZ2mvSagelMl77xGiy9pEX5grFqD46hZKRZpX5eIdFQ98KM99HM0lcl5DCuADENqjrDku5Ul6GV3RU/68Y3yp4dc0uwkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294620; c=relaxed/simple;
	bh=m9JNrrfBSufU0pda1MmPs8eOa1zymvANmQG8L8E/3Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSZ79akY304cwnp6l0kTkHzaJVav8+6nUyEJ33EZ6N8Acbu3j+YzTPbSog6hShvSDnkAJ2Zs6hfGzOAOREhtCC3CM+HS8swzLoBUlZgzHJappL8GJtczzt+sfYe04Sw463Vs5/rrmDuZGz2msdM3NNmogTPK0bl05wMJJfda4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuY1lngB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuY1lngB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8437A1F000E9;
	Wed, 20 May 2026 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294619;
	bh=nAI1HMaZ5PMV07Fy0Zf69D1RJJHkKTfkxgP1mqtwHBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FuY1lngByoX4/9gJO+SNx4lq40LHRZfspKEMoaIYnuf07iG1GwsR8eDMqZPn0hSqR
	 niXw9FilY6btPBb8kQF2Yjt8bzUu32q3HOUvf0P63LWW/uDSUaY8jTinsZjTG71FkY
	 Rq4SEdkPIu77Ek7XWu2nPrGqy/02QL/mcUCvKcgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0108/1146] wifi: mt76: Fix memory leak destroying device
Date: Wed, 20 May 2026 18:05:58 +0200
Message-ID: <20260520162150.784005779@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mediatek/mt76/dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f240016ed9f0e..893ac14285cab 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -874,7 +874,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 		if (!buf)
 			break;
 
-		if (!mt76_queue_is_wed_rro(q))
+		if (mtk_wed_device_active(&dev->mmio.wed) &&
+		    mt76_queue_is_wed_rro(q))
+			continue;
+
+		if (!mt76_queue_is_wed_rro_rxdmad_c(q) &&
+		    !mt76_queue_is_wed_rro_ind(q))
 			mt76_put_page_pool_buf(buf, false);
 	} while (1);
 
@@ -1168,10 +1173,6 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
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



