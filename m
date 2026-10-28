Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215012;
	b=yzTsDzmztyBbMdMmuqlwZXG/le/zG7CTRqswhrzVhUdSn04MCMraFcxjSIscMzy3puGs
	 g/tvZVLxZrk4g7/q6jemeK7EYxmoUaLiRcuQYmvtUPgUWp7Umskx1ek2p/NI1XvaKC6tT
	 KDLQC98yFwQvg2anLxlRgi97panVP5RzGR+Avj5Q4Zt9CLizyjq5rke6isxc4wZq62uhr
	 XiAlBfqsgnMwlnuolObXrQ5oXhp9IFqHDjYmQjHdWSxejPz5nNC6GfnfTVLRcOW68vyR7
	 vwCk57lOmxwqKt4vpYoJPCgsfqxJMGXL3iFIZtf3Wjn1N9tWSSnggu60ljQLH2y/wHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAEFaFYPmdXM0UEJAbAu1M3XJzY8EboRE4FbYC3vVkY=;
	b=mdbNjkueJZk++KDinqvN1/6sHluF3abPu4jRdSJ6B9ePk/WAao55Dy6rJrwuvwl1maH4
	 eM8LDCw1zO9LGteLcJcP9PCz1X+iJv563PX+OwUoP/zpxOf4Xp4jxzOKjbo9WtiA13JRH
	 pWTjujvxPVv8xi4Qx+MvIbi31asoAAbqZ3WcwSkhmm5d08ryAUJiAPfbjIg7gqPhYRzD0
	 h3j9igN5hOBQTc5qyH5SEXbt5mH6mw0vsZDECDvx5HN5pLqtk8bQ/LCOlVBCj6rS8WE+P
	 5pwSAw4RrzSi0/KfEr3QumoWx/mH9Wr7DYWP7ol3eBMr89YRvXdICFyUFy2jj/L6lGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sesw7Btk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC8D606A31A;
	Wed, 28 Oct 2026 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sesw7Btk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609EA1F01825;
	Wed, 28 Oct 2026 19:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215011;
	bh=dAEFaFYPmdXM0UEJAbAu1M3XJzY8EboRE4FbYC3vVkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sesw7BtkOn/wHzFtekUhVwjEkSIB9ibpDYpPrczlDY4NZ59lHuDwsg/frQuKv8a77
	 CuYBGFMYdcWg10Q7avqnfwU0HBsAIYGZb8/ZdoVi7YRUXZBVrj+TlNzVRBMywyClo4
	 pLOV+PmuN5jtgj8oaFeXKM3b5u05+rUcJQE3y91s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1061/1887] spi: fsl: fix controller deregistration
Date: Wed, 28 Oct 2026 17:52:37 +0100
Message-ID: <20261028170523.550274227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9b7abfed4c3754062d1f3ffd452e65a38667f586 ]

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 4178b6b1b595 ("spi: fsl-(e)spi: migrate to using devm_ functions to simplify cleanup")
Cc: stable@vger.kernel.org	# 4.3
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410064749.496888-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index c63e20ae956da..a92671faca2ab 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -631,7 +631,7 @@ static struct spi_controller *fsl_spi_probe(struct device *dev,
 
 	mpc8xxx_spi_write_reg(&reg_base->mode, regval);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0)
 		goto err_probe;
 
@@ -722,7 +722,13 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
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
@@ -768,7 +774,13 @@ static void plat_mpc8xxx_spi_remove(struct platform_device *pdev)
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
-- 
2.53.0



