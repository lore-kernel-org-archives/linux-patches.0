Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BE74CDDC0;
	Thu, 17 Sep 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659216; cv=none; b=SBJreYjJUBQep81IhwmbuhEbjT7akhTGE2xmfS+eS/AGeKmo21xIMByrqTtp1e3bSUw55HHZZsh/L29K5zIyVFSqsqfORGiGZkLtgC6vXftfo4HbPm0pBsKsL7F9IIG/GxBxiY68qR0k/QUGXdvim15lbd3cpPp8XgrMv+4qbTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659216; c=relaxed/simple;
	bh=fjC7md1ejQcGVKc7/FbPpwJMl6TfkRNiG//ZsGP1Kx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxsoO5ng7ELsa/VSbJ2YI/CjrBSef5/6DDHyApe0EzyA+ExKLmKlkEjsnImvPVmVmECKUy4dxrj4dihyyI8JKiRst398cg5b//il3aZ7ZBCluOnS6z3e4YnE2+3FdRdiSVLeePCs3Yf2/O7qn9wNAjTzF6JubByc/7SmKt+njfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA76j2VW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA76j2VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975CD1F0089B;
	Thu, 17 Sep 2026 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659206;
	bh=U+yAd9wcZ++drDTFURo4tASL75VUrLdcHYySukDalS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA76j2VW6aT3U2qKRhCAbq30XoTKQUjUeL1mtlUgmkRCEHukebaRFzslUwA+6Ktih
	 Ot1pl76QpO8UQZinWl/QpqTBDx8SxqiiyfZfeyyLZu2puuljUP5mST+HHn6Q4r7Zmv
	 pV030iyET79e4Asj6ndUamSdeSLS0pwi8fkRyCyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 180/733] ASoC: ux500: Propagate MSP setup errors
Date: Thu, 17 Sep 2026 16:08:08 +0100
Message-ID: <20260917151355.608316627@linuxfoundation.org>
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



