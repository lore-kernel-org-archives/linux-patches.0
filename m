Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839162AE7F;
	Tue, 26 Aug 2025 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218036; cv=none; b=H65qMaFKfbZpwRBgBG99A2b2CxdMQ/hinKjZO3VSSuzdSc5fkcokpBVB3pYmE1dfc4kRKF2srkf20Gko1Z8PSqZ4+mP0hPX3oZpXC5OQ0JNwr5ETne0mmareH1WK++T7qYFjJl56EPfJbWxUdIcBEjWw7TPsdTdYlW3ep9p6fTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218036; c=relaxed/simple;
	bh=4YSpal2R1eQmsg1En29N6SV28ybkWMDoM/doLkF0dCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZetsScgLIFo98EAVrkK9qgToBl8p0AtyntnVDiE0ACkcPHZtPKWfz7IPZ3knXxKj0qLMl4gFa+Lbwn9OCNZ9BSJPu9JpMg3BlhzsKdgPRDO+Cc4GwZdiv4yx6zwYe5W2ravvxLB3fUbmnntn7UE4791eRn1KhPpEJxgUrIaKVao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9HoMX2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9HoMX2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F18C4CEF1;
	Tue, 26 Aug 2025 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218036;
	bh=4YSpal2R1eQmsg1En29N6SV28ybkWMDoM/doLkF0dCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9HoMX2lGa3Rla96TPdpHkzrWA/GOYzrPNXbmSAKT82RtFtHLOoqCgM0FKIf9TH0x
	 UGcyUezg46MuDoW/z6MbCZj0HyYATXD5CNgflM1r92rSgBFbWYns1ZsDhfeUpqG7Cc
	 X9Yr09UTUUtEuBWTy6XRbqKWDLK7Bca7YIY7MBHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/523] ASoC: soc-dai.c: add missing flag check at snd_soc_pcm_dai_probe()
Date: Tue, 26 Aug 2025 13:09:08 +0200
Message-ID: <20250826110932.809360025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 5c5a7521e9364a40fe2c1b67ab79991e3e9085df ]

dai->probed is used at snd_soc_pcm_dai_probe/remove(),
and used to call real remove() function only when it was probed.

	int snd_soc_pcm_dai_probe(...)
	{
		...
		for_each_rtd_dais(rtd, i, dai) {
			...

			if (dai->driver->probe) {
(A)				int ret = dai->driver->probe(dai);

				if (ret < 0)
					return soc_dai_ret(dai, ret);
			}

=>			dai->probed = 1;
		}
		...
	}

	int snd_soc_pcm_dai_remove(...)
	{
		...
		for_each_rtd_dais(rtd, i, dai) {
			...
=>			if (dai->probed &&
			    ...) {
				...
			}

=>			dai->probed = 0;
		}
		...
	}

But on probe() case, we need to check dai->probed before calling
real probe() function at (A), otherwise real probe() might be called
multi times (but real remove() will be called only once).
This patch checks it at probe().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87wn3u64e6.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0e270f32975f ("ASoC: fsl_sai: replace regmap_write with regmap_update_bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index e2db2ad219b8..583b18d0f446 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -488,6 +488,9 @@ int snd_soc_pcm_dai_probe(struct snd_soc_pcm_runtime *rtd, int order)
 		if (dai->driver->probe_order != order)
 			continue;
 
+		if (dai->probed)
+			continue;
+
 		if (dai->driver->probe) {
 			int ret = dai->driver->probe(dai);
 
-- 
2.50.1



