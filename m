Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EE3DD874;
	Tue, 12 May 2026 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608507; cv=none; b=jnT0R+Q3yyyQ3jXXQRuzFFdFauzbWqFM5CUsLnGQ7/tTHR7WEjrhnrLj5XA2nNeHiYDhRptlLybneJhqOAkgpgjX4Iw/DhEXWSitVJ11DBeRR+JaxWK0QFNgxZgaGDltA8eJFWtTUZjN3mKQ9hJ4BiYWq3j36Fl+92EcTJMnmq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608507; c=relaxed/simple;
	bh=hDzoSndjmrPrMazsf6O9CcXNm8lbpu9mfyLMry4jXZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YatD/7m00rDGsLlu2JCAtASBXse460HwH1boXYEpv3rTMTI9gGByRExQ7i9jzZs+3QX6iHd3jH2NEnDyKPrHdloa9gNxGPqC1SLFkwK13tDBmKX3S7r82NGY8XLEHn2jWkFgDRzktMQQWGTD1tKheW0MRahN/LsSi4cbIu/0SJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhSG7oP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhSG7oP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399E4C2BCB0;
	Tue, 12 May 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608507;
	bh=hDzoSndjmrPrMazsf6O9CcXNm8lbpu9mfyLMry4jXZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhSG7oP57Dh1pEnm1z2A67GPS1cjqPCCc2pqzt/ZqWPFbPg9IV6Y3nXZibYXIh3KG
	 d1pDpbdBTkJpjXhbcgTnl5p16P/ErbkfiuzdYKfFJNDJyBOVz+miWEc7+YFzGl6adG
	 cI1EFXMCGEYW0KS32+eJvjxVOq2TDtxF54lvkk3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 079/270] spi: sun4i: fix controller deregistration
Date: Tue, 12 May 2026 19:38:00 +0200
Message-ID: <20260512173940.118676545@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 42108a2f03e0fdeabe9d02d085bdb058baa1189f upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun4i.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -505,7 +505,7 @@ static int sun4i_spi_probe(struct platfo
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI host\n");
 		goto err_pm_disable;
@@ -523,7 +523,15 @@ err_free_host:
 
 static void sun4i_spi_remove(struct platform_device *pdev)
 {
+	struct spi_controller *host = platform_get_drvdata(pdev);
+
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_force_suspend(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id sun4i_spi_match[] = {


