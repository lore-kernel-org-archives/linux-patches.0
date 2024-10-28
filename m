Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558648837;
	Mon, 28 Oct 2024 06:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098352; cv=none; b=mIuuLHlldnU2Y9sdTj+ySYfSjyzy4MjyqyMEQGjb0Uy6jyrC5c2Zxi52tcXoz3kYwnFsUvKy4kH2hp3qGqMonHtDKPVJvP19SSyJe8MMk4ltGAnv8DtP7jiL/UgRCWCo04Z9YFde5a6NIS2lRen8AYlOqBHOci9oLpz4El4nYN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098352; c=relaxed/simple;
	bh=7Kq1bEoFQavkTdedDI92hWKTwlnqWgpza4sMCByyBpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxgG14l10YwE/Y6wW9mXiEKhFLKCnscMrSbEsIxLOMldvFBzdrh4wnOOWySMnxaDpxguOCBux5qd4VDV1e09OX8vAC0AdhW9b8G7gAE0z126LKeXJEk3Q+D3McW3C9VbXMz5+ggDoU44twccr0M6y6oHSY3BPdlIXaQR/yHxy/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khT95DXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khT95DXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F9EC4CEC3;
	Mon, 28 Oct 2024 06:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098352;
	bh=7Kq1bEoFQavkTdedDI92hWKTwlnqWgpza4sMCByyBpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khT95DXws1fm3DiayBtoxzqIGQK23yi5EKimt0+kSFKFLx8qVtP26zbhcHNLVdBdJ
	 2iSSa0Tt3UUyUYULFlRuccS/FRfAZxC/uIkqV1hmXtla7WpCneMqaE206fUvaF9UmM
	 1mN11Y9Uh2HLY2E5gckxmhyQjwjblevvzrdS7v+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 190/261] ASoC: fsl_micfil: Add a flag to distinguish with different volume control types
Date: Mon, 28 Oct 2024 07:25:32 +0100
Message-ID: <20241028062316.784789161@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 22b240a70ad48..a3d580b2bbf46 100644
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



