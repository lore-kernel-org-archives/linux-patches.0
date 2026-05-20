Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C43D75C7;
	Wed, 20 May 2026 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298126; cv=none; b=Ilh2LUeC+vWKv14iKTlr2N5HqbVN8aCk0OYsqCFUhPeB8FFM++VZAAilKPb5/J8MNfQU7qxX41qOxVvIbLurmeERCZlSqAxT5Dbdq7jZpfe6dPo7iUSA9XIB1xdRv8TwRoq45VLhGfaeoWfCrPXatflIjdeMx/IDE4DsMaevthU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298126; c=relaxed/simple;
	bh=18Aly05Ar5HRrP6hRNrbNFf8tsWfm3NZ33nKA4mvYqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwtLcykvnRuC1ZLtQo3rP7TIYTESEZYRttJpXcaQexPm7ABwsV2CRmvOW/hJC5VcbWgpzkfL2i7KlgD08pA3VjRLovIC6j0LB1ihHHgYZfnK04BKaee5BTd/iP0fEA+niqy7ilPVSzgMUOmtqSxGR+x4YyGyx3VrUJ11SFLetpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GosX7l4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GosX7l4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF171F000E9;
	Wed, 20 May 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298125;
	bh=VPqZhgBWuMTcO/5VdeXk3977iNCRarEcaJgdUqbFotU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GosX7l4fWD4A4cW5zxPYv+tvMPRWYFCaGKPDBv7urEr4Y4zOjjiIE5ecXPRPtRPZq
	 TtCXfLhBohANG5VxJsp5mREuTld02+HFEYoFgXpkQlUX2JvIkkThjctOwJFXq7t9C8
	 3s88fkt0QJMz1NchDupDQdPRs6byhzgifn9jih+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/957] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Wed, 20 May 2026 18:12:54 +0200
Message-ID: <20260520162140.847491172@linuxfoundation.org>
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

[ Upstream commit 00541b86fb578d4949cfdd6aff1f82d43fcf07af ]

Add check of input value's range in fsl_easrc_iec958_put_bits(),
otherwise the wrong value may be written from user space.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-10-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 8e52e43a8ba85..8647df027c3fd 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -54,6 +54,9 @@ static int fsl_easrc_iec958_put_bits(struct snd_kcontrol *kcontrol,
 	unsigned int regval = ucontrol->value.integer.value[0];
 	int ret;
 
+	if (regval < EASRC_WIDTH_16_BIT || regval > EASRC_WIDTH_24_BIT)
+		return -EINVAL;
+
 	ret = (easrc_priv->bps_iec958[mc->regbase] != regval);
 
 	easrc_priv->bps_iec958[mc->regbase] = regval;
-- 
2.53.0



