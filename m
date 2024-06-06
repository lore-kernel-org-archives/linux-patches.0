Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2F1198A06;
	Thu,  6 Jun 2024 14:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683343; cv=none; b=h48OHXrCTnaAahJeQzuwNxeO2gSFs6Ee34Nhfdc7fnrs3I1IDTyzsLPhoSgAyn+gzcy2iED7tuHYgtcZP1xdZ5gg4kaMEtP8emLU8znHJ+tzO1MjkzKglmjU9zteyegz7stuBSwR+FKGX+6QrHrRUP8BGohZItGd5t6r0WxkMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683343; c=relaxed/simple;
	bh=N22RFA4pwrq7yI2EEo8CdkYv701tu+4HVGxmG6V1qa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieKQBhKR9o5DeQyuAOR61s2bSRbwscml4V/8sFQBdzwLoDKYeOKqQiNqXuWu71i9uHrxpWsOamBOvt/0HiD+msXuNMQ4iHULynE5Ge8e6RYAQ6ci42rv5eOK/ksbp6twIBoBrWj61r0Acuv0SWqjCKkanYTeNDn7QviXbxURI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/rxV1i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/rxV1i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBBC32782;
	Thu,  6 Jun 2024 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683343;
	bh=N22RFA4pwrq7yI2EEo8CdkYv701tu+4HVGxmG6V1qa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/rxV1i0Ahyjr3EA4fMLmLc1gU96g1QnZl5xUMWOPkzueRHn6vX4qWHpCsS0A/kvS
	 K2GV/0I+ML74x22Bwg9QaEu1/W/xt99+tGltOUG4mpsZP6mvo2YQ+hks0dY22gaSTn
	 2h3edZeigjsiAoWX28AdtzCPiTTj/7B8SgzKmUkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/744] ASoC: mediatek: Assign dummy when codec not specified for a DAI link
Date: Thu,  6 Jun 2024 15:59:16 +0200
Message-ID: <20240606131741.517225578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



