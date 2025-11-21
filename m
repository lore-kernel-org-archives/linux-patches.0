Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E164734CFA6;
	Fri, 21 Nov 2025 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732268; cv=none; b=W0L8bVprENJ5e3AFWcR2AFh+npSH9jaiZWkEinEf/mpUFjolWcoMX3Y+50vY2lMwZM/DpIExmvcyh8soH1Qh6HS1Tl8RMCiJXWnH7Yukjj9GMcFYGx8rxYrRzpQA/b34GUj8VmgSe0Z1nplEET/hVdrCsMjW9sDjLZVr5/71nS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732268; c=relaxed/simple;
	bh=be4Tr+vd1uGrS8Sc/p9bmU63tjq+aFJFIntQr/lyWg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGyVXmgAgJQQDmu54tPQDHDQBy44/l+0+qWvHy7scMcJvbkTezTBhCgoNVmGycrFNhR3ju4jjJZW7jsRebdk+DgOg5X6UYsfFLWbjm64anhbLkOJ5AyE6MSLO/pfsvCTukUdLQ8ZWZqU8m9vCTqifQpmfBWndwKiOvnV3l11kSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1RRwMZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1RRwMZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A41C4CEF1;
	Fri, 21 Nov 2025 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732267;
	bh=be4Tr+vd1uGrS8Sc/p9bmU63tjq+aFJFIntQr/lyWg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1RRwMZgyF8nBZX1cguErCKok2nujWYhLsCY40Haal/dTqi4M7Z+CuwC/Bkckjlxl
	 FI5X0OKAuIgeN3uquWu4L2B6CxHzB1NOCuZF5rToV6kT6ic4ky1arkCmz8m+OTS244
	 Q5q/sInatGtKfFKmQnwZe6YIdxOhtY0d59A3HP98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/529] ASoC: fsl_sai: fix bit order for DSD format
Date: Fri, 21 Nov 2025 14:05:27 +0100
Message-ID: <20251121130232.001028964@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index a6948a57636ab..0de878d64a3bd 100644
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



