Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F61634CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AD1C433EF;
	Wed,  7 Jun 2023 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170383;
	bh=zpV5SE+b+pNWUY2xCtVHyDVz/RSQi2tKBoj7a2cWFUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwC/XoMNBttZ2b8HHVZhZ7S6Mm5ynlkZdkMy77uMgPIYKNiIDiPLgecgK6gzrlioU
	 bIDRcKdqe1tH57N0PXSCey3/fnyx9alMC3EBs2Vbpi3QnmeoJHCH4+SD4WzzDj5n/+
	 6HFqJ6A/a+NLsdeWBvWedTLtoVxdhAfOjvfD+fvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/225] ASoC: Intel: soc-acpi-cht: Add quirk for Nextbook Ares 8A tablet
Date: Wed,  7 Jun 2023 22:14:17 +0200
Message-ID: <20230607200916.456245234@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ec6f82b4c63cc68f8dc03316e725106d242706be ]

The Nextbook Ares 8A tablet which has Android as factory OS, has a buggy
DSDT with both ESSX8316 and 10EC5651 ACPI devices.

This tablet actually uses an rt5651 codec, but the matching code ends up
picking the ESSX8316 device, add a quirk to ignote the ESSX8316 device
on this tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-Id: <20230429104721.7176-1-hdegoede@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-cht-match.c   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-cht-match.c b/sound/soc/intel/common/soc-acpi-intel-cht-match.c
index 6beb00858c33f..cdcbf04b8832f 100644
--- a/sound/soc/intel/common/soc-acpi-intel-cht-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cht-match.c
@@ -50,6 +50,31 @@ static struct snd_soc_acpi_mach *cht_quirk(void *arg)
 		return mach;
 }
 
+/*
+ * Some tablets with Android factory OS have buggy DSDTs with an ESSX8316 device
+ * in the ACPI tables. While they are not using an ESS8316 codec. These DSDTs
+ * also have an ACPI device for the correct codec, ignore the ESSX8316.
+ */
+static const struct dmi_system_id cht_ess8316_not_present_table[] = {
+	{
+		/* Nextbook Ares 8A */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			DMI_MATCH(DMI_BIOS_VERSION, "M882"),
+		},
+	},
+	{ }
+};
+
+static struct snd_soc_acpi_mach *cht_ess8316_quirk(void *arg)
+{
+	if (dmi_check_system(cht_ess8316_not_present_table))
+		return NULL;
+
+	return arg;
+}
+
 static const struct snd_soc_acpi_codecs rt5640_comp_ids = {
 	.num_codecs = 2,
 	.codecs = { "10EC5640", "10EC3276" },
@@ -113,6 +138,7 @@ struct snd_soc_acpi_mach  snd_soc_acpi_intel_cherrytrail_machines[] = {
 		.drv_name = "bytcht_es8316",
 		.fw_filename = "intel/fw_sst_22a8.bin",
 		.board = "bytcht_es8316",
+		.machine_quirk = cht_ess8316_quirk,
 		.sof_tplg_filename = "sof-cht-es8316.tplg",
 	},
 	/* some CHT-T platforms rely on RT5640, use Baytrail machine driver */
-- 
2.39.2



