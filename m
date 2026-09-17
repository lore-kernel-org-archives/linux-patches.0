Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E14ABBCF;
	Thu, 17 Sep 2026 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659037; cv=none; b=Q11PsGfF+KRoScHppHK29EZJ9do5t57K6t1H2owlDIN29Vl16bj2x7sVBPr9OIo+/aAdBCloMlthRKDXWKt0QGfTnie2BQu6Uebr7b+cObOhfqwAAOV32Io8fCxGIviJ99hwgu5KaWr5qgz3Dk+SSzalva+x6H9Ryr5hrHEMT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659037; c=relaxed/simple;
	bh=TiMIEP7jt/BQy0Cn2BNIgw4ZHqvPvXl6dxB540QwQx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWYcU57oWGWqTXkS92OTLGa0jLYqDMgx0XalgLsbQUJtBiadGIVM4RzATExeMoPnXEQa4nP2NB+4T58f0xIO1/hROrkA9k5ghJt1lj0OFog5LfkIDEFMHf0KPtVo8Yb8SHcfXrxQD4c0CfX9lNKQr6cvIycdzs13c2cuvztBTcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+yrbPQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+yrbPQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E511F00898;
	Thu, 17 Sep 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659028;
	bh=CsfCRAL91jzc5ILgIla5DOtnfb6pDOE4yvk2cCtisqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+yrbPQLNYvYi0Y0emdsYvR5eesosZD+WfBO9w1jRdLI9xt15/R7iLNfwJQuz+YSp
	 c43CH88rTCDoqWV1eo3bUWX/naouSxSMHpjqOQwvn4fyKgXPbyr2VIjB+ZP+QDLAAg
	 1z0jF08QWjkDnjITg5jBgNlrfl4ymK5n1taGRfvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 117/733] ASoC: ab8500: Reset the audio block before configuring it
Date: Thu, 17 Sep 2026 16:07:05 +0100
Message-ID: <20260917151353.915499633@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 8e839bca7793a0b03c005f4b2b0825464290d425 ]

ResetAudn is active low, but the codec probe only deasserts it. It also
clears Clk32kOut2Dis despite claiming to disable that output, and writes
codec registers before releasing reset.

Pulse ResetAudn before the first audio-bank access and leave the unused
32 kHz output disabled.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-1-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 6e8ef9cd1b31a..2f920eb907254 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1640,18 +1640,18 @@ static struct snd_kcontrol_new ab8500_ctrls[] = {
 static int ab8500_audio_init_audioblock(struct snd_soc_component *component)
 {
 	int status;
+	u8 mask = AB8500_STW4500CTRL3_CLK32KOUT2DIS |
+		  AB8500_STW4500CTRL3_RESETAUDN;
 
 	dev_dbg(component->dev, "%s: Enter.\n", __func__);
 
-	/* Reset audio-registers and disable 32kHz-clock output 2 */
-	status = ab8500_sysctrl_write(AB8500_STW4500CTRL3,
-				AB8500_STW4500CTRL3_CLK32KOUT2DIS |
-					AB8500_STW4500CTRL3_RESETAUDN,
-				AB8500_STW4500CTRL3_RESETAUDN);
+	/* Reset the audio registers and disable the unused 32 kHz output. */
+	status = ab8500_sysctrl_write(AB8500_STW4500CTRL3, mask,
+				      AB8500_STW4500CTRL3_CLK32KOUT2DIS);
 	if (status < 0)
 		return status;
 
-	return 0;
+	return ab8500_sysctrl_write(AB8500_STW4500CTRL3, mask, mask);
 }
 
 static int ab8500_audio_setup_mics(struct snd_soc_component *component,
@@ -2183,6 +2183,13 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 
 	ab8500_codec_of_probe(dev, np, &codec_pdata);
 
+	status = ab8500_audio_init_audioblock(component);
+	if (status < 0) {
+		dev_err(dev, "%s: failed to init audio-block (%d)!\n",
+			__func__, status);
+		return status;
+	}
+
 	status = ab8500_audio_setup_mics(component, &codec_pdata.amics);
 	if (status < 0) {
 		pr_err("%s: Failed to setup mics (%d)!\n", __func__, status);
@@ -2195,13 +2202,6 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 		return status;
 	}
 
-	status = ab8500_audio_init_audioblock(component);
-	if (status < 0) {
-		dev_err(dev, "%s: failed to init audio-block (%d)!\n",
-			__func__, status);
-		return status;
-	}
-
 	/* Override HW-defaults */
 	snd_soc_component_write(component, AB8500_ANACONF5,
 		      BIT(AB8500_ANACONF5_HSAUTOEN));
-- 
2.53.0



