Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEE7373BEE;
	Wed, 20 May 2026 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302100; cv=none; b=WIpR94kijCgFxh8RI6L/ygeQFN1X3IT8JdBFrmcnY6T6qu/N1lsYvgJDkkgXe6+3wjFKUbF7RdRVQmpId1dK23/pcReUf28aHRuBO6AYWJZoA3RdrCfXk0GR6JedhazQO+AJO8psDLoxhV/fDJNHp+Z2BSjr3ef+XGd+wXujiow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302100; c=relaxed/simple;
	bh=iw2Pnb74kERRbmVUCtDuIgVfFjUXQr16kyZQPQKeuzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqT+yNYCtEwOURr66kazttuTGQFW7dBjp2ep4yzxUZ7gpLiO7NgPzQrt4rh3hf+NZ3IqmylYg87UsMn3gU8B6G4Qh504Evz3EUzfwZDwsmkwez2w3c01OTc3XK4qIHcK8JYtj3V+TSVXzWsqwBvgXAsEF/70eSrnbhjWvyjZzDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCf5zfDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCf5zfDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354F61F00894;
	Wed, 20 May 2026 18:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302098;
	bh=WoMLj2ASPD514E3Oar4vsJHb3PDBg1NjxfLWjd8oSoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCf5zfDN1zgjWMCFFAtI+uxAES7q1i1PVtwiaDI027YqcPg3aMtZABdmVMygX9Pts
	 bXAstWIzM/NKt/MEhwcWvUJJdaGBADoVWXPIzqjE68RZIuSsOK9tj0fdaEV6SM5ex3
	 +5rgNlBiSGmAczL3pwr4pqS7a6HEvzju3wVoC9Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/508] ASoC: fsl_micfil: Fix event generation in micfil_put_dc_remover_state()
Date: Wed, 20 May 2026 18:19:22 +0200
Message-ID: <20260520162101.641598170@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 7d2bd35100de370dc326b250e8f6b66bee06a2f3 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation micfil_put_dc_remover_state() only returns 0 or a
negative error code, causing ALSA to not generate any change events.

return the value of snd_soc_component_update_bits() directly, as it has
the capability of return check status of changed or not.

Also enable pm runtime before calling the function
snd_soc_component_update_bits() to make the regmap cache data align with
the value in hardware.

Fixes: 29dbfeecab85 ("ASoC: fsl_micfil: Add Hardware Voice Activity Detector support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-6-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 88553f0c0de86..32ee7093c8110 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -243,6 +243,10 @@ static int micfil_put_dc_remover_state(struct snd_kcontrol *kcontrol,
 	if (val < 0 || val > 3)
 		return -EINVAL;
 
+	ret = pm_runtime_resume_and_get(comp->dev);
+	if (ret)
+		return ret;
+
 	micfil->dc_remover = val;
 
 	/* Calculate total value for all channels */
@@ -252,10 +256,10 @@ static int micfil_put_dc_remover_state(struct snd_kcontrol *kcontrol,
 	/* Update DC Remover mode for all channels */
 	ret = snd_soc_component_update_bits(comp, REG_MICFIL_DC_CTRL,
 					    MICFIL_DC_CTRL_CONFIG, reg_val);
-	if (ret < 0)
-		return ret;
 
-	return 0;
+	pm_runtime_put_autosuspend(comp->dev);
+
+	return ret;
 }
 
 static int micfil_get_dc_remover_state(struct snd_kcontrol *kcontrol,
-- 
2.53.0



