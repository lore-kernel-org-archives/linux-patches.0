Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E334F4047;
	Wed, 30 Sep 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783053; cv=none; b=m5YUqITOTdieXxJxtJ7NdrNm09tUTIkb2B0nVdtvnrslqk0tQgGro9r9nfHLY4ov+eQ5vZ6iZTFC9KXO/A7vu0rC+QrMVBkxYh4seuqfn8k0YfC3s+QyHTiH80Sq4MRSmqSgwLJS72A+kL/m4UNumJTYGXmq6yZ7Ovrmh/ZARi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783053; c=relaxed/simple;
	bh=rzU/cZEDuoW1TRQblKMGSZ7ui0Iu5uMsPN460VRDSZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz04uZsYITltvz+qlsWa6PhUd5LBjkMyCM89tMlPF04ZTBYMDwXKxP8CTdPTNdWOZPQuMginY/YMoRltRFnXzJZatcyu3y2sLsM64exm8Vkuc75CgPk78YWTWxEnmofn386D9VRKpoHB2fXakcrp2EQcQ6noUJArFwbWRewr5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi2Ym618; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi2Ym618"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F31E1F00898;
	Wed, 30 Sep 2026 15:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783046;
	bh=ZAoN9IEVtENRu0pCE1itMU1wqIbGjo6+ILgik7IsPGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi2Ym618kQCEnvNv8bouA6VnjuYqc852omNkOHL8FTYs8cidjepH0PZzQYIsGJZC/
	 FZJwyqq2gtQBlKYqHMrf2VJRS16hAev752PhrH/lVi/NsZ4jJ4Gywh54nzEOBjTdL2
	 e2HLXNn1dl/JvLuurA+wL6yiQrtn+h6154mWbqD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/595] ASoC: ux500: Propagate MSP setup errors
Date: Wed, 30 Sep 2026 17:21:49 +0200
Message-ID: <20260930152352.377616330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



