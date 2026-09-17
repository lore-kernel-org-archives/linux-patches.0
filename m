Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0784DDB5A;
	Thu, 17 Sep 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665468; cv=none; b=gvALTVeYHFh8JLMnI3ppNnuSBOutZyIUYA8sEfYP4EtHYkIbU5XVUjKZqFmgs/aj4QCjkZ5aby5DLzznn4Rt7CG1IoN71TE+RRVkjdbxmnhc/ScvXb7Fy7lezJy/AP8ZIRt402+m9TEwYpUTSVWdfx6jauLtkXveW6LBoIn9yGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665468; c=relaxed/simple;
	bh=wSfQjKDxUKF6COxQ/Tg1FIEDgcVjEVek+p9wCF/A0Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqIB/sQ/ko5Pqj8jqGKahDRLa/mA52NJe9HTAz/8QD+cgPiw6QHNBkirOci6EHD4fpY14IsGZF5BUEarxBcSzInS/YnBwIwLu/WSxAHe0IwJsD7Tche1rlSGv3H/zq/tp4qi6bcgVTlnI1CgqM+6yKejt2U70+ETBtPxKo2yTWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nS83a31G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nS83a31G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5491F000FF;
	Thu, 17 Sep 2026 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665467;
	bh=0ibPtCjreuoBgPPSanq6Eu/w5rB+TsktYumKeaU4WK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nS83a31G3Rp2EbbozwgumCC4FReQCOLDolHjKCiauW4axwNYoSm2HMpqf/XJK52g4
	 xi2BaNE3XTPJ7R2U1YWCive7Pat5i7MMhxlcOYS0eoWcXWYlJrlkPZbIEWmfb07/I6
	 8qfwQZD3gjxcPbrm2tLTpgwcdD95o68QgUTtBBX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0714/1250] ASoC: ux500: Propagate MSP setup errors
Date: Thu, 17 Sep 2026 16:08:29 +0100
Message-ID: <20260917151611.248131323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3415421a2b0bc4e32bb5a9df24ed7863512d47a7 ]

The prepare callback continues with a partly initialized configuration
when format setup fails. Probe likewise tests the allocated pointer
instead of the return value, so an MMIO resource or mapping failure can
be ignored after allocation succeeds.

Return configuration failures from prepare and test the MSP
initialization result directly.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-2-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 7d65408989340..32d751fc1e784 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -468,7 +468,9 @@ static int ux500_msp_dai_prepare(struct snd_pcm_substream *substream,
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter (rate = %d).\n", __func__,
 		dai->id, snd_pcm_stream_str(substream), runtime->rate);
 
-	setup_msp_config(substream, dai, &msp_config);
+	ret = setup_msp_config(substream, dai, &msp_config);
+	if (ret)
+		return ret;
 
 	ret = ux500_msp_i2s_open(drvdata->msp, &msp_config);
 	if (ret < 0) {
@@ -764,7 +766,7 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 	}
 
 	ret = ux500_msp_i2s_init_msp(pdev, &drvdata->msp);
-	if (!drvdata->msp) {
+	if (ret) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to init MSP-struct (%d)!",
 			__func__, ret);
-- 
2.53.0



