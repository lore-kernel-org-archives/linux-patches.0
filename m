Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5036A189F52;
	Tue, 10 Sep 2024 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961967; cv=none; b=Mw7z1ijOFL6/z4CllerobKHmhQaQFx3oDMrPFX1u6N3FSuzsKtrNuMPZZ4oRIIHLEsiS0iDqc2ITrREcpjWpbACjoAt5Y2b+q1z1UkZ1lI76smWhL2/m8/evQDxv3jVKDCwGjoKOnj+Pi1RFusE6jDwZIKAX5wuT/AnMF4Ip+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961967; c=relaxed/simple;
	bh=9eGfz0piUnm8SzcJxArbg7C+4m0rDOsvIHCiTnqtflQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJZaXG8OFgWccvT3UutoXbFqDcuzEfFG9Rh1tUP6TwC+mpqzI5kbOEStfRkgvrGmA2mUBpH3bnSeOdmPn5ppKGsW9gR851ySk0CzGbfUY+9wNqf0QS+Z3KNTjJCCtrbVU5hDVzVQLC83lVu6jmbDt/Jj9K77fa7E0/5kzKm5tAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOKWP1z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOKWP1z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD98C4CEC3;
	Tue, 10 Sep 2024 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961967;
	bh=9eGfz0piUnm8SzcJxArbg7C+4m0rDOsvIHCiTnqtflQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOKWP1z0XY4u5GcBZpazhxPA/4edxRYO3jmmvsDSTdnDjvuJTuCzAdvuJRwPiAvOz
	 5oOCJujBMP8YxMC2oCbKJ2LYm99WFriRvwMfvduYTvHIf1cdLEUVIwcK9aXIpwplmr
	 sRGKy4q1e1dl936e5yHQU01o4J2nZ9uY5R9VEOKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 223/375] ASoc: TAS2781: replace beXX_to_cpup with get_unaligned_beXX for potentially broken alignment
Date: Tue, 10 Sep 2024 11:30:20 +0200
Message-ID: <20240910092630.035571179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 1cc509edbe23b61e8c245611bd15d88edb635a38 ]

Use get_unaligned_be16 instead of be16_to_cpup and get_unaligned_be32
instead of be32_to_cpup for potentially broken alignment.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20240707083011.98-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 71 +++++++++++++++----------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 08082806d589..8f9a3ae7153e 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -21,7 +21,7 @@
 #include <sound/soc.h>
 #include <sound/tlv.h>
 #include <sound/tas2781.h>
-
+#include <asm/unaligned.h>
 
 #define ERROR_PRAM_CRCCHK			0x0000000
 #define ERROR_YRAM_CRCCHK			0x0000001
