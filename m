Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7687836F421;
	Wed, 20 May 2026 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298108; cv=none; b=i6rmDhFaweRqfZsKOQ4k1xrN2HerqaUG2PLI7Kxe/Be++XIeFAay/6g+CtPBOR8bmCUa54b2iffbkhh91Rb3GkaIimRfSCD2SIu0yTmv/4GzipkrCdxjoMpHDoQtG7a46TgezEWbtFJfI+e5pStGzny3et1TyeXMGhl9JZr7bSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298108; c=relaxed/simple;
	bh=tU7gISz+eVmHiUPdpnCvXt7Bw87Sfc/HFoG1suY7fCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSyEXz5QK8anfg8asI4zxsejpfTIreE4kEYyUCDq1Jm4JTfYjMBkKZXT0kCZtlWdcZjOoa4oJguQKQl4xXi7EHjrHuVDw7qvuYCMLjcGMC7JNl63bi0lbMNeChx+Ill+nBxE7xzY3Z+sfN0eaERX78mdLnJ5DPlXEnqdGyMDGL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uglqugex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uglqugex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0361F000E9;
	Wed, 20 May 2026 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298107;
	bh=ei3Y38nxs9zKrDSypepJCphLQf6p9nIA34MMUCX3v6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UglqugexdWFnEUX+6/JbfnXdASjYPk6uxwxprDEC66mruUpZ5wjwefO+UniCI5wU9
	 gfx+9urAf1kfQBnDZpTEsvbVix0NSToYMDLwhd7hCEDpFKqrLHxma6hQkCuMezZiY/
	 Li91i3/cNsE+AvbmnebDKAx/7LKu2UBAHBHQc1z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/957] ASoC: fsl_micfil: Fix event generation in hwvad_put_enable()
Date: Wed, 20 May 2026 18:12:48 +0200
Message-ID: <20260520162140.720088409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ddc56f77f1455..668e6dbe5a712 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -306,10 +306,15 @@ static int hwvad_put_enable(struct snd_kcontrol *kcontrol,
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



