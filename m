Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB13384CED;
	Sat, 17 Oct 2026 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253889; cv=none; b=j6a6aS+AKkgNT9pltmpp3WACtS1NOKycBjHOfyUBIcBNaGcpW1minWtTFCvux7PIDSOkYLVI2HBaww45slL0uiTo9ZiHYlmaCuXT+FR/bq8+GOJpft5ON0TI8pbbWMtxm8dHXaVOscRxnKv1nHIzgl4o3fgHpf3LLPOP+6scH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253889; c=relaxed/simple;
	bh=p0YTc9TE/AarRLC2Tm5QmneA56ASO+Xe//9/9BiLK0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR83CNNaVZKdy35DCNcm+0gFFrmfeHxQ7Nj6Rq2jWNn0mGPY6N89W3+XpqUIyNMk+CUlrwEW0wZ+3Btnt+9cicqFnarBmeagKqHZ4mCeMDcmCiv+tjLRIWgEz1BLJK3ziOeGIXWl2tOywzAVt3hecVMVJxCzCQRx/g7xzEApAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lllW6DjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lllW6DjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB05A1F000C4;
	Sat, 17 Oct 2026 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253888;
	bh=HlC612+nUU2S9ihtrW3xoKypOSOdwd8Ae4ACGpHPq5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lllW6DjOw2MPCSDND/LmZ9VRgg9uDVhGq0t08IBCtJOqgf5s00sjgSbrwVBIbBuyv
	 IKgzNNuAjOV/uPxaVLohWYxwpKMrNV0bz0aMC2hWDE/r8s9r8RN0GcUgQtQZFAV0PA
	 MedolL0wHeeB4m0mDN8Byusng6swVsN9LPMad20Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/869] ASoC: amd: acp-mach-common: Add missing error check for clock acquisition
Date: Sat, 17 Oct 2026 17:51:47 +0200
Message-ID: <20261017160043.882608816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 30c64fb9839949f085c8eb55b979cbd8a4c51f00 ]

The acp_card_rt5682_init() and acp_card_rt5682s_init() functions did not
check the return values of clk_get(). This could lead to a kernel crash
when the invalid pointers are later dereferenced by clock core
functions.

Fix this by:
1. Changing clk_get() to the device-managed devm_clk_get().
2. Adding IS_ERR() checks immediately after each clock acquisition.

Fixes: 8b7256266848 ("ASoC: amd: acp: Add support for RT5682-VS codec")
Fixes: d4c750f2c7d4 ("ASoC: amd: acp: Add generic machine driver support for ACP cards")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260310044327.2582018-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index 6c0a92d76b54d..75143f24a5cea 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -133,8 +133,13 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682)
 		return -EINVAL;
 
-	drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
-	drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
+	drvdata->wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+	if (IS_ERR(drvdata->wclk))
+		return PTR_ERR(drvdata->wclk);
+
+	drvdata->bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+	if (IS_ERR(drvdata->bclk))
+		return PTR_ERR(drvdata->bclk);
 
 	ret = snd_soc_dapm_new_controls(&card->dapm, rt5682_widgets,
 					ARRAY_SIZE(rt5682_widgets));
@@ -375,8 +380,13 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 		return -EINVAL;
 
 	if (!drvdata->soc_mclk) {
-		drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
-		drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
+		drvdata->wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+		if (IS_ERR(drvdata->wclk))
+			return PTR_ERR(drvdata->wclk);
+
+		drvdata->bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+		if (IS_ERR(drvdata->bclk))
+			return PTR_ERR(drvdata->bclk);
 	}
 
 	ret = snd_soc_dapm_new_controls(&card->dapm, rt5682s_widgets,
-- 
2.53.0



