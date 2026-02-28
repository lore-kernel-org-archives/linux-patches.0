Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46D3325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300974; cv=none; b=sOsbI0BCeaegVMA6UxujlDu2rsbn196k/1jrxeKGjf/zjYyFC+yezDfPAA5weJ2ZXhlCl/BTgwiWImc8vURfaWtT/TSczkAnQknOSElnbIfukNQjzOKiCgYMM9bHLJMMn/WY+rFIKyqNUVQ4p65KTRib6EuZOSutYT2lAcrfzmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300974; c=relaxed/simple;
	bh=uZiaFSzPj05fK+Caj/goHYRSBC6v9HZFf3WZoHgNqrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz25lBny/Zms+4FmITXpDJpRJrzwJ6RshogDCQU1s7gq3jW2foO6V7fzdMSpybjIh2S2xM5PzA29taoR70ka/Up7uK3JLKAHPh01ZXvhnqQWw0wf8zxNGDD03w9BijwBpX0ZJsZ1yYFMVG5f7/ZOIyMb2A/9JnRb69qlgucfSkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TC7v7eGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TC7v7eGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ED3C19423;
	Sat, 28 Feb 2026 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300974;
	bh=uZiaFSzPj05fK+Caj/goHYRSBC6v9HZFf3WZoHgNqrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC7v7eGisOXsK2YR1yB03n/Ne7o8HAz0DskYwZNgswoAzZWqS2SwqpQE3pq+y8Vpf
	 w5n/O00LXsGUfTegk65LHWS5cnr5I+SpwYHMY58fkhpiSgaB10j2L3hyuedv8to76C
	 ZrLLugycAgAfisC2GSRP1BKU43BWd7GL2mzunNtYzars8d429OlyIOJ4wi4ISmHkCK
	 m7AuVd/wtzvSAXQxSYpDO2afV4t3U3hGH2CnRzIYXwM2k8qf+mYmetd2n8fITEA8oc
	 6JosLBDp0/SWsTEj/NsBvoasI1XCFjrF4Fr+QF7B59YGM9zKvkDKmugXofCdou0LWu
	 9BdSLVs2lUaDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peng Fan <peng.fan@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/752] soc: imx8m: Fix error handling for clk_prepare_enable()
Date: Sat, 28 Feb 2026 12:36:53 -0500
Message-ID: <20260228174750.1542406-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f6ef3d9ff81240e9bcc030f2da132eb0f8a761d7 ]

imx8m_soc_prepare() directly returns the result of clk_prepare_enable(),
which skips proper cleanup if the clock enable fails. Check the return
value of clk_prepare_enable() and release resources if failure.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202601111406.ZVV3YaiU-lkp@intel.com/
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 04a1b60f2f2b5..8e2322999f099 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -148,7 +148,11 @@ static int imx8m_soc_prepare(struct platform_device *pdev, const char *ocotp_com
 		goto err_clk;
 	}
 
-	return clk_prepare_enable(drvdata->clk);
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto err_clk;
+
+	return 0;
 
 err_clk:
 	iounmap(drvdata->ocotp_base);
-- 
2.51.0

