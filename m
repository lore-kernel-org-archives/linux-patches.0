Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68D369999;
	Wed, 20 May 2026 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298119; cv=none; b=nLFQPWKrWVHUVNbQwFf9WUEC5/ciso2x6+Klo7MdfFWCDX+JWwlntCtqHFudQkDslJydlCHj1dw69kGbyhRz3AOw++7tRhSQj1+Z3JwMFppqlcJuMTp+EtULuydVBwT0XjVlenHHPD8KUG/T1Nmq+9ELrcbWVnOabJZsbIo7YYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298119; c=relaxed/simple;
	bh=kphrayRDa5pagxXmdJo7bKiBwMkq5xK2MJVybDqVmZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXOambfu8Lcn9ZD1tj8OgPLFQr2Dwjh/JTJFC1ZE9as8T1CWTf3WJHFHGxzI8AasQhoagLpFgbt9WOIHlL6J9hnpqgNRFe0Cf8IvFbjqLj4Zs4Ovzzug+0raq1kSyY4kUfBAvoZema5TjA5eVqyXhrzYdWtBzB4McbKQ5AQyATM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y46j4PxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y46j4PxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BED1F000E9;
	Wed, 20 May 2026 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298117;
	bh=RlhonkQXC8MGtLPKG+FwiHud/NE/Pp0vAoZI3iW7F4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y46j4PxC0P3BMQTTAv9zlhAdlNqBx1uckbZbHh614fxAkZOJHacKZGVLWBLm+gh66
	 JqvVqJ2k1qhxjRSWacZPgFO4mkbcegji4uLv1WZdhfcWsfoTH/FqySUMEucwVrd+VD
	 HdP+thLkQeuYe+N5MmaGNRnYM5fe57DyB+aHe9h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/957] ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_arc_mode_put()
Date: Wed, 20 May 2026 18:12:52 +0200
Message-ID: <20260520162140.805297652@linuxfoundation.org>
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

[ Upstream commit 1b61c8103c9317a9c37fe544c2d83cee1c281149 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_xcvr_arc_mode_put() only returns 0 or a negative
error code, causing ALSA to not generate any change events.

Add a suitable check in the function before updating the arc_mode
variable.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-8-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index a268fb81a2f86..008e45009c83f 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -115,10 +115,17 @@ static int fsl_xcvr_arc_mode_put(struct snd_kcontrol *kcontrol,
 	struct fsl_xcvr *xcvr = snd_soc_dai_get_drvdata(dai);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int *item = ucontrol->value.enumerated.item;
+	int val = snd_soc_enum_item_to_val(e, item[0]);
+	int ret;
 
-	xcvr->arc_mode = snd_soc_enum_item_to_val(e, item[0]);
+	if (val < 0 || val > 1)
+		return -EINVAL;
 
-	return 0;
+	ret = (xcvr->arc_mode != val);
+
+	xcvr->arc_mode = val;
+
+	return ret;
 }
 
 static int fsl_xcvr_arc_mode_get(struct snd_kcontrol *kcontrol,
-- 
2.53.0



