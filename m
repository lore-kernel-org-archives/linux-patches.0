Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E6217E015;
	Fri, 15 Nov 2024 06:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652933; cv=none; b=fVWMcwwcmVbtgy48xTG8qHIqTiYf+9cf/ivQNN1IcnQMue4VnbHdGI8ktJZB9vFy4lfSltKn0t3H9+zg0eDYCFmv7srzmj0KQ+kcHbl/VVwzFDgfjKrw+ceTq6m5tG5q+jnodLJrq9P4vla5jWcPG4lgrE3lDMwiR0aYnuC9r3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652933; c=relaxed/simple;
	bh=RCQllpTKcWFOKHNUbYhbQchtUqAT3+yHWB3g3mkD75A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p74YLtkMhLcUmixY9JCG0IAhjVIow2se1Qt6O1+CUNa4AkPML33NgGghM6XYbHOPicCjc/vI7KzR1aPSFdp+CflkM03MbyBvPtEQTkbLiC58NFA7PHpyCKcJiFPx3lyJ7mBKzVS+quV0UNCeNJlKwjYAM9Pe0gIHTRdJWlzSW2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeiZxa0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeiZxa0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931BBC4CECF;
	Fri, 15 Nov 2024 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652933;
	bh=RCQllpTKcWFOKHNUbYhbQchtUqAT3+yHWB3g3mkD75A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeiZxa0Q69Kq+DqkaVStKMQuAgpljRBMJDIpe1k9nOY1/x7p6LnY7MVauTcPuMDiD
	 VVWRjZiAjIlgok45xRKpBGsZnaqowk+iAom1g0bU8H7MegntrSJnd2Ck5v3KulDDrm
	 GZbVTJch8Ai3boy8g4KSnWXuc0yMTWkbf72CfOic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/52] ALSA: usb-audio: Add custom mixer status quirks for RME CC devices
Date: Fri, 15 Nov 2024 07:37:52 +0100
Message-ID: <20241115063724.268028192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit d39f1d68fe1de1f9dbe167a73f0f605226905e27 ]

Adds several vendor specific mixer quirks for RME's Class Compliant
USB devices. These provide extra status information from the device
otherwise not available.

These include AES/SPDIF rate and status information, current system
sampling rate and measured frequency. This information is especially
useful in cases where device's clock is slaved to external clock
source.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4413665dd6c5 ("ALSA: usb-audio: Add quirks for Dell WD19 dock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 381 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 381 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 3bb89fcaa2f5c..16730c85e12f7 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -29,6 +29,7 @@
 
 #include <linux/hid.h>
 #include <linux/init.h>
+#include <linux/math64.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
@@ -1823,6 +1824,380 @@ static int dell_dock_mixer_init(struct usb_mixer_interface *mixer)
 	return 0;
 }
 