@@ -187,8 +187,7 @@ static struct tasdevice_config_info *tasdevice_add_config(
 	/* convert data[offset], data[offset + 1], data[offset + 2] and
 	 * data[offset + 3] into host
 	 */
-	cfg_info->nblocks =
-		be32_to_cpup((__be32 *)&config_data[config_offset]);
+	cfg_info->nblocks = get_unaligned_be32(&config_data[config_offset]);
 	config_offset += 4;
 
 	/* Several kinds of dsp/algorithm firmwares can run on tas2781,
@@ -232,14 +231,14 @@ static struct tasdevice_config_info *tasdevice_add_config(
 
 		}
 		bk_da[i]->yram_checksum =
-			be16_to_cpup((__be16 *)&config_data[config_offset]);
+			get_unaligned_be16(&config_data[config_offset]);
 		config_offset += 2;
 		bk_da[i]->block_size =
-			be32_to_cpup((__be32 *)&config_data[config_offset]);
+			get_unaligned_be32(&config_data[config_offset]);
 		config_offset += 4;
 
 		bk_da[i]->n_subblks =
-			be32_to_cpup((__be32 *)&config_data[config_offset]);
+			get_unaligned_be32(&config_data[config_offset]);
 
 		config_offset += 4;
 
@@ -289,7 +288,7 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 	}
 	buf = (unsigned char *)fmw->data;
 
-	fw_hdr->img_sz = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->img_sz = get_unaligned_be32(&buf[offset]);
 	offset += 4;
 	if (fw_hdr->img_sz != fmw->size) {
 		dev_err(tas_priv->dev,
@@ -300,9 +299,9 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 		goto out;
 	}
 
-	fw_hdr->checksum = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->checksum = get_unaligned_be32(&buf[offset]);
 	offset += 4;
-	fw_hdr->binary_version_num = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->binary_version_num = get_unaligned_be32(&buf[offset]);
 	if (fw_hdr->binary_version_num < 0x103) {
 		dev_err(tas_priv->dev, "File version 0x%04x is too low",
 			fw_hdr->binary_version_num);
@@ -311,7 +310,7 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 		goto out;
 	}
 	offset += 4;
-	fw_hdr->drv_fw_version = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->drv_fw_version = get_unaligned_be32(&buf[offset]);
 	offset += 8;
 	fw_hdr->plat_type = buf[offset];
 	offset += 1;
@@ -339,11 +338,11 @@ int tasdevice_rca_parser(void *context, const struct firmware *fmw)
 	for (i = 0; i < TASDEVICE_DEVICE_SUM; i++, offset++)
 		fw_hdr->devs[i] = buf[offset];
 
-	fw_hdr->nconfig = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->nconfig = get_unaligned_be32(&buf[offset]);
 	offset += 4;
 
 	for (i = 0; i < TASDEVICE_CONFIG_SUM; i++) {
-		fw_hdr->config_size[i] = be32_to_cpup((__be32 *)&buf[offset]);
+		fw_hdr->config_size[i] = get_unaligned_be32(&buf[offset]);
 		offset += 4;
 		total_config_sz += fw_hdr->config_size[i];
 	}
@@ -423,7 +422,7 @@ static int fw_parse_block_data_kernel(struct tasdevice_fw *tas_fmw,
 	/* convert data[offset], data[offset + 1], data[offset + 2] and
 	 * data[offset + 3] into host
 	 */
-	block->type = be32_to_cpup((__be32 *)&data[offset]);
+	block->type = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
 	block->is_pchksum_present = data[offset];
@@ -438,10 +437,10 @@ static int fw_parse_block_data_kernel(struct tasdevice_fw *tas_fmw,
 	block->ychksum = data[offset];
 	offset++;
 
-	block->blk_size = be32_to_cpup((__be32 *)&data[offset]);
+	block->blk_size = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
-	block->nr_subblocks = be32_to_cpup((__be32 *)&data[offset]);
+	block->nr_subblocks = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
 	/* fixed m68k compiling issue:
@@ -482,7 +481,7 @@ static int fw_parse_data_kernel(struct tasdevice_fw *tas_fmw,
 		offset = -EINVAL;
 		goto out;
 	}
-	img_data->nr_blk = be32_to_cpup((__be32 *)&data[offset]);
+	img_data->nr_blk = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
 	img_data->dev_blks = kcalloc(img_data->nr_blk,
@@ -578,14 +577,14 @@ static int fw_parse_variable_header_kernel(
 		offset = -EINVAL;
 		goto out;
 	}
-	fw_hdr->device_family = be16_to_cpup((__be16 *)&buf[offset]);
+	fw_hdr->device_family = get_unaligned_be16(&buf[offset]);
 	if (fw_hdr->device_family != 0) {
 		dev_err(tas_priv->dev, "%s:not TAS device\n", __func__);
 		offset = -EINVAL;
 		goto out;
 	}
 	offset += 2;
-	fw_hdr->device = be16_to_cpup((__be16 *)&buf[offset]);
+	fw_hdr->device = get_unaligned_be16(&buf[offset]);
 	if (fw_hdr->device >= TASDEVICE_DSP_TAS_MAX_DEVICE ||
 		fw_hdr->device == 6) {
 		dev_err(tas_priv->dev, "Unsupported dev %d\n", fw_hdr->device);
@@ -603,7 +602,7 @@ static int fw_parse_variable_header_kernel(
 		goto out;
 	}
 
-	tas_fmw->nr_programs = be32_to_cpup((__be32 *)&buf[offset]);
+	tas_fmw->nr_programs = get_unaligned_be32(&buf[offset]);
 	offset += 4;
 
 	if (tas_fmw->nr_programs == 0 || tas_fmw->nr_programs >
@@ -622,14 +621,14 @@ static int fw_parse_variable_header_kernel(
 
 	for (i = 0; i < tas_fmw->nr_programs; i++) {
 		program = &(tas_fmw->programs[i]);
-		program->prog_size = be32_to_cpup((__be32 *)&buf[offset]);
+		program->prog_size = get_unaligned_be32(&buf[offset]);
 		offset += 4;
 	}
 
 	/* Skip the unused prog_size */
 	offset += 4 * (TASDEVICE_MAXPROGRAM_NUM_KERNEL - tas_fmw->nr_programs);
 
-	tas_fmw->nr_configurations = be32_to_cpup((__be32 *)&buf[offset]);
+	tas_fmw->nr_configurations = get_unaligned_be32(&buf[offset]);
 	offset += 4;
 
 	/* The max number of config in firmware greater than 4 pieces of
@@ -661,7 +660,7 @@ static int fw_parse_variable_header_kernel(
 
 	for (i = 0; i < tas_fmw->nr_programs; i++) {
 		config = &(tas_fmw->configs[i]);
-		config->cfg_size = be32_to_cpup((__be32 *)&buf[offset]);
+		config->cfg_size = get_unaligned_be32(&buf[offset]);
 		offset += 4;
 	}
 
@@ -699,7 +698,7 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 		switch (subblk_typ) {
 		case TASDEVICE_CMD_SING_W: {
 			int i;
-			unsigned short len = be16_to_cpup((__be16 *)&data[2]);
+			unsigned short len = get_unaligned_be16(&data[2]);
 
 			subblk_offset += 2;
 			if (subblk_offset + 4 * len > sublocksize) {
@@ -725,7 +724,7 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 		}
 			break;
 		case TASDEVICE_CMD_BURST: {
-			unsigned short len = be16_to_cpup((__be16 *)&data[2]);
+			unsigned short len = get_unaligned_be16(&data[2]);
 
 			subblk_offset += 2;
 			if (subblk_offset + 4 + len > sublocksize) {
@@ -766,7 +765,7 @@ static int tasdevice_process_block(void *context, unsigned char *data,
 				is_err = true;
 				break;
 			}
-			sleep_time = be16_to_cpup((__be16 *)&data[2]) * 1000;
+			sleep_time = get_unaligned_be16(&data[2]) * 1000;
 			usleep_range(sleep_time, sleep_time + 50);
 			subblk_offset += 2;
 		}
@@ -910,7 +909,7 @@ static int fw_parse_variable_hdr(struct tasdevice_priv
 
 	offset += len;
 
-	fw_hdr->device_family = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->device_family = get_unaligned_be32(&buf[offset]);
 	if (fw_hdr->device_family != 0) {
 		dev_err(tas_priv->dev, "%s: not TAS device\n", __func__);
 		offset = -EINVAL;
@@ -918,7 +917,7 @@ static int fw_parse_variable_hdr(struct tasdevice_priv
 	}
 	offset += 4;
 
-	fw_hdr->device = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_hdr->device = get_unaligned_be32(&buf[offset]);
 	if (fw_hdr->device >= TASDEVICE_DSP_TAS_MAX_DEVICE ||
 		fw_hdr->device == 6) {
 		dev_err(tas_priv->dev, "Unsupported dev %d\n", fw_hdr->device);
@@ -963,7 +962,7 @@ static int fw_parse_block_data(struct tasdevice_fw *tas_fmw,
 		offset = -EINVAL;
 		goto out;
 	}
-	block->type = be32_to_cpup((__be32 *)&data[offset]);
+	block->type = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
 	if (tas_fmw->fw_hdr.fixed_hdr.drv_ver >= PPC_DRIVER_CRCCHK) {
@@ -988,7 +987,7 @@ static int fw_parse_block_data(struct tasdevice_fw *tas_fmw,
 		block->is_ychksum_present = 0;
 	}
 
-	block->nr_cmds = be32_to_cpup((__be32 *)&data[offset]);
+	block->nr_cmds = get_unaligned_be32(&data[offset]);
 	offset += 4;
 
 	n = block->nr_cmds * 4;
@@ -1039,7 +1038,7 @@ static int fw_parse_data(struct tasdevice_fw *tas_fmw,
 		goto out;
 	}
 	offset += n;
-	img_data->nr_blk = be16_to_cpup((__be16 *)&data[offset]);
+	img_data->nr_blk = get_unaligned_be16(&data[offset]);
 	offset += 2;
 
 	img_data->dev_blks = kcalloc(img_data->nr_blk,
@@ -1076,7 +1075,7 @@ static int fw_parse_program_data(struct tasdevice_priv *tas_priv,
 		offset = -EINVAL;
 		goto out;
 	}
-	tas_fmw->nr_programs = be16_to_cpup((__be16 *)&buf[offset]);
+	tas_fmw->nr_programs = get_unaligned_be16(&buf[offset]);
 	offset += 2;
 
 	if (tas_fmw->nr_programs == 0) {
@@ -1143,7 +1142,7 @@ static int fw_parse_configuration_data(
 		offset = -EINVAL;
 		goto out;
 	}
-	tas_fmw->nr_configurations = be16_to_cpup((__be16 *)&data[offset]);
+	tas_fmw->nr_configurations = get_unaligned_be16(&data[offset]);
 	offset += 2;
 
 	if (tas_fmw->nr_configurations == 0) {
@@ -1775,7 +1774,7 @@ static int fw_parse_header(struct tasdevice_priv *tas_priv,
 	/* Convert data[offset], data[offset + 1], data[offset + 2] and
 	 * data[offset + 3] into host
 	 */
-	fw_fixed_hdr->fwsize = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_fixed_hdr->fwsize = get_unaligned_be32(&buf[offset]);
 	offset += 4;
 	if (fw_fixed_hdr->fwsize != fmw->size) {
 		dev_err(tas_priv->dev, "File size not match, %lu %u",
@@ -1784,9 +1783,9 @@ static int fw_parse_header(struct tasdevice_priv *tas_priv,
 		goto out;
 	}
 	offset += 4;
-	fw_fixed_hdr->ppcver = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_fixed_hdr->ppcver = get_unaligned_be32(&buf[offset]);
 	offset += 8;
-	fw_fixed_hdr->drv_ver = be32_to_cpup((__be32 *)&buf[offset]);
+	fw_fixed_hdr->drv_ver = get_unaligned_be32(&buf[offset]);
 	offset += 72;
 
  out:
@@ -1828,7 +1827,7 @@ static int fw_parse_calibration_data(struct tasdevice_priv *tas_priv,
 		offset = -EINVAL;
 		goto out;
 	}
-	tas_fmw->nr_calibrations = be16_to_cpup((__be16 *)&data[offset]);
+	tas_fmw->nr_calibrations = get_unaligned_be16(&data[offset]);
 	offset += 2;
 
 	if (tas_fmw->nr_calibrations != 1) {
-- 
2.43.0



