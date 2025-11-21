Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96852332904;
	Fri, 21 Nov 2025 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731941; cv=none; b=PiBPBDp/DFTwnMXCZMSixYLRSzCPbl758tItFNuYZRKXCPKACQVyTZxjmP67hjJCXQOMP+zQMlR1PactkooSKRlM157khH3hHtgmfLS6jBWTlxbNZJ+2bseOqDjn2OsAoIgqbH+xCunzU3j9RjgDEe/V85wpk63deJC8JL6ZPuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731941; c=relaxed/simple;
	bh=BT0f1X799ahFFW4+Gz+VY1gqUWtSrAOCYV7kqaRsj2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYpkVa71P/TCzjoGKPk4Bd2v8GISHwxNCGqlYkj2GQ9koYWQCkXoXfNdSCpAGeVGu2aWh8KkKnsQt6B2/IZNrPA9oPXnxcHIq606vk7o3WNS0h/9FxRS18Kwo579cBxycznEVJ68fEU23STXp+ZGvohopGAprDMTSqaOv/zM0Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YES6Xu4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YES6Xu4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6788C4CEF1;
	Fri, 21 Nov 2025 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731941;
	bh=BT0f1X799ahFFW4+Gz+VY1gqUWtSrAOCYV7kqaRsj2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YES6Xu4LCiDql4EAAWejnnftSQImU1YTXgEtxJBdaAi5w1emWbpweJyUUsIN12wI4
	 5/KEg3bMnYsKjkPTwcmpGO3BcWD79JWSOmh9KJykUowTq3SpR0UM+KY8Fj5iy7bmmg
	 QX0j/EzZxb9/o0152lSl/NccM9PwF39FAx0GfS8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 135/185] spi: Try to get ACPI GPIO IRQ earlier
Date: Fri, 21 Nov 2025 14:12:42 +0100
Message-ID: <20251121130148.746433702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
@@ -2879,6 +2879,16 @@ static acpi_status acpi_register_spi_dev
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


