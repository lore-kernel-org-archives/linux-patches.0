Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507233148DA;
	Sat, 30 May 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161242; cv=none; b=HIw9gvf4zU3yg73/YajQaCMg8Z+RkUbmLD6fr9/QPO3+u/JLWzHh2NRXkumXx+dTO+7gUfhJZqSwVWBGQVnFcfXCXfgPsSDGLDu8dtAdst7E5DlD8ooVmVcrN+fF7U0tMNSeuQXs0HDzax6iS8gAvTzl+5DCjHTEab7UvTCS9IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161242; c=relaxed/simple;
	bh=C6857qMhoiJA2hHIUcWZ+AgLTaHd7wuYevmRIu3UfUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+M6YBsPswu0R5EE11TLK5cIswir5n1CCCFthxWzBKLbBO4HdQxkRDOACDbszF4RPk4ulHM7aZOVGB6xyUce+sDFIz19As8zSCy2Cq0VL+SkWr2gnOKyAHREdny+Sp5Ba+ayhN3bkIyULOKYX/BtWJEVd4914W5fAsulIF6ywZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUEgfiu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUEgfiu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A491F00893;
	Sat, 30 May 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161241;
	bh=Od+Mq/W7cd/RBi18LtoIuOhsLfZzmrvoKIhHLO6SU8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUEgfiu4t/Fn1ns9aD6460HCmb5I8bQIZAOzBwEFFH6AF5w+BcQMviQGb2wPEieQF
	 l+C3kQk9+phNzVIlxTT7EHNR6Ghos4MkdsDVGyWrfS179lllE0jiJZvnE7byW1RnbN
	 jk69EZT4iJx1GdxQrAqL+/8cIql4Ams69Dc1P4Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 536/969] ASoC: fsl_easrc: Change the type for iec958 channel status controls
Date: Sat, 30 May 2026 18:01:00 +0200
Message-ID: <20260530160315.168669172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 47f28a5bd154a95d5aa563dde02a801bd32ddb81 ]

Use the type SNDRV_CTL_ELEM_TYPE_IEC958 for iec958 channel status
controls, the original type will cause mixer-test to iterate all 32bit
values, which costs a lot of time. And using IEC958 type can reduce the
control numbers.

Also enable pm runtime before updating registers to make the regmap cache
data align with the value in hardware.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-12-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 118 +++++++++++++++++++++++++++-----------
 1 file changed, 84 insertions(+), 34 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 05aacebee884f..4c3b462512461 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -78,17 +78,47 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static int fsl_easrc_iec958_info(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_IEC958;
+	uinfo->count = 1;
+	return 0;
+}
+
 static int fsl_easrc_get_reg(struct snd_kcontrol *kcontrol,
 			     struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
-	unsigned int regval;
+	struct fsl_asrc *easrc = snd_soc_component_get_drvdata(component);
+	unsigned int *regval = (unsigned int *)ucontrol->value.iec958.status;
+	int ret;
+
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS0(mc->regbase), &regval[0]);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS1(mc->regbase), &regval[1]);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS2(mc->regbase), &regval[2]);
+	if (ret)
+		return ret;
 
-	regval = snd_soc_component_read(component, mc->regbase);
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS3(mc->regbase), &regval[3]);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS4(mc->regbase), &regval[4]);
+	if (ret)
+		return ret;
 
-	ucontrol->value.integer.value[0] = regval;
+	ret = regmap_read(easrc->regmap, REG_EASRC_CS5(mc->regbase), &regval[5]);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -100,22 +130,62 @@ static int fsl_easrc_set_reg(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 	struct fsl_asrc *easrc = snd_soc_component_get_drvdata(component);
-	unsigned int regval = ucontrol->value.integer.value[0];
-	bool changed;
+	unsigned int *regval = (unsigned int *)ucontrol->value.iec958.status;
+	bool changed, changed_all = false;
 	int ret;
 
-	ret = regmap_update_bits_check(easrc->regmap, mc->regbase,
-				       GENMASK(31, 0), regval, &changed);
-	if (ret != 0)
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret)
 		return ret;
 
-	return changed;
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS0(mc->regbase),
+				       GENMASK(31, 0), regval[0], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS1(mc->regbase),
+				       GENMASK(31, 0), regval[1], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS2(mc->regbase),
+				       GENMASK(31, 0), regval[2], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS3(mc->regbase),
+				       GENMASK(31, 0), regval[3], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS4(mc->regbase),
+				       GENMASK(31, 0), regval[4], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+
+	ret = regmap_update_bits_check(easrc->regmap, REG_EASRC_CS5(mc->regbase),
+				       GENMASK(31, 0), regval[5], &changed);
+	if (ret != 0)
+		goto err;
+	changed_all |= changed;
+err:
+	pm_runtime_put_autosuspend(component->dev);
+
+	if (ret != 0)
+		return ret;
+	else
+		return changed_all;
 }
 
 #define SOC_SINGLE_REG_RW(xname, xreg) \
 {	.iface = SNDRV_CTL_ELEM_IFACE_PCM, .name = (xname), \
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE, \
-	.info = snd_soc_info_xr_sx, .get = fsl_easrc_get_reg, \
+	.info = fsl_easrc_iec958_info, .get = fsl_easrc_get_reg, \
 	.put = fsl_easrc_set_reg, \
 	.private_value = (unsigned long)&(struct soc_mreg_control) \
 		{ .regbase = xreg, .regcount = 1, .nbits = 32, \
@@ -146,30 +216,10 @@ static const struct snd_kcontrol_new fsl_easrc_snd_controls[] = {
 	SOC_SINGLE_VAL_RW("Context 2 IEC958 Bits Per Sample", 2),
 	SOC_SINGLE_VAL_RW("Context 3 IEC958 Bits Per Sample", 3),
 
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS0", REG_EASRC_CS0(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS0", REG_EASRC_CS0(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS0", REG_EASRC_CS0(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS0", REG_EASRC_CS0(3)),
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS1", REG_EASRC_CS1(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS1", REG_EASRC_CS1(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS1", REG_EASRC_CS1(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS1", REG_EASRC_CS1(3)),
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS2", REG_EASRC_CS2(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS2", REG_EASRC_CS2(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS2", REG_EASRC_CS2(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS2", REG_EASRC_CS2(3)),
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS3", REG_EASRC_CS3(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS3", REG_EASRC_CS3(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS3", REG_EASRC_CS3(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS3", REG_EASRC_CS3(3)),
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS4", REG_EASRC_CS4(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS4", REG_EASRC_CS4(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS4", REG_EASRC_CS4(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS4", REG_EASRC_CS4(3)),
-	SOC_SINGLE_REG_RW("Context 0 IEC958 CS5", REG_EASRC_CS5(0)),
-	SOC_SINGLE_REG_RW("Context 1 IEC958 CS5", REG_EASRC_CS5(1)),
-	SOC_SINGLE_REG_RW("Context 2 IEC958 CS5", REG_EASRC_CS5(2)),
-	SOC_SINGLE_REG_RW("Context 3 IEC958 CS5", REG_EASRC_CS5(3)),
+	SOC_SINGLE_REG_RW("Context 0 IEC958 CS", 0),
+	SOC_SINGLE_REG_RW("Context 1 IEC958 CS", 1),
+	SOC_SINGLE_REG_RW("Context 2 IEC958 CS", 2),
+	SOC_SINGLE_REG_RW("Context 3 IEC958 CS", 3),
 };
 
 /*
-- 
2.53.0



