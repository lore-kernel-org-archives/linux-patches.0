Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6051A76AD;
	Tue, 30 Jul 2024 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360719; cv=none; b=rx/zPTo9kf2LTXO2Ym2UDXfZi7dsdijymyPdoL0Ppv9tFTSPyxdwbENooctK9HnCJxVrCgfW/vTgDqaP8BXMzGE5uhQ+LYPquaLDsikeNlLpFQHrJFdcsjmws+6OmwNJo5KWuQ6d1FZRcZoOV4nO/IH0ff39k0vSwglVuTMzeRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360719; c=relaxed/simple;
	bh=VdWh/PzDqAOl1TNBee5qImNghEW+Q0DlBDpC9ntWU9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcXwXHlwdVOxrbYt9lo3GeQW4H7QMEgMfp+ZdWimk09S7Q0gOJ1+ta9fPVrH8GgWUnNk/WrDFy2YZZ5Y4GdoqYWNDZ5jOpia+nwxwtnUzMF+mKHtmFM3QHPTmlr6vbpcG5mQI+mG2XhfSHHUC4bD4iupH8k/m82X62fkf6i6arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLtfqXvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLtfqXvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A88C32782;
	Tue, 30 Jul 2024 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360719;
	bh=VdWh/PzDqAOl1TNBee5qImNghEW+Q0DlBDpC9ntWU9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLtfqXvIxuQ7RpHaMSzrmT9/r3w0ODP7DfKQrg3hT+TCBGb8NkqSCSwaqdxoPDb7d
	 mR8wXfJ6yMeUUlVUTb1iXKE/Gn4uj0S5T67+eMuqq3emwMTi97T4KJp8h50MiX7TbL
	 vKI3am3g65g6txK7VSKqsr9byPCxVRes3W7HSffc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Curtis Malainey <cujomalainey@chromium.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 786/809] ASoC: Intel: Fix RT5650 SSP lookup
Date: Tue, 30 Jul 2024 17:51:02 +0200
Message-ID: <20240730151756.010684951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit 6f6a23d42bdfbbfe1b41a23e2c78319a0cc65db3 ]

Commit 8efcd4864652 ("ASoC: Intel: sof_rt5682: use common module for
sof_card_private initialization") migrated the pin assignment in the
context struct up to soc-acpi-intel-ssp-common.c. This uses a lookup
table to see if a device has a amp/codec before assigning the pin. The
issue here arises when combination parts that serve both (with 2 ports)
are used.

sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1f.3/adl_rt5682_def/SSP0-Codec'
CPU: 1 PID: 2079 Comm: udevd Tainted: G     U             6.6.36-03391-g744739e00023 #1 3be1a2880a0970f65545a957db7d08ef4b3e2c0d
Hardware name: Google Anraggar/Anraggar, BIOS Google_Anraggar.15217.552.0 05/07/2024
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 sysfs_warn_dup+0x5b/0x70
 sysfs_create_dir_ns+0xb0/0x100
 kobject_add_internal+0x133/0x3c0
 kobject_add+0x66/0xb0
 ? device_add+0x65/0x780
 device_add+0x164/0x780
 snd_soc_add_pcm_runtimes+0x2fa/0x800
 snd_soc_bind_card+0x35e/0xc20
 devm_snd_soc_register_card+0x48/0x90
 platform_probe+0x7b/0xb0
 really_probe+0xf7/0x2a0
 ...
kobject: kobject_add_internal failed for SSP0-Codec with -EEXIST, don't try to register things with the same name in the same directory.

The issue is that the ALC5650 was only defined in the codec table and
not the amp table which left the pin unassigned but the dai link was
still created by the machine driver.

Also patch the suffix filename code for the topology to prevent double
suffix names as a result of this change.

Fixes: 8efcd4864652 ("ASoC: Intel: sof_rt5682: use common module for sof_card_private initialization")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240716084012.299257-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-ssp-common.c    |  9 +++++++++
 sound/soc/sof/intel/hda.c                       | 17 +++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-ssp-common.c b/sound/soc/intel/common/soc-acpi-intel-ssp-common.c
index 75d0b931d895d..de7a3f7f47f10 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ssp-common.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ssp-common.c
@@ -64,6 +64,15 @@ static const struct codec_map amps[] = {
 	CODEC_MAP_ENTRY("RT1015P", "rt1015", RT1015P_ACPI_HID, CODEC_RT1015P),
 	CODEC_MAP_ENTRY("RT1019P", "rt1019", RT1019P_ACPI_HID, CODEC_RT1019P),
 	CODEC_MAP_ENTRY("RT1308", "rt1308", RT1308_ACPI_HID, CODEC_RT1308),
+
+	/*
+	 * Monolithic components
+	 *
+	 * Only put components that can serve as both the amp and the codec below this line.
+	 * This will ensure that if the part is used just as a codec and there is an amp as well
+	 * then the amp will be selected properly.
+	 */
+	CODEC_MAP_ENTRY("RT5650", "rt5650", RT5650_ACPI_HID, CODEC_RT5650),
 };
 
 enum snd_soc_acpi_intel_codec
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index dead1c19558bb..81647ddac8cbc 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1307,9 +1307,10 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 	const struct sof_dev_desc *desc = sof_pdata->desc;
 	struct hdac_bus *bus = sof_to_bus(sdev);
 	struct snd_soc_acpi_mach *mach = NULL;
-	enum snd_soc_acpi_intel_codec codec_type;
+	enum snd_soc_acpi_intel_codec codec_type, amp_type;
 	const char *tplg_filename;
 	const char *tplg_suffix;
+	bool amp_name_valid;
 
 	/* Try I2S or DMIC if it is supported */
 	if (interface_mask & (BIT(SOF_DAI_INTEL_SSP) | BIT(SOF_DAI_INTEL_DMIC)))
@@ -1413,15 +1414,16 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 			}
 		}
 
-		codec_type = snd_soc_acpi_intel_detect_amp_type(sdev->dev);
+		amp_type = snd_soc_acpi_intel_detect_amp_type(sdev->dev);
+		codec_type = snd_soc_acpi_intel_detect_codec_type(sdev->dev);
+		amp_name_valid = amp_type != CODEC_NONE && amp_type != codec_type;
 
-		if (tplg_fixup &&
-		    mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_AMP_NAME &&
-		    codec_type != CODEC_NONE) {
-			tplg_suffix = snd_soc_acpi_intel_get_amp_tplg_suffix(codec_type);
+		if (tplg_fixup && amp_name_valid &&
+		    mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_AMP_NAME) {
+			tplg_suffix = snd_soc_acpi_intel_get_amp_tplg_suffix(amp_type);
 			if (!tplg_suffix) {
 				dev_err(sdev->dev, "no tplg suffix found, amp %d\n",
-					codec_type);
+					amp_type);
 				return NULL;
 			}
 
@@ -1436,7 +1438,6 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 			add_extension = true;
 		}
 
-		codec_type = snd_soc_acpi_intel_detect_codec_type(sdev->dev);
 
 		if (tplg_fixup &&
 		    mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_CODEC_NAME &&
-- 
2.43.0



