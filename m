Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86DD1AC431;
	Thu,  6 Jun 2024 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683322; cv=none; b=R4QraONO9y6EqJQVb2v6/7r0jDGT0c3U/GXcj92M51iVqtD+8YJQcdyhcncMfpOwqGq+8FXb9w1D/FgIpi/b/RynYXi+chnfCXXr7YO6uRSbVJboq6cAtGghKE+NwiTR+cuqKzSNjUYli8/Ey3661j3/puscLPwlqm1pypbkhzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683322; c=relaxed/simple;
	bh=6sPcI5ZeZ7RPhKNYw8/IcFJCNBuZlJcFKY7BQ0bNFNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+joufY5jB4S1bhlY8pMZrQ3Lqx3rwjUrjEC0fL8j/KYoNPIwy3AdcSllMORlCz0s1TU+JR3EPWlKS5kUT3RbLs0YhTH3rsvFXyvlmdzyFKl757KP1i1BUMzmOZtH6F0wwA5a6vWUj+gPPqreXAzUuSVdGiM4cQPsVzNjyvoKXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vosDGJ3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vosDGJ3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AF2C4AF07;
	Thu,  6 Jun 2024 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683322;
	bh=6sPcI5ZeZ7RPhKNYw8/IcFJCNBuZlJcFKY7BQ0bNFNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vosDGJ3M1dGftANJfPrGdjKraFF+sHLmPjnkXV5XLbIAxN1fbvvuW/qVo7HFG5dY7
	 CmTsv6qZ3JrfyNefa+OaA9uU+2vCuKlVcGclTuYWcx9Ei7dzLg4smMbihAJMmpjzvx
	 T/N+coszS4PTq7QIiIRUzVFKo1EmUcfDHEnSwP5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/473] ASoC: kirkwood: Fix potential NULL dereference
Date: Thu,  6 Jun 2024 16:02:11 +0200
Message-ID: <20240606131706.616617197@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit ea60ab95723f5738e7737b56dda95e6feefa5b50 ]

In kirkwood_dma_hw_params() mv_mbus_dram_info() returns NULL if
CONFIG_PLAT_ORION macro is not defined.
Fix this bug by adding NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bb6a40fc5a83 ("ASoC: kirkwood: Fix reference to PCM buffer address")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://msgid.link/r/20240328173337.21406-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index 640cebd2983e2..16d2c9acc33a6 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -182,6 +182,9 @@ static int kirkwood_dma_hw_params(struct snd_soc_component *component,
 	const struct mbus_dram_target_info *dram = mv_mbus_dram_info();
 	unsigned long addr = substream->runtime->dma_addr;
 
+	if (!dram)
+		return 0;
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		kirkwood_dma_conf_mbus_windows(priv->io,
 			KIRKWOOD_PLAYBACK_WIN, addr, dram);
-- 
2.43.0



