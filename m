Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D771DE2AE;
	Tue,  8 Oct 2024 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391676; cv=none; b=MGxbedgv1os/OZe0dQi1p8wKFm+vGgqlawGESLecQtt9W+IuvRpVFj6mBFP0WEuVzjxNkWGRmjr31DMzCVRTV3kwPwS9n7S+yQLPW9rgMxEPhcO74EfTBQy+bxfPSMFrA/6OPtwwWFwNHXHq8v+hpm6XrOUCrTygOpzioJygbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391676; c=relaxed/simple;
	bh=jNhZEUSR4hvcPchvODBnT/biwIupgOvD2dmbrVRS2YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA+dP4KE64EEZkP/GPANh9+r8NMGf/Ygglzwqauwr5eG9mBF/Hj2l51PjEiPhJ2shmqJPpB3MAUndiPYm4NaS56XEbB8anVdySTfWmnbCTxMWIGFzQdrERowZn50yKP3XhWmEfQ+2Ds73GvwZpqwsSFzPvXH4lbIJ1znPUhcr8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDNrcUEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDNrcUEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9874DC4CEC7;
	Tue,  8 Oct 2024 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391676;
	bh=jNhZEUSR4hvcPchvODBnT/biwIupgOvD2dmbrVRS2YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDNrcUEF/KD2qXns6iR4EYbJmbv2aRmWCDYbNrBTeNlAuBmlTm42NlVD1gfO1MFN6
	 0ugRb4hdkHe4PX5tzfCeiglzUdMaVlH1emxKSVxBBCHrmfiXCc6mZLgHBlL/SR/w37
	 XvNPdhKVa86CIY0y8U5iWeeJFvwFo+Q+O9O6Njfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 172/558] ALSA: usb-audio: Add mixer quirk for RME Digiface USB
Date: Tue,  8 Oct 2024 14:03:22 +0200
Message-ID: <20241008115709.126145312@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asahi Lina <lina@asahilina.net>

[ Upstream commit 611a96f6acf2e74fe28cb90908a9c183862348ce ]

Implement sync, output format, and input status mixer controls, to allow
the interface to be used as a straight ADAT/SPDIF (+ Headphones) I/O
interface.

This does not implement the matrix mixer, output gain controls, or input
level meter feedback. The full mixer interface is only really usable
using a dedicated userspace control app (there are too many mixer nodes
for alsamixer to be usable), so for now we leave it up to userspace to
directly control these features using raw USB control messages. This is
similar to how it's done with some FireWire interfaces (ffado-mixer).

Signed-off-by: Asahi Lina <lina@asahilina.net>
Link: https://patch.msgid.link/20240903-rme-digiface-v2-2-71b06c912e97@asahilina.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 413 +++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks-table.h |   1 +
 2 files changed, 414 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 8cbfb65846047..74abc44be77ca 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -14,6 +14,7 @@
  *	    Przemek Rudy (prudy1@o2.pl)
  */
 
+#include <linux/bitfield.h>
 #include <linux/hid.h>
 #include <linux/init.h>
 #include <linux/math64.h>
@@ -2926,6 +2927,415 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 	return 0;
 }
 
