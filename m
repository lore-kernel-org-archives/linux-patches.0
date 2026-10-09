Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EA9125AA;
	Fri,  9 Oct 2026 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556344; cv=none; b=tHw7Tl1hTRpjBQ+F5IV2kD7VzQLHRC4JqJSSLUwIoWFpmImXkgSrdnIgCuaUACtFwGxQPSKcxREiGAxGQHREUiB56deRK9++oLmxM4bHi4JP/bpAk4Ol1Prh4SDKYer37vmwaTg+6lqsrgM5whwHJU1qbOlHGEvGDP2luRleoTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556344; c=relaxed/simple;
	bh=uw0G1rRfhKnAUqhz0zWWSLMdi+8bm2unCXmBknWS7GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVr3IzVW5cFcgqdpXbpegj5QJlVVUy97tICuxVp/k4xLK0YBNVl0wnNNh2CMhKJ1ZfnM0+hOOwt4EBIuaxV4Xwm09FtG9/KifskFZgZO+Wj/iaFJqaKGhYaK+sxp/yUJsdVDJ7DodDY00lz9OcTumtmSF5oexyBQbgvSx+0tQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNAYU7pb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNAYU7pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A7C1F000FF;
	Fri,  9 Oct 2026 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556343;
	bh=HnnF4m0RRmFisZ5rW0UY9J3Wd94u1+biws8F0EQWrDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNAYU7pb0GD4m7cHh3FgSJbVOsgVx7lOmdC4Hh+PykUylHP0s1huqcI2mV8R/dpHA
	 Z24+IHtJDKLph5AQ2xcHfiWY9ODVTXAXfqlCoyXb8ZeXbd3Bgatba+YauqbJmF0HuO
	 4324k/NpK5sXW0D47seZ95o+AP0soxmjn+FLD4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wiza Jalakasi <wjalakasi@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 161/428] spi: cs42l43: Workaround for wrong speaker ID on Dell XPS 13 DX13260
Date: Fri,  9 Oct 2026 16:08:18 +0200
Message-ID: <20261009140949.696890331@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit cad16d850e3759dd82cd869f739b56e9844a1fee ]

On Dell XPS 13 DX13260 create an acpi_gpio_mapping with exactly two
GPIO entries to point at the two pins in the GpioIo(). Use this to
read the speaker ID GPIOs.

This fixes problems on Dell XPS 13 DX13260:

- No speaker audio
- The wrong firmware was loaded so the speaker protection did not match
  the speaker characteristics.

The Dell XPS 13 DX13260 has two speaker ID GPIOs, to form a 2-bit ID. The
ACPI GpioIo() has both pins but the Linux-specific spk-id-gpios property
only has a mapping to the first pin. This meant that the speaker ID was
wrong in most cases, and that would lead to the codec driver loading the
wrong amp firmware, or not finding a firmware (as 0 is not a valid ID on
this laptop).

Assisted-by: Codex:gpt-6-sol
Reported-by: Wiza Jalakasi <wjalakasi@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221956
Tested-by: Wiza Jalakasi <wjalakasi@gmail.com>
Fixes: f3c605147741e ("spi: cs42l43: Add GPIO speaker id support to the bridge configuration")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20261001085830.4014291-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 97 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index 7106a8a4f2805..6772abb483dd3 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -11,6 +11,7 @@
 #include <linux/bitfield.h>
 #include <linux/cleanup.h>
 #include <linux/device.h>
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
@@ -215,12 +216,108 @@ static size_t cs42l43_spi_max_length(struct spi_device *spi)
 	return CS42L43_SPI_MAX_LENGTH;
 }
 
+/*
+ * Workaround needed for two speaker ID pins in one ACPI GpioIo() but
+ * the Linux-specific _DSD property only contains one pin.
+ * Create a temporary acpi_gpio_mapping pointing at both pins.
+ */
+static const struct acpi_gpio_params cs42l43_2bit_speaker_id_from_one_gpioio_params[] = {
+	[0] = {
+		.crs_entry_index = 0,
+		.line_index = 0,
+	},
+	[1] = {
+		.crs_entry_index = 0,
+		.line_index = 1,
+	},
+};
+
+static const struct acpi_gpio_mapping cs42l43_2bit_speaker_id_from_one_gpioio_mapping[] = {
+	{
+		.name = "spk-id-quirk-gpios",
+		.data = cs42l43_2bit_speaker_id_from_one_gpioio_params,
+		.size = ARRAY_SIZE(cs42l43_2bit_speaker_id_from_one_gpioio_params),
+	},
+	{ }
+};
+
+static int cs42l43_get_2bit_speaker_id_from_one_gpioio(struct cs42l43_spi *priv, int *result)
+{
+	struct fwnode_reference_args args;
+	struct acpi_device *adev;
+	struct gpio_desc *desc;
+	u32 spkid = 0;
+	int i, ret;
+
+	/* Use the _DSD property to get the node containing the GpioIo() */
+	ret = fwnode_property_get_reference_args(dev_fwnode(priv->dev), "spk-id-gpios",
+						 NULL, 3, 0, &args);
+	if (ret)
+		return ret;
+
+	struct fwnode_handle *fwnode __free(fwnode_handle) = args.fwnode;
+
+	/* An acpi_gpio_mapping must be added to the node that contains the GpioIo() */
+	adev = to_acpi_device_node(fwnode);
+	if (!adev)
+		return -EINVAL;
+
+	ret = acpi_dev_add_driver_gpios(adev, cs42l43_2bit_speaker_id_from_one_gpioio_mapping);
+	if (ret)
+		return ret;
+
+	/* gpiod_get_array() can't read from a mapping in a child node */
+	for (i = 0; i < ARRAY_SIZE(cs42l43_2bit_speaker_id_from_one_gpioio_params); i++) {
+		desc = fwnode_gpiod_get_index(fwnode, "spk-id-quirk", i, GPIOD_IN,
+					      dev_name(priv->dev));
+		if (IS_ERR(desc)) {
+			ret = PTR_ERR(desc);
+			goto out;
+		}
+
+		ret = gpiod_get_value_cansleep(desc);
+		gpiod_put(desc);
+		if (ret < 0)
+			goto out;
+
+		spkid |= (u32)ret << i;
+	}
+
+	dev_dbg(priv->dev, "spk-id-gpios = %u\n", spkid);
+	*result = spkid;
+	ret = 0;
+out:
+	acpi_dev_remove_driver_gpios(adev);
+
+	return ret;
+}
+
+static const struct dmi_system_id cs42l43_spk_id_quirks[] = {
+	{
+		.ident = "Dell XPS 13 DX13260",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0E53"),
+		},
+		.driver_data = cs42l43_get_2bit_speaker_id_from_one_gpioio,
+	},
+	{ }
+};
+
 static int cs42l43_get_speaker_id_gpios(struct cs42l43_spi *priv, int *result)
 {
+	const struct dmi_system_id *dmi_id;
 	struct gpio_descs *descs;
 	u32 spkid;
 	int i, ret;
 
+	dmi_id = dmi_first_match(cs42l43_spk_id_quirks);
+	if (dmi_id) {
+		int (*get_speaker_id)(struct cs42l43_spi *priv, int *result) = dmi_id->driver_data;
+
+		return get_speaker_id(priv, result);
+	}
+
 	descs = gpiod_get_array_optional(priv->dev, "spk-id", GPIOD_IN);
 	if (!descs)
 		return 0;
-- 
2.53.0



