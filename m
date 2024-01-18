Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F9B65C;
	Thu, 18 Jan 2024 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575029; cv=none; b=cdM/K8DEwb5099j4rD79zyeC+XzFRkTszf8fmIKZQ442YWlZE9YNLQSfgCxn3MHsbM5U8moNY7xqS2652xfnW4gUjocVq4xf3QrZSfUKh4pbz15YJ2D+iBkhDSkV4ZOuH86InNxNh75vnA/mRrGEuTFW65doBT0lqpZKM3CK/3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575029; c=relaxed/simple;
	bh=G+mXHue0OESYRdJGSaSiJhNfRVBsz2kv6xpkdLuRgZc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=NSqQDJWChx6f3E0GGrdhRqUwg7WKC0hxSSErReyMC0TcvpPFt8V12XzzZKFnt4ilUA+Z4Siq3atFQg8H3hdGxbRYpzCNIoRHp7qT1kR0mepL+VhCwbpzStCp3ZfrpVFmz9MfaM/EHXLz7mDEEw0EBPCtP0OGVNsdfZ73oESrzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwUy3IoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwUy3IoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE81DC433F1;
	Thu, 18 Jan 2024 10:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575029;
	bh=G+mXHue0OESYRdJGSaSiJhNfRVBsz2kv6xpkdLuRgZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwUy3IoTnC1aRrt815wMretYRV0GmbKjsxPDCb9/nUo+XI1Fh4cBdJzSNsFlVKRG4
	 I2mwG1lIWLmuNPgU/7IcFzYka+AFxNBAb0QaRJY9iCh6fbCwMZAl4OVmR1NdKFVOyO
	 BdsgC9Ke1NxHW9aZJzFtiaRCLGLWssKGGQIvxL6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 04/28] ALSA: hda: cs35l41: Prevent firmware load if SPI speed too low
Date: Thu, 18 Jan 2024 11:48:54 +0100
Message-ID: <20240118104301.390792090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit d110858a6925827609d11db8513d76750483ec06 upstream.

Some laptops without _DSD have the SPI speed set very low in the BIOS.
Since the SPI controller uses this speed as its max speed, the SPI
transactions are very slow. Firmware download writes to many registers,
and if the SPI speed is too slow, it can take a long time to download.
For this reason, disable firmware loading if the maximum SPI speed is
too low. Without Firmware, audio playback will work, but the volume
will be low to ensure safe operation of the CS35L41.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org> # v6.7+
Link: https://lore.kernel.org/r/20231221132518.3213-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda.c          |   25 ++++++++++-
 sound/pci/hda/cs35l41_hda.h          |   12 +++++
 sound/pci/hda/cs35l41_hda_i2c.c      |    2 
 sound/pci/hda/cs35l41_hda_property.c |   74 ++++++++++++++++-------------------
 sound/pci/hda/cs35l41_hda_spi.c      |    2 
 5 files changed, 70 insertions(+), 45 deletions(-)

--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -12,6 +12,7 @@
 #include <sound/hda_codec.h>
 #include <sound/soc.h>
 #include <linux/pm_runtime.h>
+#include <linux/spi/spi.h>
 #include "hda_local.h"
 #include "hda_auto_parser.h"
 #include "hda_jack.h"
