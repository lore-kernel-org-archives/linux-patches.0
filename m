Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBA38E8CE;
	Wed, 30 Sep 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791370; cv=none; b=ajuID2ezug9G/JA9tpwuBPODiFehdMk4xRjhHLARATsTAYmpD06hd7ogwTd4l4Dr58R4ciHz0zL3iXybSIbUuR33g3hNN6FNQssKgS3L9gwOfH9YxbcDIflu4k70eBmEq+vmR66gnffka4tiEDgd6FdyvoZi0PJCTQnq83egpnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791370; c=relaxed/simple;
	bh=D6xzqgtAladrUSa4m3QwJnU7qAAV8NQGI+6YwcHmbUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHFUhBZCE0EIWCdUKcI009DxE5w9rAUvp4yqaWovqD2GCB2a5Ea6QjGu1U7nmhOtd35gEGwb1Ek+brTeRyReBPVNvFrSRM80o1WHRXeNt7+CILQKtZ2WSviy289o/uE2XiNfUYGTVVTDKz+gqfRdBO05Bc5E9Uo5PVEKmRHz4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGs1FFYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGs1FFYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D08E1F000FF;
	Wed, 30 Sep 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791369;
	bh=1Y4CE4j19fniuBsmrC7YPjmey4nljY9AdTlnca4pXVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGs1FFYTYU98NsM2SqsV0VqaaRKD8v9i3Gs19xG5r67MhGVV3Mg/1OoXzKaz14CbN
	 6hSNMu7nOsNQX1GRnMbjiOs85kQ1OduNLcBFjPwrmSpBXQ33MxMrcznd3iNDEsgB6/
	 Ak71iAg7U3HNf3hyyMjGOEjdrPOzNO7jhy753hno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/752] ASoC: ux500: Propagate MSP setup errors
Date: Wed, 30 Sep 2026 17:22:29 +0200
Message-ID: <20260930152404.327491756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8d57ee06c46d6..6e71615c3b840 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -470,7 +470,9 @@ static int ux500_msp_dai_prepare(struct snd_pcm_substream *substream,
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter (rate = %d).\n", __func__,
 		dai->id, snd_pcm_stream_str(substream), runtime->rate);
 
-	setup_msp_config(substream, dai, &msp_config);
+	ret = setup_msp_config(substream, dai, &msp_config);
+	if (ret)
+		return ret;
 
 	ret = ux500_msp_i2s_open(drvdata->msp, &msp_config);
 	if (ret < 0) {
@@ -765,7 +767,7 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 	}
 
 	ret = ux500_msp_i2s_init_msp(pdev, &drvdata->msp);
-	if (!drvdata->msp) {
+	if (ret) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to init MSP-struct (%d)!",
 			__func__, ret);
-- 
2.53.0



