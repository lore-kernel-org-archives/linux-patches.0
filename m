Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803746AF14;
	Tue, 16 Jun 2026 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627397; cv=none; b=cx9Ava39iZ8Wk+4+MyJOC0MVinvYlXrloWT0+lkFbSTt3btV9kql2V3xq/LNLsOTI1OHXBTBqovjrPRWA5wVD4Pl2Q/+MBGcPb0UPrgl9g+KVyH8XdZcKB3V/k1OY5Gwd0AbSMPmRyYbvqEfoGJcTllsoRB8qXbnfd1HCXj7qSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627397; c=relaxed/simple;
	bh=jqMnilQnrrgt23P7RuZHjyTaVjy1wXa6BLwWXU99JTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpgU/XsKciKAQbLedwzssmR3ijBPtCdOTCi3jQ/+jJwosB4iLV363F5HMizpO1mSy8lRf+OxNv/WIrtS/g75e5BV8bZRJIJcDhBbRuc0NLpCL1KAjcBkiEZfvxJG/v9zqDVlxxCkkCMdc7qqRaGeTT535qTKjkpAG6Z2CaQAIvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itkNrGfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itkNrGfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA71F000E9;
	Tue, 16 Jun 2026 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627396;
	bh=KIj55wvz8XodC+A4ZyJAsnLO0nD685ALCdImWaAIfMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itkNrGfFOn3lgyI8MIBfPqL/N9IfCa32Gj6CNdc+2MRzi2vZGgigY87JQOPJyQ97f
	 EFuyMbQFCWPEC2OL3PrChopuie9g+jM2rgIJqnja54ge7E9VZ9XQD6ZCc8v9U+7DT+
	 1n8iRfW0cu14cd0GfUtrhqI3j4wK51aEL2Y67upQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 165/261] ASoC: fsl_sai: Fix 32 slots TDM broken by integer shift UB in xMR write
Date: Tue, 16 Jun 2026 20:30:03 +0530
Message-ID: <20260616145052.718085178@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

commit 4790af1cc2e8871fb31f28c66e42b9a949a23992 upstream.

When configuring 32 slots TDM (channels == slots == 32), the xMR
(Mask Register) write used:
~0UL - ((1 << min(channels, slots)) - 1)

The literal "1" is a signed 32-bit int. Shifting it by 32 positions is
undefined behaviour which may set this register to 0xFFFFFFFF, masking
all 32 slots.

Use GENMASK_U32() macro instead. For 32 slots this produces a zero mask:
~GENMASK_U32(31, 0) = ~0xFFFFFFFF = 0x00000000
Behaviour for fewer than 32 slots is unchanged.

Fixes: 770f58d7d2c5 ("ASoC: fsl_sai: Support multiple data channel enable bits")
Cc: stable@vger.kernel.org
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Reviewed-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20260601083327.1535185-1-chancel.liu@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -714,7 +714,7 @@ static int fsl_sai_hw_params(struct snd_
 				   FSL_SAI_CR4_FSD_MSTR, FSL_SAI_CR4_FSD_MSTR);
 
 	regmap_write(sai->regmap, FSL_SAI_xMR(tx),
-		     ~0UL - ((1 << min(channels, slots)) - 1));
+		     ~GENMASK_U32(min(channels, slots) - 1, 0));
 
 	return 0;
 }


