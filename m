Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587773B811F;
	Mon, 17 Aug 2026 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975680; cv=none; b=R+SCBwp38afh8sq99rNoCdG8ZkycyQ0fAPyarrlKQkn2EUN6qUmqVzDXa2G8UmfluUq5MUXJyDmreRyBUEM91VkwJ7Tq8qu9ykLRWGqlchjhrZpUboohadcY04ObTqhfWakjUc5gRFU1UTiRRkx71OjV6mW1Pd8+LNTQCsppzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975680; c=relaxed/simple;
	bh=mhXtmMilWuy+vY5+VQtiiBINZ0D30HkzhgHTxyH3Zmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOfgVE/ObWHNYUuiC1uT2vsNkZCcbrCKh/LynWThfnX6Oi4LHPme/Qudj2OFklg/HWRmw4PFrmhokC6CxfngymEHEmNFhq0fhiGehQON75DxJmMKPymyC/Skm67/e1ZsLXbO/svOvnl9aTZd5HhymV2xIgbf5semEVasPw/mYJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0Y4hw1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0Y4hw1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCCC1F000E9;
	Mon, 17 Aug 2026 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975679;
	bh=6cOA3h916lNTolpbXImkRe0bKnRStJOonrkkqXsJ6R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0Y4hw1Wrd5h597NCpfNT4heNIwK+zfvcQCSe/0SMAvXRhELzHzeOLeJvKSgxDssI
	 W+11qNdowHjBUt7xwN1Cpz1Kjl2ZLbriRdOe1FrdDI8/w+JKt/WV+3TqfMC+z9r0rU
	 emJUim2yNUQLtqw1pwvSXGNvutu/tHNvxXm2W5Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/389] ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI
Date: Mon, 17 Aug 2026 15:28:31 +0200
Message-ID: <20260817132541.909715618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0b604e886ece11b71c4daaeccc512c784b89b014 ]

The bt-sco-pcm-wb DAI uses the same stream_name strings as bt-sco-pcm
("Playback" and "Capture"). This causes duplicate DAPM AIF widget
names within the same component, leading to debugfs warnings:

  debugfs: 'Playback' already exists in 'dapm'
  debugfs: 'Capture' already exists in 'dapm'

Give the wideband DAI distinct stream names ("WB Playback" and
"WB Capture") and add corresponding DAPM AIF widgets and routes for
them.

Fixes: 5947e1b4992e ("ASoC: bt-sco: extend rate and add a general compatible string")
Assisted-by: VeroCoder:claude-sonnet-4-5
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715100620.1387159-1-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/bt-sco.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/bt-sco.c b/sound/soc/codecs/bt-sco.c
index cf17b9741bd832..7c42fcdee27bb7 100644
--- a/sound/soc/codecs/bt-sco.c
+++ b/sound/soc/codecs/bt-sco.c
@@ -17,11 +17,17 @@ static const struct snd_soc_dapm_widget bt_sco_widgets[] = {
 			    SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("BT_SCO_TX", "Capture", 0,
 			     SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("BT_SCO_RX_WB", "WB Playback", 0,
+			    SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("BT_SCO_TX_WB", "WB Capture", 0,
+			     SND_SOC_NOPM, 0, 0),
 };
 
 static const struct snd_soc_dapm_route bt_sco_routes[] = {
 	{ "BT_SCO_TX", NULL, "RX" },
 	{ "TX", NULL, "BT_SCO_RX" },
+	{ "BT_SCO_TX_WB", NULL, "RX" },
+	{ "TX", NULL, "BT_SCO_RX_WB" },
 };
 
 static struct snd_soc_dai_driver bt_sco_dai[] = {
@@ -45,14 +51,14 @@ static struct snd_soc_dai_driver bt_sco_dai[] = {
 	{
 		.name = "bt-sco-pcm-wb",
 		.playback = {
-			.stream_name = "Playback",
+			.stream_name = "WB Playback",
 			.channels_min = 1,
 			.channels_max = 1,
 			.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE,
 		},
 		.capture = {
-			 .stream_name = "Capture",
+			 .stream_name = "WB Capture",
 			.channels_min = 1,
 			.channels_max = 1,
 			.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000,
-- 
2.53.0



