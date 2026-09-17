Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A5E535FAA;
	Thu, 17 Sep 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664526; cv=none; b=E/oJvSgc/mNJbMppOkLkDnbhFoOR7MWBUkQBa22VJcGP11mSP3ZIaN9KCqoUlKRRLtLSNJyLn07ca0oWUgsdbLaEmuqQtUdCdmLV/XAtz66kzcGvoGPOeWfd07/RNzhVDnnEYPiZwm6r6sQpUftRyV/RenWmA+HvmWzWqEJzm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664526; c=relaxed/simple;
	bh=z3YkIlR+TDHiLHgRcWrVzditycePY7OkggnwumIycYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov6lipEvF3cL4wz7BLZC1bLno13RXwd6q4K7d6wuPsd0Obl6ZRPru8s4cGEDLeQQXm3Z4JWl6my7w0Gfyke6aOH0ldZiBmiFJqF5BmSPcY0GxhCCydPK69HIw6vV4wHtuOE10Lzy+bR+lo9F3bhu2+dPmSIbWBczpO15WpQXcUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoyLvtP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoyLvtP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B721F000FF;
	Thu, 17 Sep 2026 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664525;
	bh=yDOjpJs7fIZV499xay8BHdPxdULj5wGr9fGlMYSebcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoyLvtP3An4HT9pyuMxNo8FTvazDzbO8XdvHdJpLMh9Fkv3c/2GCEjURQ2/JarC/V
	 X/DxUZLkiYjE3DTowGCpbBBYYVJtVlw2JWkucxpffHgPqnhMuXr+AJ5vBIdHOzJQLZ
	 HeJyL6yYV70ld9B0guaXybX9dycz69jqLD6GvGMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0402/1250] ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence
Date: Thu, 17 Sep 2026 16:03:17 +0100
Message-ID: <20260917151602.924042305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3168721d6ec3b610edf6a3c22ad190722a27d276 ]

Enable the 'hclk' bus clock before the 'clk' controller clock during
runtime resume.
The bus clock provides the register access interface, so enable it before
the controller clock. This also makes the resume sequence the reverse of
the suspend sequence, which keeps the clock ordering consistent.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 01292b63bf9d6..115e90d3bbfe0 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -426,16 +426,16 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 	struct rk_pdm_dev *pdm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(pdm->clk);
+	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
-		dev_err(pdm->dev, "clock enable failed %d\n", ret);
+		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(pdm->hclk);
+	ret = clk_prepare_enable(pdm->clk);
 	if (ret) {
-		clk_disable_unprepare(pdm->clk);
-		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
+		clk_disable_unprepare(pdm->hclk);
+		dev_err(pdm->dev, "clock enable failed %d\n", ret);
 		return ret;
 	}
 
-- 
2.53.0



