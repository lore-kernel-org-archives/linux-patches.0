Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629445517A;
	Thu, 30 Jul 2026 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428318; cv=none; b=cfmmY/fsa4QWZU2jPR/Cr4ChyuZz+426K6+cK1fSWLilR78PiP/GQbJUrwMQz9zhiUu2kWPJpQ+ew7am/3v1WRb2/61cpx0jQmPWb2GAtbN1zZcnfpXiyo8GC9UEm5TgGM17NL3ROLI09mzdGQ5O7mRthpI6DvS62CIqVcbpi7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428318; c=relaxed/simple;
	bh=FRqFnbLGOQQXA7IjGn1sjAdU604kIC0qEVcmlk7cEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q05mA62SWfk+Oj4t6MN5H3yqSGd790AKJjPhF5Cbs9/kWyy730Gbp+CUncOhcdQpHk6F+ngFGTQWbVB/mOfhNUsbahr6q3LVtr/3stJlwqxFLq+JmhS0JXxjvtGMdu2U4g2eMnOfy1sp2rLck/R/Dbnw8lDmGJiP2nCULOqXw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+WpC6ij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+WpC6ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047131F00A3A;
	Thu, 30 Jul 2026 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428316;
	bh=qbSz+kzTzLOyHhZDu2LwoxjjnCvZUc4Ogm1eELpoUDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+WpC6ij8SWGzBrAe7z4JNwTCVGvaidJLNPJhYFQj8hqS2fAZj444iGZEShbmlxu8
	 N1I1/oA830z5oJOOeS5TqmpkxtUvFnRzMNKtdZ54tqArHWPhQGRZMHitSNljpsySYs
	 QhmIoGkSomKonV5mB/JJiaRzHMRFA6MfwjzZDmHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 480/484] ASoC: mediatek: mt8195: Add platform entry for ETDM1_OUT_BE dai link
Date: Thu, 30 Jul 2026 16:16:17 +0200
Message-ID: <20260730141433.922504520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 282a4482e198e03781c152c88aac8aa382ef9a55 upstream.

Commit e70b8dd26711 ("ASoC: mediatek: mt8195: Remove afe-dai component
and rework codec link") removed the codec entry for the ETDM1_OUT_BE
dai link entirely instead of replacing it with COMP_EMPTY(). This worked
by accident as the remaining COMP_EMPTY() platform entry became the codec
entry, and the platform entry became completely empty, effectively the
same as COMP_DUMMY() since snd_soc_fill_dummy_dai() doesn't do anything
for platform entries.

This causes a KASAN out-of-bounds warning in mtk_soundcard_common_probe()
in sound/soc/mediatek/common/mtk-soundcard-driver.c:

	for_each_card_prelinks(card, i, dai_link) {
		if (adsp_node && !strncmp(dai_link->name, "AFE_SOF", strlen("AFE_SOF")))
			dai_link->platforms->of_node = adsp_node;
		else if (!dai_link->platforms->name && !dai_link->platforms->of_node)
			dai_link->platforms->of_node = platform_node;
	}

where the code expects the platforms array to have space for at least one entry.

Add an COMP_EMPTY() entry so that dai_link->platforms has space.

Fixes: e70b8dd26711 ("ASoC: mediatek: mt8195: Remove afe-dai component and rework codec link")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20240624061257.3115467-1-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8195/mt8195-mt6359.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -939,6 +939,7 @@ SND_SOC_DAILINK_DEFS(ETDM2_IN_BE,
 
 SND_SOC_DAILINK_DEFS(ETDM1_OUT_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM1_OUT")),
+		     DAILINK_COMP_ARRAY(COMP_EMPTY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM2_OUT_BE,


