Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705003;
	b=2zWKn5DBBUWKamJpXluK62HZVZArE29AhQznmsc0MMmVu5jMe6ieiUO66TNYrzjrm1Jv
	 jnVuLLaOcAqtmkfWzzBZu7ya6+FZ+C8QMyr8rFbVH5s8EEHNEE68cpDUSZ15lUq9pC3+8
	 jJZkUFDEQlGSc5fyhPwWM2ZrQ7W2NUVpwDTTQUKMcgk7BG6TjjbSJxWGMxTJJrZCb/mNc
	 1mDg4o/xFB4Je5B3vGE/AXGaqROibOunrOEbK/yFeYs97/IId2+GiTjO27Pd/2Y8gfelZ
	 yu2O7HH3KCH7XaMLJBLoL1F5B1R7+et3UA0+0BagHmKv3zKk+NTLB3YPLf1mzbErfXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gL7kHCp13MUO+SaHUEybwAI1he/NrlIFlQuLrkyQcxU=;
	b=EhMSmtnYoebDeiOovUIfYJ4Z26nFpLbtJ8tx5HgUJsYrm4OJTv2vntkMjVmTCNjOmR3y
	 7P1ttwDxROry/sElXEJnh/+EW9T/pFMcsgVMPE1z1qEPt5dmrbiqWNj063s3Uwb3cAi8k
	 NCoJ3GYEoar5VOqFBZiqwFxChDT8aXHhkmPixYoN4ucKKLvryhyVjWUwCiIGcQWjkeh7p
	 SlPu2/RlJkFt5iJx9PFoAzN2gED9gUtOZff1cM/S2T0/9k1YlFkOsZqa5qtRcRUHdotfC
	 2AQXiZFK0tkezTP7jo9kvSoc5Q0XkLJA2K+pzV09EWqizvP3U90ieXASuf+QMlg0o9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdHeWG4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916D606A337;
	Thu, 26 Nov 2026 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdHeWG4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290891F000C0;
	Thu, 26 Nov 2026 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705002;
	bh=gL7kHCp13MUO+SaHUEybwAI1he/NrlIFlQuLrkyQcxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdHeWG4MaviNeOyvS4pBO/f0qKIzIBf7ndWTdcgBHnVcMScNoG5/QW0srIYEBjVeh
	 BM7W1c9Uj9HlMhGu9DhHx/NVRzFav36IXWPEZ1KOjJDtC+gPaPitFskN9i+8F3O/AN
	 O9WrMlOUeE0XX+wZEbTcn2IFbX7UYEiPNwYOsE+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/319] spi: acpi: only look up the IRQ of confirmed SPI devices
Date: Thu, 26 Nov 2026 15:36:57 +0100
Message-ID: <20261126144007.842867531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 56505af80ba80..a32a1cb4ddcd1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2275,7 +2275,6 @@ struct acpi_spi_lookup {
 	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
-	int			irq;
 	u8			bits_per_word;
 	u8			chip_select;
 	int			n;
@@ -2379,17 +2378,25 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
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
@@ -2414,6 +2421,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	struct list_head resource_list;
 	struct acpi_spi_lookup lookup = {};
 	struct spi_device *spi;
+	int irq = -1;
 	int ret;
 
 	if (!ctlr && index == -1)
@@ -2421,7 +2429,6 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 
 	lookup.ctlr		= ctlr;
 	lookup.device_handle	= acpi_device_handle(adev);
-	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
 
@@ -2444,6 +2451,19 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
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
@@ -2454,7 +2474,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	ACPI_COMPANION_SET(&spi->dev, adev);
 	spi->max_speed_hz	= lookup.max_speed_hz;
 	spi->mode		|= lookup.mode;
-	spi->irq		= lookup.irq;
+	spi->irq		= irq;
 	spi->bits_per_word	= lookup.bits_per_word;
 	spi->chip_select	= lookup.chip_select;
 
-- 
2.53.0



