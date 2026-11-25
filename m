Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621121;
	b=p4+5WIKpt2H6pHzCKMUIfTX5K1kV8LAR/z+LmvngcetPOXOoezXvnKTZh85M9fv8OznJ
	 D1k9n4Iyo1mOlsCdLuNiadNpg0EPBe9LmRhCN+y0z7dlHJF/60BitGtewK/EClGfIzKBf
	 NGT9gyqV402KZyUuXEd8aLBAFpSKcnflnlxaPam9aI3pRVHQFL6mRv4tYTbJ72FXONMwW
	 Z77Xtnm951LfFqrpt3p3Zfe89R0MFRyy6cEHGD3uPxL2ls724qc3WtIVuqmDD8AOGc+rT
	 KQbmC7z4Iri93Zscr6iXXdpfUmI28VS5Y6uLAg+Q/nkvccoVvds+o35a63TG6Kt7HNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+1ZCyM9iqonLIhGSha1B5TobQqXGZvaahbLJAM0EdQ=;
	b=TKL643ulsxjHvGdO8FhPP1OJnyqFtr2As4rC4fCvAJEqx8L3rTw/Wx/VoeQobnU4W8d4
	 G0B2D5RASTIr9Xy0/ATb27grL0BR/KlAxosUtnfiP3etwJXhxe1wS0NHbLvcZkAX57Kjc
	 s8HYfmhmWygNEZLAe6DImHw2rxk1pNyvZ869CdI9NiIOkrf3krbONkah8xy3A8t7CTO1a
	 bP5vdkizbf0uIWK70Y9cxQO5huXBV4jqGMFI7ZLSThhx93MZ51RmTOT56y2y0XxVVMwqv
	 v1RQ6v5mowOHQB9U715MDGlav6gXhg7+WGTeB7EpbIcLpZcsdMhOmoC64LvZvorpFmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbeJQmGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77B8606A32C;
	Wed, 25 Nov 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbeJQmGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AB91F000CA;
	Wed, 25 Nov 2026 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621120;
	bh=T+1ZCyM9iqonLIhGSha1B5TobQqXGZvaahbLJAM0EdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbeJQmGO77QbE+jO3FIQmT6j4mE8Kil2hTCymN2NM6SoOhJqSrlkB3gMipOJXxFBH
	 3Ucq8WF9PILod8HHp21H3HPI9qaMovauWXJV0LMWRgHETUJ726tiW7RdJU544GyTd5
	 Ow625y0Q6Bc7IaeIHJut0rhe/1+o4N2DRsXsOJX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/990] spi: acpi: only look up the IRQ of confirmed SPI devices
Date: Wed, 25 Nov 2026 15:24:56 +0100
Message-ID: <20261125143825.108831899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 2d0953ab69d316589624b0517fdce01f8e630bf0 ]

When an SPI controller is registered, acpi_register_spi_device() is
called for every present ACPI device in the namespace and
acpi_spi_device_alloc() walks each device's _CRS. While doing so,
acpi_spi_add_resource() converts the first interrupt resource it finds,
even for devices that have no SpiSerialBus resource at all and are
discarded right afterwards. Converting an interrupt resource registers
its GSI, so this maps IRQs for arbitrary unrelated ACPI devices.

On a Dell Precision M4800 (Lynx Point, 24-pin IOAPIC) the DSDT reports
Haswell-ULT LPSS child devices (\_SB.PCI0.I2C0.ACD0 and
\_SB.PCI0.SDHC.WI01) as present with interrupts on GSI 37 and 38.
Registering the intel-spi controller then results in:

  ERROR: Unable to locate IOAPIC for GSI 37
  ERROR: Unable to locate IOAPIC for GSI 38

Do what the I2C core does and only parse the interrupt resource once the
device has been identified as an SPI device on this controller.

Fixes: 4c3c59544f33 ("spi/acpi: enumerate all SPI slaves in the namespace")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20261101200155.15740-1-rosenp@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index b447907fba508..b678e202b384b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2604,7 +2604,6 @@ struct acpi_spi_lookup {
 	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
-	int			irq;
 	u8			bits_per_word;
 	u8			chip_select;
 	int			n;
@@ -2747,17 +2746,25 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
 				lookup->mode |= SPI_CS_HIGH;
 		}
-	} else if (lookup->irq < 0) {
-		struct resource r;
-
-		if (acpi_dev_resource_interrupt(ares, 0, &r))
-			lookup->irq = r.start;
 	}
 
 	/* Always tell the ACPI core to skip this resource */
 	return 1;
 }
 
+static int acpi_spi_add_irq_resource(struct acpi_resource *ares, void *data)
+{
+	int *irq = data;
+	struct resource r;
+
+	if (*irq < 0 && ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS &&
+	    acpi_dev_resource_interrupt(ares, 0, &r))
+		*irq = r.start;
+
+	/* Always tell the ACPI core to skip this resource */
+	return 1;
+}
+
 /**
  * acpi_spi_device_alloc - Allocate a spi device, and fill it in with ACPI information
  * @ctlr: controller to which the spi device belongs
@@ -2782,6 +2789,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	struct list_head resource_list;
 	struct acpi_spi_lookup lookup = {};
 	struct spi_device *spi;
+	int irq = -1;
 	int ret;
 
 	if (!ctlr && index == -1)
@@ -2789,7 +2797,6 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 
 	lookup.ctlr		= ctlr;
 	lookup.device_handle	= acpi_device_handle(adev);
-	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
 
@@ -2812,6 +2819,19 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	if (!lookup.max_speed_hz)
 		return ERR_PTR(-ENODEV);
 
+	/*
+	 * Only look up the IRQ once we know this is an SPI device for us.
+	 * Parsing an interrupt resource maps its GSI, which must not be done
+	 * for every unrelated ACPI device walked during enumeration.
+	 */
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_spi_add_irq_resource, &irq);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	acpi_dev_free_resource_list(&resource_list);
+
 	spi = spi_alloc_device(lookup.ctlr);
 	if (!spi) {
 		dev_err(&lookup.ctlr->dev, "failed to allocate SPI device for %s\n",
@@ -2824,7 +2844,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	ACPI_COMPANION_SET(&spi->dev, adev);
 	spi->max_speed_hz	= lookup.max_speed_hz;
 	spi->mode		|= lookup.mode;
-	spi->irq		= lookup.irq;
+	spi->irq		= irq;
 	spi->bits_per_word	= lookup.bits_per_word;
 	/*
 	 * By default spi->chip_select[0] will hold the physical CS number,
-- 
2.53.0



