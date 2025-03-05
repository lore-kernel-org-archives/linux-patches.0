Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A80253322;
	Wed,  5 Mar 2025 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198481; cv=none; b=I4PLt8MKz12fBZrMME7XVPXcL8P73hHjM7uo1SfYX5cOY0TTk1D9yfNUgYJ6cD/dhpH+tjWSV9n3feoYvPeVDlYM56VcY3l9W4P7YFJaKAf+dtpQz6tXqZlisi4HZFcsQtU9TEaG62NlWKKahSI4Uz0I+cLcMe5qrIdqgl70Tqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198481; c=relaxed/simple;
	bh=sGoEVMG7OkNxK29fH5d2xp2nLaPHzH62VoGpgTGvsng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3NcSYItUF2qYUj9Xxm15huwpgDDCovWy4tqWoMbjKBwtyOsyaxOpVX7h7+3mNokFidYI65SpG26MQDfzvAcbREtQOgCeVEjt/tEb1hAXJ/qffsYaY7ZwqDHHiU3tYzNjs++tDirCEXM+pzJ5pNKXu1XHA6W+KYeU+d6y+eY5jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPWCNVzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPWCNVzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD35C4CEE2;
	Wed,  5 Mar 2025 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198480;
	bh=sGoEVMG7OkNxK29fH5d2xp2nLaPHzH62VoGpgTGvsng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPWCNVzVxgAx2UPBi0MeVZPSLRXfBPK99altl47zZ69JfieIyAbFBZBgKGai5A03B
	 eczjdOEL9VrS83OpOa3qPQZ/o7WsedFk+oso3hlEXCiy98g+EHoKm0WiDUtCMCwg4r
	 D0kHGiuFf3J1apLV5MyP/hdMqoU2TQx+xDD6rMik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 042/157] ASoC: cs35l56: Prevent races when soft-resetting using SPI control
Date: Wed,  5 Mar 2025 18:47:58 +0100
Message-ID: <20250305174506.990258358@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 769c1b79295c38d60fde4c0a8f5f31e01360c54f ]

When SPI is used for control, the driver must hold the SPI bus lock
while issuing the sequence of writes to perform a soft reset.

>From the time the driver writes the SYSTEM_RESET command until the
driver does a write to terminate the reset, there must not be any
activity on the SPI bus lines. If there is any SPI activity during the
soft-reset, another soft-reset will be triggered. The state of the SPI
chip select is irrelevant.

A repeated soft-reset does not in itself cause any problems, and it is
not an infinite loop. The problem is a race between these resets and
the driver polling for boot completion. There is a time window between
soft resets where the driver could read HALO_STATE as 2 (fully booted)
while the chip is actually soft-resetting. Although this window is
small, it is long enough that it is possible to hit it in normal
operation.

To prevent this race and ensure the chip really is fully booted, the
driver calls spi_bus_lock() to prevent other activity while resetting.
It then issues the SYSTEM_RESET mailbox command. After allowing
sufficient time for reset to take effect, the driver issues a PING
mailbox command, which will force completion of the full soft-reset
sequence. The SPI bus lock can then be released. The mailbox is
checked for any boot or wakeup response from the firmware, before the
value in HALO_STATE will be trusted.

This does not affect SoundWire or I2C control.

Fixes: 8a731fd37f8b ("ASoC: cs35l56: Move utility functions to shared file")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250225131843.113752-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h           | 31 ++++++++++++
 sound/pci/hda/cs35l56_hda_spi.c   |  3 ++
 sound/soc/codecs/cs35l56-shared.c | 80 +++++++++++++++++++++++++++++++
 sound/soc/codecs/cs35l56-spi.c    |  3 ++
 4 files changed, 117 insertions(+)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index 3dc7a1551ac35..5d653a3491d07 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -12,6 +12,7 @@
 #include <linux/firmware/cirrus/cs_dsp.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
+#include <linux/spi/spi.h>
 #include <sound/cs-amp-lib.h>
 
 #define CS35L56_DEVID					0x0000000
@@ -61,6 +62,7 @@
 #define CS35L56_IRQ1_MASK_8				0x000E0AC
 #define CS35L56_IRQ1_MASK_18				0x000E0D4
 #define CS35L56_IRQ1_MASK_20				0x000E0DC
