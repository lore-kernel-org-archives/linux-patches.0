Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5734F248881;
	Wed, 25 Feb 2026 01:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983198; cv=none; b=Bq4o/7/KJz4YwuqjS1xSDoTVwrJIeGhkw5n5Eg/19TUyJoRX/rdemOaDQ0xGrW51TzhM0Yl6inIiycDj5XEH+VLgiHpPu5/hXqcvyXkeB2q2upOIsWbZoapVSIJ6sNBlgxr+TSQtkqINfJbM2Cvov0R461AqBUW52weFd/YTdFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983198; c=relaxed/simple;
	bh=5m1HFNh3OzA89ksiA1mEUG8qsrKRQ6kaIKm440Lhs58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtkQ3hgcCWFCRC5V3xVlpev5svTiU1mJkMKQWh4euNE5OdgDGBZgug73v/bjdQbkRFR+ww05Mz6u5I2Efm71btwF9U+FmQGYiWRvXkBS30Iwvqwc0hEil+aYG8FuuiXDHdYz2mjghzogynl3wZYa0+Pu5uMtvz6uNFPQZzNCqG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M259nBDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M259nBDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E3C19424;
	Wed, 25 Feb 2026 01:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983198;
	bh=5m1HFNh3OzA89ksiA1mEUG8qsrKRQ6kaIKm440Lhs58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M259nBDYm2qUseztlZ7/jWB0BSrNipmQ6+2cUskHaT1TQ4c5sW382lP0oRNfK1Jng
	 Kt9USHbvQYrOWLzHrJsuLRnbD8z/kLB7HY/r1e28ba7wVkEv7yxeZa4L6UEdLobywy
	 Mcudo8xbpKQstorDFpoeihQa6C2yL5VpnUXOF4EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 304/781] ASoC: SDCA: Factor out jack handling into new c file
Date: Tue, 24 Feb 2026 17:16:53 -0800
Message-ID: <20260225012407.165598133@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3addd63d1fba8d9013e00b06d9420e39271c0c4e ]

