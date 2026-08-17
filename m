Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5173B8D78;
	Mon, 17 Aug 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976752; cv=none; b=Utsa8tyS6a5dLjoP7SquOaa4s67rdcmnwto0qCnJIrY7FxVI4jqlSBJ2i7SWlSpqG9PZlmpR1vmQ9ZlLptVENhzP/wN4GSGuP4y4EC454FBVtf3zd+BxxD2HvXyIK6GyJbQ+VP8v24vlp1E2wImEv/EnLKJvxlFtM9bfQGD/hQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976752; c=relaxed/simple;
	bh=Mvv1MQDeg9aV45m0P6AfrienQxOuIKcekzOd1dXjHGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKWkTnoeBNvF7KlyfmSH/qopZWDZqquHvWSYje+ICjTZJiLwoZIiZNfsmY+XZQrfXx3+NXAy7gkV958FgKRI4MO5DOqEqDtzcf7EWltptLPgHtTSUV7gvnvvgAHGUzxtL7ReWJDizVmTABXt0/6Za4cFfGcNf7Md9/Kc3jRYmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRBIZ3X4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRBIZ3X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6701F000E9;
	Mon, 17 Aug 2026 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976750;
	bh=U54KIKgY0Izm1hiqlE0rVs/wu3sApVpXhRhjvD5s8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRBIZ3X4/96/zqpO/XSlyiIObOiDaRLDD0OYSHhgvMJPGy5SdOxXkrwlGc/Tgae84
	 KYFsmAf2xVoWZo0pTtQJtzos4VA8hig1qObKUTskVVLiXVXPqnMZJkgky2m874ZLXI
	 4TIq95aoLQF6Fh07QjgXsqChnKhhQrMFDyEDuruE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxin Yu <jiaxin.yu@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/456] ASoC: bt-sco: fix bt-sco-pcm-wb dai widget dont connect to the endpoint
Date: Mon, 17 Aug 2026 15:28:00 +0200
Message-ID: <20260817132543.635258837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxin Yu <jiaxin.yu@mediatek.com>

[ Upstream commit 8f2b025abc31bc15d38657d1286d7470bbbd5efa ]

This patch fix the second dai driver's dai widget can't connect to the
endpoint. Because "bt-sco-pcm" and "bt-sco-pcm-wb" dai driver have the
same stream_name, so it will cause they have the same widget name.
Therefor it will just create only one route when do snd_soc_dapm_add_route
that only find the widget through the widget name.

Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Link: https://lore.kernel.org/r/20220302013533.29068-1-jiaxin.yu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0b604e886ece ("ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/bt-sco.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/bt-sco.c b/sound/soc/codecs/bt-sco.c
index 4d286844e3c832..cf17b9741bd832 100644
--- a/sound/soc/codecs/bt-sco.c
+++ b/sound/soc/codecs/bt-sco.c
@@ -13,11 +13,15 @@
 static const struct snd_soc_dapm_widget bt_sco_widgets[] = {
 	SND_SOC_DAPM_INPUT("RX"),
 	SND_SOC_DAPM_OUTPUT("TX"),
+	SND_SOC_DAPM_AIF_IN("BT_SCO_RX", "Playback", 0,
+			    SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("BT_SCO_TX", "Capture", 0,
+			     SND_SOC_NOPM, 0, 0),
 };
 
 static const struct snd_soc_dapm_route bt_sco_routes[] = {
-	{ "Capture", NULL, "RX" },
-	{ "TX", NULL, "Playback" },
+	{ "BT_SCO_TX", NULL, "RX" },
+	{ "TX", NULL, "BT_SCO_RX" },
 };
 
 static struct snd_soc_dai_driver bt_sco_dai[] = {
-- 
2.53.0



