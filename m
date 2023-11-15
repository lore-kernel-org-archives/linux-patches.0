Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BBA3C477
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dd4CJca+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373C3C433C9;
	Wed, 15 Nov 2023 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077220;
	bh=0xAxlfNM1DrQIyO/PB63GKHoK+hacvsK3I29BudszeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd4CJca+Siu2kM6csSuRKGuQm/t3CUbyufApcvGVbgZaYIZd7Msi+4YFjH2zGGHzi
	 rAm90D/KPPVdgLDuNJm26o21iH1CMa7m2jT+IlX9xi7Wxy36PpaDkQkhPmxRwoUJ1Y
	 kOrN/pf28PfBZV8YcLVJYPZrNBcswFE/bI9dFEcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/603] clk: imx: imx8: Fix an error handling path in imx8_acm_clk_probe()
Date: Wed, 15 Nov 2023 14:11:56 -0500
Message-ID: <20231115191625.041636428@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e9a164e367f039629fd5466a79b9f495646e1261 ]

If an error occurs after a successful clk_imx_acm_attach_pm_domains() call,
it must be undone.

Add an explicit error handling path, re-order the code and add the missing
clk_imx_acm_detach_pm_domains() call.

Fixes: d3a0946d7ac9 ("clk: imx: imx8: add audio clock mux driver")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8-acm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8-acm.c b/drivers/clk/imx/clk-imx8-acm.c
index 73b3b53549517..1c95ae905eec8 100644
--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -374,7 +374,6 @@ static int imx8_acm_clk_probe(struct platform_device *pdev)
 										0, NULL, NULL);
 		if (IS_ERR(hws[sels[i].clkid])) {
 			ret = PTR_ERR(hws[sels[i].clkid]);
-			pm_runtime_disable(&pdev->dev);
 			goto err_clk_register;
 		}
 	}
@@ -384,12 +383,16 @@ static int imx8_acm_clk_probe(struct platform_device *pdev)
 	ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, clk_hw_data);
 	if (ret < 0) {
 		dev_err(dev, "failed to register hws for ACM\n");
-		pm_runtime_disable(&pdev->dev);
+		goto err_clk_register;
 	}
 
-err_clk_register:
+	pm_runtime_put_sync(&pdev->dev);
+	return 0;
 
+err_clk_register:
 	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	clk_imx_acm_detach_pm_domains(&pdev->dev, &priv->dev_pm);
 
 	return ret;
 }
-- 
2.42.0



