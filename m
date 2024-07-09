Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41E855E4C;
	Tue,  9 Jul 2024 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524765; cv=none; b=l3//OolKOpDcPKlVv2htoyIGcNxwhb+xSU1dwiXEZbtcVPOmEnY3/qSdtJdlFo6AqJNYXtZwAUPlHu6qqok3ZwdRZMPHKKVp/SfeSMKDT96fOOu6jZ8DuURg7j4vEQc+/X9Qhv7a774Zs29GXvDcAzpBeXCxZSKUxGprAzygoMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524765; c=relaxed/simple;
	bh=6ycvlKFKbO84CmJknbiuVbKTvtF0x4ISRsdRVI6P3Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6jsMmrLaITXV3e8D9Wybi1saAFb/zIAcrAa+kDRrvDAx/mSC0V5zFidBKy3HZ7pbQv0uOEvx54maL5tbvSfnSOokXh3EYKuAitWA14Wd/QeuYrMXI9zplRZFdFTSsJgSecVH3dpjJWfdiif+ThqUr0NOP7/hpnzCQg6tEOC2bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUlGbnLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUlGbnLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78113C3277B;
	Tue,  9 Jul 2024 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524764;
	bh=6ycvlKFKbO84CmJknbiuVbKTvtF0x4ISRsdRVI6P3Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUlGbnLrBvmrVl/i5dBJsaRqYOYOgDF2HTHQliDgOWfqZZ4+GX1IPSRxLqOYFBTZF
	 3vE2t5xX7ZaLmFHKDPsnZZ/6Xhwt2gi2H3ZRM1oY0mpCyazWoHP7zOxaoSEf379H8H
	 fYI7XgTMEmogWnFbO9TzUTtZzDNAdqcTvrjm+ow0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Miles Chen <miles.chen@mediatek.com>,
	Mingming Su <mingming.su@mediatek.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/102] clk: mediatek: clk-mtk: Register MFG notifier in mtk_clk_simple_probe()
Date: Tue,  9 Jul 2024 13:10:49 +0200
Message-ID: <20240709110654.719717523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit fd9fe654f41c0271dbfe55d975c6d1bfa88820fb ]

In preparation for commonizing topckgen probe on various MediaTek SoCs
clock drivers, add the ability to register the MFG MUX notifier in
mtk_clk_simple_probe() by passing a custom notifier register function
pointer, as this function will be slightly different across different
SoCs.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230120092053.182923-19-angelogioacchino.delregno@collabora.com
Tested-by: Mingming Su <mingming.su@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 878e845d8db0 ("clk: mediatek: mt8183: Only enable runtime PM on mt8183-mfgcfg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 8 ++++++++
 drivers/clk/mediatek/clk-mtk.h | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index fa2c1b1c7dee4..42ae5c0d56467 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -529,6 +529,14 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 			goto unregister_composites;
 	}
 
+	if (mcd->clk_notifier_func) {
+		struct clk *mfg_mux = clk_data->hws[mcd->mfg_clk_idx]->clk;
+
+		r = mcd->clk_notifier_func(&pdev->dev, mfg_mux);
+		if (r)
+			goto unregister_clks;
+	}
+
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
 		goto unregister_clks;
diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
index 880b3d6d80119..361de8078df01 100644
--- a/drivers/clk/mediatek/clk-mtk.h
+++ b/drivers/clk/mediatek/clk-mtk.h
@@ -207,6 +207,9 @@ struct mtk_clk_desc {
 	const struct mtk_clk_rst_desc *rst_desc;
 	spinlock_t *clk_lock;
 	bool shared_io;
+
+	int (*clk_notifier_func)(struct device *dev, struct clk *clk);
+	unsigned int mfg_clk_idx;
 };
 
 int mtk_clk_simple_probe(struct platform_device *pdev);
-- 
2.43.0



