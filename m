Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F322D7BF;
	Tue,  3 Dec 2024 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239466; cv=none; b=R1tgODHWJiMLDd9ftchcbxAYdJgre5SaZeX/5RKlK0T0aAslktAO7Elxb1AnLVjX2qzydo5Y4pDUHuj39RLZkUVS05dq6RUg6i1gd2rUrc6NThUfSS84yIPmLOJ6eCUTRaZ96qhgwzcaopVN/9dHDpZD7ioosuUxsVY4Vz0VoYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239466; c=relaxed/simple;
	bh=GZR/ntGGEg3o7tTWFMl/PzvDo/p7PvMTFlL/xn9fFTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVKmtj9nog1j+L6lXFqlwfi/Vv6jVAsxF/eNxRSCgYcHyPMd2nXNMWagSxhNYrb1bCc9yEpITUk8FpQdB1IbeYm75hVTKMxoLhq4WECuQ0Y7iGprwZv9V/s7mzV/ztVfzPriqCNySd8E1bLf0pP1fH8fVLWN8Gs0QnjUtpXqD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCje+ksx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCje+ksx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69459C4CECF;
	Tue,  3 Dec 2024 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239465;
	bh=GZR/ntGGEg3o7tTWFMl/PzvDo/p7PvMTFlL/xn9fFTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCje+ksxrxcbwEsiY5J7wTcSrXWKjGMy0KF6DpKuEC0kreRnD3fyR0XZuFZlKX+sQ
	 znkzLJ6x9ChSgwBeM4sw1ySuHbs3pSgFIOKfrHR1ci91cfgvp46V3UWQf7xJj4Sp4n
	 9Qma0ui+rWy436pBUs/IWN1eAYi5kdPIBf4EwAO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Fei Shao <fshao@chromium.org>,
	Trevor Wu <trevor.wu@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 624/817] ASoC: mediatek: Check num_codecs is not zero to avoid panic during probe
Date: Tue,  3 Dec 2024 15:43:16 +0100
Message-ID: <20241203144020.293220092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 2f2020327cc8561d7c520d2f2d9acea84fa7b3a3 ]

