Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BEE3FF1A2;
	Fri, 15 May 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860333; cv=none; b=OZLnAZFZjBAYyfGSG82/gJY79SJs5zyAvLk5LoHYvnOhBxdaMQt3jG98DOrZIRuM+3xJqDq9FNvyLTZmlv8AG1dNALN2BNHvu2jva3MsKjeAd3QgJaSjP2z10qV7yVWM5Na01vIJFR0jakOcuPzkrmRMagSbwM/omYIw/1GCUbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860333; c=relaxed/simple;
	bh=wZeMndgOnQJDzUc4ktcVgHxBaAExXCPl42xvdSd3fW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHnqS0Nd33DikXWNd4nzDojbaTP76gVg5qmC4rbEROyvqUK6thOXk6hEYt00tcktP3WxXIT6O99DupEQo/GCdl93qEDkSu3masOOQhXyqZ32/QClc31oLkqPobbI0muTEWMzEYb0ecUMgHzmyXCV75aPVUZVBKCHTiqNRsUcIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vx+M2sxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vx+M2sxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672C4C2BCB0;
	Fri, 15 May 2026 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860332;
	bh=wZeMndgOnQJDzUc4ktcVgHxBaAExXCPl42xvdSd3fW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vx+M2sxcxak7iyZcJvIl8WwZnH+iDTvMs4+kN9vTH86brfVAPQ8E5CL6y8DdWh6bi
	 4ZdjwOA8J+FBInoS/dGxZ0ay7ajglIPwzFF3inDFx4dXgSN7s9puHHS3sZb1GMEnTm
	 8mmK762KVA8OGznjDUlkq1A3K+zs92E84HW9sPdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 047/144] spi: fsl: fix controller deregistration
Date: Fri, 15 May 2026 17:47:53 +0200
Message-ID: <20260515154654.625666562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
@@ -614,7 +614,7 @@ static struct spi_controller *fsl_spi_pr
 
 	mpc8xxx_spi_write_reg(&reg_base->mode, regval);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0)
 		goto err_probe;
 
@@ -705,7 +705,13 @@ static void of_fsl_spi_remove(struct pla
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
@@ -751,7 +757,13 @@ static void plat_mpc8xxx_spi_remove(stru
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


