Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C78D17E90E;
	Mon, 27 May 2024 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837051; cv=none; b=FkgRIUGk8FhJ0fJdJJrgHvjP4wNBnBdh/fe00t4D8etCM0lN4RyJKwxJVyGs1wx0Gg7LymNTjwgfAh6TQDLrc+PWnzmIOHd/Wod7g++Eefsitk+zS3bqFHMMW10wBai0CqLeLx2Gs0msSA7wJ4MWeDxoGtF2BVJDVnR5tMB5ilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837051; c=relaxed/simple;
	bh=Fho2e9qA7nqM77EaKG5js2mdfd3jBAh9yt9zFeepYa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lupgd+YEOvCvfruPHAeO7MOnHby3TNn5T1+DkESP7UBlkFvD4vD3T7kSjH4+PDYjlQ2/Di7ANy271hIj8g4fGf9poKRPaLASeFu3OXWmth4ER+uPEt3jrM4UOsZ4oX44faf9N0D8KCXM9zh8Ii1rZdwg52ExfDt9oo7IBmY/NzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymjeCRDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymjeCRDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B924C2BBFC;
	Mon, 27 May 2024 19:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837050;
	bh=Fho2e9qA7nqM77EaKG5js2mdfd3jBAh9yt9zFeepYa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymjeCRDAOvlwyvfGa5OuWcOkmjE68+EOeZv5vNTiVTFHXhMNsKio96qiMiyR90UiG
	 s1fahr8hdHMZHSVOgfuV00XR/uzdMIsLcEVKP3iOajn8/hvfPaCwK46kjCqDwS1WXl
	 KK1Sc7XVYh2ewTPBGmjELXtveR5Sle5l1wHi7eLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 291/427] ASoC: mediatek: Assign dummy when codec not specified for a DAI link
Date: Mon, 27 May 2024 20:55:38 +0200
Message-ID: <20240527185629.555111583@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 5f39231888c63f0a7708abc86b51b847476379d8 ]

MediaTek sound card drivers are checking whether a DAI link is present
and used on a board to assign the correct parameters and this is done
by checking the codec DAI names at probe time.

If no real codec is present, assign the dummy codec to the DAI link
to avoid NULL pointer during string comparison.

Fixes: 4302187d955f ("ASoC: mediatek: common: add soundcard driver common code")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://msgid.link/r/20240313110147.1267793-5-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-soundcard-driver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/common/mtk-soundcard-driver.c b/sound/soc/mediatek/common/mtk-soundcard-driver.c
index a58e1e3674dec..000a086a8cf44 100644
--- a/sound/soc/mediatek/common/mtk-soundcard-driver.c
+++ b/sound/soc/mediatek/common/mtk-soundcard-driver.c
@@ -22,7 +22,11 @@ static int set_card_codec_info(struct snd_soc_card *card,
 
 	codec_node = of_get_child_by_name(sub_node, "codec");
 	if (!codec_node) {
-		dev_dbg(dev, "%s no specified codec\n", dai_link->name);
+		dev_dbg(dev, "%s no specified codec: setting dummy.\n", dai_link->name);
+
+		dai_link->codecs = &snd_soc_dummy_dlc;
+		dai_link->num_codecs = 1;
+		dai_link->dynamic = 1;
 		return 0;
 	}
 
-- 
2.43.0



