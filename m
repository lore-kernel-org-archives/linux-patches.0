Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88C3BED1E;
	Wed, 20 May 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295315; cv=none; b=X6IfD95ONGVK1WDmCVVX28vsWFPMSXIxTZf5gFRMBmlqbrIqKWNmBa736tlkyeluNEEPoaBqz63LviNVaMXBK6rCqzowag9dSgioMuMi2cjKVG6YaEYvyfKQehj6rbOQkCyHLGauyOuVfr4ovpjKHEYXwBqpsXK1QzrUsroLklw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295315; c=relaxed/simple;
	bh=W7aJztK1u8J0QBe1yHr3V2nGPWIjMfsnCqMhQcP3xG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYm8ST+U+NbszMuUEVqLIVi0Tbw2mz5fQhkmRiNMBUc6ZFrgLSpJcI++bE9YmOzFf4OB5IUQ3B5aWc4Y6iWCJbRPK3mKxCblHhCxVfV80WmQSf1Bdec3KvWBFl6SVXlf5sE99+aPdCoCrYyz3pYRl6/16rAV2ofWlZ/c3QpWaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChNccDcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChNccDcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20481F000E9;
	Wed, 20 May 2026 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295314;
	bh=RTfoK/BgIq2vIdh7tSQbiQYJKCzp32cpce+pGfork9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChNccDcZtNDtjqLy4G53QGYs4S0bBjL0VIAyo6FdM1BpONbG1s9PREqdYxbLnnx0D
	 Or2TyBnfsiAsRs4+2A+tEv5DscxJzxfuC9a8szbiV0FJu8tQmpiH/dKo6ngePQ8uOT
	 HY5rzHJGDvDS5ZWqgL0eniSv4sEilit1ETb8DWK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0371/1146] ASoC: fsl_micfil: Fix event generation in hwvad_put_init_mode()
Date: Wed, 20 May 2026 18:10:21 +0200
Message-ID: <20260520162156.596924217@linuxfoundation.org>
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

[ Upstream commit 7e226209906906421f0d952d7304e48fdb0adabc ]

ALSA controls should return 1 if the value in the control changed but the
control put operation hwvad_put_init_mode() only returns 0 or a negative
error code, causing ALSA to not generate any change events.

Add a suitable check in the function before updating the vad_init_mode
variable.

Fixes: 29dbfeecab85 ("ASoC: fsl_micfil: Add Hardware Voice Activity Detector support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-4-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 97f24c9bdd68b..1c826e0cb1d5e 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -407,13 +407,18 @@ static int hwvad_put_init_mode(struct snd_kcontrol *kcontrol,
 	unsigned int *item = ucontrol->value.enumerated.item;
 	struct fsl_micfil *micfil = snd_soc_component_get_drvdata(comp);
 	int val = snd_soc_enum_item_to_val(e, item[0]);
+	bool change = false;
+
+	if (val < MICFIL_HWVAD_ENVELOPE_MODE || val > MICFIL_HWVAD_ENERGY_MODE)
+		return -EINVAL;
 
 	/* 0 - Envelope-based Mode
 	 * 1 - Energy-based Mode
 	 */
+	change = (micfil->vad_init_mode != val);
 	micfil->vad_init_mode = val;
 
-	return 0;
+	return change;
 }
 
 static int hwvad_get_init_mode(struct snd_kcontrol *kcontrol,
-- 
2.53.0



