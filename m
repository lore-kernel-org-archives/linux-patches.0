Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ED23AB26B;
	Sat, 30 May 2026 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164233; cv=none; b=kWyFHezmOzC21O3y9zmRAIwHs6v1e9oZqA4RQW8wY3M4YD/CdQTmudYv8aaBq9UhxvD50AusmVYLEIjoelWsjOUzUi1pG28ZaWiZKPDnWH4V6ymqXAoLVLcDJDEDM0meX8hyONqpXO7lKwo1ytvmZuzhVznT9jwUuvPCkonYygI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164233; c=relaxed/simple;
	bh=jsDbqPh+lKro2Wg7NRaa1/eVQIqSJ7q8lZ1QHSqynxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIpCRSnFqk/rYjl4EWzThYmhs6J96O7ZhMrrxYDbLeZgc0FSjkpTdzmUxLUBVrGnG09NOevm1uYKu/TQ3PGC/RVnF69gd2ZSOK4Vksne9dupuHK8AOYl5O8SvnGtqTKWLbe8bsUrNCrn/6D2JiKlnd+h5fy6PZ35wlPeGhefqmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLhq4NcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLhq4NcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73381F00893;
	Sat, 30 May 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164232;
	bh=yX82XhA6UbnjlNPjyd3wd6TAbjGnl8+9C/7fKP133xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLhq4NcCJQoo8yXuuxedaMRTBk5HEBWB67C66IR1C795YqdO4e/4FVAUnyFrQCmZ5
	 I7oZGChsp7VnS7RAl2vkx0RqNUjIlkR9mjDEyIA5iudX/kmxLBAmW+HfY8YobpfzxQ
	 a32/dUUX3qdsUFYTTISNovUTJ9XLdsTAAhZnEKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 464/776] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Sat, 30 May 2026 18:02:58 +0200
Message-ID: <20260530160252.349346072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 792884006f6bc..c144f99927705 100644
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



