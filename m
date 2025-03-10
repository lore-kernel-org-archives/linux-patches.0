Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4F2253FE;
	Mon, 10 Mar 2025 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627813; cv=none; b=Sbt/I2YtVTkzalipEksiMdvztMEQl3JojZWPiL2Sf1ArtR+b96uDE7S4lCYic/VrAn25GK7ooeU5LpvDDc5qXA3VgOWH3mpQAxbwh8PX0hg4kGKGXdnfUvjUNYU02I/sN8zdEwuUi4JgseqwbHg4QSb2SLVFpE9suFF4Pd5adtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627813; c=relaxed/simple;
	bh=zy6TLv4fCa0/HqRGiRmEJDCON+Bm3LxFmrX7Jcw0mJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMeCbiZw+Bxz4JgdjcCxyyfgecCsifCu/8xyv85cF9cVV+uolfla6YHxRhzruFG+9o5NgOTHClR4ENP3IJs5qNsk4KW5WcXuKpvyGiUdD8cZQKbUMomRujRNMoIKrnE29ny6cUdm9VOXJTrWOZU1O5NuBMtYsFzsdi64MXs+/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtilBSGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtilBSGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD3C4CEE5;
	Mon, 10 Mar 2025 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627812;
	bh=zy6TLv4fCa0/HqRGiRmEJDCON+Bm3LxFmrX7Jcw0mJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtilBSGAGHHC79XVUn6uGE35aEd1+pMZwsnN1h5v28jaiZYDFmaxT9WhMwqZVQiuI
	 iwtynw5yeWJB+aXVHFtjhS5hDS24H1VkiHvbh8mQy/Ywd2j9zExUGj+t1LDRdpyDmi
	 z8j0xV1YND6oY1eofVJXp9n9uA7CfkleHr4cYSsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 259/269] ALSA: hda: realtek: fix incorrect IS_REACHABLE() usage
Date: Mon, 10 Mar 2025 18:06:52 +0100
Message-ID: <20250310170508.114092105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit d0bbe332669c5db32c8c92bc967f8e7f8d460ddf upstream.

The alternative path leads to a build error after a recent change:

sound/pci/hda/patch_realtek.c: In function 'alc233_fixup_lenovo_low_en_micmute_led':
include/linux/stddef.h:9:14: error: called object is not a function or function pointer
    9 | #define NULL ((void *)0)
      |              ^
sound/pci/hda/patch_realtek.c:5041:49: note: in expansion of macro 'NULL'
 5041 | #define alc233_fixup_lenovo_line2_mic_hotkey    NULL
      |                                                 ^~~~
sound/pci/hda/patch_realtek.c:5063:9: note: in expansion of macro 'alc233_fixup_lenovo_line2_mic_hotkey'
 5063 |         alc233_fixup_lenovo_line2_mic_hotkey(codec, fix, action);

Using IS_REACHABLE() is somewhat questionable here anyway since it
leads to the input code not working when the HDA driver is builtin
but input is in a loadable module. Replace this with a hard compile-time
dependency on CONFIG_INPUT. In practice this won't chance much
other than solve the compiler error because it is rare to require
sound output but no input support.

Fixes: f603b159231b ("ALSA: hda/realtek - add supported Mic Mute LED for Lenovo platform")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250304142620.582191-1-arnd@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/Kconfig         |    1 +
 sound/pci/hda/patch_realtek.c |    5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -208,6 +208,7 @@ comment "Set to Y if you want auto-loadi
 
 config SND_HDA_CODEC_REALTEK
 	tristate "Build Realtek HD-audio codec support"
+	depends on INPUT
 	select SND_HDA_GENERIC
 	select SND_HDA_GENERIC_LEDS
 	select SND_HDA_SCODEC_COMPONENT
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5002,7 +5002,6 @@ static void alc298_fixup_samsung_amp_v2_
 		alc298_samsung_v2_init_amps(codec, 4);
 }
 
-#if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
 {
@@ -5111,10 +5110,6 @@ static void alc233_fixup_lenovo_line2_mi
 		spec->kb_dev = NULL;
 	}
 }
-#else /* INPUT */
-#define alc280_fixup_hp_gpio2_mic_hotkey	NULL
-#define alc233_fixup_lenovo_line2_mic_hotkey	NULL
-#endif /* INPUT */
 
 static void alc269_fixup_hp_line1_mic1_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)


