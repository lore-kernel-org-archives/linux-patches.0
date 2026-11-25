Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624193;
	b=HmHu5NDzbYpUzNnFooGB1hwPZduQWwrgC0nkuTqqEgyrEZjSs6Nlf15Wr+K91TDeP8Vm
	 UIUlSU/sg11IHv3b+X7YxqEFIz4tGFbhaKbH5gNUDSWFtysJrP72svP4K4I0VD6ezPXtp
	 83gMsdYEqlud0yjwljR6CYaZQFb8i5dnBxCQCfaOxlp1Mle/BuiSp5CMcviORh6TFkKq5
	 yIq1HW5vMQKcGRhA0hZ1QJ7Gi7Qvl7DiYSzHLZclfod1i4FlZeqoMXx+qispmbfd2P8Ce
	 xNYkqou7+H5o3a/Pdcn5YiPh8ZzR0O+qmPPCzB+UanDLgCLkDFMo/qbWqfHRKZ4uvZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W+ebfG417XrMfkGdDxIkNrkzB8DABSOTBQx4eGUW1dU=;
	b=R7Bf8+o20A9qGZS2iwCChir/M0qgvCHc3dR5+1QgnrP7G8B6oWgGsZHLFBQ6GaDXqFmw
	 Yp0C395ztmnRdb6CcuSwxD3W8/Jov8sAxmB3QS5eVLnH0niVJHMFX3qF2LJsojRZzTeGL
	 Yz+Cxp7vXr8ibygNf/2lMlUqUP7I6jq8gJs8F6lREGRz1uzpXo9+kuLsKReDmKXOVDIY9
	 c6M7KK4f0sdTFQMSdzgrOuJYC3VrSwjjG32TFzhjx+GXTdmL+PtiRaExaibI9LGp8G7wa
	 b+367aPRHz7yc3lWVPjIGOz2PZlf7J5CxB9Lo+g76Ot1cpM6Ui4OUyS24IXB7B8EQ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrUl4My3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC7606A681;
	Wed, 25 Nov 2026 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrUl4My3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF31F000CF;
	Wed, 25 Nov 2026 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624192;
	bh=W+ebfG417XrMfkGdDxIkNrkzB8DABSOTBQx4eGUW1dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrUl4My3SVIeOWQtZxTmMlM55peUL1st+moOlMK4ymRXbnZO4vbwu/kUSkGMEzSzl
	 kr7pIa/YruFTF0LNlHXVUPd3Jht9S1xzD0nh/0XuPFQH28e+OWg3nvwiuhW+jVlAeN
	 tiamTJ3P9lu2d4y4fwmf6bg7yGqnHUojo4s4qChY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/816] spi: acpi: only look up the IRQ of confirmed SPI devices
Date: Wed, 25 Nov 2026 15:27:41 +0100
Message-ID: <20261125143851.826948682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5f58df273dc7b..6b7702433c764 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2631,7 +2631,6 @@ struct acpi_spi_lookup {
 	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
-	int			irq;
 	u8			bits_per_word;
 	u8			chip_select;
 	int			n;
@@ -2774,17 +2773,25 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
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
@@ -2809,6 +2816,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	struct list_head resource_list;
 	struct acpi_spi_lookup lookup = {};
 	struct spi_device *spi;
+	int irq = -1;
 	int ret;
 
 	if (!ctlr && index == -1)
@@ -2816,7 +2824,6 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 
 	lookup.ctlr		= ctlr;
 	lookup.device_handle	= acpi_device_handle(adev);
-	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
 
@@ -2839,6 +2846,19 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
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
@@ -2852,7 +2872,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
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



