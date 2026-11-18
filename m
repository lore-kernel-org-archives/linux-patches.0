Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025351;
	b=HrSyxzbP/FBVkWLpM+5y/2anljcNonikYaV3ZC1MTElbTjDZW9RVOTO1mAqSBADtHdbq
	 dTvNvNlBqwsEQWhjbyuY0LtfaF1aby+uZYTLmEYKlksaATotnYQE/olt0nHOkwh3TljTY
	 RyEgbcHXYjRZZlYOqgxBB73WyOBxQto88HcbxFHP8dX6SbSC/WZ+6Wrlmufffz831lFEI
	 8ig6pOodrjz0ingpyzDKH280watgZ2SOeVSrkbBYQuJ7PxaxYjj8vN+3+w6KOEzTvD/Bv
	 vUJGt4CH3N1xZu69hzYML9e+x8qMV4WtjeGcO5WM3nQ9ou3LvuuzmZZM7Pt5BAXwCLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RCxqo1d1NxaqPVQctYHl+i/0AdF5vjgcqYToXgnKTQo=;
	b=GVVf/o66k572BXLAFLq91Yr3Y1KEcM7tjGE5lvNvztqspegbyB2uII/O2aJjcWRvSoMo
	 aGEkxpV/UfIGQeOHKl0+nJGMOHJ4A2DZgM1iWQRQlgJg1Q4QMDNplVdQVQZNF07Wj2MFI
	 Zh/UubtaXFb1Kj14IMR1QS/093qLGNEePSv01fZ2pjXbg13MknkboJavTj3aiyegyx3bs
	 rsYT72Y/c9eenaGP2LrQsTDJOPOqCLR2HmnJLzf8UvqKtdP4yTVWYe9LJ/hJkjOEwZV/e
	 QwPteOGqbIdmq8CpmFeYzeAZBOW945NBSXYgaa7G/Yl3i+4INtjWtz0Ebnw6Ayp/N5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jofwe/Yz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB23606A330;
	Wed, 18 Nov 2026 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jofwe/Yz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1E31F000C4;
	Wed, 18 Nov 2026 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025351;
	bh=RCxqo1d1NxaqPVQctYHl+i/0AdF5vjgcqYToXgnKTQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jofwe/Yzq9UHvsjQPdj0HZa6pPU/NCGgld+d1563xOV3z/vXm1lLiAg6eFJUVWtSh
	 Y7d7H5rRlyYZydaiJX6FOCvVqoiVcmPQdGFi7wpsbvg00DTow0ScWzLGy+enxbGXqL
	 KH3LzbFputuoE18imSiXhARedm7bS4ebKUalc5F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1048/2151] spi: fsl: switch to managed controller allocation
Date: Wed, 18 Nov 2026 15:46:23 +0100
Message-ID: <20261118150200.502244611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6afe041c2ce9068b2b6c64eddb5537911752050c ]

Switch to device managed controller allocation to simplify error
handling and to avoid having to take another reference during
deregistration.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260429091333.165363-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: af1d882d421d ("spi: fsl: unmap immr_spi_cs on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index a516abbb6f67a..dbe30664c1829 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -535,7 +535,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 	u32 regval;
 	int ret = 0;
 
-	host = spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
+	host = devm_spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -559,7 +559,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 	ret = fsl_spi_cpm_init(mpc8xxx_spi);
 	if (ret)
-		goto err_cpm_init;
+		goto err;
 
 	mpc8xxx_spi->reg_base = devm_ioremap_resource(dev, mem);
 	if (IS_ERR(mpc8xxx_spi->reg_base)) {
@@ -625,8 +625,6 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 err_probe:
 	fsl_spi_cpm_free(mpc8xxx_spi);
-err_cpm_init:
-	spi_controller_put(host);
 err:
 	return ERR_PTR(ret);
 }
@@ -705,13 +703,9 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
 	struct spi_controller *host = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
-	spi_controller_get(host);
-
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-
-	spi_controller_put(host);
 }
 
 static struct platform_driver of_fsl_spi_driver = {
@@ -757,13 +751,9 @@ static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
 
-	spi_controller_get(host);
-
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
-
-	spi_controller_put(host);
 }
 
 MODULE_ALIAS("platform:mpc8xxx_spi");
-- 
2.53.0



