Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C512D77F5;
	Fri,  9 Oct 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557507; cv=none; b=q9KhZZtZNldTlkLCNtwAaq5RSWg4lcLRvsdscMBQjjfDYQ0T943oeRugHY7BU9MjArJS2y3/z+tZdzobtOsw/GRc7Fgq8Uoz3HBNPc7B9jwpWPkRVSJOKrgdOEJ1ufb9xv0MnQ+rDVIFKFBMA1eP7EWZy0g/SOC/d9J38BesjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557507; c=relaxed/simple;
	bh=ok4DN3nFXpNZWsdOwpcu9WTl2jZZ/sttYawPUArYvAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m19zHVpIzGAORvLZJW71WoYmZwTMJ4hFw9EPdtulP5zEUFZ8h7UClYb0Ev9XW/hjBfgzxstONzLL0TjOCZRQONC5YZNt5+Be52MRKWRf42oudCjLcku9xdEhPX5ZJw6gJi997ws39U1zvUE177FKySiX/0AxFe7Vh87l8E95W4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp6I3VUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp6I3VUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED51F000FF;
	Fri,  9 Oct 2026 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557506;
	bh=E2JARIVSw2f/zaJFOtYXcpBEDCHauNpTqMNBlJ6OAGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xp6I3VUjQV/vbbM67bVhk3A6U+THtf3msh1j7tH0fgDRbqcPKOd5//qZNcQLbGCCM
	 BXDWXp/rfYrnrA69DCLXRVIjgT1y5yhoWMNjpQXufaJj2YabqhSSwaEcCYhIUunP9G
	 /vZoK3n6JJYvxZ1Me2+BCQ6onA2cy0FF9nM2H3nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 382/428] iio: adc: axp288: Add TS bias override for Haier HV103H
Date: Fri,  9 Oct 2026 16:11:59 +0200
Message-ID: <20261009140954.586107042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>

commit 0f300db7b7315b2c7ea0e2d4437b88de162d191f upstream.

The Haier HV103H firmware configures the AXP288 TS pin bias
current to 60 uA. This causes the battery temperature reading to
cross the charging temperature threshold under load, incorrectly
stopping battery charging.

Setting the TS bias current to 80 uA fixes the temperature
measurement and prevents charging from being incorrectly disabled.

Add a DMI quirk to use the 80 uA TS bias current on the Haier
HV103H.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
Fixes: 048058399f19 ("iio: adc: axp288: Override TS pin bias current for some models") # Add necessary infrastructure
Signed-off-by: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp288_adc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -207,6 +207,14 @@ static const struct dmi_system_id axp288
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Haier HV103H */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "Haier"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "HV103H"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{ }
 };
 


