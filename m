Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA82D29D9;
	Tue, 15 Jul 2025 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587450; cv=none; b=ek34/eiCG10juttHn1Fh1O3WmLvBg4j39SsdX/3CJ2KB9c5LW04HU/lfXkqn6YfZAkOHK7fdTpBEAJXAQciBS6FwVSfse0/ZXw5lEGMvCO3NRCgtuVBvBWXu/r8kU3twvSYeNp4F14c2QebSrJzIzgiFYu63bx5tHqxNvebvRfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587450; c=relaxed/simple;
	bh=5w7i37qnMkS/iZcVo+vjxllUJ6pUCLMIrXqQwWD6fqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDl44Wvt5SmoJN3GceJE+/FrvZ+RommUZVxlm5A5YFhqsjzPyWFpc3QNrVkV9C/tEJkv1k25FHMrRlfKVEM7pBi/JfI0pJbhaJYz0NpoOTCdNPZBXiHR3hTJQRRmAgGiVMD7ouD1sjC9TD9gZS1/kJ7LFJNyBE4ZfUL4tNnf9nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuXtIhVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuXtIhVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD57C4CEE3;
	Tue, 15 Jul 2025 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587450;
	bh=5w7i37qnMkS/iZcVo+vjxllUJ6pUCLMIrXqQwWD6fqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuXtIhVQRqAKUwrpiU1fVfTxS9Xro59s5upYmbLYsPx/YhwHe4Rui7fq2coA5d8Ca
	 eENwVfjfsabvApzHhFVc424+31VXjKmf0QxB6TBDLN7rJF+gPdnfUll9qx+1rcytkm
	 yQO6AS7JKepVBm4Hkfuqnqjx6uMBaO6ejhscrkew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/208] ALSA: hda: Ignore unsol events for cards being shut down
Date: Tue, 15 Jul 2025 15:12:06 +0200
Message-ID: <20250715130811.523119915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a83afa5f373c..6625643f333e8 100644
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



