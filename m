Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB69D20B3E;
	Tue, 23 Apr 2024 21:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908525; cv=none; b=m5n18aM9UrldToOGtYqstjRCeJ1YSy0zl/PihoNJLCdXA8kiXguL16if2cDcLn0xz8weYULaP+Yu+d6FqVIGSp/XZ5jF+nIiTgMVncbXgyWa1xHc/mFC2d5gDR/LrTWz+3EXzicW61xEQGfRcn/KDWbMMk0rZE71dFqkrscSDr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908525; c=relaxed/simple;
	bh=ZBJVbYC8ylBF7v5JDL1USv1pjgZvt5q5aqafTq0PoYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FArUqQ2QQCx9v9YB9cQRPE/J6MlghURPhtRygfenZffk2sfHy27oBS3xNCdxXzM8GOrXpDBci7WY9vmgCllLcfus2Chh4ZS4Naf6pfGoLfqiI8l0sjwgOODurX5Jq15d+xI1OJ5xMEuvUvg27RLj0omNI2nduKOe/bYbtjBzBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+EkjVLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+EkjVLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CEFC116B1;
	Tue, 23 Apr 2024 21:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908525;
	bh=ZBJVbYC8ylBF7v5JDL1USv1pjgZvt5q5aqafTq0PoYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+EkjVLzQxuE2MJ35OBkMnJ5kutRu+9piKHwsiNDr4MfldoCJgIqFNW/WZ9QTrmaQ
	 TjXwVIMr9nR0h8+L11PP16vBi8i4WLcjKko8aX0VH1Suv2TU9b4difXglYB3P0sQHl
	 gxJt/PbEN0V38K3PUR2+6nmu/G+NPVSnCi/96AlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 082/158] clk: mediatek: Do a runtime PM get on controllers during probe
Date: Tue, 23 Apr 2024 14:38:24 -0700
Message-ID: <20240423213858.617961652@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 2f7b1d8b5505efb0057cd1ab85fca206063ea4c3 ]

mt8183-mfgcfg has a mutual dependency with genpd during the probing
stage, which leads to a deadlock in the following call stack:

CPU0:  genpd_lock --> clk_prepare_lock
genpd_power_off_work_fn()
 genpd_lock()
 generic_pm_domain::power_off()
    clk_unprepare()
      clk_prepare_lock()

CPU1: clk_prepare_lock --> genpd_lock
clk_register()
  __clk_core_init()
    clk_prepare_lock()
    clk_pm_runtime_get()
      genpd_lock()

Do a runtime PM get at the probe function to make sure clk_register()
won't acquire the genpd lock. Instead of only modifying mt8183-mfgcfg,
do this on all mediatek clock controller probings because we don't
believe this would cause any regression.

Verified on MT8183 and MT8192 Chromebooks.

Fixes: acddfc2c261b ("clk: mediatek: Add MT8183 clock support")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>

Link: https://lore.kernel.org/r/20240312115249.3341654-1-treapking@chromium.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 2e55368dc4d82..bd37ab4d1a9bb 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include "clk-mtk.h"
@@ -494,6 +495,16 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 			return IS_ERR(base) ? PTR_ERR(base) : -ENOMEM;
 	}
 
+
+	devm_pm_runtime_enable(&pdev->dev);
+	/*
+	 * Do a pm_runtime_resume_and_get() to workaround a possible
+	 * deadlock between clk_register() and the genpd framework.
+	 */
+	r = pm_runtime_resume_and_get(&pdev->dev);
+	if (r)
+		return r;
+
 	/* Calculate how many clk_hw_onecell_data entries to allocate */
 	num_clks = mcd->num_clks + mcd->num_composite_clks;
 	num_clks += mcd->num_fixed_clks + mcd->num_factor_clks;
@@ -574,6 +585,8 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 			goto unregister_clks;
 	}
 
+	pm_runtime_put(&pdev->dev);
+
 	return r;
 
 unregister_clks:
@@ -604,6 +617,8 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 free_base:
 	if (mcd->shared_io && base)
 		iounmap(base);
+
+	pm_runtime_put(&pdev->dev);
 	return r;
 }
 
-- 
2.43.0



