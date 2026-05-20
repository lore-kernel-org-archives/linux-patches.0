Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0340A3FBEC5;
	Wed, 20 May 2026 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302113; cv=none; b=FEKbGNEHhwMl9e5WAaSvTfRfInJm3SgFeo+7Oytcfmjf6aqd4q8mqXOlZS1zaZyELf6mvXV1JJHJ34vxDMpSfksgROqdBHSx7i3cR9869YgaYbdw8ORYrKRUVQn5rFwFho8JBjNFyKBINRs0wbYkzvJfAEeY1vcvFcjQVzZPXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302113; c=relaxed/simple;
	bh=qiktoII08QXeTULmORFUpPEkzfn1LLkPzmoXx4Rx2kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqc69YUSrlgnuAtKU9pMb6eEqjk/jUXzlUqhZLpyr28bVAFyqGbJy56TrWQe8+kt7tsV/J9+/SQ/mFtrBbw639kTSAY0hQ3sXirrHHqxhTzH2qjJMufFhjln//FAveZyHPGFfZzgfd2tGyTWAyWHFU1BEejM2EV+IlXPVfH78dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqjGIdJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqjGIdJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688F91F000E9;
	Wed, 20 May 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302111;
	bh=Q8Y9XYa/xgTIszUxXVWBCUkSZXRlNmCCPy81eu103Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqjGIdJgVEnshko2P98ZeNOKjj6HcfWtxlzgP1T8ILwI+jWb3QJFlV4R1XSwf23dw
	 dcSIZJPAbFae9XIgjuqXHA00LvBCEpeLqpadIMMZ2nGYJ/mLSQAswaC7vj5Y4NuxXi
	 7yIz3ZFIMvAxTcoqPn35dYe40JCl7ez6XLx590Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/508] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Wed, 20 May 2026 18:19:26 +0200
Message-ID: <20260520162101.729581178@linuxfoundation.org>
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
index c78abf7698e0f..48d7a3e109129 100644
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



