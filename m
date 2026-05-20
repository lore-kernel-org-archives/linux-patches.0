Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83194369D7A;
	Wed, 20 May 2026 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302094; cv=none; b=PcUW19nNxYtVGZVQ54Fd17tkKmc7raOR9lQdokTW7LK6gP+f4Ebx7Fj46KeLBVpDA+OVMeh07GrL/tb2v3Ac5ZhyEPcrr+IdRqc1wcLZoXknbCsf2tz/KzrlBYsl23qumCcu/mPJuNgQ3OPDUAdjBuy1rgx+5F1ejQy/lTbfkoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302094; c=relaxed/simple;
	bh=qSRtr4xTP9DXjP6Gak1c+72GUEkeeQT9GTCF747dTGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK7rI6hgeI+0c1KkQ5jOI1/ifF4Jc/873BnOkSyhH0X5q3fpVqQrrPvtmchjJGnJU0xKJSPvmMDcyH1XQHRpSk6aUVJF078aQC61cIHrMsMY0rjbnAobB9RKSeuJukKdAC65Ry/XVRfXYar/b06+BO8YRwIoMie2e9G65ewOkxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQorUGY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQorUGY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7981F000E9;
	Wed, 20 May 2026 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302093;
	bh=5WfzaxEWQcTCPhPP6J/mGkOz9GdiFBLfETTb/jTfmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQorUGY2Q1MUgk4F3zkFN3ho2WRHfgh2946x06OI2DfinRo1sQwj94x3+mlvGIVPA
	 VUP9ldFjHVlsG5JG8YcH5TKBNOSApZuvl2iqcNZBZoA0XB6hgBIBa74weIn4+poNxj
	 KXOQXYBD9lfgh/o/cheqdg+dOjmLv+pwFsbIUBYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/508] ASoC: fsl_micfil: Fix event generation in hwvad_put_enable()
Date: Wed, 20 May 2026 18:19:20 +0200
Message-ID: <20260520162101.598054934@linuxfoundation.org>
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

[ Upstream commit 59b9061824f2179fe133e2636203548eaba3e528 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation hwvad_put_enable() only returns 0 or a negative
error code, causing ALSA to not generate any change events.

Add a suitable check in the function before updating the vad_enabled
variable.

Fixes: 29dbfeecab85 ("ASoC: fsl_micfil: Add Hardware Voice Activity Detector support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 56ee7cbf371c1..8eb5f553aa209 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -277,10 +277,15 @@ static int hwvad_put_enable(struct snd_kcontrol *kcontrol,
 	unsigned int *item = ucontrol->value.enumerated.item;
 	struct fsl_micfil *micfil = snd_soc_component_get_drvdata(comp);
 	int val = snd_soc_enum_item_to_val(e, item[0]);
+	bool change = false;
 
+	if (val < 0 || val > 1)
+		return -EINVAL;
+
+	change = (micfil->vad_enabled != val);
 	micfil->vad_enabled = val;
 
-	return 0;
+	return change;
 }
 
 static int hwvad_get_enable(struct snd_kcontrol *kcontrol,
-- 
2.53.0



