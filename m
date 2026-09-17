Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B529E4DDB5A;
	Thu, 17 Sep 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659150; cv=none; b=UraYBtOIWPY9/OESjSyc+z4c1A0kldhHTeuLCImH3hHAjCJ7vg6cPkCPTJWwpoLYvfn1ZEJDijnTXqyyFzn8DfU6ke36ST8scVge7DvPnDZl2J+GcOgk0GY2aqkxlHpGJTzxCsyW2UJdhhMKlCvfwr944lsQ0ARIwUTr3GzWZj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659150; c=relaxed/simple;
	bh=J1szZTzCm/HDPw5YqRO2WcnRq+g8hqo/hQdzzr+tBME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMjbOo3PYeR0+E8irJ98O2HDRq11OT8Wz3/qhlrEEQDxVg5+aNbB+i9/I9S4hyWyfppxkXASbVPNOs/ugIuTLFXmPqdyO7CLvRLcpI0iG3gEHok1V6OhvEQmjJOLXeeVoIs7JEkjfpPTHo6ykWyjRk84rN4qAWMmC9+F2nlagCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+mYDxs0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+mYDxs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6071F00898;
	Thu, 17 Sep 2026 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659138;
	bh=/uaBXFPKJMr4OR5BwWxTmAjhPiwpuKl+jPKp8FnQbhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+mYDxs021PqW052LO3EdnhZbqAisBfSnuvQwOVdXKvJAy7tgh3ANlsBNim6yQT/u
	 vPi1FN+eEMDwVPrbeNZViRSmf5zznEuCc2mcVQOkXncTc6a5UNl1hgi7uzvuNebtad
	 EBwfpG39/SOB7GJMlIJBVG2/jIIWKGUTlPFU+pv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C8=98tefan=20Ghe=C8=9Bu?= <stefanghetu9@gmail.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 155/733] ASoC: fsl_micfil: balance mclk enable/disable
Date: Thu, 17 Sep 2026 16:07:43 +0100
Message-ID: <20260917151354.926830295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ștefan Ghețu <stefanghetu9@gmail.com>

[ Upstream commit d3dbccfe6afa7b9a6a7ed65cfaa76a47fa050a56 ]

hw_params() enables mclk unconditionally and hw_free() disables it
unconditionally, but the PCM core does not guarantee 1:1 pairing:
hw_free() can run without hw_params(), and hw_params() can be called
multiple times from the SETUP state. This triggers an "already
disabled" WARN() in the first case and leaks an enable reference in
the second, leaving the clock ungateable.

Guard both sides with the existing mclk_flag, as fsl_sai.c does with
mclk_streams.

Fixes: b47024dc624b ("ASoC: fsl_micfil: Add mclk enable flag")
Signed-off-by: Ștefan Ghețu <stefanghetu9@gmail.com>
Reviewed-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://patch.msgid.link/20260830205106.11267-1-stefanghetu9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 60ac8eabab9da..5d8f0f76ab46f 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -953,12 +953,17 @@ static int fsl_micfil_reparent_rootclk(struct fsl_micfil *micfil, unsigned int s
 	/* Get root clock */
 	clk = micfil->mclk;
 
-	/* Disable clock first, for it was enabled by pm_runtime */
+	/* Reparent root clock to the PLL matching this sample rate */
 	fsl_asoc_reparent_pll_clocks(dev, clk, micfil->pll8k_clk,
 				     micfil->pll11k_clk, ratio);
-	ret = clk_prepare_enable(clk);
-	if (ret)
-		return ret;
+
+	/* Enable only once; hw_params can be called multiple times */
+	if (!micfil->mclk_flag) {
+		ret = clk_prepare_enable(clk);
+		if (ret)
+			return ret;
+		micfil->mclk_flag = true;
+	}
 
 	return 0;
 }
@@ -991,8 +996,6 @@ static int fsl_micfil_hw_params(struct snd_pcm_substream *substream,
 	if (ret)
 		return ret;
 
-	micfil->mclk_flag = true;
-
 	/* floor(K * CLKDIV) */
 	switch (micfil->quality) {
 	case QUALITY_HIGH:
@@ -1068,8 +1071,10 @@ static int fsl_micfil_hw_free(struct snd_pcm_substream *substream,
 {
 	struct fsl_micfil *micfil = snd_soc_dai_get_drvdata(dai);
 
-	clk_disable_unprepare(micfil->mclk);
-	micfil->mclk_flag = false;
+	if (micfil->mclk_flag) {
+		clk_disable_unprepare(micfil->mclk);
+		micfil->mclk_flag = false;
+	}
 
 	return 0;
 }
-- 
2.53.0