+#define CS35L56_DSP_MBOX_1_RAW				0x0011000
 #define CS35L56_DSP_VIRTUAL1_MBOX_1			0x0011020
 #define CS35L56_DSP_VIRTUAL1_MBOX_2			0x0011024
 #define CS35L56_DSP_VIRTUAL1_MBOX_3			0x0011028
@@ -224,6 +226,7 @@
 #define CS35L56_HALO_STATE_SHUTDOWN			1
 #define CS35L56_HALO_STATE_BOOT_DONE			2
 
+#define CS35L56_MBOX_CMD_PING				0x0A000000
 #define CS35L56_MBOX_CMD_AUDIO_PLAY			0x0B000001
 #define CS35L56_MBOX_CMD_AUDIO_PAUSE			0x0B000002
 #define CS35L56_MBOX_CMD_AUDIO_REINIT			0x0B000003
@@ -254,6 +257,16 @@
 #define CS35L56_NUM_BULK_SUPPLIES			3
 #define CS35L56_NUM_DSP_REGIONS				5
 
+/* Additional margin for SYSTEM_RESET to control port ready on SPI */
+#define CS35L56_SPI_RESET_TO_PORT_READY_US (CS35L56_CONTROL_PORT_READY_US + 2500)
+
+struct cs35l56_spi_payload {
+	__be32	addr;
+	__be16	pad;
+	__be32	value;
+} __packed;
+static_assert(sizeof(struct cs35l56_spi_payload) == 10);
+
 struct cs35l56_base {
 	struct device *dev;
 	struct regmap *regmap;
@@ -269,6 +282,7 @@ struct cs35l56_base {
 	s8 cal_index;
 	struct cirrus_amp_cal_data cal_data;
 	struct gpio_desc *reset_gpio;
+	struct cs35l56_spi_payload *spi_payload_buf;
 };
 
 static inline bool cs35l56_is_otp_register(unsigned int reg)
@@ -276,6 +290,23 @@ static inline bool cs35l56_is_otp_register(unsigned int reg)
 	return (reg >> 16) == 3;
 }
 
