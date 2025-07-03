Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395222EE96D;
	Thu,  3 Jul 2025 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554759; cv=none; b=OWNYI3rFWfGKlRTYzvu+RelXc16immj3E08M+BAXmX+J9SGKF8tW8/J+yhoDb4HQmEjR5XP2uO6dopHwSwtFPsvngNEIGuFHA0jWp+eWwcz4qnkMyuheXjnREVus7zYeB0susrE9wwW1KkrnKe3qSKinKWJ6Bow8PLdhTTzoA5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554759; c=relaxed/simple;
	bh=F0ZjKuiEK16Llvg75l5DC9OS992eWlmqTX+bg6JDqKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0XGKeYzE7HfH9fKjWsBTb+7N9TK0iktKmtSzJ++Cg/AhcH1TiyFXCm8OEV3rx/yhD+RFL0z5TlnF64Vz/jKv04FGfYMcy8eTR9IMo+hNb/EEVtIUBmmgG/HJbUEEzuGw07g1LwnLbJKp2jQIQzX522APZLAAsyRknSL7+dOiI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpGLjOYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpGLjOYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE8CC4CEED;
	Thu,  3 Jul 2025 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554759;
	bh=F0ZjKuiEK16Llvg75l5DC9OS992eWlmqTX+bg6JDqKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpGLjOYlmBYyfocoGXU+KYhT1iWazQJXX//HHpDkyAxxSeTZmlXgP9RPWiopxgj0q
	 cqB0JRQuQMutmrrr7WSvVKp+fFf3AI2AfGx83Gv3cVc59l2IENM4uqaLFPP7i5mvP8
	 9zB3B77FB1MOS05n2h+ESiUHR2ZQ/qMNUjywc8Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 070/263] ALSA: hda: Ignore unsol events for cards being shut down
Date: Thu,  3 Jul 2025 16:39:50 +0200
Message-ID: <20250703144007.118530161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 3f100f524e75586537e337b34d18c8d604b398e7 ]

For the classic snd_hda_intel driver, codec->card and bus->card point to
the exact same thing. When snd_card_diconnect() fires, bus->shutdown is
set thanks to azx_dev_disconnect(). card->shutdown is already set when
that happens but both provide basically the same functionality.

For the DSP snd_soc_avs driver where multiple codecs are located on
multiple cards, bus->shutdown 'shortcut' is not sufficient. One codec
card may be unregistered while other codecs are still operational.
Proper check in form of card->shutdown must be used to verify whether
the codec's card is being shut down.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141309.2943404-1-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_bind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 1fef350d821ef..df8f88beddd07 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -44,7 +44,7 @@ static void hda_codec_unsol_event(struct hdac_device *dev, unsigned int ev)
 	struct hda_codec *codec = container_of(dev, struct hda_codec, core);
 
 	/* ignore unsol events during shutdown */
-	if (codec->bus->shutdown)
+	if (codec->card->shutdown || codec->bus->shutdown)
 		return;
 
 	/* ignore unsol events during system suspend/resume */
-- 
2.39.5



