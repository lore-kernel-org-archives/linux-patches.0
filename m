Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0C08487;
	Sat, 30 Dec 2023 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yk81LMQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01702C433C8;
	Sat, 30 Dec 2023 12:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937790;
	bh=9YUf3lUkW2cWfIfm1D6Y1Psdx60DF+ZQVnffFBDlaT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yk81LMQzAxqgFEoO2rvUd9GHlm6aH3+FmEXpzCiAHc00HTDE4uGYbVSXchQVY38K6
	 NES1Q+LQi8L/QkWmeJ15JLLsLUx25CB9izdz3UHCd1ciYpKdiLQLMyvHecAVafc1Xi
	 wUa+DvtFg9RHm7ccpO6GmufVGGZhJT+hlldHeMs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/156] net: ethernet: mtk_wed: fix possible NULL pointer dereference in mtk_wed_wo_queue_tx_clean()
Date: Sat, 30 Dec 2023 11:58:38 +0000
Message-ID: <20231230115814.435653223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7cb8cd4daacfea646cf8b5925ca2c66c98b18480 ]

In order to avoid a NULL pointer dereference, check entry->buf pointer before running
skb_free_frag in mtk_wed_wo_queue_tx_clean routine.

Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/3c1262464d215faa8acebfc08869798c81c96f4a.1702827359.git.lorenzo@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index 3bd51a3d66500..ae44ad5f8ce8a 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -291,6 +291,9 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 	for (i = 0; i < q->n_desc; i++) {
 		struct mtk_wed_wo_queue_entry *entry = &q->entry[i];
 
+		if (!entry->buf)
+			continue;
+
 		dma_unmap_single(wo->hw->dev, entry->addr, entry->len,
 				 DMA_TO_DEVICE);
 		skb_free_frag(entry->buf);
-- 
2.43.0



