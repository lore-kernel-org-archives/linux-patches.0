Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0693A47A879;
	Tue, 21 Jul 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656433; cv=none; b=c2qi1vSyi+psu7JGZmTmQZlG9FrLs9oHx3TdAiMnY4rM5TZ1DF2kuR+BN5RPx2mO2TD1YYXTWtchQMt849GpBN/B+WsBwiqNDsttBVk/AFRsiLbcTCDbrF8wdBKI5PzcQiy9l7Jr4otuNKCzR+O5DeyKE+KgiShV/wZXSOxM9Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656433; c=relaxed/simple;
	bh=dY0UZz1i2K2cdtp3wED5VS9NIiIh2Auqg+ryAouhfiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB3vgr1VoUkmwEF3VIbRWvCCQC9a7sU4vqzHJke8uIUqTgXGcMFd/xMlJy4dw8bNNxgfOMYxXnSyQJCpBNhjbPGBXDF1bvzd8sRMRwNxjss2/xR6Tx0Vs+symz6GT8fywO2thJbS/EySoCLdFS3m9i5ML9KO8d4RYSVfBGg0uEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yriEzQqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yriEzQqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA301F000E9;
	Tue, 21 Jul 2026 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656431;
	bh=aubjM88uBQeFBwoDwUCrdBIDCZ95bu9aI9cskVhuswE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yriEzQqJbakpaJ0SItDpwBlCsqTzA+kvlIX3koV0/9Lqz9333uUNn8wC8KTugf9BI
	 ZsdUW6fwvr8IlaL5y7VVTI7gNyLmNqY6y6jhWptOVOEYEwCNQ6LWTTFECnARXseWAO
	 o4/fKEvYQVtge9ce49KZgOHpibhAqh2XS/yjMD/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0386/1611] ASoC: amd: acp-sdw-legacy: Bound DAI link iteration
Date: Tue, 21 Jul 2026 17:08:22 +0200
Message-ID: <20260721152523.891962453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit d49ecdf327cc91062d2f80996a163cf65fda1e60 ]

create_sdw_dailinks() walks soc_dais until it finds an entry with
initialised cleared, but soc_dais is allocated with exactly num_ends
entries. If all entries are initialised, the loop reads past the end of
the array.

This was reported by KASAN:

  BUG: KASAN: slab-out-of-bounds in mc_probe+0x26b3/0x2774 [snd_acp_sdw_legacy_mach]
  Read of size 1

Pass the allocated entry count to create_sdw_dailinks() and stop before
reading past the array.

Fixes: 2981d9b0789c ("ASoC: amd: acp: add soundwire machine driver for legacy stack")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://patch.msgid.link/20260528082110.915549-1-aaron.ma@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index e87d9e9991e1c6..ac955a9b51dc31 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -287,13 +287,14 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 static int create_sdw_dailinks(struct snd_soc_card *card,
 			       struct snd_soc_dai_link **dai_links, int *be_id,
-			       struct asoc_sdw_dailink *soc_dais,
+			       struct asoc_sdw_dailink *soc_dais, int num_dais,
 			       struct snd_soc_codec_conf **codec_conf)
 {
 	struct device *dev = card->dev;
 	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	struct amd_mc_ctx *amd_ctx = (struct amd_mc_ctx *)ctx->private;
 	struct snd_soc_dai_link_component *sdw_platform_component;
+	int i;
 	int ret;
 
 	sdw_platform_component = devm_kzalloc(dev, sizeof(struct snd_soc_dai_link_component),
@@ -313,7 +314,7 @@ static int create_sdw_dailinks(struct snd_soc_card *card,
 	}
 
 	/* generate DAI links by each sdw link */
-	while (soc_dais->initialised) {
+	for (i = 0; i < num_dais && soc_dais->initialised; i++) {
 		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, soc_dais, dai_links,
@@ -438,7 +439,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	/* SDW */
 	if (sdw_be_num) {
 		ret = create_sdw_dailinks(card, &dai_links, &be_id,
-					  soc_dais, &codec_conf);
+					  soc_dais, num_ends, &codec_conf);
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