+/*
+ * RME Digiface USB
+ */
+
+#define RME_DIGIFACE_READ_STATUS 17
+#define RME_DIGIFACE_STATUS_REG0L 0
+#define RME_DIGIFACE_STATUS_REG0H 1
+#define RME_DIGIFACE_STATUS_REG1L 2
+#define RME_DIGIFACE_STATUS_REG1H 3
+#define RME_DIGIFACE_STATUS_REG2L 4
+#define RME_DIGIFACE_STATUS_REG2H 5
+#define RME_DIGIFACE_STATUS_REG3L 6
+#define RME_DIGIFACE_STATUS_REG3H 7
+
+#define RME_DIGIFACE_CTL_REG1 16
+#define RME_DIGIFACE_CTL_REG2 18
+
+/* Reg is overloaded, 0-7 for status halfwords or 16 or 18 for control registers */
+#define RME_DIGIFACE_REGISTER(reg, mask) (((reg) << 16) | (mask))
+#define RME_DIGIFACE_INVERT BIT(31)
+
+/* Nonconst helpers */
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
+
+static int snd_rme_digiface_write_reg(struct snd_kcontrol *kcontrol, int item, u16 mask, u16 val)
+{
+	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
+	struct snd_usb_audio *chip = list->mixer->chip;
+	struct usb_device *dev = chip->dev;
+	int err;
+
+	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			      item,
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      val, mask, NULL, 0);
+	if (err < 0)
+		dev_err(&dev->dev,
+			"unable to issue control set request %d (ret = %d)",
+			item, err);
+	return err;
+}
+
+static int snd_rme_digiface_read_status(struct snd_kcontrol *kcontrol, u32 status[4])
+{
+	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
+	struct snd_usb_audio *chip = list->mixer->chip;
+	struct usb_device *dev = chip->dev;
+	__le32 buf[4];
+	int err;
+
+	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),
+			      RME_DIGIFACE_READ_STATUS,
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0, 0,
+			      buf, sizeof(buf));
+	if (err < 0) {
+		dev_err(&dev->dev,
+			"unable to issue status read request (ret = %d)",
+			err);
+	} else {
+		for (int i = 0; i < ARRAY_SIZE(buf); i++)
+			status[i] = le32_to_cpu(buf[i]);
+	}
+	return err;
+}
+
+static int snd_rme_digiface_get_status_val(struct snd_kcontrol *kcontrol)
+{
+	int err;
+	u32 status[4];
+	bool invert = kcontrol->private_value & RME_DIGIFACE_INVERT;
+	u8 reg = (kcontrol->private_value >> 16) & 0xff;
+	u16 mask = kcontrol->private_value & 0xffff;
+	u16 val;
+
+	err = snd_rme_digiface_read_status(kcontrol, status);
+	if (err < 0)
+		return err;
+
+	switch (reg) {
+	/* Status register halfwords */
+	case RME_DIGIFACE_STATUS_REG0L ... RME_DIGIFACE_STATUS_REG3H:
+		break;
+	case RME_DIGIFACE_CTL_REG1: /* Control register 1, present in halfword 3L */
+		reg = RME_DIGIFACE_STATUS_REG3L;
+		break;
+	case RME_DIGIFACE_CTL_REG2: /* Control register 2, present in halfword 3H */
+		reg = RME_DIGIFACE_STATUS_REG3H;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (reg & 1)
+		val = status[reg >> 1] >> 16;
+	else
+		val = status[reg >> 1] & 0xffff;
+
+	if (invert)
+		val ^= mask;
+
+	return field_get(mask, val);
+}
+
+static int snd_rme_digiface_rate_get(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	int freq = snd_rme_digiface_get_status_val(kcontrol);
+
+	if (freq < 0)
+		return freq;
+	if (freq >= ARRAY_SIZE(snd_rme_rate_table))
+		return -EIO;
+
+	ucontrol->value.integer.value[0] = snd_rme_rate_table[freq];
+	return 0;
+}
+
+static int snd_rme_digiface_enum_get(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	int val = snd_rme_digiface_get_status_val(kcontrol);
+
+	if (val < 0)
+		return val;
+
+	ucontrol->value.enumerated.item[0] = val;
+	return 0;
+}
+
+static int snd_rme_digiface_enum_put(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	bool invert = kcontrol->private_value & RME_DIGIFACE_INVERT;
+	u8 reg = (kcontrol->private_value >> 16) & 0xff;
+	u16 mask = kcontrol->private_value & 0xffff;
+	u16 val = field_prep(mask, ucontrol->value.enumerated.item[0]);
+
+	if (invert)
+		val ^= mask;
+
+	return snd_rme_digiface_write_reg(kcontrol, reg, mask, val);
+}
+
+static int snd_rme_digiface_current_sync_get(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	int ret = snd_rme_digiface_enum_get(kcontrol, ucontrol);
+
+	/* 7 means internal for current sync */
+	if (ucontrol->value.enumerated.item[0] == 7)
+		ucontrol->value.enumerated.item[0] = 0;
+
+	return ret;
+}
+
+static int snd_rme_digiface_sync_state_get(struct snd_kcontrol *kcontrol,
+					   struct snd_ctl_elem_value *ucontrol)
+{
+	u32 status[4];
+	int err;
+	bool valid, sync;
+
+	err = snd_rme_digiface_read_status(kcontrol, status);
+	if (err < 0)
+		return err;
+
+	valid = status[0] & BIT(kcontrol->private_value);
+	sync = status[0] & BIT(5 + kcontrol->private_value);
+
+	if (!valid)
+		ucontrol->value.enumerated.item[0] = SND_RME_CLOCK_NOLOCK;
+	else if (!sync)
+		ucontrol->value.enumerated.item[0] = SND_RME_CLOCK_LOCK;
+	else
+		ucontrol->value.enumerated.item[0] = SND_RME_CLOCK_SYNC;
+	return 0;
+}
+
+
+static int snd_rme_digiface_format_info(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const format[] = {
+		"ADAT", "S/PDIF"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(format), format);
+}
+
+
+static int snd_rme_digiface_sync_source_info(struct snd_kcontrol *kcontrol,
+					     struct snd_ctl_elem_info *uinfo)
+{
+	static const char *const sync_sources[] = {
+		"Internal", "Input 1", "Input 2", "Input 3", "Input 4"
+	};
+
+	return snd_ctl_enum_info(uinfo, 1,
+				 ARRAY_SIZE(sync_sources), sync_sources);
+}
+
+static int snd_rme_digiface_rate_info(struct snd_kcontrol *kcontrol,
+				      struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 200000;
+	uinfo->value.integer.step = 0;
+	return 0;
+}
+
+static const struct snd_kcontrol_new snd_rme_digiface_controls[] = {
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 1 Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_digiface_sync_state_get,
+		.private_value = 0,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 1 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG0H, BIT(0)) |
+			RME_DIGIFACE_INVERT,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 1 Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG1L, GENMASK(3, 0)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 2 Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_digiface_sync_state_get,
+		.private_value = 1,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 2 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG0L, BIT(13)) |
+			RME_DIGIFACE_INVERT,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 2 Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG1L, GENMASK(7, 4)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 3 Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_digiface_sync_state_get,
+		.private_value = 2,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 3 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG0L, BIT(14)) |
+			RME_DIGIFACE_INVERT,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 3 Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG1L, GENMASK(11, 8)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 4 Sync",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_sync_state_info,
+		.get = snd_rme_digiface_sync_state_get,
+		.private_value = 3,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 4 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG0L, GENMASK(15, 12)) |
+			RME_DIGIFACE_INVERT,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Input 4 Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG1L, GENMASK(3, 0)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Output 1 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.put = snd_rme_digiface_enum_put,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG2, BIT(0)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Output 2 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.put = snd_rme_digiface_enum_put,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG2, BIT(1)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Output 3 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.put = snd_rme_digiface_enum_put,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG2, BIT(3)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Output 4 Format",
+		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+		.info = snd_rme_digiface_format_info,
+		.get = snd_rme_digiface_enum_get,
+		.put = snd_rme_digiface_enum_put,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG2, BIT(4)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Sync Source",
+		.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+		.info = snd_rme_digiface_sync_source_info,
+		.get = snd_rme_digiface_enum_get,
+		.put = snd_rme_digiface_enum_put,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG1, GENMASK(2, 0)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Current Sync Source",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_digiface_sync_source_info,
+		.get = snd_rme_digiface_current_sync_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG0L, GENMASK(12, 10)),
+	},
+	{
+		/*
+		 * This is writeable, but it is only set by the PCM rate.
+		 * Mixer apps currently need to drive the mixer using raw USB requests,
+		 * so they can also change this that way to configure the rate for
+		 * stand-alone operation when the PCM is closed.
+		 */
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "System Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_CTL_REG1, GENMASK(6, 3)),
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Current Rate",
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.info = snd_rme_rate_info,
+		.get = snd_rme_digiface_rate_get,
+		.private_value = RME_DIGIFACE_REGISTER(RME_DIGIFACE_STATUS_REG1H, GENMASK(7, 4)),
+	}
+};
+
+static int snd_rme_digiface_controls_create(struct usb_mixer_interface *mixer)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(snd_rme_digiface_controls); ++i) {
+		err = add_single_ctl_with_resume(mixer, 0,
+						 NULL,
+						 &snd_rme_digiface_controls[i],
+						 NULL);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 /*
  * Pioneer DJ DJM Mixers
  *
@@ -3484,6 +3894,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x2a39, 0x3fb0): /* RME Babyface Pro FS */
 		err = snd_bbfpro_controls_create(mixer);
 		break;
+	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+		err = snd_rme_digiface_controls_create(mixer);
+		break;
 	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
 		err = snd_djm_controls_create(mixer, SND_DJM_250MK2_IDX);
 		break;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 631b9ab80f6cd..24c981c9b2405 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3620,6 +3620,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 			 * Three modes depending on sample rate band,
 			 * with different channel counts for in/out
 			 */
+			{ QUIRK_DATA_STANDARD_MIXER(0) },
 			{
 				QUIRK_DATA_AUDIOFORMAT(0) {
 					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-- 
2.43.0



