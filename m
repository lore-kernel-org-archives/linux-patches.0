Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FED45BD71;
	Tue, 16 Jun 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625841; cv=none; b=i4bhtQFcg5UcdBv40xvQOgI5Hf5s8sjuJytHi2Yh41CLw9y9FqvfbIq20D+Q2Eiowx9XsDppuQkqEh8ik6aDQzVXVb1QDWZ31fD7sumaNH+rqDpPR1AyBIVL6V4UtNF1WGFWBrdKIaClWIcJx/4BNRMTyYseyM1beEXEA6KE5mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625841; c=relaxed/simple;
	bh=0n7BzpH2U3zjMGc3Ruetazw0sE9PUCOy/IeufXOs5+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/UsFpq13TPYveR5XuaJObMYRywmPKmMk9ZDDIimHaAVcJY1YuZHVmSXenpt0MG18UG8sd6/MnYDpEyvAdVGZQui+c165xS3sov9BceAiIviyPIHwiyKHLAWUTrMF4qyl2fk2BiutD5Gdsa9jJEuSnYUDjETDmyvJ6u8GwAmsrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgXXfG+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgXXfG+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BDB1F000E9;
	Tue, 16 Jun 2026 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625840;
	bh=BTACcK7XQ5qkBMUnLxO7BuuJ31mnxZNxb6BLe872518=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgXXfG+Ar+BQB0bxJKVxDMD3dnEDIXVkCfKrTaG+Nmlcy7VsWMQ+aMeBoShpoJmxw
	 EHc3fLM6lFDQ6a4o3RjHja5/lA0Kx1/aRFi9AqTZG9F/F6HaPUhaKhOvqKw+wfkyi7
	 9HmhXdOcdlqtCjQp4VDwHrcKuBSQ/naBuTLRG4wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 210/325] ASoC: fsl_sai: Fix 32 slots TDM broken by integer shift UB in xMR write
Date: Tue, 16 Jun 2026 20:30:06 +0530
Message-ID: <20260616145108.545085674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -746,7 +746,7 @@ static int fsl_sai_hw_params(struct snd_
 				   FSL_SAI_CR4_FSD_MSTR, FSL_SAI_CR4_FSD_MSTR);
 
 	regmap_write(sai->regmap, FSL_SAI_xMR(tx),
-		     ~0UL - ((1 << min(channels, slots)) - 1));
+		     ~GENMASK_U32(min(channels, slots) - 1, 0));
 
 	return 0;
 }


