Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD0D225A38;
	Mon, 13 Apr 2026 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097878; cv=none; b=j/nNKI5nWpvlL//jdIvmWbOAwZr9QWTEL5hxXNpBMB0CASs/lTVPb5F9+WGbHFR8TQrGaQCh4LN5EtNPgDfmjYinuutNVJBLwrAKxiI+4gnklmQUXap043DtQK9gTKu7n2p4UOzhxakcsTlyDab/j4K1ePLSjaRhngJnHgho7Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097878; c=relaxed/simple;
	bh=pgaoGz+oLkgpGHl7ya+NfTHk2jG1LseIRSNcXfSCfek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujjsGfjn92t6UJAATO8Qpnmcqi7ER8vBwUSg3LPX2u36M9IYIJztTuqFDgye2mTe6X8lGH/F7gwTYK6j12h1QsgFv+dMSX1pDcSCAZSr9FF8stx21x5lF6HPuXidM02rooTWJgAuD8Oo1DQhTH9Sbia//9hfU0ik4HkUoV/QGic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Af+akH8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Af+akH8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EEEC2BCAF;
	Mon, 13 Apr 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097878;
	bh=pgaoGz+oLkgpGHl7ya+NfTHk2jG1LseIRSNcXfSCfek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Af+akH8mZ+gO0k+LyWjBQrA1/rgF3cJzc6yhcge3a80lODqpJX1uTjkL+WLiAXLN1
	 eG25YOp75tpBpv3DD6dNPyKqj0DSX39vgldrEdMh04sB+JPf76uS/aUQDEBgnZBvqh
	 pnMsXaXQ3Q4yRkkSnyiKZX2XrKRFKN9LmUJSzcfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/570] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()
Date: Mon, 13 Apr 2026 17:57:19 +0200
Message-ID: <20260413155842.036286889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 31ddc62c1cd92e51b9db61d7954b85ae2ec224da ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_easrc_set_reg() only returns 0 or a negative
error code, causing ALSA to not generate any change events. Add a suitable
check by using regmap_update_bits_check() with the underlying regmap, this
is more clearly and simply correct than trying to verify that one of the
generic ops is exactly equivalent to this one.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260205-asoc-fsl-easrc-fix-events-v1-2-39d4c766918b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index c7ff48208d005..95ad4eeec4863 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -93,14 +93,17 @@ static int fsl_easrc_set_reg(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
+	struct fsl_asrc *easrc = snd_soc_component_get_drvdata(component);
 	unsigned int regval = ucontrol->value.integer.value[0];
+	bool changed;
 	int ret;
 
-	ret = snd_soc_component_write(component, mc->regbase, regval);
-	if (ret < 0)
+	ret = regmap_update_bits_check(easrc->regmap, mc->regbase,
+				       GENMASK(31, 0), regval, &changed);
+	if (ret != 0)
 		return ret;
 
-	return 0;
+	return changed;
 }
 
 #define SOC_SINGLE_REG_RW(xname, xreg) \
-- 
2.51.0



