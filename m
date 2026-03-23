Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD049396B85;
	Mon, 23 Mar 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282477; cv=none; b=ffv1vfFOBRoxnIIGV/6IW3tDVIpvgpixIg3fVw7gYHaQS2EbBe8LUlLRAe6hPKupq2Z7z2HEbKzKyYBHEhBFObhIgxQhBlZdeOKH/ZHQ0TPRj8Je/bGGrTD1I3llgowwuauyY5aTXoWZ20q5XmUt7uMELLmc++31qy6QS8/VNmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282477; c=relaxed/simple;
	bh=pjytYdGb+uh8058AD5oKer1+41NSrUDtJNBG77mhGyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwUMffNB79JZOOPAgug++tt0IfPr1Jhwh6RDcrhJ6kYCG6/J3rzCC9ToeYoijZEf4a0UZGTJ100vjhLNboWpdTy9ITi2rRwMej5l9i2T6LxrmcxZi+y/NrIv7HTRcvKtlgBXMCOu47z3rCa5+wEJ0XNTdbYgZRZRImsNhVO7nRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiYmyG59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiYmyG59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F86DC4CEF7;
	Mon, 23 Mar 2026 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282477;
	bh=pjytYdGb+uh8058AD5oKer1+41NSrUDtJNBG77mhGyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiYmyG59/oBuS1suWNLkBiic6rP51Uxwl6imaHe8kMuR1QcFsJ15SppvMX+FaCopH
	 6Lhpy5iUg+2p+EmYd2YyJSJQXQIq2fQQx3WgaRvt/zdDv6z2TkzN0w7izimfx9FTyy
	 +BKFzAhKe3xIxdc1ctE+5zmSsxy0l3L8RyP6InGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/481] ASoC: core: Do not call link_exit() on uninitialized rtd objects
Date: Mon, 23 Mar 2026 14:42:32 +0100
Message-ID: <20260323134529.366025805@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit dd9f9cc1e6b9391140afa5cf27bb47c9e2a08d02 ]

On init we have sequence:

	for_each_card_prelinks(card, i, dai_link) {
		ret = snd_soc_add_pcm_runtime(card, dai_link);

	ret = init_some_other_things(...);
	if (ret)
		goto probe_end:

	for_each_card_rtds(card, rtd) {
		ret = soc_init_pcm_runtime(card, rtd);

probe_end:

while on exit:
	for_each_card_rtds(card, rtd)
		snd_soc_link_exit(rtd);

If init_some_other_things() step fails due to error we end up with
not fully setup rtds and try to call snd_soc_link_exit on them, which
depending on contents on .link_exit handler, can end up dereferencing
NULL pointer.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230929103243.705433-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 95bc5c225513 ("ASoC: soc-core: flush delayed work before removing DAIs and widgets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h  |  2 ++
 sound/soc/soc-core.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index d63ac6d9fbdc4..015d5fff397fa 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1110,6 +1110,8 @@ struct snd_soc_pcm_runtime {
 	unsigned int pop_wait:1;
 	unsigned int fe_compr:1; /* for Dynamic PCM */
 
+	bool initialized;
+
 	int num_components;
 	struct snd_soc_component *components[]; /* CPU/Codec/Platform */
 };
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index d42cba7de0a3b..835a9251c074b 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1256,7 +1256,7 @@ static int soc_init_pcm_runtime(struct snd_soc_card *card,
 	snd_soc_runtime_get_dai_fmt(rtd);
 	ret = snd_soc_runtime_set_dai_fmt(rtd, dai_link->dai_fmt);
 	if (ret)
-		return ret;
+		goto err;
 
 	/* add DPCM sysfs entries */
 	soc_dpcm_debugfs_add(rtd);
@@ -1281,17 +1281,26 @@ static int soc_init_pcm_runtime(struct snd_soc_card *card,
 	/* create compress_device if possible */
 	ret = snd_soc_dai_compress_new(cpu_dai, rtd, num);
 	if (ret != -ENOTSUPP)
-		return ret;
+		goto err;
 
 	/* create the pcm */
 	ret = soc_new_pcm(rtd, num);
 	if (ret < 0) {
 		dev_err(card->dev, "ASoC: can't create pcm %s :%d\n",
 			dai_link->stream_name, ret);
-		return ret;
+		goto err;
 	}
 
-	return snd_soc_pcm_dai_new(rtd);
+	ret = snd_soc_pcm_dai_new(rtd);
+	if (ret < 0)
+		goto err;
+
+	rtd->initialized = true;
+
+	return 0;
+err:
+	snd_soc_link_exit(rtd);
+	return ret;
 }
 
 static void soc_set_name_prefix(struct snd_soc_card *card,
@@ -1894,7 +1903,8 @@ static void soc_cleanup_card_resources(struct snd_soc_card *card)
 
 	/* release machine specific resources */
 	for_each_card_rtds(card, rtd)
-		snd_soc_link_exit(rtd);
+		if (rtd->initialized)
+			snd_soc_link_exit(rtd);
 	/* remove and free each DAI */
 	soc_remove_link_dais(card);
 	soc_remove_link_components(card);
-- 
2.51.0



