Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA2B33F59A;
	Sat, 12 Sep 2026 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215280; cv=none; b=ZeRaowiGIDporHXMJ5hsu7pJX5Xdr+RT7laPdDBdX+uZPOtBZ1JzN7YyJ6U+8GeeM1uOfbomW6k/GI9PFw/usRuWcmnc2BeDoxi65/ATHb+D3IRdQ3n4md6ei8stu7uBZUq25RyGXbNVzngEcVv+P7Y+hhgrYPnZx6IBWsSy4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215280; c=relaxed/simple;
	bh=ips+bXA8XCtm93ax6ZSXHcRJe7qdA1/nVnumLRmqHKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8M2f1noOPFvlNQ2KX2k7aTUzriO9Y7x2/LucBXW0vbAGdsMKLz+7NX2K25UwCpCZpkxZeZWm8/ThJH9t4RZq+kXX163BRqTewyi/w5S2g+e6uwZUAJWaqaGWyk5HiJPui5P/TrOy0Sz+o7R1RmSKByqfDCWb7Kz5Y6DiPcl08k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLwAkpkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLwAkpkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889E51F000FF;
	Sat, 12 Sep 2026 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215279;
	bh=dLaFMpfitnl/N6d0/c7Oorkl2TpvWgBxBbeey4bgTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLwAkpkSEseqmCxPHK+MRALaQUcjmmI4JWNEWLbuq247o4AIFClpFklSpy6NJeYVZ
	 4DZ2A4NZeDLxrnguFW/8RI16ObeJmk3w4JV43KbhiXDUR6Sid6p6vfA5BYel406RUi
	 om/yrZYyV2H+kC+SXU7cm0Eex5mNadD7PwyPoL4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0498/1376] bus: qcom-ebi2: use managed resources for clocks and children
Date: Sat, 12 Sep 2026 08:48:44 +0200
Message-ID: <20260912065618.637692223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d19a46f7ed8eb54fea61e0eaf7db53ff7babb03c ]

qcom_ebi2_probe() enables the EBI2 clocks manually and populates child
devices manually. Several later failure paths can then return without
disabling the clocks or without relying on the driver core to undo child
population.

Use devm_clk_get_enabled() for both clocks and
devm_of_platform_populate() for children. This lets the driver core
unwind the resources automatically and removes the hand-written error
labels.

Fixes: 335a12754808 ("bus: qcom: add EBI2 driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://lore.kernel.org/r/20260623015415.26975-1-pengpeng@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 50 +++++++++--------------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index ab00c75b9e953..8d2eb955dc921 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -302,41 +302,23 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 	u32 val;
 	int ret;
 
-	ebi2xclk = devm_clk_get(dev, "ebi2x");
+	ebi2xclk = devm_clk_get_enabled(dev, "ebi2x");
 	if (IS_ERR(ebi2xclk))
 		return PTR_ERR(ebi2xclk);
 
-	ret = clk_prepare_enable(ebi2xclk);
-	if (ret) {
-		dev_err(dev, "could not enable EBI2X clk (%d)\n", ret);
-		return ret;
-	}
-
-	ebi2clk = devm_clk_get(dev, "ebi2");
-	if (IS_ERR(ebi2clk)) {
-		ret = PTR_ERR(ebi2clk);
-		goto err_disable_2x_clk;
-	}
-
-	ret = clk_prepare_enable(ebi2clk);
-	if (ret) {
-		dev_err(dev, "could not enable EBI2 clk\n");
-		goto err_disable_2x_clk;
-	}
+	ebi2clk = devm_clk_get_enabled(dev, "ebi2");
+	if (IS_ERR(ebi2clk))
+		return PTR_ERR(ebi2clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ebi2_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(ebi2_base)) {
-		ret = PTR_ERR(ebi2_base);
-		goto err_disable_clk;
-	}
+	if (IS_ERR(ebi2_base))
+		return PTR_ERR(ebi2_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	ebi2_xmem = devm_ioremap_resource(dev, res);
-	if (IS_ERR(ebi2_xmem)) {
-		ret = PTR_ERR(ebi2_xmem);
-		goto err_disable_clk;
-	}
+	if (IS_ERR(ebi2_xmem))
+		return PTR_ERR(ebi2_xmem);
 
 	/* Allegedly this turns the power save mode off */
 	writel(0UL, ebi2_xmem + EBI2_XMEM_CFG);
@@ -353,7 +335,7 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
 		if (ret)
-			goto err_disable_clk;
+			return ret;
 
 		if (csindex > 5) {
 			dev_err(dev,
@@ -372,20 +354,10 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		have_children = true;
 	}
 
-	if (have_children) {
-		ret = of_platform_default_populate(np, NULL, dev);
-		if (ret)
-			goto err_disable_clk;
-	}
+	if (have_children)
+		return devm_of_platform_populate(dev);
 
 	return 0;
-
-err_disable_clk:
-	clk_disable_unprepare(ebi2clk);
-err_disable_2x_clk:
-	clk_disable_unprepare(ebi2xclk);
-
-	return ret;
 }
 
 static const struct of_device_id qcom_ebi2_of_match[] = {
-- 
2.53.0



