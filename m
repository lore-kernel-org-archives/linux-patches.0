Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB893922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B921C4339B;
	Wed,  7 Jun 2023 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171503;
	bh=lpl61S+v3ZPoqhG86DBxo7gPGeIdGqeATuWVOyQwG64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlSlDX0YyKb6YianEWOvnwvgnFd43gIhI4U6TGq89mhSdLu55SO0fvN3DloothM6a
	 /1JbQUMy49tCXKLmvdxOkMqGkcSG9S1zU2C9NnvcRg3rj3kc3p58WxVOLJV2mZlyQ9
	 ouJet6O3uim9fp6JGq6+v9l/Xjh3MrRbo34RjQbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jasontao <jasontao@glenfly.com>,
	Reaper Li <reaperlioc@glenfly.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/159] ALSA: hda: Glenfly: add HD Audio PCI IDs and HDMI Codec Vendor IDs.
Date: Wed,  7 Jun 2023 22:15:45 +0200
Message-ID: <20230607200905.051578367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: jasontao <jasontao@glenfly.com>

[ Upstream commit c51e431052e2eacfb23fbf6b39bc6c8770d9827a ]

Add a set of HD Audio PCI IDS, and the HDMI codec vendor IDs for
Glenfly Gpus.

- In default_bdl_pos_adj, set bdl to 128 as Glenfly Gpus have hardware
limitation, need to increase hdac interrupt interval.
- In azx_first_init, enable polling mode for Glenfly Gpu. When the codec
complete the command, it sends interrupt and writes response entries to
memory, howerver, the write requests sometimes are not actually
synchronized to memory when driver handle hdac interrupt on Glenfly Gpus.
If the RIRB status is not updated in the interrupt handler,
azx_rirb_get_response keeps trying to recevie a response from rirb until
1s timeout. Enabling polling mode for Glenfly Gpu can fix the issue.
- In patch_gf_hdmi, set Glenlfy Gpu Codec's no_sticky_stream as it need
driver to do actual clean-ups for the linked codec when switch from one
codec to another.

