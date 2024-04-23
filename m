Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2158E145B0F;
	Tue, 23 Apr 2024 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908622; cv=none; b=c5eq6YW0p7HtuANLPfBRfOIKIxDzyp18vAe6Vx3eE6y3BcpsZb9CZGBoboSOYvhMnXeFJbk+SAw1Jv1ugVCREK3l70bhGbCtwRohSpL3vp2SePHkgohx1FebO2fMjuZEop3bIMerKzWS+L9nCBahGiui3G0fvh/tpblRzFq7Eqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908622; c=relaxed/simple;
	bh=QxYsMVWMynwM9XeE+ticMddsfMXnXsoh5udqcyf4uA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK4SyqBpLO8f8PdK6HRMGpxs6qKWa4R+aQ8ITHpYDlH1mTLBcKGojs0wxK6i+iDk0JOu2VOmmxVK1enMB0Bn6ak9dyhy9Y8wbIoBLAk5/MfON/SUES4hJcOvONLhRDw54MeeQUYus682Hw+yOxvVkgqhFR6AxU/r1b+74wp3yXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7DCEDGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7DCEDGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9380C3277B;
	Tue, 23 Apr 2024 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908622;
	bh=QxYsMVWMynwM9XeE+ticMddsfMXnXsoh5udqcyf4uA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7DCEDGGWLEP8UFzY3Cj8/N65X/ev4Y62rzIp5Sw0OKGOIWenW1Bg9yffcuXb3/pN
	 HGEPO+Ko3J4Xx1mFOe5V0QjqokiWGhcgs8TN0YawO9d3MgFYmWodagUisLSNYy88h6
	 ko2Khi1GAe3SNAqc5ykQaMf3reOBGa6Rgyi2Eik4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/158] clk: mediatek: Do a runtime PM get on controllers during probe
Date: Tue, 23 Apr 2024 14:38:53 -0700
Message-ID: <20240423213858.867439612@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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



