Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABD03491EB;
	Wed,  3 Dec 2025 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778732; cv=none; b=i0RBRon6mikynwwlxpSP8bK1u+ZYR+MF5nTb9FgzMcrKKptIgBKnMhe4Iahr+8ZwKYGk3zNr7GV21mR4SSQ7FcT8J4rGzoSdo0kd1R7fhFWPKUG10eMDb47GXx9MY89cOdbOQkW00o0lvJj4OnQkpGXyxJFo9IDeeVE8N8m6BtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778732; c=relaxed/simple;
	bh=7rWHWJwd3rdhYCY86Ny23n15/31FA9lDZYR5WJS0d9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkdAkMX8WsRcL5A1LbXQIQs41AkrommV8qBjaDZEETRyTHOKt5nCHH+V1wSa8uB1iRgmJeeE1aEi3KawhQ5Oth1QMJhRioWIIBlHSVuTC2AhdYH8jv5XmVMlG4GATmYsGBnJ44ZwJSGt21AC4ho31OXUR0mbECfT8DBPuDLEHII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yu9pg14/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yu9pg14/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9409BC4CEF5;
	Wed,  3 Dec 2025 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778732;
	bh=7rWHWJwd3rdhYCY86Ny23n15/31FA9lDZYR5WJS0d9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yu9pg14/OJi6ZekDCYM7wAw9adHSOlTV0e/P+h9tn/NBNlhfrBEMRaxoFtV+kH1fK
	 k/zhwxR4ZpAROMoq5n8xn4UJaYrzY72HVxTiyqcGdw1rYIBpiy29imsRLm84gHd+lJ
	 3o70YTV8tcdBGd8J6FuFDSlxrruki2duOe6/QC+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/568] ASoC: fsl_sai: fix bit order for DSD format
Date: Wed,  3 Dec 2025 16:20:45 +0100
Message-ID: <20251203152442.269178821@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit d9fbe5b0bf7e2d1e20d53e4e2274f9f61bdcca98 ]

The DSD little endian format requires the msb first, because oldest bit
is in msb.
found this issue by testing with pipewire.

Fixes: c111c2ddb3fd ("ASoC: fsl_sai: Add PDM daifmt support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251023064538.368850-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index e622c8375a465..f5266be2bbc22 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -322,7 +322,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		break;
 	case SND_SOC_DAIFMT_PDM:
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~FSL_SAI_CR4_MF;
 		sai->is_pdm_mode = true;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
@@ -597,7 +596,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(slot_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(slot_width);
 
-	if (sai->is_lsb_first || sai->is_pdm_mode)
+	if (sai->is_lsb_first)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
-- 
2.51.0