@@ -996,6 +997,11 @@ static int cs35l41_smart_amp(struct cs35
 	__be32 halo_sts;
 	int ret;
 
+	if (cs35l41->bypass_fw) {
+		dev_warn(cs35l41->dev, "Bypassing Firmware.\n");
+		return 0;
+	}
+
 	ret = cs35l41_init_dsp(cs35l41);
 	if (ret) {
 		dev_warn(cs35l41->dev, "Cannot Initialize Firmware. Error: %d\n", ret);
@@ -1588,6 +1594,7 @@ static int cs35l41_hda_read_acpi(struct
 	u32 values[HDA_MAX_COMPONENTS];
 	struct acpi_device *adev;
 	struct device *physdev;
+	struct spi_device *spi;
 	const char *sub;
 	char *property;
 	size_t nval;
@@ -1610,7 +1617,7 @@ static int cs35l41_hda_read_acpi(struct
 	ret = cs35l41_add_dsd_properties(cs35l41, physdev, id, hid);
 	if (!ret) {
 		dev_info(cs35l41->dev, "Using extra _DSD properties, bypassing _DSD in ACPI\n");
-		goto put_physdev;
+		goto out;
 	}
 
 	property = "cirrus,dev-index";
@@ -1701,8 +1708,20 @@ static int cs35l41_hda_read_acpi(struct
 		hw_cfg->bst_type = CS35L41_EXT_BOOST;
 
 	hw_cfg->valid = true;
+out:
 	put_device(physdev);
 
+	cs35l41->bypass_fw = false;
+	if (cs35l41->control_bus == SPI) {
+		spi = to_spi_device(cs35l41->dev);
+		if (spi->max_speed_hz < CS35L41_MAX_ACCEPTABLE_SPI_SPEED_HZ) {
+			dev_warn(cs35l41->dev,
+				 "SPI speed is too slow to support firmware download: %d Hz.\n",
+				 spi->max_speed_hz);
+			cs35l41->bypass_fw = true;
+		}
+	}
+
 	return 0;
 
 err:
@@ -1711,14 +1730,13 @@ err:
 	hw_cfg->gpio1.valid = false;
 	hw_cfg->gpio2.valid = false;
 	acpi_dev_put(cs35l41->dacpi);
-put_physdev:
 	put_device(physdev);
 
 	return ret;
 }
 
 int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int irq,
-		      struct regmap *regmap)
+		      struct regmap *regmap, enum control_bus control_bus)
 {
 	unsigned int regid, reg_revid;
 	struct cs35l41_hda *cs35l41;
@@ -1737,6 +1755,7 @@ int cs35l41_hda_probe(struct device *dev
 	cs35l41->dev = dev;
 	cs35l41->irq = irq;
 	cs35l41->regmap = regmap;
+	cs35l41->control_bus = control_bus;
 	dev_set_drvdata(dev, cs35l41);
 
 	ret = cs35l41_hda_read_acpi(cs35l41, device_name, id);
--- a/sound/pci/hda/cs35l41_hda.h
+++ b/sound/pci/hda/cs35l41_hda.h
@@ -20,6 +20,8 @@
 #include <linux/firmware/cirrus/cs_dsp.h>
 #include <linux/firmware/cirrus/wmfw.h>
 
+#define CS35L41_MAX_ACCEPTABLE_SPI_SPEED_HZ	1000000
+
 struct cs35l41_amp_cal_data {
 	u32 calTarget[2];
 	u32 calTime[2];
@@ -46,6 +48,11 @@ enum cs35l41_hda_gpio_function {
 	CS35l41_SYNC,
 };
 
+enum control_bus {
+	I2C,
+	SPI
+};
+
 struct cs35l41_hda {
 	struct device *dev;
 	struct regmap *regmap;
@@ -74,6 +81,9 @@ struct cs35l41_hda {
 	struct cs_dsp cs_dsp;
 	struct acpi_device *dacpi;
 	bool mute_override;
+	enum control_bus control_bus;
+	bool bypass_fw;
+
 };
 
 enum halo_state {
@@ -85,7 +95,7 @@ enum halo_state {
 extern const struct dev_pm_ops cs35l41_hda_pm_ops;
 
 int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int irq,
-		      struct regmap *regmap);
+		      struct regmap *regmap, enum control_bus control_bus);
 void cs35l41_hda_remove(struct device *dev);
 int cs35l41_get_speaker_id(struct device *dev, int amp_index, int num_amps, int fixed_gpio_id);
 
--- a/sound/pci/hda/cs35l41_hda_i2c.c
+++ b/sound/pci/hda/cs35l41_hda_i2c.c
@@ -30,7 +30,7 @@ static int cs35l41_hda_i2c_probe(struct
 		return -ENODEV;
 
 	return cs35l41_hda_probe(&clt->dev, device_name, clt->addr, clt->irq,
-				 devm_regmap_init_i2c(clt, &cs35l41_regmap_i2c));
+				 devm_regmap_init_i2c(clt, &cs35l41_regmap_i2c), I2C);
 }
 
 static void cs35l41_hda_i2c_remove(struct i2c_client *clt)
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -16,10 +16,6 @@
 
 struct cs35l41_config {
 	const char *ssid;
-	enum {
-		SPI,
-		I2C
-	} bus;
 	int num_amps;
 	enum {
 		INTERNAL,
@@ -35,46 +31,46 @@ struct cs35l41_config {
 };
 
 static const struct cs35l41_config cs35l41_config_table[] = {
-	{ "10280B27", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10280B28", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10280BEB", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
-	{ "10280C4D", I2C, 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10280B27", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10280B28", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10280BEB", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
+	{ "10280C4D", 4, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT }, 0, 1, -1, 1000, 4500, 24 },
 /*
  * Device 103C89C6 does have _DSD, however it is setup to use the wrong boost type.
  * We can override the _DSD to correct the boost type here.
  * Since this laptop has valid ACPI, we do not need to handle cs-gpios, since that already exists
  * in the ACPI. The Reset GPIO is also valid, so we can use the Reset defined in _DSD.
  */
-	{ "103C89C6", SPI, 2, INTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, -1, -1, -1, 1000, 4500, 24 },
-	{ "104312AF", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431433", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431463", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431473", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
-	{ "10431483", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
-	{ "10431493", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "104314D3", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "104314E3", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431503", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431533", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431573", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431663", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
-	{ "104316D3", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
-	{ "104316F3", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
-	{ "104317F3", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431863", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "104318D3", I2C, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
-	{ "10431C9F", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431CAF", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431CCF", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431CDF", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431CEF", SPI, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
-	{ "10431D1F", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431DA2", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
-	{ "10431E02", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
-	{ "10431EE2", I2C, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
-	{ "10431F12", I2C, 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
-	{ "10431F1F", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
-	{ "10431F62", SPI, 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "103C89C6", 2, INTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, -1, -1, -1, 1000, 4500, 24 },
+	{ "104312AF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431433", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431463", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431473", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
+	{ "10431483", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
+	{ "10431493", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "104314D3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "104314E3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431503", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431533", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431573", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431663", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 1000, 4500, 24 },
+	{ "104316D3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "104316F3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "104317F3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431863", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "104318D3", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "10431C9F", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431CAF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431CCF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431CDF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431CEF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
+	{ "10431D1F", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431DA2", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "10431E02", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
+	{ "10431EE2", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "10431F12", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
+	{ "10431F1F", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
+	{ "10431F62", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{}
 };
 
@@ -212,7 +208,7 @@ static int generic_dsd_config(struct cs3
 			 "_DSD already exists.\n");
 	}
 
-	if (cfg->bus == SPI) {
+	if (cs35l41->control_bus == SPI) {
 		cs35l41->index = id;
 
 		/*
--- a/sound/pci/hda/cs35l41_hda_spi.c
+++ b/sound/pci/hda/cs35l41_hda_spi.c
@@ -26,7 +26,7 @@ static int cs35l41_hda_spi_probe(struct
 		return -ENODEV;
 
 	return cs35l41_hda_probe(&spi->dev, device_name, spi_get_chipselect(spi, 0), spi->irq,
-				 devm_regmap_init_spi(spi, &cs35l41_regmap_spi));
+				 devm_regmap_init_spi(spi, &cs35l41_regmap_spi), SPI);
 }
 
 static void cs35l41_hda_spi_remove(struct spi_device *spi)


