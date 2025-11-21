Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2316A26CE33;
	Fri, 21 Nov 2025 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731416; cv=none; b=GoqOGBZa01uODpve2IcUoLcKfovaMN8igse118NPJ/8DNTSfcnaJlNbbhQ14kmLHTWv8PDWIqUDTTPdGNPYFFQeUtd+l/FeNftxg8VipribnIETUesp8RroN7qWXrkFZQBQNxWWYfUa1MAcOWK0oPx5TiOlcVWOCxDUOpEY9qbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731416; c=relaxed/simple;
	bh=tjm3DaLjYUbKpmgMhaV3kXhl/13gLiuVpsxze0mvTb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqiL08RROUvfEtCtg2/F/EAugjDpnkUBIbfIXBNJhecd8pKQxZCv/1A2EPuBgoibqx+VQz6iBun8p9DwI4lAG4WKidXvz2y7HdcSleAta+A3NXkMuYkYKDVd+ze0vo4ujAgdqtH/XMcKTFSjxIGaE1Pw1VYAOOYCR0Tm5VDfgng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=groP2DA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="groP2DA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E35CC4CEFB;
	Fri, 21 Nov 2025 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731416;
	bh=tjm3DaLjYUbKpmgMhaV3kXhl/13gLiuVpsxze0mvTb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=groP2DA8juXctpjAnct+Ni11oWX1fwJACRLNlA2jlDmiie9DivnGUhqVakwIOzMgN
	 tQP4bFMBaoo/b6ivEhupAoEhP5pPhDCw8lBOY4Fh/fnxFqOcpU/p3/WrBuOAK0cT6m
	 e+3Fc5waWOyiKzJ3a3YTwrZMBaibRV/s2wlbCwwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 201/247] spi: Try to get ACPI GPIO IRQ earlier
Date: Fri, 21 Nov 2025 14:12:28 +0100
Message-ID: <20251121130201.938806416@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

commit 3cd2018e15b3d66d2187d92867e265f45ad79e6f upstream.

Since commit d24cfee7f63d ("spi: Fix acpi deferred irq probe"), the
acpi_dev_gpio_irq_get() call gets delayed till spi_probe() is called
on the SPI device.

If there is no driver for the SPI device then the move to spi_probe()
results in acpi_dev_gpio_irq_get() never getting called. This may
cause problems by leaving the GPIO pin floating because this call is
responsible for setting up the GPIO pin direction and/or bias according
to the values from the ACPI tables.

Re-add the removed acpi_dev_gpio_irq_get() in acpi_register_spi_device()
to ensure the GPIO pin is always correctly setup, while keeping the
acpi_dev_gpio_irq_get() call added to spi_probe() to deal with
-EPROBE_DEFER returns caused by the GPIO controller not having a driver
yet.

Link: https://bbs.archlinux.org/viewtopic.php?id=302348
Fixes: d24cfee7f63d ("spi: Fix acpi deferred irq probe")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20251102190921.30068-1-hansg@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2866,6 +2866,16 @@ static acpi_status acpi_register_spi_dev
 	acpi_set_modalias(adev, acpi_device_hid(adev), spi->modalias,
 			  sizeof(spi->modalias));
 
+	/*
+	 * This gets re-tried in spi_probe() for -EPROBE_DEFER handling in case
+	 * the GPIO controller does not have a driver yet. This needs to be done
+	 * here too, because this call sets the GPIO direction and/or bias.
+	 * Setting these needs to be done even if there is no driver, in which
+	 * case spi_probe() will never get called.
+	 */
+	if (spi->irq < 0)
+		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
+
 	acpi_device_set_enumerated(adev);
 
 	adev->power.flags.ignore_parent = true;


