Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C633F1
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71515C433D2;
	Mon, 16 Jan 2023 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884735;
	bh=geRFAUh7sosFQs81275Gr+FKEcPi19gXnjpTQdAny2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubRiy7vPisCJXBwKJOdJ1YYIoWkGhNevgN63o8qybKuZ3cxUYOeoDsLrNombZV0RY
	 Bi90UNrEiblphlVGW9UMyCMmqdypnbrK+emH028V/Jv58Q5uI+BfeuPE6uoAj5c6PK
	 69xD4UrrR6Uh+2ChtcqUbttWOB6/c3y2QcFmPquw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Brent Lu <brent.lu@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/183] ASoC: Intel: sof_nau8825: support rt1015p speaker amplifier
Date: Mon, 16 Jan 2023 16:50:25 +0100
Message-Id: <20230116154807.709645122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brent Lu <brent.lu@intel.com>

[ Upstream commit 13c459fa37c9f26e9bf884a832dd67598b5c4d3e ]

Add rt1015p speaker amplifier support with a new board info
'adl_rt1015p_nau8825' which supports NAU8825 on SSP0 and ALC1015Q on
SSP1.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Brent Lu <brent.lu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221117231919.112483-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3e78986a840d ("ASoC: Intel: sof-nau8825: fix module alias overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_nau8825.c             | 16 ++++++++++++++++
 .../soc/intel/common/soc-acpi-intel-adl-match.c  | 12 ++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/sound/soc/intel/boards/sof_nau8825.c b/sound/soc/intel/boards/sof_nau8825.c
index 5585c217f78d..27880224359d 100644
--- a/sound/soc/intel/boards/sof_nau8825.c
+++ b/sound/soc/intel/boards/sof_nau8825.c
@@ -47,6 +47,7 @@
 #define SOF_RT1019P_SPEAKER_AMP_PRESENT	BIT(14)
 #define SOF_MAX98373_SPEAKER_AMP_PRESENT	BIT(15)
 #define SOF_MAX98360A_SPEAKER_AMP_PRESENT	BIT(16)
+#define SOF_RT1015P_SPEAKER_AMP_PRESENT	BIT(17)
 
 static unsigned long sof_nau8825_quirk = SOF_NAU8825_SSP_CODEC(0);
 
@@ -483,6 +484,8 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		} else if (sof_nau8825_quirk &
 				SOF_MAX98360A_SPEAKER_AMP_PRESENT) {
 			max_98360a_dai_link(&links[id]);
+		} else if (sof_nau8825_quirk & SOF_RT1015P_SPEAKER_AMP_PRESENT) {
+			sof_rt1015p_dai_link(&links[id]);
 		} else {
 			goto devm_err;
 		}
@@ -576,6 +579,8 @@ static int sof_audio_probe(struct platform_device *pdev)
 
 	if (sof_nau8825_quirk & SOF_MAX98373_SPEAKER_AMP_PRESENT)
 		max_98373_set_codec_conf(&sof_audio_card_nau8825);
+	else if (sof_nau8825_quirk & SOF_RT1015P_SPEAKER_AMP_PRESENT)
+		sof_rt1015p_codec_conf(&sof_audio_card_nau8825);
 
 	if (sof_nau8825_quirk & SOF_SSP_BT_OFFLOAD_PRESENT)
 		sof_audio_card_nau8825.num_links++;
@@ -642,6 +647,16 @@ static const struct platform_device_id board_ids[] = {
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 
 	},
+	{
+		.name = "adl_rt1015p_nau8825",
+		.driver_data = (kernel_ulong_t)(SOF_NAU8825_SSP_CODEC(0) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_RT1015P_SPEAKER_AMP_PRESENT |
+					SOF_NAU8825_SSP_AMP(1) |
+					SOF_NAU8825_NUM_HDMIDEV(4) |
+					SOF_BT_OFFLOAD_SSP(2) |
+					SOF_SSP_BT_OFFLOAD_PRESENT),
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(platform, board_ids);
@@ -663,3 +678,4 @@ MODULE_AUTHOR("Mac Chiang <mac.chiang@intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS(SND_SOC_INTEL_HDA_DSP_COMMON);
 MODULE_IMPORT_NS(SND_SOC_INTEL_SOF_MAXIM_COMMON);
+MODULE_IMPORT_NS(SND_SOC_INTEL_SOF_REALTEK_COMMON);
diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index 9990d5502d26..ce4d8ec86f2c 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -430,6 +430,11 @@ static const struct snd_soc_acpi_codecs adl_rt5682_rt5682s_hp = {
 	.codecs = {"10EC5682", "RTL5682"},
 };
 
+static const struct snd_soc_acpi_codecs adl_rt1015p_amp = {
+	.num_codecs = 1,
+	.codecs = {"RTL1015"}
+};
+
 static const struct snd_soc_acpi_codecs adl_rt1019p_amp = {
 	.num_codecs = 1,
 	.codecs = {"RTL1019"}
@@ -495,6 +500,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[] = {
 		.quirk_data = &adl_rt1019p_amp,
 		.sof_tplg_filename = "sof-adl-rt1019-rt5682.tplg",
 	},
+	{
+		.id = "10508825",
+		.drv_name = "adl_rt1015p_nau8825",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &adl_rt1015p_amp,
+		.sof_tplg_filename = "sof-adl-rt1015-nau8825.tplg",
+	},
 	{
 		.id = "10508825",
 		.drv_name = "sof_nau8825",
-- 
2.35.1



