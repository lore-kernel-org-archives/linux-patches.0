Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F861F707A;
	Tue,  3 Dec 2024 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239684; cv=none; b=cG2mbVrHXOox6uLPsVF8udTCDmPiZoPuOVVxqwrcMJzcb1nrJBAsfxkhxqxX0tZK9pCgiumfGpAicPYLvlpp87jAC4Mp/kUN37Dq+YbS4XVCDNZHq4uqrllgEGJ232XmXwbaiyKTR4Odj6mHVDANF/jC4ViN8IuFP7Cqf0K+82A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239684; c=relaxed/simple;
	bh=4elaOkIRtvXfl0efLRoOgzJc8M4ZD/L+zodmcUbfQNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4aAMeWUYhsnyI3CkXQBE9a8uWnCnzSEg0Q/oqsqepwZyGUCYAMf1TjmopuqjI69lvTaW2VmjF5Skrc5M+/HImzU32OEATAtQwiHqDS4ddhR5cVEwCO5VUrug2se+FZ/u5MTJNAGDl+yE5DkGYcQA7Usa6HfEsEZtLqcq+9tUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtBm8AvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtBm8AvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF25C4CECF;
	Tue,  3 Dec 2024 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239684;
	bh=4elaOkIRtvXfl0efLRoOgzJc8M4ZD/L+zodmcUbfQNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtBm8AvMpksNvK02fe5SsAzSjH6KyxkAS4drd9Tlj9yIQ9ItzZsg0RsoGCwOiPoaS
	 xueiKIiu9tGVBhs45KIFpkIu1k5RHoj6+jctKS9UDFLf3CVc2SpXpGWD6oi+YmZS8s
	 qVuEoW6ta9tWdZyOjVCIF8x6dRtQ+vJM5X4PVQCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH 6.11 698/817] spi: Fix acpi deferred irq probe
Date: Tue,  3 Dec 2024 15:44:30 +0100
Message-ID: <20241203144023.224501933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,6 +424,16 @@ static int spi_probe(struct device *dev)
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
@@ -2869,9 +2879,6 @@ static acpi_status acpi_register_spi_dev
 	acpi_set_modalias(adev, acpi_device_hid(adev), spi->modalias,
 			  sizeof(spi->modalias));
 
-	if (spi->irq < 0)
-		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
-
 	acpi_device_set_enumerated(adev);
 
 	adev->power.flags.ignore_parent = true;


