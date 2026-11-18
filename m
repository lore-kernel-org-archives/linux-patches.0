Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040700;
	b=2xzWCEi9me+0R5yZMFCAkvdnQzIXosy6vnDhz4ADnH119tyAAI0sFtJlGg3LVYan27Vv
	 vlAsN9O7RyS8onyB49XwBkNp6AY6aGOUu1Kd0X1O5GK+YlnMuO64FcEixHLMQ6ZXD8nSe
	 xOLvkJlysfRZQIUdUgtegKW4aIadvHUw1hpv2+4uZCd4FCm+Lr+f+S8sdICO0wNmyJIUw
	 ytK5Pwwn5XbDDmEY9cdX+EoZT/WP+nFPwZhJHGsHpZCcYisd/TCHtQU/OvsL5pEkv8ul8
	 aYHmmw0LB/NBp5GrFTIWe9cv3JY9MpulNbaxI08Rap74QJmzojopcP827WaS9OMA7XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOrQzDN41+ROHITB8IwYcFJmGSyJhLIWDKPSlT36hDc=;
	b=i9Gx71DsHdzRSHYMAESHBAiKnjYCf8olCgGuCCOOr9nhcjVXu49GbNRplixwn5Kttpx3
	 wZBjVOr3KA6rJ0ofdu8fo+VZPnSimkAPA9ON57Tal/TTm7Tw98EZoFi4hKRrmM0qD/aJk
	 8XwQJoM23BD7ivRrRPoqp9KZOL46a+lsl2yxeZQQcOltB+hBEjn/h5EVbSBCPAFtYeT4X
	 /EGRch6cd2kv+PxHdqTxtyzi93w1/BwBfY1msHJQa2bOQH8ys768NeNqVZj2H6cq0XPO5
	 imdv+i75X4fvAESOmWPpHSVy9il59YsUQQ7+UAT3pScD0DviGxSbUpqCrHWygEFXaPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qc+luikn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75A606A32C;
	Wed, 18 Nov 2026 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qc+luikn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801821F000C4;
	Wed, 18 Nov 2026 22:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040700;
	bh=VOrQzDN41+ROHITB8IwYcFJmGSyJhLIWDKPSlT36hDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc+luiknanbUvZN67ljbcSwk01IiicTgf+EE2PGLI2msgmLC4XV0s2rGbm4Mvahb7
	 Wey30VeU2sli6WR7lQvmeIxIMZ8InNW5c60dZkfZG6POl6nY/J+XPGJ6GIgljJUvY9
	 5b0Nshz61OYDsPSN9jpHCL5FacMMe+eeT6pReDnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2551/3318] spi: fsl: switch to managed controller allocation
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150437.816389679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8c4db35377903..0c0d1b89c9d6a 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -536,7 +536,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 	u32 regval;
 	int ret = 0;
 
-	host = spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
+	host = devm_spi_alloc_host(dev, sizeof(struct mpc8xxx_spi));
 	if (host == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -560,7 +560,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 	ret = fsl_spi_cpm_init(mpc8xxx_spi);
 	if (ret)
-		goto err_cpm_init;
+		goto err;
 
 	mpc8xxx_spi->reg_base = devm_ioremap_resource(dev, mem);
 	if (IS_ERR(mpc8xxx_spi->reg_base)) {
@@ -626,8 +626,6 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 err_probe:
 	fsl_spi_cpm_free(mpc8xxx_spi);
-err_cpm_init:
-	spi_controller_put(host);
 err:
 	return ERR_PTR(ret);
 }
@@ -706,13 +704,9 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
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
@@ -758,13 +752,9 @@ static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
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