+static inline int cs35l56_init_config_for_spi(struct cs35l56_base *cs35l56,
+					      struct spi_device *spi)
+{
+	cs35l56->spi_payload_buf = devm_kzalloc(&spi->dev,
+						sizeof(*cs35l56->spi_payload_buf),
+						GFP_KERNEL | GFP_DMA);
+	if (!cs35l56->spi_payload_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline bool cs35l56_is_spi(struct cs35l56_base *cs35l56)
+{
+	return IS_ENABLED(CONFIG_SPI_MASTER) && !!cs35l56->spi_payload_buf;
+}
+
 extern const struct regmap_config cs35l56_regmap_i2c;
 extern const struct regmap_config cs35l56_regmap_spi;
 extern const struct regmap_config cs35l56_regmap_sdw;
diff --git a/sound/pci/hda/cs35l56_hda_spi.c b/sound/pci/hda/cs35l56_hda_spi.c
index d4ee5bb7c4866..9035784669053 100644
--- a/sound/pci/hda/cs35l56_hda_spi.c
+++ b/sound/pci/hda/cs35l56_hda_spi.c
@@ -22,6 +22,9 @@ static int cs35l56_hda_spi_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	cs35l56->base.dev = &spi->dev;
+	ret = cs35l56_init_config_for_spi(&cs35l56->base, spi);
+	if (ret)
+		return ret;
 
 #ifdef CS35L56_WAKE_HOLD_TIME_US
 	cs35l56->base.can_hibernate = true;
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index e0ed4fc11155a..e28bfefa72f33 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
 #include <linux/types.h>
 #include <sound/cs-amp-lib.h>
 
@@ -303,6 +304,79 @@ void cs35l56_wait_min_reset_pulse(void)
 }
 EXPORT_SYMBOL_NS_GPL(cs35l56_wait_min_reset_pulse, "SND_SOC_CS35L56_SHARED");
 
+static const struct {
+	u32 addr;
+	u32 value;
+} cs35l56_spi_system_reset_stages[] = {
+	{ .addr = CS35L56_DSP_VIRTUAL1_MBOX_1, .value = CS35L56_MBOX_CMD_SYSTEM_RESET },
+	/* The next write is necessary to delimit the soft reset */
+	{ .addr = CS35L56_DSP_MBOX_1_RAW, .value = CS35L56_MBOX_CMD_PING },
+};
+
+static void cs35l56_spi_issue_bus_locked_reset(struct cs35l56_base *cs35l56_base,
+					       struct spi_device *spi)
+{
+	struct cs35l56_spi_payload *buf = cs35l56_base->spi_payload_buf;
+	struct spi_transfer t = {
+		.tx_buf		= buf,
+		.len		= sizeof(*buf),
+	};
+	struct spi_message m;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(cs35l56_spi_system_reset_stages); i++) {
+		buf->addr = cpu_to_be32(cs35l56_spi_system_reset_stages[i].addr);
+		buf->value = cpu_to_be32(cs35l56_spi_system_reset_stages[i].value);
+		spi_message_init_with_transfers(&m, &t, 1);
+		ret = spi_sync_locked(spi, &m);
+		if (ret)
+			dev_warn(cs35l56_base->dev, "spi_sync failed: %d\n", ret);
+
+		usleep_range(CS35L56_SPI_RESET_TO_PORT_READY_US,
+			     2 * CS35L56_SPI_RESET_TO_PORT_READY_US);
+	}
+}
+
+static void cs35l56_spi_system_reset(struct cs35l56_base *cs35l56_base)
+{
+	struct spi_device *spi = to_spi_device(cs35l56_base->dev);
+	unsigned int val;
+	int read_ret, ret;
+
+	/*
+	 * There must not be any other SPI bus activity while the amp is
+	 * soft-resetting.
+	 */
+	ret = spi_bus_lock(spi->controller);
+	if (ret) {
+		dev_warn(cs35l56_base->dev, "spi_bus_lock failed: %d\n", ret);
+		return;
+	}
+
+	cs35l56_spi_issue_bus_locked_reset(cs35l56_base, spi);
+	spi_bus_unlock(spi->controller);
+
+	/*
+	 * Check firmware boot by testing for a response in MBOX_2.
+	 * HALO_STATE cannot be trusted yet because the reset sequence
+	 * can leave it with stale state. But MBOX is reset.
+	 * The regmap must remain in cache-only until the chip has
+	 * booted, so use a bypassed read.
+	 */
+	ret = read_poll_timeout(regmap_read_bypassed, read_ret,
+				(val > 0) && (val < 0xffffffff),
+				CS35L56_HALO_STATE_POLL_US,
+				CS35L56_HALO_STATE_TIMEOUT_US,
+				false,
+				cs35l56_base->regmap,
+				CS35L56_DSP_VIRTUAL1_MBOX_2,
+				&val);
+	if (ret) {
+		dev_err(cs35l56_base->dev, "SPI reboot timed out(%d): MBOX2=%#x\n",
+			read_ret, val);
+	}
+}
+
 static const struct reg_sequence cs35l56_system_reset_seq[] = {
 	REG_SEQ0(CS35L56_DSP1_HALO_STATE, 0),
 	REG_SEQ0(CS35L56_DSP_VIRTUAL1_MBOX_1, CS35L56_MBOX_CMD_SYSTEM_RESET),
@@ -315,6 +389,12 @@ void cs35l56_system_reset(struct cs35l56_base *cs35l56_base, bool is_soundwire)
 	 * accesses other than the controlled system reset sequence below.
 	 */
 	regcache_cache_only(cs35l56_base->regmap, true);
+
+	if (cs35l56_is_spi(cs35l56_base)) {
+		cs35l56_spi_system_reset(cs35l56_base);
+		return;
+	}
+
 	regmap_multi_reg_write_bypassed(cs35l56_base->regmap,
 					cs35l56_system_reset_seq,
 					ARRAY_SIZE(cs35l56_system_reset_seq));
diff --git a/sound/soc/codecs/cs35l56-spi.c b/sound/soc/codecs/cs35l56-spi.c
index c101134e85328..ca6c03a8766d3 100644
--- a/sound/soc/codecs/cs35l56-spi.c
+++ b/sound/soc/codecs/cs35l56-spi.c
@@ -33,6 +33,9 @@ static int cs35l56_spi_probe(struct spi_device *spi)
 
 	cs35l56->base.dev = &spi->dev;
 	cs35l56->base.can_hibernate = true;
+	ret = cs35l56_init_config_for_spi(&cs35l56->base, spi);
+	if (ret)
+		return ret;
 
 	ret = cs35l56_common_probe(cs35l56);
 	if (ret != 0)
-- 
2.39.5



