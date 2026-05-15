Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070E3F58FC;
	Fri, 15 May 2026 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861439; cv=none; b=DyHxayHhUpdMQcfoOuSm2Am3bNoAE80dLeiAMP2kfuRe1YN8HBudpuIh+ZN9urWtv9IaDnLxoPpB83QLrTubytYcgkcKgTnI40GqaWPhEK94fbr0dCO/WYs0keL9+JaD52wO1/jMQxFxdW1vigcX1H3YJK83Dv/Li5WbVdQzLE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861439; c=relaxed/simple;
	bh=eZ7sg0eSzODr7DIfanSsMaV8pnvUfLEyu54DepIlXCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyezqQGGw+OVN/hdKBoRLuKHFwcUuY1EwybM7NAPd8OIfA/KN+rVg17wns5yyfW0KdExMapwXgIHxjkDlmW1ACQt1/bUz9pH0H8ruf5hS6PAJUxjcxxFL8Sw0JZZcBn7fFaVAmHgEA4CqhYyKBCWhnAYPa1t4g1gaR1GxbJgb88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjdStPBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjdStPBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72DCC2BCB0;
	Fri, 15 May 2026 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861439;
	bh=eZ7sg0eSzODr7DIfanSsMaV8pnvUfLEyu54DepIlXCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjdStPBRLCC073xiTvWnlKsl5SjPdusxWhL+VgFIjRkdIrON/Be3Bhp4S9LVg9o1d
	 xA6Mr61A3kd+b8V4JTlz80t/kDjS8RzHKvFLhje4VNXLpdlE5ft0HrpQTiSicygdbB
	 kksj7AgeGu6Y41TFSniTJQU7mxEOwvsJzQfceRM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 328/474] spi: fsl: fix controller deregistration
Date: Fri, 15 May 2026 17:47:17 +0200
Message-ID: <20260515154722.109549614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 9b7abfed4c3754062d1f3ffd452e65a38667f586 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 4178b6b1b595 ("spi: fsl-(e)spi: migrate to using devm_ functions to simplify cleanup")
Cc: stable@vger.kernel.org	# 4.3
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410064749.496888-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -615,7 +615,7 @@ static struct spi_controller *fsl_spi_pr
 
 	mpc8xxx_spi_write_reg(&reg_base->mode, regval);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0)
 		goto err_probe;
 
@@ -706,7 +706,13 @@ static void of_fsl_spi_remove(struct pla
 	struct spi_controller *host = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	fsl_spi_cpm_free(mpc8xxx_spi);
+
+	spi_controller_put(host);
 }
 
 static struct platform_driver of_fsl_spi_driver = {
@@ -752,7 +758,13 @@ static void plat_mpc8xxx_spi_remove(stru
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	fsl_spi_cpm_free(mpc8xxx_spi);
+
+	spi_controller_put(host);
 }
 
 MODULE_ALIAS("platform:mpc8xxx_spi");


