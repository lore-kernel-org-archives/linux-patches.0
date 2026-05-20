Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8CC2F363F;
	Wed, 20 May 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300511; cv=none; b=nsytA7o5LicAIQm4EfbeVISOqfbKjFCGkC/F0fj0ivI7rUwg4f68ePAmVgy9man3JcFqIjmRSBByOeN4k1TOzId5ebJAcB+W1gz8G1vEfiSgTCfYDvQ8sMAzVDE+Uf9zikqS1s/p1nZJ3pEo3dFNGGMKPbysMdPgtWcjJltD+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300511; c=relaxed/simple;
	bh=McXAcvaK4F9ODaD3eg4ES6N8OAehI7JVUExxyLi5QkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQN3Cjp8rzRHdXf6N9r9t95UENAGCRBIMxUfwfJxPeABbukHh1WCUYem920xbEyZeayNo/6ZeWAqisM24H4VAzqnLo8ZLX5s4h/+7RMHg4mvjqwgt8NkBgvLDHNWVhXukgONO2r//T0vfPlCZGK7DLJo81hRSXAYA+foCa8UQyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPv1phh1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPv1phh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D7E1F000E9;
	Wed, 20 May 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300509;
	bh=IXAhhPCuMp/qHo5OxDjdtVC693Zj1gGEQ4fRMp5viNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPv1phh1P2/ap+zmt4id/Yrkt4yZjZfTDHSKnC4mL5zE8FOs3Cq3+LxTFJkrTfRYg
	 ovfh0unVBbwt0ciFrd4jU0RuRmUv3/f9AFSt/ozlcCXDUn8gZNTfPW6icNc1ARk60I
	 sRywvu6W2xZLYLtnYLNLJ6nB1enDrK+Iadon2aco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/666] ASoC: fsl_micfil: Fix event generation in micfil_put_dc_remover_state()
Date: Wed, 20 May 2026 18:16:52 +0200
Message-ID: <20260520162115.560405734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47b8688605fa6..a04a17db80e43 100644
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



