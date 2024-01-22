Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335823C6;
	Tue, 23 Jan 2024 00:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969564; cv=none; b=aNT5TJPhNBZpIkPdvWOyMZAk7du2QjRLdsxjQXEn5kT/XdC517yVo+C1SfXZ8pfAFovnesTFh9NPG7iDTvcYczcVVwtGBKBC7eu2OwSH4TDj9Cf9p7eIrDt2KDkQGfzB6wk/4w56k63G5okm1CdUOyEJ/lJjo//UaSMzOHcBosg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969564; c=relaxed/simple;
	bh=mq3xviUyv1GCt/SKgvGpEp28mdFkcIk77r7jbRyPx24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3di0FMMdJ1Hx0i2Lau9/C2W4puAGXVl4TTeR1W3DwNM+lNFTD2z4mtbCUF64QF6bfbPEczpTOrzyTOBJSBGDsEorq7GMuf9w3aR963gI3KEEOfQw10Syc0GuC6r3vEP8hkiq4q/Wdip16MYy5ArHShfLBN7wlblvCGA3yqEosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCt8RYZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCt8RYZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DD4C433F1;
	Tue, 23 Jan 2024 00:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969564;
	bh=mq3xviUyv1GCt/SKgvGpEp28mdFkcIk77r7jbRyPx24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCt8RYZdTx73qpSLbia5bGIft8P8SbvmyyFlnJPUixfGaIBr+Iuxjn8bo6oiFlYiq
	 1hKOs21g2PPkox8UucoFCfQhuvgQEVpv3qy/6+oHPZoT5JQOJdRhC+OsTufpVXgHOd
	 kEX4qe6+AMbWwaR9yLtsajjhyWje4WC0JU2Jk1P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 326/641] drm/mediatek: Fix underrun in VDO1 when switches off the layer
Date: Mon, 22 Jan 2024 15:53:50 -0800
Message-ID: <20240122235828.089845944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 73b5ab27ab2ee616f2709dc212c2b0007894a12e ]

Do not reset Merge while using CMDQ because reset API doesn't
wait for frame done event as CMDQ does and could lead to
underrun when the layer is switching off.

Fixes: aaf94f7c3ae6 ("drm/mediatek: Add display merge async reset control")

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231214055847.4936-23-shawn.sung@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_merge.c b/drivers/gpu/drm/mediatek/mtk_disp_merge.c
index e525a6b9e5b0..22f768d923d5 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_merge.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_merge.c
@@ -103,7 +103,7 @@ void mtk_merge_stop_cmdq(struct device *dev, struct cmdq_pkt *cmdq_pkt)
 	mtk_ddp_write(cmdq_pkt, 0, &priv->cmdq_reg, priv->regs,
 		      DISP_REG_MERGE_CTRL);
 
-	if (priv->async_clk)
+	if (!cmdq_pkt && priv->async_clk)
 		reset_control_reset(priv->reset_ctl);
 }
 
-- 
2.43.0



