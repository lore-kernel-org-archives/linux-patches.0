Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5B833DEFE;
	Mon, 20 Apr 2026 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700246; cv=none; b=qo0Lc9PN+Ww+1UFbslWurTrZa6VDxtcgzPOCW38mDDz4PZP+5gtr41Lz1POLcXrSlO+2W+y2O87Ly+O5Id3fqy6Tx3l2CgIFLVaRhPSA4p5LPjo3Ksd1VBUmyIRARMlqLRkMASdt605gqZ6cSC/czIwT2peuyjTNCcA9irXf7Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700246; c=relaxed/simple;
	bh=ZvJoJsZG3B2KG+3qgKG310VxldYIH+sKzGOgaCvN3o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFRII/BlywFNovAetqN+x0taUwdnJ4vuOC2iguwOds4WaEPAkelDpycrUV8m9wtY3XqqwtBrkr8/i2Kb2FHn0KMeSpsqVy8TmVOgdqi8pPq2y0+CQrhwwwApbGIBrsn0QfAkBW5jtlEMvvpQEK4pcSWFZkHyihyXDAXdmuwA4Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcNIrHc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcNIrHc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8184EC2BCB4;
	Mon, 20 Apr 2026 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700245;
	bh=ZvJoJsZG3B2KG+3qgKG310VxldYIH+sKzGOgaCvN3o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcNIrHc9++/iZkaK7r6o5anFNNEtshCQ2JMdAzME8O6LsVS9IP66PYs0nVrVE2u1E
	 SrUONRNqU+AJ6xTujn220JyNRsYDp26yMPO9kby4sFQx05qk1TeeKrCqcrikbhqgoI
	 QkPZjar+qXwGod/Dph7PMOi5Q3g/O8i5kfa8wOMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 097/220] ASoC: SOF: Intel: fix iteration in is_endpoint_present()
Date: Mon, 20 Apr 2026 17:40:38 +0200
Message-ID: <20260420153937.526101543@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 1de6ddcddc954a69f96b1c23205e03ddd603e3c8 ]

is_endpoint_present() iterates over sdca_data.num_functions, but checks
the dai_type according to codec info list, which will cause problems if
not all endpoints from the codec info list are present. Make sure the
type of actually present functions is compared against target dai_type.

Fixes: 5226d19d4cae ("ASoC: SOF: Intel: use sof_sdw as default SDW machine driver")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260402064531.2287261-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 882198308319e..b039306454da2 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1133,13 +1133,12 @@ static void hda_generic_machine_select(struct snd_sof_dev *sdev,
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE)
 
-static bool is_endpoint_present(struct sdw_slave *sdw_device,
-				struct asoc_sdw_codec_info *dai_info, int dai_type)
+static bool is_endpoint_present(struct sdw_slave *sdw_device, int dai_type)
 {
 	int i;
 
 	for (i = 0; i < sdw_device->sdca_data.num_functions; i++) {
-		if (dai_type == dai_info->dais[i].dai_type)
+		if (dai_type == asoc_sdw_get_dai_type(sdw_device->sdca_data.function[i].type))
 			return true;
 	}
 	dev_dbg(&sdw_device->dev, "Endpoint DAI type %d not found\n", dai_type);
@@ -1193,8 +1192,7 @@ static struct snd_soc_acpi_adr_device *find_acpi_adr_device(struct device *dev,
 		}
 		for (j = 0; j < codec_info_list[i].dai_num; j++) {
 			/* Check if the endpoint is present by the SDCA DisCo table */
-			if (!is_endpoint_present(sdw_device, &codec_info_list[i],
-						 codec_info_list[i].dais[j].dai_type))
+			if (!is_endpoint_present(sdw_device, codec_info_list[i].dais[j].dai_type))
 				continue;
 
 			endpoints[ep_index].num = j;
-- 
2.53.0



