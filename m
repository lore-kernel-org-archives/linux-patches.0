Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4414F397928;
	Thu, 17 Sep 2026 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668986; cv=none; b=o4CSPccfHIXmEq/W9xEtgWnpquhCdmOtvPYrb+UUX950ygHsiijg6jrubHS3KCMD16LAcYfDlwsY7nB9r/joSvQFGIA/4DE0q1UF6YKVfMIoOG5v21r3VoBTwk+OemrtQaWUvk7fX9udQGD5wKwu29D6YsB8YwyEsLq6u+DMbH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668986; c=relaxed/simple;
	bh=wFN6XF7O7dW7bbWNU8170y0eHYAP0iQNVX1ZobFWEJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+DfPqdhK4bR1YGnzwv0Q+cd3M2mlAyn3VfdoeLOX3kB2G81fxc8V5RNHrY8iYlEuRdnqB59EdeZXvnUdZNU0MEfqv+CUJFV7bR6L5B7GnB8gCrRH1JCS2582vkLfOIeWvEO6jp+RvZxbvVT3HeNJ85TgvLnFS5vCysmdTn5XVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oubiapsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oubiapsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A24B1F000FF;
	Thu, 17 Sep 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668985;
	bh=SGkrnHW8HqpGcuRVk/REToyZ7s07IVeHOGFwYk5QlgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oubiapsu7snV0HytfeWimqRIqYnZsISEfDK6TptxETDEF/GQUZfsXkPoYdhdCVSGE
	 o6fHUBlCuH5gbC5ieXiuVAUd1vpU8DjxwEMKPY4WfZFPTSPduSold2AKKpmBLJvJCg
	 31NUbzGzCwsxE0mPt4saDs4HM9JhgnXYxJF1C2Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0607/1102] ASoC: ux500: Propagate MSP setup errors
Date: Thu, 17 Sep 2026 16:09:10 +0100
Message-ID: <20260917151555.263611094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 217645ec31a54..3479a547b2d8e 100644
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



