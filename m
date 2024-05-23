Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D814AD03;
	Thu, 23 May 2024 13:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470248; cv=none; b=buB4KCENOvC056GuTm/7k7UBCbXAJh7e2QEkKSqVtbiLQSjPc6d/WJyVIJ4O/Vnvs/VWYlgKhKR8KZB+jd++G5EpTOUVCUArZqXqAMVGP3dDZNe9f+jjdj1UgwWalYy2orM2oWOj/0KnZHPC3+1OCGlRa96aV2qYHuhI03oKQ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470248; c=relaxed/simple;
	bh=0I4R3A381r6dm0n17R5XzpoaB3+6dI/9+9atgwpFLq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkH1Efe1U3F1PEVVIjh0IaBBVKFbFlWvvnrVVvVMCyaVz8mvx+OCDApwgeyggOa1yxFNIc7LeY5LmoSlfDlrShuTKK5liQIjYxs0IPbA0/gCKALzkJaQuPPoatGbd89PIaIEbB98wOq1YXYVzSa8WcECd3zLdSP2nsLWSorDKBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl/jAdP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl/jAdP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FC4C3277B;
	Thu, 23 May 2024 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470248;
	bh=0I4R3A381r6dm0n17R5XzpoaB3+6dI/9+9atgwpFLq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl/jAdP9rTHFfU2dgfPJV1Ivbrc2Dm2OHOireeds6OsX4LN7lvL4EDY6gNAo2AfhM
	 EwSKqqsawT0DwhPLb6EQCJyNvuXnLFfqL8zKweDyaYz/RJn0mOVO4tGvq3yQucO8HR
	 Fq5jBrnNx1NFxbfZuTMaJSjJmWEgmYoi37EobSKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Song <chao.song@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.9 09/25] ASoC: Intel: sof_sdw: use generic rtd_init function for Realtek SDW DMICs
Date: Thu, 23 May 2024 15:12:54 +0200
Message-ID: <20240523130330.738992207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit bee2fe44679f1e6a5332d7f78587ccca4109919f upstream.

The only thing that the rt_xxx_rtd_init() functions do is to set
card->components. And we can set card->components with name_prefix
as rt712_sdca_dmic_rtd_init() does.
And sof_sdw_rtd_init() will always select the first dai with the
given dai->name from codec_info_list[]. Unfortunately, we have
different codecs with the same dai name. For example, dai name of
rt715 and rt715-sdca are both "rt715-aif2". Using a generic rtd_init
allow sof_sdw_rtd_init() run the rtd_init() callback from a similar
codec dai.

Fixes: 8266c73126b7 ("ASoC: Intel: sof_sdw: add common sdw dai link init")
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240326160429.13560-25-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/Makefile          |    1 
 sound/soc/intel/boards/sof_sdw.c         |   12 +++----
 sound/soc/intel/boards/sof_sdw_common.h  |    1 
 sound/soc/intel/boards/sof_sdw_rt_dmic.c |   52 +++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 6 deletions(-)
 create mode 100644 sound/soc/intel/boards/sof_sdw_rt_dmic.c

--- a/sound/soc/intel/boards/Makefile
+++ b/sound/soc/intel/boards/Makefile
@@ -42,6 +42,7 @@ snd-soc-sof-sdw-objs += sof_sdw.o				\
 			sof_sdw_rt711.o sof_sdw_rt_sdca_jack_common.o	\
 			sof_sdw_rt712_sdca.o sof_sdw_rt715.o	\
 			sof_sdw_rt715_sdca.o sof_sdw_rt722_sdca.o	\
+			sof_sdw_rt_dmic.o			\
 			sof_sdw_cs42l42.o sof_sdw_cs42l43.o	\
 			sof_sdw_cs_amp.o			\
 			sof_sdw_dmic.o				\
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -730,7 +730,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt712-sdca-dmic-aif1",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt712_sdca_dmic_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
@@ -760,7 +760,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt712-sdca-dmic-aif1",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt712_sdca_dmic_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
@@ -822,7 +822,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt715-aif2",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt715_sdca_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
@@ -837,7 +837,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt715-aif2",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt715_sdca_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
@@ -852,7 +852,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt715-aif2",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt715_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
@@ -867,7 +867,7 @@ static struct sof_sdw_codec_info codec_i
 				.dai_name = "rt715-aif2",
 				.dai_type = SOF_SDW_DAI_TYPE_MIC,
 				.dailink = {SDW_UNUSED_DAI_ID, SDW_DMIC_DAI_ID},
-				.rtd_init = rt715_rtd_init,
+				.rtd_init = rt_dmic_rtd_init,
 			},
 		},
 		.dai_num = 1,
--- a/sound/soc/intel/boards/sof_sdw_common.h
+++ b/sound/soc/intel/boards/sof_sdw_common.h
@@ -190,6 +190,7 @@ int rt712_sdca_dmic_rtd_init(struct snd_
 int rt712_spk_rtd_init(struct snd_soc_pcm_runtime *rtd);
 int rt715_rtd_init(struct snd_soc_pcm_runtime *rtd);
 int rt715_sdca_rtd_init(struct snd_soc_pcm_runtime *rtd);
+int rt_dmic_rtd_init(struct snd_soc_pcm_runtime *rtd);
 int rt_amp_spk_rtd_init(struct snd_soc_pcm_runtime *rtd);
 int rt_sdca_jack_rtd_init(struct snd_soc_pcm_runtime *rtd);
 
--- /dev/null
+++ b/sound/soc/intel/boards/sof_sdw_rt_dmic.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2024 Intel Corporation
+
+/*
+ * sof_sdw_rt_dmic - Helpers to handle Realtek SDW DMIC from generic machine driver
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <sound/soc.h>
+#include <sound/soc-acpi.h>
+#include "sof_board_helpers.h"
+#include "sof_sdw_common.h"
+
+static const char * const dmics[] = {
+	"rt715",
+	"rt712-sdca-dmic",
+};
+
+int rt_dmic_rtd_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_card *card = rtd->card;
+	struct snd_soc_component *component;
+	struct snd_soc_dai *codec_dai;
+	char *mic_name;
+
+	codec_dai = get_codec_dai_by_name(rtd, dmics, ARRAY_SIZE(dmics));
+	if (!codec_dai)
+		return -EINVAL;
+
+	component = codec_dai->component;
+
+	/*
+	 * rt715-sdca (aka rt714) is a special case that uses different name in card->components
+	 * and component->name_prefix.
+	 */
+	if (!strcmp(component->name_prefix, "rt714"))
+		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "rt715-sdca");
+	else
+		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "%s", component->name_prefix);
+
+	card->components = devm_kasprintf(card->dev, GFP_KERNEL,
+					  "%s mic:%s", card->components,
+					  mic_name);
+	if (!card->components)
+		return -ENOMEM;
+
+	dev_dbg(card->dev, "card->components: %s\n", card->components);
+
+	return 0;
+}
+MODULE_IMPORT_NS(SND_SOC_INTEL_SOF_BOARD_HELPERS);


