Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8BE12CDB6;
	Tue,  9 Jul 2024 11:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524792; cv=none; b=qij5lTGpfrtIzEGsLyfckrrtlBzxyRe9afZaJlgCU4EGaQvEfkZDT+s+xqfuriWm3dQO3C26uvwR0BWUnh0ePrYdpL/uhi5YMiYcvTeyar/BpY8OUV5tU+L9t95Fmadbl5aHa+Hp3MXfyb7jIaUoukjqnz/mR5RL1HnwJ5kTlcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524792; c=relaxed/simple;
	bh=3vbQml/qHuQxs+L/zU4umPLpXkoolgHQhNZfp/DzX7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f32yjno2dOhV7dMsC+6S4RZG4d/d6ModiUchzOoUH8hDgyggkou3gFR2MBbWSV9XtfXL5Cnu1Rj3eeSqm5OlB1fgHhD0WB5c1Ja+zifavJzsThwqjsN4DrTQVmZWRiXqWqo8hLuVEw7WlM0VD8BZUlbqblFnyDPr6aQooWLHoKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lU7lA5t4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lU7lA5t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9677BC3277B;
	Tue,  9 Jul 2024 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524792;
	bh=3vbQml/qHuQxs+L/zU4umPLpXkoolgHQhNZfp/DzX7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lU7lA5t4zH0lN4U+R8R4nHAPHOuXVrer2XXO6Ka7XyPbAlQVhhgb98gSNADgs/Rkz
	 TWYUsMoVDv0r45JWZZ87gUPcvNeqegAJGfx5IvhAG3FAKyPuK0V/s6FrgyI2OAS06m
	 e6is3EkIJ3kn2FktO9IuT6rHWs6NQzBll6dmRHCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/102] clk: mediatek: mt8183: Only enable runtime PM on mt8183-mfgcfg
Date: Tue,  9 Jul 2024 13:10:50 +0200
Message-ID: <20240709110654.757847507@linuxfoundation.org>
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 878e845d8db04df9ff3bbbaac09d335b24153704 ]

Commit 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers
during probe") enabled runtime PM for all mediatek clock controllers,
but this introduced an issue on the resume path.

If a device resumes earlier than the clock controller and calls
clk_prepare() when runtime PM is enabled on the controller, it will end
up calling clk_pm_runtime_get(). But the subsequent
pm_runtime_resume_and_get() call will fail because the runtime PM is
temporarily disabled during suspend.

To workaround this, introduce a need_runtime_pm flag and only enable it
on mt8183-mfgcfg, which is the driver that observed deadlock previously.
Hopefully mt8183-cfgcfg won't run into the issue at the resume stage
because the GPU should have stopped rendering before the system calls
suspend.

Fixes: 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers during probe")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Link: https://lore.kernel.org/r/20240613120357.1043342-1-treapking@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c |  1 +
 drivers/clk/mediatek/clk-mtk.c           | 24 ++++++++++++++----------
 drivers/clk/mediatek/clk-mtk.h           |  2 ++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8183-mfgcfg.c b/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
index 730c9ae5ea124..50ccd59794464 100644
--- a/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
+++ b/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
@@ -29,6 +29,7 @@ static const struct mtk_gate mfg_clks[] = {
 static const struct mtk_clk_desc mfg_desc = {
 	.clks = mfg_clks,
 	.num_clks = ARRAY_SIZE(mfg_clks),
+	.need_runtime_pm = true,
 };
 
 static const struct of_device_id of_match_clk_mt8183_mfg[] = {
diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 42ae5c0d56467..9dbfc11d5c591 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -472,14 +472,16 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 	}
 
 
-	devm_pm_runtime_enable(&pdev->dev);
-	/*
-	 * Do a pm_runtime_resume_and_get() to workaround a possible
-	 * deadlock between clk_register() and the genpd framework.
-	 */
-	r = pm_runtime_resume_and_get(&pdev->dev);
-	if (r)
-		return r;
+	if (mcd->need_runtime_pm) {
+		devm_pm_runtime_enable(&pdev->dev);
+		/*
+		 * Do a pm_runtime_resume_and_get() to workaround a possible
+		 * deadlock between clk_register() and the genpd framework.
+		 */
+		r = pm_runtime_resume_and_get(&pdev->dev);
+		if (r)
+			return r;
+	}
 
 	/* Calculate how many clk_hw_onecell_data entries to allocate */
 	num_clks = mcd->num_clks + mcd->num_composite_clks;
@@ -550,7 +552,8 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 			goto unregister_clks;
 	}
 
-	pm_runtime_put(&pdev->dev);
+	if (mcd->need_runtime_pm)
+		pm_runtime_put(&pdev->dev);
 
 	return r;
 
@@ -578,7 +581,8 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 	if (mcd->shared_io && base)
 		iounmap(base);
 
-	pm_runtime_put(&pdev->dev);
+	if (mcd->need_runtime_pm)
+		pm_runtime_put(&pdev->dev);
 	return r;
 }
 EXPORT_SYMBOL_GPL(mtk_clk_simple_probe);
diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
index 361de8078df01..65c24ab6c9470 100644
--- a/drivers/clk/mediatek/clk-mtk.h
+++ b/drivers/clk/mediatek/clk-mtk.h
@@ -210,6 +210,8 @@ struct mtk_clk_desc {
 
 	int (*clk_notifier_func)(struct device *dev, struct clk *clk);
 	unsigned int mfg_clk_idx;
+
+	bool need_runtime_pm;
 };
 
 int mtk_clk_simple_probe(struct platform_device *pdev);
-- 
2.43.0



