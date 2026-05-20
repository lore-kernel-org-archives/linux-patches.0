Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA517A2FC;
	Wed, 20 May 2026 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302098; cv=none; b=HGARfODQvLbdS1AWagk6gfl760VePpU8cyOKmpkUOTSAqSLeqSsp+rfyu03et7l5jbrA0jX3X1sBf0oozeNEnG4WbQiDQrK1sgeP7HGN54F6D/ZrJYJwCtAsyblYlt1U8nneL678V6SUHnSDClVmXFICuqqtxb7BiblX4u46e6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302098; c=relaxed/simple;
	bh=/VlZ0fxCiGl6dY119kgSR0H4TC41p9F8IBGKsWMVOq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syB+zfmlPuX4dUHuQXaV4gSQ53yhQuRln85Kxmh8LaoEi51A6Tavu6tpZDRFVUBHiGbk15WXR8x+osVrDHX+vTfyVpbCq/5pc5CX+kJ2HTDEIv5Fltyaj6riDZnHrzTt67KOJt+m9+VUHMmJAI5eduzHVLgF1PyxwbXplelUcPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI0bvq/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI0bvq/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAE31F000E9;
	Wed, 20 May 2026 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302096;
	bh=koBaqgZQyJFwe1zpd40E9Ewu+Hsmn2ARz55+742USXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FI0bvq/fvLgCiBxw1CLqrE6bgge5bAFcnB+40/dZovIYxrB6wuGTlEq8YO2u0lZwB
	 Su8tEn0sy5u3fSyJhptRnDt2avViPToT/UHG+GuVURKdCjuRxlNCvTrXruxtAFSZy2
	 7+fPuD1W2h13hJWI3GHNmdKSeOJxSGZB4KD+j+WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/508] ASoC: fsl_micfil: Fix event generation in hwvad_put_init_mode()
Date: Wed, 20 May 2026 18:19:21 +0200
Message-ID: <20260520162101.619370968@linuxfoundation.org>
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
index 8eb5f553aa209..88553f0c0de86 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -307,13 +307,18 @@ static int hwvad_put_init_mode(struct snd_kcontrol *kcontrol,
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