+/* RME Class Compliant device quirks */
+
+#define SND_RME_GET_STATUS1			23
+#define SND_RME_GET_CURRENT_FREQ		17
+#define SND_RME_CLK_SYSTEM_SHIFT		16
+#define SND_RME_CLK_SYSTEM_MASK			0x1f
+#define SND_RME_CLK_AES_SHIFT			8
+#define SND_RME_CLK_SPDIF_SHIFT			12
+#define SND_RME_CLK_AES_SPDIF_MASK		0xf
+#define SND_RME_CLK_SYNC_SHIFT			6
+#define SND_RME_CLK_SYNC_MASK			0x3
+#define SND_RME_CLK_FREQMUL_SHIFT		18
+#define SND_RME_CLK_FREQMUL_MASK		0x7
+#define SND_RME_CLK_SYSTEM(x) \
+	((x >> SND_RME_CLK_SYSTEM_SHIFT) & SND_RME_CLK_SYSTEM_MASK)
+#define SND_RME_CLK_AES(x) \
+	((x >> SND_RME_CLK_AES_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+#define SND_RME_CLK_SPDIF(x) \
+	((x >> SND_RME_CLK_SPDIF_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+#define SND_RME_CLK_SYNC(x) \
+	((x >> SND_RME_CLK_SYNC_SHIFT) & SND_RME_CLK_SYNC_MASK)
+#define SND_RME_CLK_FREQMUL(x) \
+	((x >> SND_RME_CLK_FREQMUL_SHIFT) & SND_RME_CLK_FREQMUL_MASK)
+#define SND_RME_CLK_AES_LOCK			0x1
+#define SND_RME_CLK_AES_SYNC			0x4
+#define SND_RME_CLK_SPDIF_LOCK			0x2
+#define SND_RME_CLK_SPDIF_SYNC			0x8
+#define SND_RME_SPDIF_IF_SHIFT			4
+#define SND_RME_SPDIF_FORMAT_SHIFT		5
+#define SND_RME_BINARY_MASK			0x1
+#define SND_RME_SPDIF_IF(x) \
+	((x >> SND_RME_SPDIF_IF_SHIFT) & SND_RME_BINARY_MASK)
+#define SND_RME_SPDIF_FORMAT(x) \
+	((x >> SND_RME_SPDIF_FORMAT_SHIFT) & SND_RME_BINARY_MASK)
+
+static const u32 snd_rme_rate_table[] = {
+	32000, 44100, 48000, 50000,
+	64000, 88200, 96000, 100000,
+	128000, 176400, 192000, 200000,
+	256000,	352800, 384000, 400000,
+	512000, 705600, 768000, 800000
+};
+/* maximum number of items for AES and S/PDIF rates for above table */
+#define SND_RME_RATE_IDX_AES_SPDIF_NUM		12
+
+enum snd_rme_domain {
+	SND_RME_DOMAIN_SYSTEM,
+	SND_RME_DOMAIN_AES,
+	SND_RME_DOMAIN_SPDIF
+};
+
+enum snd_rme_clock_status {
+	SND_RME_CLOCK_NOLOCK,
+	SND_RME_CLOCK_LOCK,
+	SND_RME_CLOCK_SYNC
+};
+
+static int snd_rme_read_value(struct snd_usb_audio *chip,
+			      unsigned int item,
+			      u32 *value)
+{
+	struct usb_device *dev = chip->dev;
+	int err;
+
+	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),
+			      item,
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0, 0,
+			      value, sizeof(*value));
+	if (err < 0)
+		dev_err(&dev->dev,
+			"unable to issue vendor read request %d (ret = %d)",
+			item, err);
+	return err;
+}
+
+static int snd_rme_get_status1(struct snd_kcontrol *kcontrol,
+			       u32 *status1)
+{
+	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
+	struct snd_usb_audio *chip = list->mixer->chip;
+	int err;
+
+	err = snd_usb_lock_shutdown(chip);
+	if (err < 0)
+		return err;
+	err = snd_rme_read_value(chip, SND_RME_GET_STATUS1, status1);
+	snd_usb_unlock_shutdown(chip);
+	return err;
+}
+
+static int snd_rme_rate_get(struct snd_kcontrol *kcontrol,
+			    struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status1;
+	u32 rate = 0;
+	int idx;
+	int err;
+
+	err = snd_rme_get_status1(kcontrol, &status1);
+	if (err < 0)
+		return err;
+	switch (kcontrol->private_value) {
+	case SND_RME_DOMAIN_SYSTEM:
+		idx = SND_RME_CLK_SYSTEM(status1);
+		if (idx < ARRAY_SIZE(snd_rme_rate_table))
+			rate = snd_rme_rate_table[idx];
+		break;
+	case SND_RME_DOMAIN_AES:
+		idx = SND_RME_CLK_AES(status1);
+		if (idx < SND_RME_RATE_IDX_AES_SPDIF_NUM)
+			rate = snd_rme_rate_table[idx];
+		break;
+	case SND_RME_DOMAIN_SPDIF:
+		idx = SND_RME_CLK_SPDIF(status1);
+		if (idx < SND_RME_RATE_IDX_AES_SPDIF_NUM)
+			rate = snd_rme_rate_table[idx];
+		break;
+	default:
+		return -EINVAL;
+	}
+	ucontrol->value.integer.value[0] = rate;
+	return 0;
+}
+
+static int snd_rme_sync_state_get(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status1;
+	int idx = SND_RME_CLOCK_NOLOCK;
+	int err;
+
+	err = snd_rme_get_status1(kcontrol, &status1);
+	if (err < 0)
+		return err;
+	switch (kcontrol->private_value) {
+	case SND_RME_DOMAIN_AES:  /* AES */
+		if (status1 & SND_RME_CLK_AES_SYNC)
+			idx = SND_RME_CLOCK_SYNC;
+		else if (status1 & SND_RME_CLK_AES_LOCK)
+			idx = SND_RME_CLOCK_LOCK;
+		break;
+	case SND_RME_DOMAIN_SPDIF:  /* SPDIF */
+		if (status1 & SND_RME_CLK_SPDIF_SYNC)
+			idx = SND_RME_CLOCK_SYNC;
+		else if (status1 & SND_RME_CLK_SPDIF_LOCK)
+			idx = SND_RME_CLOCK_LOCK;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ucontrol->value.enumerated.item[0] = idx;
+	return 0;
+}
+
+static int snd_rme_spdif_if_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status1;
+	int err;
+
+	err = snd_rme_get_status1(kcontrol, &status1);
+	if (err < 0)
+		return err;
+	ucontrol->value.enumerated.item[0] = SND_RME_SPDIF_IF(status1);
+	return 0;
+}
+
+static int snd_rme_spdif_format_get(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status1;
+	int err;
+
+	err = snd_rme_get_status1(kcontrol, &status1);
+	if (err < 0)
+		return err;
+	ucontrol->value.enumerated.item[0] = SND_RME_SPDIF_FORMAT(status1);
+	return 0;
+}
+
+static int snd_rme_sync_source_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status1;
+	int err;
+
+	err = snd_rme_get_status1(kcontrol, &status1);
+	if (err < 0)
+		return err;
+	ucontrol->value.enumerated.item[0] = SND_RME_CLK_SYNC(status1);
+	return 0;
+}
+
+static int snd_rme_current_freq_get(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
+	struct snd_usb_audio *chip = list->mixer->chip;
+	u32 status1;
+	const u64 num = 104857600000000ULL;
+	u32 den;
+	unsigned int freq;
+	int err;
+
+	err = snd_usb_lock_shutdown(chip);
+	if (err < 0)
+		return err;
+	err = snd_rme_read_value(chip, SND_RME_GET_STATUS1, &status1);
+	if (err < 0)
+		goto end;
+	err = snd_rme_read_value(chip, SND_RME_GET_CURRENT_FREQ, &den);
+	if (err < 0)
+		goto end;
+	freq = (den == 0) ? 0 : div64_u64(num, den);
+	freq <<= SND_RME_CLK_FREQMUL(status1);
+	ucontrol->value.integer.value[0] = freq;
+
+end:
+	snd_usb_unlock_shutdown(chip);
+	return err;
+}
+
+static int snd_rme_rate_info(struct snd_kcontrol *kcontrol,
+			     struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 1;
+	switch (kcontrol->private_value) {
+	case SND_RME_DOMAIN_SYSTEM:
+		uinfo->value.integer.min = 32000;
+		uinfo->value.integer.max = 800000;
+		break;
+	case SND_RME_DOMAIN_AES:
+	case SND_RME_DOMAIN_SPDIF:
+	default:
+		uinfo->value.integer.min = 0;
+		uinfo->value.integer.max = 200000;
+	}
+	uinfo->value.integer.step = 0;
+	return 0;
+}
+
+static int snd_rme_sync_state_info(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const sync_states[] = {
+		"No Lock", "Lock", "Sync"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(sync_states), sync_states);
+}
+
+static int snd_rme_spdif_if_info(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const spdif_if[] = {
+		"Coaxial", "Optical"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(spdif_if), spdif_if);
+}
+
+static int snd_rme_spdif_format_info(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const optical_type[] = {
+		"Consumer", "Professional"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(optical_type), optical_type);
+}
+
+static int snd_rme_sync_source_info(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const sync_sources[] = {
+		"Internal", "AES", "SPDIF", "Internal"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(sync_sources), sync_sources);
+}
+
+static struct snd_kcontrol_new snd_rme_controls[] = {
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "AES Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_rate_get,
+		.private_value = SND_RME_DOMAIN_AES
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "AES Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_sync_state_get,
+		.private_value = SND_RME_DOMAIN_AES
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "SPDIF Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_rate_get,
+		.private_value = SND_RME_DOMAIN_SPDIF
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "SPDIF Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_sync_state_get,
+		.private_value = SND_RME_DOMAIN_SPDIF
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "SPDIF Interface",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_spdif_if_info,
+		.get = snd_rme_spdif_if_get,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "SPDIF Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_spdif_format_info,
+		.get = snd_rme_spdif_format_get,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Sync Source",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_source_info,
+		.get = snd_rme_sync_source_get
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "System Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_rate_get,
+		.private_value = SND_RME_DOMAIN_SYSTEM
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Current Frequency",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_current_freq_get
+	}
+};
+
+static int snd_rme_controls_create(struct usb_mixer_interface *mixer)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(snd_rme_controls); ++i) {
+		err = add_single_ctl_with_resume(mixer, 0,
+						 NULL,
+						 &snd_rme_controls[i],
+						 NULL);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 {
 	int err = 0;
@@ -1910,6 +2285,12 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x0bda, 0x4014): /* Dell WD15 dock */
 		err = dell_dock_mixer_init(mixer);
 		break;
+
+	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
+	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */
+	case USB_ID(0x2a39, 0x3fd4): /* RME */
+		err = snd_rme_controls_create(mixer);
+		break;
 	}
 
 	return err;
-- 
2.43.0



