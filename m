Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59893CAE61;
	Wed, 20 May 2026 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295318; cv=none; b=d+TUX+YYlbC/Tx7rc3tc+axoGMJb+MeKT+XiG1JXZrdsc3OyPiEBB0b7E/CyPuU7KYzdwGs0WJm7X1j1b20vy/6vx9m1MBxqgfXCVXg2DwoSfKRxLyuNY051BIGgRCQQT62dWwLRSyl10wHgPkD6hO5Z7QJRcIhCTAgrg8iK26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295318; c=relaxed/simple;
	bh=XngeS8LU5XJdwRUw1dfpugjd7yKHn2em2So7ZqjgcuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb2byTd/L7NwoV3QHN3/qRuGgqQ5w8Sfi3fotdrvEVvoOhnxNyHylNH9epiIq8P6D1dageB713mHXFneMjs5hf5PSZ1xTwHbXTLftu916Fs5KVxLkZWmxIAhGyZU6G/G6/4hqbfwGmQSZ9Tj851bv5gK2kziQp8v+YVvaBsPiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz3etlFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz3etlFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579A21F000E9;
	Wed, 20 May 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295316;
	bh=QfyX01X3yZyGjBBZPMduVSpyx462LCEB1pfs2bzjeas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz3etlFpwwcCvv8oThi4ZxNnGET34bY+ucH5yUC/WAbf2RvRvZc5zQKnduJmP0gKl
	 l3Wyceokz/momOsDxtvwV1EpEia7upHBl4BD9BLSVF1A0Hj8sTsGzitdgVr/pMkNmm
	 fqzSOADQvdf41SUIiptImhkn/6m8+tql2cj+wXLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0372/1146] ASoC: fsl_micfil: Fix event generation in micfil_range_set()
Date: Wed, 20 May 2026 18:10:22 +0200
Message-ID: <20260520162156.620807004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit fc4daaddb276d370b7da3819872044df446a1911 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation micfil_range_set() only returns 0 or a negative
error code, causing ALSA to not generate any change events.

Use snd_soc_component_update_bits() function to replace the
regmap_update_bits(), for snd_soc_component_update_bits() has the
capability of return check status.

Also enable pm runtime before calling the function
snd_soc_component_update_bits() to make the regmap cache data align with
the value in hardware.

Fixes: ef1a7e02fdb7 ("ASoC: fsl_micfil: Set channel range control")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-5-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 1c826e0cb1d5e..0cfdd6343291a 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -210,15 +210,23 @@ static int micfil_range_set(struct snd_kcontrol *kcontrol,
 		(struct soc_mixer_control *)kcontrol->private_value;
 	unsigned int shift = mc->shift;
 	int max_range, new_range;
+	int ret;
 
 	new_range = ucontrol->value.integer.value[0];
 	max_range = micfil_get_max_range(micfil);
 	if (new_range > max_range)
 		dev_warn(&micfil->pdev->dev, "range makes channel %d data unreliable\n", shift / 4);
 
-	regmap_update_bits(micfil->regmap, REG_MICFIL_OUT_CTRL, 0xF << shift, new_range << shift);
+	ret = pm_runtime_resume_and_get(cmpnt->dev);
+	if (ret)
+		return ret;
 
-	return 0;
+	ret = snd_soc_component_update_bits(cmpnt, REG_MICFIL_OUT_CTRL, 0xF << shift,
+					    new_range << shift);
+
+	pm_runtime_put_autosuspend(cmpnt->dev);
+
+	return ret;
 }
 
 static int micfil_set_quality(struct fsl_micfil *micfil)
-- 
2.53.0



