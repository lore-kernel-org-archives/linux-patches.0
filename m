Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3052142E73;
	Thu, 13 Jun 2024 12:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281997; cv=none; b=clyc8z4fWWk+PbF/n+TBF9O/mHjMqG/5Gh0ff9ciTvpt9xs5Inbx9pR6/2rJLWPgcGVBPtny6roY071OwMUX7ZP0+DsSUbigJW3mlpEj77ntE8xcBvUdSsUguQuPUmuDQXl84Dto+KjciSz8PHPmiv+wU6XoelAd4gwRrBP7Hz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281997; c=relaxed/simple;
	bh=T8hi1wZ8wwPfiuVUhNi+HKWtL7Nz15DaziC2OaCbnXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSpPeA3Kinvcs4rIvZGWJMwD3qmGho1NDlD0k2fMCHkOHmx2exEtdKZmSDKOSjAFHaOMb3QfyPduFJzQDdDDwVTQ0ODyZdpwrOZk8AU0p0zdZCeV8ZhUDAj+DTN7bE4ojDplA8jv4ZCbTSfqfqNhu8jJW5B7dCPkPkqwMHHXe2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jG36dYpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jG36dYpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E93C2BBFC;
	Thu, 13 Jun 2024 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281997;
	bh=T8hi1wZ8wwPfiuVUhNi+HKWtL7Nz15DaziC2OaCbnXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jG36dYpds5UGYXihic8RglOd/l0c3yn9EvQpdVXWLG+zinCzSgALSmFOODkDMnpPH
	 Dt2zWftEk9KSv3ANWe8hALg5FltcPy8Ni8IqGERcoQDT/NwDsdq8Pcl91GtxrVbcAC
	 r6GwJKhgDN7EdWdOKWXEsFRfDb0gw9IPWpH/8gIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/402] ASoC: kirkwood: Fix potential NULL dereference
Date: Thu, 13 Jun 2024 13:31:25 +0200
Message-ID: <20240613113307.133916377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



