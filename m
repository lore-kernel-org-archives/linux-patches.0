Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60071547CC;
	Mon, 22 Sep 2025 19:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570384; cv=none; b=fz82xjH38geNULM87QydzxMK9RdfeIAhENoyHUcE+UbSOt6AkhbC8vTkCAL2sPA5fPP0/vit/zKe+NNQ8rquWPByRB+CrBHalg/gN0mVudFfB4+Os960OBJwI+WA4VOyJRrYEIUcSVmN5Jp4Wqey5vGXFD+wQ8LouNDx1fBBgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570384; c=relaxed/simple;
	bh=1gKZXUq5BHLEWOUGc9GB6lCNWkdEgsLJ0JSJY7B8txo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+gdcyYkZCPI5uBca4P030MXOd6dzudeRO1Rj13aXG1oZEAbFVYRSwH75sa2Fvp8aX0dkaTaqYqztdFo5sT+ivilgHdEA0hE5mo1LqCWyru5ABDCBLrj+G9ofOsr9EFToKe2CZNLywQf1KxfEYIj+KERPCmJotHns50eI8o31xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXuEwwV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXuEwwV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B2C4CEF0;
	Mon, 22 Sep 2025 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570384;
	bh=1gKZXUq5BHLEWOUGc9GB6lCNWkdEgsLJ0JSJY7B8txo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXuEwwV6FFHM05oVHU7w2VS+G2R+GUEp5if7D0VVvJk3FPnv3Mmb5TmCFtRNpiJws
	 Mj3iFnD9uXUkLA5WUCUDY+zMYkr+iC8bzHHvxBN47VRquMYfJydq1yyCvPOwVXp0vO
	 rLYfi+oQbRXD+Rqav0K0m1gFCWR32icotIHgS4D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 116/149] ASoC: amd: acp: Fix incorrect retrival of acp_chip_info
Date: Mon, 22 Sep 2025 21:30:16 +0200
Message-ID: <20250922192415.800903355@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit d7871f400cad1da376f1d7724209a1c49226c456 ]

Use dev_get_drvdata(dev->parent) instead of dev_get_platdata(dev)
to correctly obtain acp_chip_info members in the acp I2S driver.
Previously, some members were not updated properly due to incorrect
data access, which could potentially lead to null pointer
dereferences.

This issue was missed in the earlier commit
("ASoC: amd: acp: Fix NULL pointer deref in acp_i2s_set_tdm_slot"),
which only addressed set_tdm_slot(). This change ensures that all
relevant functions correctly retrieve acp_chip_info, preventing
further null pointer dereference issues.

Fixes: e3933683b25e ("ASoC: amd: acp: Remove redundant acp_dev_data structure")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250910171419.3682468-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index 70fa54d568ef6..4d9589b67099e 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -72,7 +72,7 @@ static int acp_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 			   unsigned int fmt)
 {
 	struct device *dev = cpu_dai->component->dev;
-	struct acp_chip_info *chip = dev_get_platdata(dev);
+	struct acp_chip_info *chip = dev_get_drvdata(dev->parent);
 	int mode;
 
 	mode = fmt & SND_SOC_DAIFMT_FORMAT_MASK;
@@ -196,7 +196,7 @@ static int acp_i2s_hwparams(struct snd_pcm_substream *substream, struct snd_pcm_
 	u32 reg_val, fmt_reg, tdm_fmt;
 	u32 lrclk_div_val, bclk_div_val;
 
-	chip = dev_get_platdata(dev);
+	chip = dev_get_drvdata(dev->parent);
 	rsrc = chip->rsrc;
 
 	/* These values are as per Hardware Spec */
@@ -383,7 +383,7 @@ static int acp_i2s_trigger(struct snd_pcm_substream *substream, int cmd, struct
 {
 	struct acp_stream *stream = substream->runtime->private_data;
 	struct device *dev = dai->component->dev;
-	struct acp_chip_info *chip = dev_get_platdata(dev);
+	struct acp_chip_info *chip = dev_get_drvdata(dev->parent);
 	struct acp_resource *rsrc = chip->rsrc;
 	u32 val, period_bytes, reg_val, ier_val, water_val, buf_size, buf_reg;
 
@@ -513,14 +513,13 @@ static int acp_i2s_trigger(struct snd_pcm_substream *substream, int cmd, struct
 static int acp_i2s_prepare(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
 	struct device *dev = dai->component->dev;
-	struct acp_chip_info *chip = dev_get_platdata(dev);
+	struct acp_chip_info *chip = dev_get_drvdata(dev->parent);
 	struct acp_resource *rsrc = chip->rsrc;
 	struct acp_stream *stream = substream->runtime->private_data;
 	u32 reg_dma_size = 0, reg_fifo_size = 0, reg_fifo_addr = 0;
 	u32 phy_addr = 0, acp_fifo_addr = 0, ext_int_ctrl;
 	unsigned int dir = substream->stream;
 
-	chip = dev_get_platdata(dev);
 	switch (dai->driver->id) {
 	case I2S_SP_INSTANCE:
 		if (dir == SNDRV_PCM_STREAM_PLAYBACK) {
@@ -629,7 +628,7 @@ static int acp_i2s_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 {
 	struct acp_stream *stream = substream->runtime->private_data;
 	struct device *dev = dai->component->dev;
-	struct acp_chip_info *chip = dev_get_platdata(dev);
+	struct acp_chip_info *chip = dev_get_drvdata(dev->parent);
 	struct acp_resource *rsrc = chip->rsrc;
 	unsigned int dir = substream->stream;
 	unsigned int irq_bit = 0;
-- 
2.51.0



