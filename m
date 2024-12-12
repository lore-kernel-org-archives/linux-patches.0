Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827C121660C;
	Thu, 12 Dec 2024 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024342; cv=none; b=M6D+Nq+AZbAmaRWHWd6O/eTG8Z3lJ4gnippowG1LQ25+jzOulKD2MBKyxM6jHrAZW98XKEUAZxavUx492Y4cxynnGMwiBKT9G8VEa+JxC9pLv41crPTiSvvoMaH9+O8RRGS3laPockNQL2nzISqFKoWcZHrjquF6Lh77yP4zp5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024342; c=relaxed/simple;
	bh=FHLgtNFr0ufY07a+1snulwTHe2xxNvCdCl0BZL5nNig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mz3+q7soi4ECZDlSUCatVRyiRu9C9wF0O8Ct4vA7zH91lc4OKi0USP08toBQvMp+qMIrhJX5/WIbKeSv2OD0Uznn/akq/LOvC8EeOyVulaPrMPWVggM4R0I6NUUxLTMtQACWzbgev3oNt/H/+Y9C5J53FQFzGteUxQDBhvQzSmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siIzeVYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siIzeVYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0305AC4CECE;
	Thu, 12 Dec 2024 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024342;
	bh=FHLgtNFr0ufY07a+1snulwTHe2xxNvCdCl0BZL5nNig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siIzeVYpLTST7M0yJGPSPFWYaoduELdPa292fdecll+XYAGka9rsa0e1+wJOwrUtO
	 LDb9JzR4p1rj2p3j4vPpGTTLSUT4s+6SvQggrpAE9x+F95XsSUdbYwoFiAUZvk2tp8
	 iIRxKEVRFE9kzpzsh/y98PVbC7cdlsbLsxp0e0l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH 5.10 265/459] spi: Fix acpi deferred irq probe
Date: Thu, 12 Dec 2024 16:00:03 +0100
Message-ID: <20241212144304.070768411@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit d24cfee7f63d6b44d45a67c5662bd1cc48e8b3ca upstream.

When probing spi device take care of deferred probe of ACPI irq gpio
similar like for OF/DT case.

>From practical standpoint this fixes issue with vsc-tp driver on
Dell XP 9340 laptop, which try to request interrupt with spi->irq
equal to -EPROBE_DEFER and fail to probe with the following error:

vsc-tp spi-INTC10D0:00: probe with driver vsc-tp failed with error -22

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Fixes: 33ada67da352 ("ACPI / spi: attach GPIO IRQ from ACPI description to SPI device")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Alexis Lothoré <alexis.lothore@bootlin.com> # Dell XPS9320, ov01a10
Link: https://patch.msgid.link/20241122094224.226773-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -397,6 +397,16 @@ static int spi_drv_probe(struct device *
 			spi->irq = 0;
 	}
 
+	if (has_acpi_companion(dev) && spi->irq < 0) {
+		struct acpi_device *adev = to_acpi_device_node(dev->fwnode);
+
+		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
+		if (spi->irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		if (spi->irq < 0)
+			spi->irq = 0;
+	}
+
 	ret = dev_pm_domain_attach(dev, true);
 	if (ret)
 		return ret;
@@ -2249,9 +2259,6 @@ static acpi_status acpi_register_spi_dev
 	acpi_set_modalias(adev, acpi_device_hid(adev), spi->modalias,
 			  sizeof(spi->modalias));
 
-	if (spi->irq < 0)
-		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
-
 	acpi_device_set_enumerated(adev);
 
 	adev->power.flags.ignore_parent = true;


