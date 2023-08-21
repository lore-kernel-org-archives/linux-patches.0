Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807AC1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01977C433C8;
	Mon, 21 Aug 2023 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648018;
	bh=Df5Cd+qXoza4tr5db3N30kUzoYiOuz3+DyXiqM42MlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=015eFnEn/fp8054IK2XW3esyHRXH+JZQ+4aHilxvNDbxd7Pg90fFPA1RGDPiWWve/
	 Pl+ZLcSLp7gUj+xBlElRqKLah2z6arrCcTMZ3hGImC6GqifcFj+uORXw2PeXSTm/ey
	 XI8kmbB4Tq4h63bukGNmiPkLro7ih5oisVJ9yQMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 025/234] ASoC: SOF: Intel: fix SoundWire/HDaudio mutual exclusion
Date: Mon, 21 Aug 2023 21:39:48 +0200
Message-ID: <20230821194129.874670305@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f751b99255cacd9ffe8c4bbf99767ad670cee1f7 ]

The functionality described in Commit 61bef9e68dca ("ASoC: SOF: Intel: hda: enforce exclusion between HDaudio and SoundWire")
does not seem to be properly implemented with two issues that need to
be corrected.

a) The test used is incorrect when DisplayAudio codecs are not supported.

b) Conversely when only Display Audio codecs can be found, we do want
to start the SoundWire links, if any. That will help add the relevant
topologies and machine descriptors, and identify cases where the
SoundWire information in ACPI needs to be modified with a quirk.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20230606222529.57156-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 3153e21f100ab..3853582e32e12 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1343,12 +1343,22 @@ static void hda_generic_machine_select(struct snd_sof_dev *sdev,
 			hda_mach->mach_params.dmic_num = dmic_num;
 			pdata->tplg_filename = tplg_filename;
 
-			if (codec_num == 2) {
+			if (codec_num == 2 ||
+			    (codec_num == 1 && !HDA_IDISP_CODEC(bus->codec_mask))) {
 				/*
 				 * Prevent SoundWire links from starting when an external
 				 * HDaudio codec is used
 				 */
 				hda_mach->mach_params.link_mask = 0;
+			} else {
+				/*
+				 * Allow SoundWire links to start when no external HDaudio codec
+				 * was detected. This will not create a SoundWire card but
+				 * will help detect if any SoundWire codec reports as ATTACHED.
+				 */
+				struct sof_intel_hda_dev *hdev = sdev->pdata->hw_pdata;
+
+				hda_mach->mach_params.link_mask = hdev->info.link_mask;
 			}
 
 			*mach = hda_mach;
-- 
2.40.1



