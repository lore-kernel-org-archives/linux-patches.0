Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C406E17727;
	Mon, 27 May 2024 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838369; cv=none; b=E3QEUm0+KbeeR643WsQwc1xTRinUncEKwAn0yve+nucVsqSC8eoLUEZp4ETSHmWRwJHA2goEYMFYp899EvZq1N49VPPsil2FTQwBmksCIW8cT1jy/+1ZvHkfdEGXWFio0gIKwx3e0HDc+reDmdz2hnUmhKaucaE2PYpLvtIDGQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838369; c=relaxed/simple;
	bh=jiWSFjRH56O1YjdBWWMEaoi9p6+tqbxVSIkOa7cZ+Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdjKeF80kbpIaX9oto0l178RnyBdzOt65hIFuS09419a6wszscQA2rj9Q6DbUxtTI4u/hvnZYnyA9meDUk6OyNmQhMA+UA+gtHJZ9V5u8PR1xxzj1D5+ITh1wJ2ahxGjUYpJYPrb55xYrDoJW+DD0OzVYUJjZFi7gEaLiyI4haY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7EZ+02R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7EZ+02R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7B0C2BBFC;
	Mon, 27 May 2024 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838369;
	bh=jiWSFjRH56O1YjdBWWMEaoi9p6+tqbxVSIkOa7cZ+Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7EZ+02RZVIMX1qNTbVbIbk4h1RzfFlOAE1H9pjdh3fIFjGsUK+9f0XBHB6x8UfxR
	 cbsdAUylIvGPBZhupMbGRYhb/eu1755ATIwUbE9rWFlvxLI6qKcGzk1McRStfIDbF8
	 0/pQqFbAYVwLN0Ep3AEaDzQoBAHwuiVDEgqsPGz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 367/493] ASoC: mediatek: Assign dummy when codec not specified for a DAI link
Date: Mon, 27 May 2024 20:56:09 +0200
Message-ID: <20240527185642.290489123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



