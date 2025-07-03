Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509792E7BD6;
	Thu,  3 Jul 2025 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554970; cv=none; b=PmsOPvdiP3z25vHXIwpzIxwv3RnA+Ydg42AyzbQ47DValMnr9f1f5GJpVNZCuNFchjjAQC50QPFS3V/VqNPQRqEYTQWPt4DJzLX1qi3JVBKBcSpDrfht4lm4PU5SFvHr1saLhtw8FbXtKw7YN+62VDIOB3NFh10O4zMiXkX6RLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554970; c=relaxed/simple;
	bh=CdzzFSIY88IwEe+zDb9Pdn3m0fQuWcBzo9RqcvqHzd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fncgWwuJ2kdXIkbRkjS/h7hXuULiXopV8VG2Oum73dlejV0ashu6Jturv3Jmd69YEztu6lTJyuRK+z7ppUe8HsT0QerHlQE5mqYsioNWrzROJI19jJhcorej8r8PZMHHoCstsDaKGorOw284eCoO4uEM4jDbigrdxA24AmdfSI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhiIiiEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhiIiiEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2F6C4CEE3;
	Thu,  3 Jul 2025 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554969;
	bh=CdzzFSIY88IwEe+zDb9Pdn3m0fQuWcBzo9RqcvqHzd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhiIiiEwK76cgeyY18AU/lqP6z0VGBtpAeKuOH8YW8P1dpLhzMf+XOXVyuJZeew62
	 FLMuuOVdAhyC/bXSCOh6Njw5WEZ8YX5kgS59er2ATqlBCsMDkCCXzHjf04Ds/NRsn7
	 Rlj+1P+fL8ygMCIutmM3Wc8NLjUtwebRYFfrHC3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/263] ASoC: amd: ps: fix for soundwire failures during hibernation exit sequence
Date: Thu,  3 Jul 2025 16:40:56 +0200
Message-ID: <20250703144009.812978574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit dc6458ed95e40146699f9c523e34cb13ff127170 ]

During the hibernate entry sequence, ACP registers will be reset to
default values and acp ip will be completely powered off including acp
SoundWire pads. During resume sequence, if acp SoundWire pad keeper enable
register is not restored along with pad pulldown control register value,
then SoundWire manager links won't be powered on correctly results in
peripheral register access failures and completely audio function is
broken.

Add code to store the acp SoundWire pad keeper enable register and acp pad
pulldown ctrl register values before entering into suspend state and
restore the register values during resume sequence based on condition check
for acp SoundWire pad keeper enable register for ACP6.3, ACP7.0 & ACP7.1
platforms.

Fixes: 491628388005 ("ASoC: amd: ps: add callback functions for acp pci driver pm ops")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250623084630.3100279-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/acp63.h     |  4 ++++
 sound/soc/amd/ps/ps-common.c | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/sound/soc/amd/ps/acp63.h b/sound/soc/amd/ps/acp63.h
