Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854282F44;
	Thu, 12 Dec 2024 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022750; cv=none; b=c/Rc1BtkGOJ6Taf+KpTDXdxR28W/rBYOJZZFa8+NnMyDFaFkmud0+trgzZfMIFl+xWAphIJ90gmA7vUvicTe29nQf8Ri16S9d9KXsPUnza9AbHroJL5Eg59Uuzec0A/ATZh6j33rQodP7APblaBU3jiWZh6BfUmtO6Tl17xgy0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022750; c=relaxed/simple;
	bh=Y1Zb6ay5QWCGLsbplNjEcHsFy6ZiKnZEDCmyjoe7KEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/rsYIpx/tgVMsQuhqQJeW7AqHB0fDYYHEUVJDF1Wd3BYKdwvSCti/QCJw/eA7BJ7f/IlJGBa45L/GXvQe8dRhKfGmJA4V0GT+2K2qwNUYGeQpaj6rVGTxqZnMkBS/NnX5UkLIiSkyt8Weoo5zN++5XwA5Amw+MbworMXajOwBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A29gjP1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A29gjP1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CE4C4CECE;
	Thu, 12 Dec 2024 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022750;
	bh=Y1Zb6ay5QWCGLsbplNjEcHsFy6ZiKnZEDCmyjoe7KEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A29gjP1q1o4Vq4N6InMOdpE0EDmuQv3p/mTQb9uRpcb+Ktl+wZpd745+xb9dOgske
	 n3f+HClSus/MBhcgXs5GPLCjPxkHqN8/Xzcg0idpcf/2lXs7svUeftjW6pxaRF1G8S
	 g4/GHojZVR08HLUlRNwZiD4iHjBl1Zmu1o+scTtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH 5.15 327/565] spi: Fix acpi deferred irq probe
Date: Thu, 12 Dec 2024 15:58:42 +0100
Message-ID: <20241212144324.524533763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,6 +400,16 @@ static int spi_probe(struct device *dev)
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
@@ -2406,9 +2416,6 @@ static acpi_status acpi_register_spi_dev
 	acpi_set_modalias(adev, acpi_device_hid(adev), spi->modalias,
 			  sizeof(spi->modalias));
 
-	if (spi->irq < 0)
-		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
-
 	acpi_device_set_enumerated(adev);
 
 	adev->power.flags.ignore_parent = true;


