Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8A92ECEA5;
	Tue, 15 Jul 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586714; cv=none; b=lTBstImOuAPv/517haM3a4cvSUx4UgVO8ma3B04sNZFqZFDBfjWRnwU3geP4C9tjAXiQnSt79pD1zqa14dNTY9/Law1wnIDKZGX8nB14NtptsznfGGj7yGpuPJXKqEZqXRDkNu6s8DBnnKmw92Lz20aPvEF9zSVp9gUHQO207WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586714; c=relaxed/simple;
	bh=WER04ewkKy/KAkZhZMgGHUxl1HMQWxFddpAjQyo0g5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCfoPdxi46XotCdlTKHDzQYr8wgvw33CLylfVDXlHHIUt4z91bvVxJg9ihevxwnU9KCQhrAWbB5xbynDk+rDd1lYjUzGv5ZmlbHLSfshaZ4pP0e/o0uokdRcs810IgBkN8oi65Y6JpKAxrzbyhV2NH4+V8RtG0eRbOSgQ5iXO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ru+ZfAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ru+ZfAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB83DC4CEE3;
	Tue, 15 Jul 2025 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586714;
	bh=WER04ewkKy/KAkZhZMgGHUxl1HMQWxFddpAjQyo0g5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ru+ZfARN5nCYSF3Z4D98NIWHH5dSRGvlRkU+Y32iVP9w3odJaVR0SAtJQfkPNfb5
	 CUK4y73ZErTooYLMTktekVERR5wuuOhNe5vf2Ey5VDfdch2ljfJmeDlgd5ybpflxvY
	 CUrRLbw3WENyXrdhSKoZnnMtEhjjODmfdnCW/q58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 003/192] ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode
Date: Tue, 15 Jul 2025 15:11:38 +0200
Message-ID: <20250715130814.999308194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 677529916dc0e..745532ccbdba6 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -517,7 +517,8 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
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