index 85feae45c44c5..d7c994e26e4df 100644
--- a/sound/soc/amd/ps/acp63.h
+++ b/sound/soc/amd/ps/acp63.h
@@ -334,6 +334,8 @@ struct acp_hw_ops {
  * @addr: pci ioremap address
  * @reg_range: ACP reigister range
  * @acp_rev: ACP PCI revision id
+ * @acp_sw_pad_keeper_en: store acp SoundWire pad keeper enable register value
+ * @acp_pad_pulldown_ctrl: store acp pad pulldown control register value
  * @acp63_sdw0-dma_intr_stat: DMA interrupt status array for ACP6.3 platform SoundWire
  * manager-SW0 instance
  * @acp63_sdw_dma_intr_stat: DMA interrupt status array for ACP6.3 platform SoundWire
@@ -367,6 +369,8 @@ struct acp63_dev_data {
 	u32 addr;
 	u32 reg_range;
 	u32 acp_rev;
+	u32 acp_sw_pad_keeper_en;
+	u32 acp_pad_pulldown_ctrl;
 	u16 acp63_sdw0_dma_intr_stat[ACP63_SDW0_DMA_MAX_STREAMS];
 	u16 acp63_sdw1_dma_intr_stat[ACP63_SDW1_DMA_MAX_STREAMS];
 	u16 acp70_sdw0_dma_intr_stat[ACP70_SDW0_DMA_MAX_STREAMS];
diff --git a/sound/soc/amd/ps/ps-common.c b/sound/soc/amd/ps/ps-common.c
index 1c89fb5fe1da5..7b4966b75dc67 100644
--- a/sound/soc/amd/ps/ps-common.c
+++ b/sound/soc/amd/ps/ps-common.c
@@ -160,6 +160,8 @@ static int __maybe_unused snd_acp63_suspend(struct device *dev)
 
 	adata = dev_get_drvdata(dev);
 	if (adata->is_sdw_dev) {
+		adata->acp_sw_pad_keeper_en = readl(adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+		adata->acp_pad_pulldown_ctrl = readl(adata->acp63_base + ACP_PAD_PULLDOWN_CTRL);
 		adata->sdw_en_stat = check_acp_sdw_enable_status(adata);
 		if (adata->sdw_en_stat) {
 			writel(1, adata->acp63_base + ACP_ZSC_DSP_CTRL);
@@ -197,6 +199,7 @@ static int __maybe_unused snd_acp63_runtime_resume(struct device *dev)
 static int __maybe_unused snd_acp63_resume(struct device *dev)
 {
 	struct acp63_dev_data *adata;
+	u32 acp_sw_pad_keeper_en;
 	int ret;
 
 	adata = dev_get_drvdata(dev);
@@ -209,6 +212,12 @@ static int __maybe_unused snd_acp63_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "ACP init failed\n");
 
+	acp_sw_pad_keeper_en = readl(adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+	dev_dbg(dev, "ACP_SW0_PAD_KEEPER_EN:0x%x\n", acp_sw_pad_keeper_en);
+	if (!acp_sw_pad_keeper_en) {
+		writel(adata->acp_sw_pad_keeper_en, adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+		writel(adata->acp_pad_pulldown_ctrl, adata->acp63_base + ACP_PAD_PULLDOWN_CTRL);
+	}
 	return ret;
 }
 
@@ -408,6 +417,8 @@ static int __maybe_unused snd_acp70_suspend(struct device *dev)
 
 	adata = dev_get_drvdata(dev);
 	if (adata->is_sdw_dev) {
+		adata->acp_sw_pad_keeper_en = readl(adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+		adata->acp_pad_pulldown_ctrl = readl(adata->acp63_base + ACP_PAD_PULLDOWN_CTRL);
 		adata->sdw_en_stat = check_acp_sdw_enable_status(adata);
 		if (adata->sdw_en_stat) {
 			writel(1, adata->acp63_base + ACP_ZSC_DSP_CTRL);
@@ -445,6 +456,7 @@ static int __maybe_unused snd_acp70_runtime_resume(struct device *dev)
 static int __maybe_unused snd_acp70_resume(struct device *dev)
 {
 	struct acp63_dev_data *adata;
+	u32 acp_sw_pad_keeper_en;
 	int ret;
 
 	adata = dev_get_drvdata(dev);
@@ -459,6 +471,12 @@ static int __maybe_unused snd_acp70_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "ACP init failed\n");
 
+	acp_sw_pad_keeper_en = readl(adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+	dev_dbg(dev, "ACP_SW0_PAD_KEEPER_EN:0x%x\n", acp_sw_pad_keeper_en);
+	if (!acp_sw_pad_keeper_en) {
+		writel(adata->acp_sw_pad_keeper_en, adata->acp63_base + ACP_SW0_PAD_KEEPER_EN);
+		writel(adata->acp_pad_pulldown_ctrl, adata->acp63_base + ACP_PAD_PULLDOWN_CTRL);
+	}
 	return ret;
 }
 
-- 
2.39.5



