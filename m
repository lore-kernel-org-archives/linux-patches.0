Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155C4202F65;
	Mon, 29 Dec 2025 16:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025387; cv=none; b=VnKiehLBcMcAn+A4JRtbTwhf+vtwfT6Fj9h2/+1iZhUJiNUdspNYzGW6RtPrm9mQW0W0CesbA3lbQuetaZh2nihcWs+06PHn9KItwuhK6yDL8fdOwFSeaiwMhfhYJSlf+t1Y//9ziNZyZTDgi4T9W8rP4kIdCPRF3BRMGaRwHFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025387; c=relaxed/simple;
	bh=Va2En5rHWgAqzlN7mA01u+OTR7aKkHjAcTcR/egQVHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kak8ktiYxXW8lHJ1x2RSkyGPgQ9HOSIQnzQ1kz+3ReQmLA7g6fC0vksq6SFuXnWXbAXq07GXPS4bHgrSESFubRDe08sX4P+wEihs6vBc/pIGH+1tIeOwUtjW9dwZLobEDfH+i2sGM39gfmWj6inh3mhhZwH3VRQMz3aY7R+ayEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4+POJPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4+POJPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9568FC4CEF7;
	Mon, 29 Dec 2025 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025387;
	bh=Va2En5rHWgAqzlN7mA01u+OTR7aKkHjAcTcR/egQVHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4+POJPwSzWCuGNg8wiNktOP4bqJR/Ppnx2rBpuFPPhDfjnEowzx998O+yhbHFnXt
	 dR9420StbJhlqYKJmnES6vfke55RPMiosSsHpeKYmJ9E+tFegZLiF0CPpl+5bRyXvy
	 RNUQa4fCydODu00ClmbfiXnd4RnyuutGWmvST/1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/430] ASoC: fsl_sai: Constrain sample rates from audio PLLs only in master mode
Date: Mon, 29 Dec 2025 17:09:30 +0100
Message-ID: <20251229160730.545730568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 9f4d0899efd9892fc7514c9488270e1bb7dedd2b ]

If SAI works in master mode it will generate clocks for external codec
from audio PLLs. Thus sample rates should be constrained according to
audio PLL clocks. While SAI works in slave mode which means clocks are
generated externally then constraints are independent of audio PLLs.

Fixes: 4edc98598be4 ("ASoC: fsl_sai: Add sample rate constraint")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://patch.msgid.link/20251210062109.2577735-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 72bfc91e21b9..86730c214914 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -917,8 +917,14 @@ static int fsl_sai_startup(struct snd_pcm_substream *substream,
 					   tx ? sai->dma_params_tx.maxburst :
 					   sai->dma_params_rx.maxburst);
 
-	ret = snd_pcm_hw_constraint_list(substream->runtime, 0,
-					 SNDRV_PCM_HW_PARAM_RATE, &sai->constraint_rates);
+	if (sai->is_consumer_mode[tx])
+		ret = snd_pcm_hw_constraint_list(substream->runtime, 0,
+						 SNDRV_PCM_HW_PARAM_RATE,
+						 &fsl_sai_rate_constraints);
+	else
+		ret = snd_pcm_hw_constraint_list(substream->runtime, 0,
+						 SNDRV_PCM_HW_PARAM_RATE,
+						 &sai->constraint_rates);
 
 	return ret;
 }
-- 
2.51.0