Signed-off-by: jasontao <jasontao@glenfly.com>
Signed-off-by: Reaper Li <reaperlioc@glenfly.com>
Link: https://lore.kernel.org/r/20230426013059.4329-1-reaperlioc@glenfly.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c  | 21 +++++++++++++++++++++
 sound/pci/hda/patch_hdmi.c | 22 ++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 5fce1ca8a393a..1379ac07df350 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -230,6 +230,7 @@ enum {
 	AZX_DRIVER_ATI,
 	AZX_DRIVER_ATIHDMI,
 	AZX_DRIVER_ATIHDMI_NS,
+	AZX_DRIVER_GFHDMI,
 	AZX_DRIVER_VIA,
 	AZX_DRIVER_SIS,
 	AZX_DRIVER_ULI,
@@ -352,6 +353,7 @@ static const char * const driver_short_names[] = {
 	[AZX_DRIVER_ATI] = "HDA ATI SB",
 	[AZX_DRIVER_ATIHDMI] = "HDA ATI HDMI",
 	[AZX_DRIVER_ATIHDMI_NS] = "HDA ATI HDMI",
+	[AZX_DRIVER_GFHDMI] = "HDA GF HDMI",
 	[AZX_DRIVER_VIA] = "HDA VIA VT82xx",
 	[AZX_DRIVER_SIS] = "HDA SIS966",
 	[AZX_DRIVER_ULI] = "HDA ULI M5461",
@@ -1742,6 +1744,12 @@ static int default_bdl_pos_adj(struct azx *chip)
 	}
 
 	switch (chip->driver_type) {
+	/*
+	 * increase the bdl size for Glenfly Gpus for hardware
+	 * limitation on hdac interrupt interval
+	 */
+	case AZX_DRIVER_GFHDMI:
+		return 128;
 	case AZX_DRIVER_ICH:
 	case AZX_DRIVER_PCH:
 		return 1;
@@ -1857,6 +1865,12 @@ static int azx_first_init(struct azx *chip)
 		pci_write_config_dword(pci, PCI_BASE_ADDRESS_1, 0);
 	}
 #endif
+	/*
+	 * Fix response write request not synced to memory when handle
+	 * hdac interrupt on Glenfly Gpus
+	 */
+	if (chip->driver_type == AZX_DRIVER_GFHDMI)
+		bus->polling_mode = 1;
 
 	err = pcim_iomap_regions(pci, 1 << 0, "ICH HD audio");
 	if (err < 0)
@@ -1957,6 +1971,7 @@ static int azx_first_init(struct azx *chip)
 			chip->playback_streams = ATIHDMI_NUM_PLAYBACK;
 			chip->capture_streams = ATIHDMI_NUM_CAPTURE;
 			break;
+		case AZX_DRIVER_GFHDMI:
 		case AZX_DRIVER_GENERIC:
 		default:
 			chip->playback_streams = ICH6_NUM_PLAYBACK;
@@ -2694,6 +2709,12 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	/* GLENFLY */
+	{ PCI_DEVICE(0x6766, PCI_ANY_ID),
+	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
+	  .class_mask = 0xffffff,
+	  .driver_data = AZX_DRIVER_GFHDMI | AZX_DCAPS_POSFIX_LPIB |
+	  AZX_DCAPS_NO_MSI | AZX_DCAPS_NO_64BIT },
 	/* VIA VT8251/VT8237A */
 	{ PCI_DEVICE(0x1106, 0x3288), .driver_data = AZX_DRIVER_VIA },
 	/* VIA GFX VT7122/VX900 */
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8ed5a499af4bb..3cd3b5c49e45e 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4298,6 +4298,22 @@ static int patch_via_hdmi(struct hda_codec *codec)
 	return patch_simple_hdmi(codec, VIAHDMI_CVT_NID, VIAHDMI_PIN_NID);
 }
 
+static int patch_gf_hdmi(struct hda_codec *codec)
+{
+	int err;
+
+	err = patch_generic_hdmi(codec);
+	if (err)
+		return err;
+
+	/*
+	 * Glenfly GPUs have two codecs, stream switches from one codec to
+	 * another, need to do actual clean-ups in codec_cleanup_stream
+	 */
+	codec->no_sticky_stream = 1;
+	return 0;
+}
+
 /*
  * patch entries
  */
@@ -4392,6 +4408,12 @@ HDA_CODEC_ENTRY(0x10de00a6, "GPU a6 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a7, "GPU a7 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de8001, "MCP73 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x10de8067, "MCP67/68 HDMI",	patch_nvhdmi_2ch),
+HDA_CODEC_ENTRY(0x67663d82, "Arise 82 HDMI/DP",	patch_gf_hdmi),
+HDA_CODEC_ENTRY(0x67663d83, "Arise 83 HDMI/DP",	patch_gf_hdmi),
+HDA_CODEC_ENTRY(0x67663d84, "Arise 84 HDMI/DP",	patch_gf_hdmi),
+HDA_CODEC_ENTRY(0x67663d85, "Arise 85 HDMI/DP",	patch_gf_hdmi),
+HDA_CODEC_ENTRY(0x67663d86, "Arise 86 HDMI/DP",	patch_gf_hdmi),
+HDA_CODEC_ENTRY(0x67663d87, "Arise 87 HDMI/DP",	patch_gf_hdmi),
 HDA_CODEC_ENTRY(0x11069f80, "VX900 HDMI/DP",	patch_via_hdmi),
 HDA_CODEC_ENTRY(0x11069f81, "VX900 HDMI/DP",	patch_via_hdmi),
 HDA_CODEC_ENTRY(0x11069f84, "VX11 HDMI/DP",	patch_generic_hdmi),
-- 
2.39.2



