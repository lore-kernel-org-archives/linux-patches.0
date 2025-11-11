Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FDD1D6DB5;
	Tue, 11 Nov 2025 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822188; cv=none; b=fT/nFCp1eHJCeID7Ka1i51fJGFy1Y5mcXiKtVx39iqf2YxujCKxFCkvuTNJ/7l7VOANkaal4Rb7brb/Y0a+OrxfkQSSX7CGW7cR9ZGkKtMwCxBLVrJip7TVC9pihtp97KMhChFE/2nwZLzfWtJhLOA9UFu5FOH7f/i8MC9dmMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822188; c=relaxed/simple;
	bh=dlxBATFKt9KBFNq8cCeWVQIzTjUSjCA2i+ybPiojXts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfkdm8gIbzjLQaVohf0SHOuWR/zNoARqFPtrLSnn4TTYIkkCGNyP00Dri4+9fqln2FKFL7sTm8zHu28UjYvn5Jr+cWFJj46Urdw+/yiV3hzQHHfi6yNnzT3tgkjUekmfvnEDJrlcjzS9+3PkTB0wjfHgkmcy+jOk2tev4CV9wXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeQx/r7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeQx/r7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D831C113D0;
	Tue, 11 Nov 2025 00:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822188;
	bh=dlxBATFKt9KBFNq8cCeWVQIzTjUSjCA2i+ybPiojXts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeQx/r7AZ0hpuWOxDnOkcEs9yucb+/kC/7TKUO1ah0JXYduFqE42/K2hsqLGbGFi4
	 bbWxhZVWaJXjeFg+7CEmryNKN/rve8T+nPrFaRTP8CXVDmH3ITaiCaYj+U9I3kFcPi
	 Z8gH0hpz4hJMYL9hzK8iYnaa30vEeUvtlw+xmup0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 052/849] ASoC: fsl_sai: fix bit order for DSD format
Date: Tue, 11 Nov 2025 09:33:42 +0900
Message-ID: <20251111004537.695750596@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d0367b21f7757..6c0ae4b33aa4f 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -353,7 +353,6 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		break;
 	case SND_SOC_DAIFMT_PDM:
 		val_cr2 |= FSL_SAI_CR2_BCP;
-		val_cr4 &= ~FSL_SAI_CR4_MF;
 		sai->is_pdm_mode = true;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
@@ -638,7 +637,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(slot_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(slot_width);
 
-	if (sai->is_lsb_first || sai->is_pdm_mode)
+	if (sai->is_lsb_first)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
-- 
2.51.0



