Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9D34041C;
	Wed, 20 May 2026 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295312; cv=none; b=nig8ltdgyusuPeIqLxy5sVZkoltA2Oo8E3ZTrCMJC82Ic8HOWrzU7PWHZDLokZ32oJD4q+pJuLPWp/w11VggrPtV99GzKEp0hUqXgsX/FOwe0XznmuNLsB4wNPmtJH8fQafYb4+BhGWxoiIMj+ak2WT5r7pEqJwjl484EGgl50s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295312; c=relaxed/simple;
	bh=rsalLay2jJBe4W/cYrdvRcg9zoNgEWNiliVHOxjmf8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+e1M8z462EOjoeJ66U1h8jVCsGb35V7itYZa4A89nS+lxFMkUowjqdb1k2t2evaGw5xoIDgFDDvHKeJEqWPcLqbt7djn9cHeeR/ss1PkAYNjbFOe6dx1YUpRgG/Fnv+FGQ3GfrsnJUSIEnubOaQcBYl+yTF10NHqMEgJfJYHng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftFfNKul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftFfNKul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107F31F000E9;
	Wed, 20 May 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295311;
	bh=gP0ABFGO1fq6yHIb+oQczJ5TWGXecmnI5FszyLjULYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftFfNKul1f8VMSGbgszfErxK/CrY6a/XKwUNe8SUQfmMnTDJ1HyoKWdEc2AkQLolJ
	 TxitOiR+NUYNw/4m8u7Z/RkcBCmLVuIHpbHa4KO711FIy36eagrdiKjN7RD95DI9Wu
	 11kGSvPZ1VuOsh9q5huBImBjBkfSUdss4S2+EFTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0370/1146] ASoC: fsl_micfil: Fix event generation in hwvad_put_enable()
Date: Wed, 20 May 2026 18:10:20 +0200
Message-ID: <20260520162156.574529162@linuxfoundation.org>
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
index 79850211742cb..97f24c9bdd68b 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -377,10 +377,15 @@ static int hwvad_put_enable(struct snd_kcontrol *kcontrol,
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



