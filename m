Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB3218EFD2;
	Mon, 28 Oct 2024 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097840; cv=none; b=ee0RFKLl5QVALlRzf0t2i1ktqLzahOrPaE2nGE6Se2eAiYCW4eh+cyBUokIwMSAPnN7qWkrS33ClcCdwJUwxTY2H06yEE8OneqRnj9VpJzOgBmw/zk7MH14Eq+kw6zpJnbOa2Fu+fHgO26mlPv57Llg4w0RiOpfCJrdT6rwIhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097840; c=relaxed/simple;
	bh=SdYHPNP6hJEwuoCZ1yQxxaEH9ReiZ9s+JWYYFN0M0+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1L2WPXPyUmS0ifbMw+hcB7BuR+hPmQ0TmZXaX4hkL99Mqy5N7cW2+cdrl2j4ROHY4e+KH4SZ4kUFkthmXm6dE/aZ+IU8p0r0n2oOiMKdmOKYX+vx5ismH7qfsl9np/KLhdf5Zg7t1ZUgSOKSEyVKKjS1kDiRYz1pGw8vmcBJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FK+ZFyyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FK+ZFyyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89062C4CEC3;
	Mon, 28 Oct 2024 06:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097839;
	bh=SdYHPNP6hJEwuoCZ1yQxxaEH9ReiZ9s+JWYYFN0M0+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FK+ZFyyG8ulD8WiCZEozRWBjE7oepjb1H7i08CunuDkQYbB/qouvSCXsFkXdNBKlN
	 dIcsNBjzZ61z60OHNfSB4i7Dkga3hbVdlGrUtEESrA6n43ELdLL31pIC4LBUzKIVBV
	 EI1Oz3ShN7BYNrDz+Q1+wZzeHF78318HR/cfqDVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/208] ASoC: fsl_micfil: Add a flag to distinguish with different volume control types
Date: Mon, 28 Oct 2024 07:25:49 +0100
Message-ID: <20241028062310.792741459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit da95e891dd5d5de6c5ebc010bd028a2e028de093 ]

On i.MX8MM the register of volume control has positive and negative
values. It is different from other platforms like i.MX8MP and i.MX93
which only have positive values. Add a volume_sx flag to use SX_TLV
volume control for this kind of platform. Use common TLV volume control
for other platforms.

Fixes: cdfa92eb90f5 ("ASoC: fsl_micfil: Correct the number of steps on SX controls")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20241017071507.2577786-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 43 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 0d37edb70261c..9407179af5d57 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -67,6 +67,7 @@ struct fsl_micfil_soc_data {
 	bool imx;
 	bool use_edma;
 	bool use_verid;
+	bool volume_sx;
 	u64  formats;
 };
 
@@ -76,6 +77,7 @@ static struct fsl_micfil_soc_data fsl_micfil_imx8mm = {
 	.fifo_depth = 8,
 	.dataline =  0xf,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	.volume_sx = true,
 };
 
 static struct fsl_micfil_soc_data fsl_micfil_imx8mp = {
@@ -84,6 +86,7 @@ static struct fsl_micfil_soc_data fsl_micfil_imx8mp = {
 	.fifo_depth = 32,
 	.dataline =  0xf,
 	.formats = SNDRV_PCM_FMTBIT_S32_LE,
+	.volume_sx = false,
 };
 
 static struct fsl_micfil_soc_data fsl_micfil_imx93 = {
@@ -94,6 +97,7 @@ static struct fsl_micfil_soc_data fsl_micfil_imx93 = {
 	.formats = SNDRV_PCM_FMTBIT_S32_LE,
 	.use_edma = true,
 	.use_verid = true,
+	.volume_sx = false,
 };
 
 static const struct of_device_id fsl_micfil_dt_ids[] = {
@@ -317,7 +321,26 @@ static int hwvad_detected(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
+static const struct snd_kcontrol_new fsl_micfil_volume_controls[] = {
+	SOC_SINGLE_TLV("CH0 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(0), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH1 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(1), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH2 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(2), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH3 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(3), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH4 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(4), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH5 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(5), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH6 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(6), 0xF, 0, gain_tlv),
+	SOC_SINGLE_TLV("CH7 Volume", REG_MICFIL_OUT_CTRL,
+		       MICFIL_OUTGAIN_CHX_SHIFT(7), 0xF, 0, gain_tlv),
+};
+
+static const struct snd_kcontrol_new fsl_micfil_volume_sx_controls[] = {
 	SOC_SINGLE_SX_TLV("CH0 Volume", REG_MICFIL_OUT_CTRL,
 			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH1 Volume", REG_MICFIL_OUT_CTRL,
@@ -334,6 +357,9 @@ static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH7 Volume", REG_MICFIL_OUT_CTRL,
 			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0x8, 0xF, gain_tlv),
+};
+
+static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 	SOC_ENUM_EXT("MICFIL Quality Select",
 		     fsl_micfil_quality_enum,
 		     micfil_quality_get, micfil_quality_set),
@@ -801,6 +827,20 @@ static int fsl_micfil_dai_probe(struct snd_soc_dai *cpu_dai)
 	return 0;
 }
 
+static int fsl_micfil_component_probe(struct snd_soc_component *component)
+{
+	struct fsl_micfil *micfil = snd_soc_component_get_drvdata(component);
+
+	if (micfil->soc->volume_sx)
+		snd_soc_add_component_controls(component, fsl_micfil_volume_sx_controls,
+					       ARRAY_SIZE(fsl_micfil_volume_sx_controls));
+	else
+		snd_soc_add_component_controls(component, fsl_micfil_volume_controls,
+					       ARRAY_SIZE(fsl_micfil_volume_controls));
+
+	return 0;
+}
+
 static const struct snd_soc_dai_ops fsl_micfil_dai_ops = {
 	.probe		= fsl_micfil_dai_probe,
 	.startup	= fsl_micfil_startup,
@@ -821,6 +861,7 @@ static struct snd_soc_dai_driver fsl_micfil_dai = {
 
 static const struct snd_soc_component_driver fsl_micfil_component = {
 	.name		= "fsl-micfil-dai",
+	.probe		= fsl_micfil_component_probe,
 	.controls       = fsl_micfil_snd_controls,
 	.num_controls   = ARRAY_SIZE(fsl_micfil_snd_controls),
 	.legacy_dai_naming      = 1,
-- 
2.43.0



