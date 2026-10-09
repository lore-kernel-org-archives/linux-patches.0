Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599532D8DC4;
	Fri,  9 Oct 2026 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555895; cv=none; b=pYa1g3x+ceGnt372iyH6VNRXkm6LATPH+m7No1F23vIkeln8ubxJl69zabYKs+H1vwpWHqSZiXGUNkfyf7U3eUOK1APmdZtjJ/N9N8oDSIr1MiZrkTYDXfe0oYstvptfFZB8OI64HPwVf7CSEWMYWmEaFTthh6wSsfScBoNwcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555895; c=relaxed/simple;
	bh=xr/qx2+1RbBnSFir+aioAkIl5KELD0xS1NOGdbADIKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlwdmTxDcae3MxiPBWMDRwOB0mVcqaI9mg6Vw231OcW7mR9Gv3gdJBhuNUGa6S1xG4rl4mUoGtPhYcMfh+yerCfvTmkno1GYX+R+LnJwbxrinISaR9dU94auJLkMkUzXYDRXZq9cF5BE8HgEinPvPWRafrDUyjO+m+ggrZZew5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdQHKZN4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdQHKZN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CDE1F00893;
	Fri,  9 Oct 2026 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555894;
	bh=j6mNnKjRRkkm18Y9mp7yUShIa1biXNYjAQVQ+UUI3io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdQHKZN4N7pJ+b53xoviyR/BDZew3Yk1o2FABNkOudxbu1qMFyMxcTFs63O0u0bLy
	 CVGzHkiJrtmZbLQ1Dfme4SwUdJf0ZxgbhcR2/Hrrt9kJbKsyhEEHLwg2PLzWYvyw37
	 EFJqnXFULyawsWFrLJC7/qwN7nUD8p/0BBOQd4sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wiza Jalakasi <wjalakasi@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/403] spi: cs42l43: Workaround for wrong speaker ID on Dell XPS 13 DX13260
Date: Fri,  9 Oct 2026 16:08:16 +0200
Message-ID: <20261009140955.231558510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 14307dd800b74..4d153f58f2462 100644
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
@@ -230,12 +231,108 @@ static size_t cs42l43_spi_max_length(struct spi_device *spi)
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



