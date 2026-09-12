Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32702365A0B;
	Sat, 12 Sep 2026 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203459; cv=none; b=YNf73sBudbQGghDblfFXnY8aNgvbjp38fGaLQY3UZ1RG3Th9O17omc9hJa//QwbYFwQi0ZSFy2CWQfAHMs/KbnN9osEfDGDlVKLgfdTXWgCwaJTS6GMyJxrBOAtyf7jXVyUBFzQVX2w8q17jI6wNWQjF/BGHcZut3EQtiaismQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203459; c=relaxed/simple;
	bh=yA77G2o7CEOz+DzXCKqyyOLWCJ5V+pMvFXChDpfcLtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDZqJAxf7L9+ESLEGUxcD2HeveZ2VrgXEA/iZiqgHgtFaK4HQVZds8klls7A6MJGDvqzwbkJ7/KIM8pKvSxVXSAxTZ+IN7hfL+lDVS5HWPyFxyDoBhYCREtIqyE3CwvsTFENCaQAJ5RiS0dZDDbvbTpc2wsDcoLpCkzGh7MI040=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcKV0gN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcKV0gN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA05C1F000FF;
	Sat, 12 Sep 2026 08:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203457;
	bh=locLGhtXKjVW1dVvf8NkVkCuewCZwojqaj4RnZQN2nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcKV0gN5HaiNIABLdOhAUWyiizm20UB/br6f2heDvyYPn9TbSI58GYWJGmdsV8ze1
	 kEnwbkel9tk9oMmg9aHEWwJW51wWO8eRwjqtZPbTpds36RgLb240Bht6WLQANL3S41
	 zl1sa5mJ9iCdwsKm7T9C6n8CbxqsNccZeIuGKL0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1410/1815] ASoC: spacemit: advertise only DMA-backed DAI streams
Date: Sat, 12 Sep 2026 08:52:40 +0200
Message-ID: <20260912065722.125030940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 0a91bb72980e4aa5f0c1be33d691e7767d7db9ed ]

The static DAI template initializes both playback and capture stream
capabilities before dma-names is examined. As a result,
snd_soc_dai_stream_valid() considers both directions valid even when the
device only provides a single DMA channel.

Move the playback and capture capability initialization into
spacemit_i2s_init_dai(), where it is performed only for the stream
directions backed by a corresponding DMA channel. This preserves the
existing capabilities for devices with both "tx" and "rx" DMA channels,
while preventing unsupported stream directions from being advertised.

Initialize rate_min and rate_max together with the other stream
capabilities to preserve the existing rate constraints.

Fixes: fce217449075 ("ASoC: spacemit: add i2s support for K1 SoC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260805064348.44283-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/spacemit/k1_i2s.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/sound/soc/spacemit/k1_i2s.c b/sound/soc/spacemit/k1_i2s.c
index 4247d8d3a6370..67c03b8a5e0c4 100644
--- a/sound/soc/spacemit/k1_i2s.c
+++ b/sound/soc/spacemit/k1_i2s.c
@@ -347,22 +347,6 @@ static const struct snd_soc_dai_ops spacemit_i2s_dai_ops = {
 
 static struct snd_soc_dai_driver spacemit_i2s_dai = {
 	.ops = &spacemit_i2s_dai_ops,
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SPACEMIT_PCM_RATES,
-		.rate_min = SNDRV_PCM_RATE_8000,
-		.rate_max = SNDRV_PCM_RATE_48000,
-		.formats = SPACEMIT_PCM_FORMATS,
-	},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SPACEMIT_PCM_RATES,
-		.rate_min = SNDRV_PCM_RATE_8000,
-		.rate_max = SNDRV_PCM_RATE_48000,
-		.formats = SPACEMIT_PCM_FORMATS,
-	},
 	.symmetric_rate = 1,
 };
 
@@ -392,6 +376,8 @@ static int spacemit_i2s_init_dai(struct spacemit_i2s_dev *i2s,
 		dai->playback.channels_min = 1;
 		dai->playback.channels_max = 2;
 		dai->playback.rates = SPACEMIT_PCM_RATES;
+		dai->playback.rate_min = SNDRV_PCM_RATE_8000;
+		dai->playback.rate_max = SNDRV_PCM_RATE_48000;
 		dai->playback.formats = SPACEMIT_PCM_FORMATS;
 
 		i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
@@ -404,6 +390,8 @@ static int spacemit_i2s_init_dai(struct spacemit_i2s_dev *i2s,
 		dai->capture.channels_min = 1;
 		dai->capture.channels_max = 2;
 		dai->capture.rates = SPACEMIT_PCM_RATES;
+		dai->capture.rate_min = SNDRV_PCM_RATE_8000;
+		dai->capture.rate_max = SNDRV_PCM_RATE_48000;
 		dai->capture.formats = SPACEMIT_PCM_FORMATS;
 
 		i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-- 
2.53.0



