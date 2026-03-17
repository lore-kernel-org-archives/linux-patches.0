Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D3357A4A;
	Tue, 17 Mar 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765814; cv=none; b=Rl24+vmTXiwbX1OkEnL/web2z0WL82y/DySN1ViL46pPPRCDzFwDf42+8ic2AXnn/w0pDaY7alzwlB4JwtYwpU1KqvU93gBLc2wm6zCdS6D1+W8JGudlHAHeidUbfxB8pZ7DFxS+henHKWIyOi1NeB98P1GjpZ5iJs8LNdfzQ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765814; c=relaxed/simple;
	bh=eZlp9FLz+nEfeJu+Fn+ivc27BOSJERbfAlVo/wGdl0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6Dtr9foL+QlLZ2S+xsvnZwbPnMWTddfLFk5v3DUSrPx8dzI42Enk5ovlZOnPAHkiRAXM7IAfJ/h/EzALIpqn6oLGW8VrVHlKtoTeIcTXh/Hr2EadFApkBZEBfdZImbB/cWeE1vRqgaplbDKn/JiIspsZxXjB7A9ZUg23jPW9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZVCp1rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZVCp1rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738BFC4CEF7;
	Tue, 17 Mar 2026 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765813;
	bh=eZlp9FLz+nEfeJu+Fn+ivc27BOSJERbfAlVo/wGdl0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZVCp1rr4kAVB516lGOuhveg3zMLwqAFl8n8WTGVY6ql5j7P9eersJRANZ0S68UkL
	 MAXzzZXnaP/JiUvPD2/N7DEjrg/iHP+L15jrLVUS5vS2ToX0jz4TccN/wBAxiUnQsL
	 v5u9Yd/zihWH5BPwiq0Man+LkuXNI6cGLQdY+L0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 101/378] ASoC: amd: acp-mach-common: Add missing error check for clock acquisition
Date: Tue, 17 Mar 2026 17:30:58 +0100
Message-ID: <20260317163010.733731334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4d99472c75baf..09f6c9a2c0410 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -127,8 +127,13 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
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
 
 	ret = snd_soc_dapm_new_controls(dapm, rt5682_widgets,
 					ARRAY_SIZE(rt5682_widgets));
@@ -370,8 +375,13 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
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
 
 	ret = snd_soc_dapm_new_controls(dapm, rt5682s_widgets,
-- 
2.51.0



