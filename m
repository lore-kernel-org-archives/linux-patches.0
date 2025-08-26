Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5D835209A;
	Tue, 26 Aug 2025 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216588; cv=none; b=iegAaDijvtjASMmfx+VOmYZEow4ZeGCsQWhMHdmxrrfdCNJYnQJThg7pNAZxEZhXL6OUXZDKEWnNmkU8Fi6J8z2qkLAzwrWiIWW8+4cognUMtEm4fJXWSibDIlzPnQs5eZfui6EJkLKRI0wDnURntFo8tvuDJfYZR3OrhGmxsU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216588; c=relaxed/simple;
	bh=peOZqkruYxmKEeRsYTXTgsR6DdlAs5Y+Ozum/I/8vn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVb69oIyRPTvini30Pri53m1T95QqeAmCASgt2yCKvkMVtQTQKUl7ORh+F48UIhmtOsh98o7pWANLvLwbxp/3si2oeVuEtMMj/9D28aLqwLhRX2O4LHee5DYiIoIwi8Rc5bOpKdxyjNTtaBVUyfOVpRNtUrrFkLBSiSzH6q+tI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJQOySIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJQOySIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C306C4CEF1;
	Tue, 26 Aug 2025 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216587;
	bh=peOZqkruYxmKEeRsYTXTgsR6DdlAs5Y+Ozum/I/8vn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJQOySIxPgq4H20wIiEKXNNAbvcNWZx8Jq59LWGPCENe60sP5KevqCmQSMSlLIz9+
	 2UrwgfGskr2AVReoL/+T7+yakalpRlOiZJhTvD4pC2KH2pyKCcFslswlqBWDjpzbGP
	 0V7z6WGM5EEvO7veeLcfxMzmXeAAwKicOZsI87Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/644] ASoC: soc-dai.c: add missing flag check at snd_soc_pcm_dai_probe()
Date: Tue, 26 Aug 2025 13:08:47 +0200
Message-ID: <20250826110957.270893307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8165f5537043..703aa9a76d03 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -561,6 +561,9 @@ int snd_soc_pcm_dai_probe(struct snd_soc_pcm_runtime *rtd, int order)
 		if (dai->driver->probe_order != order)
 			continue;
 
+		if (dai->probed)
+			continue;
+
 		if (dai->driver->probe) {
 			int ret = dai->driver->probe(dai);
 
-- 
2.50.1