The jack code is perhaps a bit large for being in the interrupt
code directly. Improve the encapsulation by factoring out the
jack handling code into a new c file, as is already done for HID
and FDL. Whilst doing so also add a jack_state structure to hold
the jack state for improved expandability in the future.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251215153650.3913117-2-ckeepax@opensource.cirrus.com
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d7730c44b7dd ("ASoC: SDCA: Still process most of the jack detect if control is missing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_jack.h        |  27 ++++++
 sound/soc/sdca/Makefile          |   2 +-
 sound/soc/sdca/sdca_interrupts.c |  83 ++----------------
 sound/soc/sdca/sdca_jack.c       | 140 +++++++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 77 deletions(-)
 create mode 100644 include/sound/sdca_jack.h
 create mode 100644 sound/soc/sdca/sdca_jack.c

diff --git a/include/sound/sdca_jack.h b/include/sound/sdca_jack.h
new file mode 100644
index 0000000000000..9fad5f22cbb9e
--- /dev/null
+++ b/include/sound/sdca_jack.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * The MIPI SDCA specification is available for public downloads at
+ * https://www.mipi.org/mipi-sdca-v1-0-download
+ *
+ * Copyright (C) 2025 Cirrus Logic, Inc. and
+ *                    Cirrus Logic International Semiconductor Ltd.
+ */
+
+#ifndef __SDCA_JACK_H__
+#define __SDCA_JACK_H__
+
+struct sdca_interrupt;
+struct snd_kcontrol;
+
+/**
+ * struct jack_state - Jack state structure to keep data between interrupts
+ * @kctl: Pointer to the ALSA control attached to this jack
+ */
+struct jack_state {
+	struct snd_kcontrol *kctl;
+};
+
+int sdca_jack_alloc_state(struct sdca_interrupt *interrupt);
+int sdca_jack_process(struct sdca_interrupt *interrupt);
+
+#endif // __SDCA_JACK_H__
diff --git a/sound/soc/sdca/Makefile b/sound/soc/sdca/Makefile
index f6b73275d9649..b3b0f5d94c8de 100644
--- a/sound/soc/sdca/Makefile
+++ b/sound/soc/sdca/Makefile
@@ -3,7 +3,7 @@
 snd-soc-sdca-y := sdca_functions.o sdca_device.o sdca_function_device.o \
 		  sdca_regmap.o sdca_asoc.o sdca_ump.o
 snd-soc-sdca-$(CONFIG_SND_SOC_SDCA_HID) += sdca_hid.o
-snd-soc-sdca-$(CONFIG_SND_SOC_SDCA_IRQ) += sdca_interrupts.o
+snd-soc-sdca-$(CONFIG_SND_SOC_SDCA_IRQ) += sdca_interrupts.o sdca_jack.o
 snd-soc-sdca-$(CONFIG_SND_SOC_SDCA_FDL) += sdca_fdl.o
 
 snd-soc-sdca-class-y := sdca_class.o
diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index 8f6a2adfb6fbe..ff3a7e405fdcb 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -22,6 +22,7 @@
 #include <sound/sdca_function.h>
 #include <sound/sdca_hid.h>
 #include <sound/sdca_interrupts.h>
+#include <sound/sdca_jack.h>
 #include <sound/sdca_ump.h>
 #include <sound/soc-component.h>
 #include <sound/soc.h>
@@ -155,14 +156,7 @@ static irqreturn_t detected_mode_handler(int irq, void *data)
 {
 	struct sdca_interrupt *interrupt = data;
 	struct device *dev = interrupt->dev;
-	struct snd_soc_component *component = interrupt->component;
-	struct snd_soc_card *card = component->card;
-	struct rw_semaphore *rwsem = &card->snd_card->controls_rwsem;
-	struct snd_kcontrol *kctl = interrupt->priv;
-	struct snd_ctl_elem_value *ucontrol __free(kfree) = NULL;
-	struct soc_enum *soc_enum;
 	irqreturn_t irqret = IRQ_NONE;
-	unsigned int reg, val;
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
@@ -171,76 +165,9 @@ static irqreturn_t detected_mode_handler(int irq, void *data)
 		goto error;
 	}
 
-	if (!kctl) {
-		const char *name __free(kfree) = kasprintf(GFP_KERNEL, "%s %s",
-							   interrupt->entity->label,
-							   SDCA_CTL_SELECTED_MODE_NAME);
-
-		if (!name)
-			goto error;
-
-		kctl = snd_soc_component_get_kcontrol(component, name);
-		if (!kctl) {
-			dev_dbg(dev, "control not found: %s\n", name);
-			goto error;
-		}
-
-		interrupt->priv = kctl;
-	}
-
-	soc_enum = (struct soc_enum *)kctl->private_value;
-
-	reg = SDW_SDCA_CTL(interrupt->function->desc->adr, interrupt->entity->id,
-			   interrupt->control->sel, 0);
-
-	ret = regmap_read(interrupt->function_regmap, reg, &val);
-	if (ret < 0) {
-		dev_err(dev, "failed to read detected mode: %d\n", ret);
-		goto error;
-	}
-
-	switch (val) {
-	case SDCA_DETECTED_MODE_DETECTION_IN_PROGRESS:
-	case SDCA_DETECTED_MODE_JACK_UNKNOWN:
-		reg = SDW_SDCA_CTL(interrupt->function->desc->adr,
-				   interrupt->entity->id,
-				   SDCA_CTL_GE_SELECTED_MODE, 0);
-
-		/*
-		 * Selected mode is not normally marked as volatile register
-		 * (RW), but here force a read from the hardware. If the
-		 * detected mode is unknown we need to see what the device
-		 * selected as a "safe" option.
-		 */
-		regcache_drop_region(interrupt->function_regmap, reg, reg);
-
-		ret = regmap_read(interrupt->function_regmap, reg, &val);
-		if (ret) {
-			dev_err(dev, "failed to re-check selected mode: %d\n", ret);
-			goto error;
-		}
-		break;
-	default:
-		break;
-	}
-
-	dev_dbg(dev, "%s: %#x\n", interrupt->name, val);
-
-	ucontrol = kzalloc(sizeof(*ucontrol), GFP_KERNEL);
-	if (!ucontrol)
-		goto error;
-
-	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(soc_enum, val);
-
-	down_write(rwsem);
-	ret = kctl->put(kctl, ucontrol);
-	up_write(rwsem);
-	if (ret < 0) {
-		dev_err(dev, "failed to update selected mode: %d\n", ret);
+	ret = sdca_jack_process(interrupt);
+	if (ret)
 		goto error;
-	}
-
-	snd_ctl_notify(card->snd_card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
 
 	irqret = IRQ_HANDLED;
 error:
@@ -536,6 +463,10 @@ int sdca_irq_populate(struct sdca_function_data *function,
 				handler = function_status_handler;
 				break;
 			case SDCA_CTL_TYPE_S(GE, DETECTED_MODE):
+				ret = sdca_jack_alloc_state(interrupt);
+				if (ret)
+					return ret;
+
 				handler = detected_mode_handler;
 				break;
 			case SDCA_CTL_TYPE_S(XU, FDL_CURRENTOWNER):
diff --git a/sound/soc/sdca/sdca_jack.c b/sound/soc/sdca/sdca_jack.c
new file mode 100644
index 0000000000000..83b2b9cc81f00
--- /dev/null
+++ b/sound/soc/sdca/sdca_jack.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2025 Cirrus Logic, Inc. and
+//                    Cirrus Logic International Semiconductor Ltd.
+
+/*
+ * The MIPI SDCA specification is available for public downloads at
+ * https://www.mipi.org/mipi-sdca-v1-0-download
+ */
+
+#include <linux/cleanup.h>
+#include <linux/device.h>
+#include <linux/dev_printk.h>
+#include <linux/soundwire/sdw.h>
+#include <linux/soundwire/sdw_registers.h>
+#include <linux/sprintf.h>
+#include <linux/regmap.h>
+#include <linux/rwsem.h>
+#include <sound/asound.h>
+#include <sound/control.h>
+#include <sound/sdca.h>
+#include <sound/sdca_function.h>
+#include <sound/sdca_interrupts.h>
+#include <sound/sdca_jack.h>
+#include <sound/soc-component.h>
+#include <sound/soc.h>
+
+/**
+ * sdca_jack_process - Process an SDCA jack event
+ * @interrupt: SDCA interrupt structure
+ *
+ * Return: Zero on success or a negative error code.
+ */
+int sdca_jack_process(struct sdca_interrupt *interrupt)
+{
+	struct device *dev = interrupt->dev;
+	struct snd_soc_component *component = interrupt->component;
+	struct snd_soc_card *card = component->card;
+	struct rw_semaphore *rwsem = &card->snd_card->controls_rwsem;
+	struct jack_state *state = interrupt->priv;
+	struct snd_kcontrol *kctl = state->kctl;
+	struct snd_ctl_elem_value *ucontrol __free(kfree) = NULL;
+	struct soc_enum *soc_enum;
+	unsigned int reg, val;
+	int ret;
+
+	if (!kctl) {
+		const char *name __free(kfree) = kasprintf(GFP_KERNEL, "%s %s",
+							   interrupt->entity->label,
+							   SDCA_CTL_SELECTED_MODE_NAME);
+
+		if (!name)
+			return -ENOMEM;
+
+		kctl = snd_soc_component_get_kcontrol(component, name);
+		if (!kctl) {
+			dev_dbg(dev, "control not found: %s\n", name);
+			return -ENOENT;
+		}
+
+		state->kctl = kctl;
+	}
+
+	soc_enum = (struct soc_enum *)kctl->private_value;
+
+	reg = SDW_SDCA_CTL(interrupt->function->desc->adr, interrupt->entity->id,
+			   interrupt->control->sel, 0);
+
+	ret = regmap_read(interrupt->function_regmap, reg, &val);
+	if (ret < 0) {
+		dev_err(dev, "failed to read detected mode: %d\n", ret);
+		return ret;
+	}
+
+	switch (val) {
+	case SDCA_DETECTED_MODE_DETECTION_IN_PROGRESS:
+	case SDCA_DETECTED_MODE_JACK_UNKNOWN:
+		reg = SDW_SDCA_CTL(interrupt->function->desc->adr,
+				   interrupt->entity->id,
+				   SDCA_CTL_GE_SELECTED_MODE, 0);
+
+		/*
+		 * Selected mode is not normally marked as volatile register
+		 * (RW), but here force a read from the hardware. If the
+		 * detected mode is unknown we need to see what the device
+		 * selected as a "safe" option.
+		 */
+		regcache_drop_region(interrupt->function_regmap, reg, reg);
+
+		ret = regmap_read(interrupt->function_regmap, reg, &val);
+		if (ret) {
+			dev_err(dev, "failed to re-check selected mode: %d\n", ret);
+			return ret;
+		}
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(dev, "%s: %#x\n", interrupt->name, val);
+
+	ucontrol = kzalloc(sizeof(*ucontrol), GFP_KERNEL);
+	if (!ucontrol)
+		return -ENOMEM;
+
+	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(soc_enum, val);
+
+	down_write(rwsem);
+	ret = kctl->put(kctl, ucontrol);
+	up_write(rwsem);
+	if (ret < 0) {
+		dev_err(dev, "failed to update selected mode: %d\n", ret);
+		return ret;
+	}
+
+	snd_ctl_notify(card->snd_card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(sdca_jack_process, "SND_SOC_SDCA");
+
+/**
+ * sdca_jack_alloc_state - allocate state for a jack interrupt
+ * @interrupt: SDCA interrupt structure.
+ *
+ * Return: Zero on success or a negative error code.
+ */
+int sdca_jack_alloc_state(struct sdca_interrupt *interrupt)
+{
+	struct device *dev = interrupt->dev;
+	struct jack_state *jack_state;
+
+	jack_state = devm_kzalloc(dev, sizeof(*jack_state), GFP_KERNEL);
+	if (!jack_state)
+		return -ENOMEM;
+
+	interrupt->priv = jack_state;
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(sdca_jack_alloc_state, "SND_SOC_SDCA");
-- 
2.51.0



