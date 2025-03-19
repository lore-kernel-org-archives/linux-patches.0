Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845351E2613;
	Wed, 19 Mar 2025 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395067; cv=none; b=uESY0kJ9kntaleseJyZIjNuhTvRvfEJWoAEhhBGT3plc5JPbrBEq53jdE4twk/HThkODSjJRjzbtXJ+Frl5VDFwydptzFGsKWhZPxGMJfLutDivg29Z4KwZcxcOUOPK/kgAh4Mt/z/h0JW1C4xD/BX5JxnDLQdcv1Rv9lcpIb9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395067; c=relaxed/simple;
	bh=N+2GN/VhrLqFHi6/NsrejQ4/suV4Yr/lGH4gVB9OnH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHBj5l9lVNM/g2wwHA4OOV60rfnJ6C1qp0EGKrz/+W3heh4cbHdPHF0Z8h5FlA/zoZ4LUPL+H08XZ3iKDeh7kyeIyuy3l+gG3znUtCJltbaalVmvpxTEDnt8hCHcQ7wpnJSedtXMDzobGq8ZXPOeZu4TUsG+GQ2sJxgIMCLw2as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygaPf7T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygaPf7T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D0FC4CEE8;
	Wed, 19 Mar 2025 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395067;
	bh=N+2GN/VhrLqFHi6/NsrejQ4/suV4Yr/lGH4gVB9OnH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygaPf7T3mftra9hRw/6gwnLX8Ub6AW2Jn3ZwtlcY8G3dCnqV/V0yMKOmKxJ0SHNPy
	 AWE8kuQNPy4NzOX06gweTvypkdjkq8svdYP9wYvjv17wh+20ojI1xrZFkMZ5Fc6Urs
	 K+GSZYLBcsiUh6lbwojpXlWdphCPGAlqZmjsTLZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/231] ASoC: Intel: sof_sdw: Add lookup of quirk using PCI subsystem ID
Date: Wed, 19 Mar 2025 07:29:56 -0700
Message-ID: <20250319143029.380206761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit fc016ef7da64fd473d73ee6c261ba1b0b47afe2b ]

Add lookup of PCI subsystem vendor:device ID to find a quirk.

The subsystem ID (SSID) is part of the PCI specification to uniquely
identify a particular system-specific implementation of a hardware
device.

Unlike DMI information, it identifies the sound hardware itself, rather
than a specific model of PC. SSID can be more reliable and stable than
DMI strings, and is preferred by some vendors as the way to identify
the actual sound hardware.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250204053943.93596-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 84fc35d88b926..8f2416b73dc43 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -13,6 +13,7 @@
 #include <linux/soundwire/sdw.h>
 #include <linux/soundwire/sdw_type.h>
 #include <linux/soundwire/sdw_intel.h>
+#include <sound/core.h>
 #include <sound/soc-acpi.h>
 #include "sof_sdw_common.h"
 #include "../../codecs/rt711.h"
@@ -685,6 +686,22 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 	{}
 };
 
+static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	{}
+};
+
+static void sof_sdw_check_ssid_quirk(const struct snd_soc_acpi_mach *mach)
+{
+	const struct snd_pci_quirk *quirk_entry;
+
+	quirk_entry = snd_pci_quirk_lookup_id(mach->mach_params.subsystem_vendor,
+					      mach->mach_params.subsystem_device,
+					      sof_sdw_ssid_quirk_table);
+
+	if (quirk_entry)
+		sof_sdw_quirk = quirk_entry->value;
+}
+
 static struct snd_soc_dai_link_component platform_component[] = {
 	{
 		/* name might be overridden during probe */
@@ -1212,6 +1229,13 @@ static int mc_probe(struct platform_device *pdev)
 
 	snd_soc_card_set_drvdata(card, ctx);
 
+	if (mach->mach_params.subsystem_id_set) {
+		snd_soc_card_set_pci_ssid(card,
+					  mach->mach_params.subsystem_vendor,
+					  mach->mach_params.subsystem_device);
+		sof_sdw_check_ssid_quirk(mach);
+	}
+
 	dmi_check_system(sof_sdw_quirk_table);
 
 	if (quirk_override != -1) {
@@ -1227,12 +1251,6 @@ static int mc_probe(struct platform_device *pdev)
 	for (i = 0; i < ctx->codec_info_list_count; i++)
 		codec_info_list[i].amp_num = 0;
 
-	if (mach->mach_params.subsystem_id_set) {
-		snd_soc_card_set_pci_ssid(card,
-					  mach->mach_params.subsystem_vendor,
-					  mach->mach_params.subsystem_device);
-	}
-
 	ret = sof_card_dai_links_create(card);
 	if (ret < 0)
 		return ret;
-- 
2.39.5