Following commit 13f58267cda3 ("ASoC: soc.h: don't create dummy
Component via COMP_DUMMY()"), COMP_DUMMY() became an array with zero
length, and only gets populated with the dummy struct after the card is
registered. Since the sound card driver's probe happens before the card
registration, accessing any of the members of a dummy component during
probe will result in undefined behavior.

This can be observed in the mt8188 and mt8195 machine sound drivers. By
omitting a dai link subnode in the sound card's node in the Devicetree,
the default uninitialized dummy codec is used, and when its dai_name
pointer gets passed to strcmp() it results in a null pointer dereference
and a kernel panic.

In addition to that, set_card_codec_info() in the generic helpers file,
mtk-soundcard-driver.c, will populate a dai link with a dummy codec when
a dai link node is present in DT but with no codec property.

The result is that at probe time, a dummy codec can either be
uninitialized with num_codecs = 0, or be an initialized dummy codec,
with num_codecs = 1 and dai_name = "snd-soc-dummy-dai". In order to
accommodate for both situations, check that num_codecs is not zero
before accessing the codecs' fields but still check for the codec's dai
name against "snd-soc-dummy-dai" as needed.

While at it, also drop the check that dai_name is not null in the mt8192
driver, introduced in commit 4d4e1b6319e5 ("ASoC: mediatek: mt8192:
Check existence of dai_name before dereferencing"), as it is actually
redundant given the preceding num_codecs != 0 check.

Fixes: 13f58267cda3 ("ASoC: soc.h: don't create dummy Component via COMP_DUMMY()")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Acked-by: Trevor Wu <trevor.wu@mediatek.com>
Link: https://patch.msgid.link/20241126-asoc-mtk-dummy-panic-v1-1-42d53e168d2e@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-mt6359.c               | 9 +++++++--
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c | 4 ++--
 sound/soc/mediatek/mt8195/mt8195-mt6359.c               | 9 +++++++--
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index 08ae962afeb92..4eed90d13a532 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -1279,10 +1279,12 @@ static int mt8188_mt6359_soc_card_probe(struct mtk_soc_card_data *soc_card_data,
 
 	for_each_card_prelinks(card, i, dai_link) {
 		if (strcmp(dai_link->name, "DPTX_BE") == 0) {
-			if (strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
+			if (dai_link->num_codecs &&
+			    strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
 				dai_link->init = mt8188_dptx_codec_init;
 		} else if (strcmp(dai_link->name, "ETDM3_OUT_BE") == 0) {
-			if (strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
+			if (dai_link->num_codecs &&
+			    strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
 				dai_link->init = mt8188_hdmi_codec_init;
 		} else if (strcmp(dai_link->name, "DL_SRC_BE") == 0 ||
 			   strcmp(dai_link->name, "UL_SRC_BE") == 0) {
@@ -1294,6 +1296,9 @@ static int mt8188_mt6359_soc_card_probe(struct mtk_soc_card_data *soc_card_data,
 			   strcmp(dai_link->name, "ETDM2_OUT_BE") == 0 ||
 			   strcmp(dai_link->name, "ETDM1_IN_BE") == 0 ||
 			   strcmp(dai_link->name, "ETDM2_IN_BE") == 0) {
+			if (!dai_link->num_codecs)
+				continue;
+
 			if (!strcmp(dai_link->codecs->dai_name, MAX98390_CODEC_DAI)) {
 				/*
 				 * The TDM protocol settings with fixed 4 slots are defined in
diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index 8b323fb199251..de8737dcf53d7 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -1099,7 +1099,7 @@ static int mt8192_mt6359_legacy_probe(struct mtk_soc_card_data *soc_card_data)
 			dai_link->ignore = 0;
 		}
 
-		if (dai_link->num_codecs && dai_link->codecs[0].dai_name &&
+		if (dai_link->num_codecs &&
 		    strcmp(dai_link->codecs[0].dai_name, RT1015_CODEC_DAI) == 0)
 			dai_link->ops = &mt8192_rt1015_i2s_ops;
 	}
@@ -1129,7 +1129,7 @@ static int mt8192_mt6359_soc_card_probe(struct mtk_soc_card_data *soc_card_data,
 		int i;
 
 		for_each_card_prelinks(card, i, dai_link)
-			if (dai_link->num_codecs && dai_link->codecs[0].dai_name &&
+			if (dai_link->num_codecs &&
 			    strcmp(dai_link->codecs[0].dai_name, RT1015_CODEC_DAI) == 0)
 				dai_link->ops = &mt8192_rt1015_i2s_ops;
 	}
diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359.c b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
index 2832ef78eaed7..8ebf6c7502aa3 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -1380,10 +1380,12 @@ static int mt8195_mt6359_soc_card_probe(struct mtk_soc_card_data *soc_card_data,
 
 	for_each_card_prelinks(card, i, dai_link) {
 		if (strcmp(dai_link->name, "DPTX_BE") == 0) {
-			if (strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
+			if (dai_link->num_codecs &&
+			    strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
 				dai_link->init = mt8195_dptx_codec_init;
 		} else if (strcmp(dai_link->name, "ETDM3_OUT_BE") == 0) {
-			if (strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
+			if (dai_link->num_codecs &&
+			    strcmp(dai_link->codecs->dai_name, "snd-soc-dummy-dai"))
 				dai_link->init = mt8195_hdmi_codec_init;
 		} else if (strcmp(dai_link->name, "DL_SRC_BE") == 0 ||
 			   strcmp(dai_link->name, "UL_SRC1_BE") == 0 ||
@@ -1396,6 +1398,9 @@ static int mt8195_mt6359_soc_card_probe(struct mtk_soc_card_data *soc_card_data,
 			   strcmp(dai_link->name, "ETDM2_OUT_BE") == 0 ||
 			   strcmp(dai_link->name, "ETDM1_IN_BE") == 0 ||
 			   strcmp(dai_link->name, "ETDM2_IN_BE") == 0) {
+			if (!dai_link->num_codecs)
+				continue;
+
 			if (!strcmp(dai_link->codecs->dai_name, MAX98390_CODEC_DAI)) {
 				if (!(codec_init & MAX98390_CODEC_INIT)) {
 					dai_link->init = mt8195_max98390_init;
-- 
2.43.0



