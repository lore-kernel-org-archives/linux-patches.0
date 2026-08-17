Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CA93B811F;
	Mon, 17 Aug 2026 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975677; cv=none; b=lVinQ3QK0OhD/UyUpez3jIHFGGyQgHFCiQkpT2zd5cdsqZKUDUnsPIsC1kruKofGgyAGrF3PMNnBLdCR0arqdAUD5+xPes0QnoqZBDmvkrwqLLh5x4fmRiMdw/hKoBCfcd9KHmBjFicvivDiqSF0zOEgnxVnfL13ir0mH8snUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975677; c=relaxed/simple;
	bh=5pGuvfUTbtfIT/zpU5hy5xg7dZpokjtrWBCawhhqgs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8IWldmDfIpsdu5C1rari8fZNwr+yrDxQRQUiX4sAlzU9t5vtmPaAMpwcWIi2g91Uj1vrrnirHgd8giqPiKor3eXI6WlVUc2l01+fbQljQC3fVANUL78pTN/8UzlxDYppwKot7OVGCah04s8vu9maE+4O+tTm694K6xkmlaudJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/K7hN5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/K7hN5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CA31F00A3A;
	Mon, 17 Aug 2026 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975676;
	bh=LSSWSRSEo6H3kEtYd6xQ6/Ka1XkqZFccAj2b7JmRh+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/K7hN5nDThqiOfVVPQGRStwA8IKDbSg5ph6zxXct3QtzCAb9OwvF9xKBtJ2LlY+m
	 vfYacImssrjx7xWj+us64koV1+ZP+P/rf7hB/SY5EP4fiTuLZCjIEhXYPJ7zRkvOzj
	 Zd45sZ5J18scdDRBh+HCwkmVwa0zS6HNz1kih2vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxin Yu <jiaxin.yu@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/389] ASoC: bt-sco: fix bt-sco-pcm-wb dai widget dont connect to the endpoint
Date: Mon, 17 Aug 2026 15:28:30 +0200
Message-ID: <20260817132541.869732807@linuxfoundation.org>
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



