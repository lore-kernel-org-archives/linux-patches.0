Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F1501F2F;
	Tue, 13 Oct 2026 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893335; cv=none; b=ieJSYJ+4Vn8y878T22+G809Sefn6etA6/p4U/OOFxlzv0jT+VyazGSvUUP+ViCp2FuzJECyoor7J5+gRMljHyW5QPHvPC7O3qz4kOlO1hOe1tyNbo+x3GcoOxIdOzyfOWVy6BgZfD+aDtlGODFV5+SI7TSaclWJACzFNy5IY+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893335; c=relaxed/simple;
	bh=GJGtoO+X+WgTpXcrU8wSz8aaQm4EoxII1XE25CUstBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3ZUIj66QdXBKy65R4T7lkviMIwQVfsUbNS4lZEy6GYM4TzJ7kOvHntD1oG1Y726aOiUyh3oDY5no1+GCeC7MqJ2frieBM0S+DhKjTgaMFVdnGAdoFy16YpOP9X8qR2BBtT4Hgdwr4IosJY4DtbVjjEf2UvRT4l8xTCG5+k8L6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhIxqyiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhIxqyiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C827E1F000FF;
	Tue, 13 Oct 2026 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893333;
	bh=Hxck9lBDluGBdzi8Ykvtj3kPI0hx0cZiiR52N0bEz5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhIxqyiMosy0g1tDJLrGtg0VTNVtIEgd+s+LBLe205hi7U2RBehmiAs2zz2nzU9j7
	 vGNd95vzcy19QqBT0hyAjZblbXnvh+K+kIPy1Ptdk8RlLlCYdbcxN9+6CxybUnCyVH
	 hAJBkUSVPFfFVs8HGevLNjWqpmJBrJI/YUCiN1io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/621] ASoC: amd: acp-mach-common: Add missing error check for clock acquisition
Date: Tue, 13 Oct 2026 13:33:05 +0200
Message-ID: <20261013112925.370859983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index a2031e7f61424..d695b9c2b9135 100644
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



