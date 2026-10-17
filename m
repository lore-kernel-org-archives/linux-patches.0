Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A82D3225;
	Sat, 17 Oct 2026 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258603; cv=none; b=LFPh/wKrMytpqfI8/h+tlzMGjldDVxcrv6Vc4fxSbnH/P7vt7flJKq7UQ44+7T0SvkvMawrUbYzFk3XqsQyCR1KFktYrLsoKXgaKVoOu6Z/xJYG2Ncqze+8eNj0YrpoRgffETkg+cDHjCcrCrghYo6Sj0ETaQf+MpLanirD9lHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258603; c=relaxed/simple;
	bh=6MBmobUqs6TyFitwM/dwExeSyFq3XWuSd4Hcaskz1WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMv3kgtNOZGEpknUmPKvGkRxHlzTCJ8W1oMBWvUK51p9+/PMjW5IrCpb72gcySNgqHV6FpLy0REfftPtOtJpm8pE5ePbv5z87vWxbgpI77H62CfLW/4aYkvovmDfZKsvdqEN70fV4pLpwfvNs41yoZ9GS99qcyzuv1vX6Vr28gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRwYLzMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRwYLzMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032B11F000C4;
	Sat, 17 Oct 2026 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258602;
	bh=QBct6eMyAchb2eLXMDKIZt21lJ2SjLTAJeTO5q+njbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRwYLzMX6+zdRg1r0jbkFVB8SwCGSd65Uov3k0swOGbkKXhxAOd7DUgv0PuT1nRo9
	 WPi5viPBAe1kxvD4awTtmNxCc9z9mx/FloenmjWV7yf+gdn8xtuI3dB3wcwSTpzBkg
	 U7TU95cun2klkqNMyXg9T4gAFqs5t9YcPp6X9wgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0940/1674] ASoC: amd: acp-mach-common: Add missing error check for clock acquisition
Date: Sat, 17 Oct 2026 17:53:32 +0200
Message-ID: <20261017160455.261617446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index fc4e91535578b..ecfabdda2fd0f 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -126,8 +126,13 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
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
@@ -352,8 +357,13 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
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



