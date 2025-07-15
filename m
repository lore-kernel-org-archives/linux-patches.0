Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB9227470;
	Tue, 15 Jul 2025 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587846; cv=none; b=KUd8l08pBulC3DK9wYX2jQwa18wwAkV1xbXTqTf81l++cxipo26Y9O2OMrEhOItOy3l+Xt8xvXQ5nX3BCIRgbEfnag95lo29IMzql9coMDxD31szZCQBlfhAmwwG8xVgBYkmGPT8jZ/iXcQx5hr1LLx9f/39ZXbud9tRC9XY3Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587846; c=relaxed/simple;
	bh=X9BdYY8Ga+7gA19B6wDj6Z4nIvT8QxXXIiZMHulwTY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvyP2tAa/p1ypqkMZAAKpyKKGywyI2HBRsme3zekSwSb2s9jaCdfKI/+ZjwnBolQ2zLVfAoa/S6QnBvMS0XsYpY8HgEpdmU4yojILSpPmwfOQqwo4mWLq7ICsaV4BusqzpoflZU9KulbHBbXCCOwK1polk4+tTzZWJ/p5sOpm0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQ9V5t5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQ9V5t5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5D6C4CEE3;
	Tue, 15 Jul 2025 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587846;
	bh=X9BdYY8Ga+7gA19B6wDj6Z4nIvT8QxXXIiZMHulwTY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQ9V5t5kyxUkleadnD4rvJytEF/P8uWvaKR9bDTRjhMX5ZexkAKHRPSX9jqnTG/uc
	 wH3gIsDRo0Y76EnTQ2rH1Gg0Essc5z/J3zrP4tvPI7cQLyhwtPlJ7BqH+jKcRIoBAU
	 m6No+YbMxMt4KUfmw4xHn9MXxNlft4uw/gTJNBpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/208] ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode
Date: Tue, 15 Jul 2025 15:14:03 +0200
Message-ID: <20250715130816.302240092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit cbe876121633dadb2b0ce52711985328638e9aab ]

When USRC=0, there is underrun issue for the non-ideal ratio mode;
according to the reference mannual, the internal measured ratio can be
used with USRC=1 and IDRC=0.

Fixes: d0250cf4f2ab ("ASoC: fsl_asrc: Add an option to select internal ratio mode")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20250625020504.2728161-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 5e3c71f025f45..cf6d3c549707b 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -513,7 +513,8 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
 			   ASRCTR_ATSi_MASK(index), ASRCTR_ATS(index));
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
-			   ASRCTR_USRi_MASK(index), 0);
+			   ASRCTR_IDRi_MASK(index) | ASRCTR_USRi_MASK(index),
+			   ASRCTR_USR(index));
 
 	/* Set the input and output clock sources */
 	regmap_update_bits(asrc->regmap, REG_ASRCSR,
-- 
2.39.5



