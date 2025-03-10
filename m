Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54DF18DB24;
	Mon, 10 Mar 2025 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628227; cv=none; b=KzF1eLHPE8BMskz0i4ONMJwnFEykZOEXf6iVcw5ECaHGufLsraOfFLpGm2Is755bozqi3HZja5xrT20Na0OA7SsTysHtSFhevMmo1WPlhYuEGO6qnuusKgP0COT3M0NaPwohBlrsW7xqazHEoU8E3xqGhf4HznODbT/HMQFdauc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628227; c=relaxed/simple;
	bh=z2OwOhvMreIMK1159BZVtr4gqpVc7upS1+RlpR4POgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxqWXrtKjTwcHmpd9zRtnhCWeYx4a4N24WlprANFlvKYx/4Y4xPNAwszsn//4MzFozSTDDWK7jW6yWoBI7KakCm+Hv9hbU+rUPfhai7ndCINeCGrYPI0tynWhzIyoDPBomedTbao6NRNm63nxhweP+Fy5MbqC/zoY1VfRF3DFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bivCL5qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bivCL5qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B729C4CEE5;
	Mon, 10 Mar 2025 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628227;
	bh=z2OwOhvMreIMK1159BZVtr4gqpVc7upS1+RlpR4POgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bivCL5qCkyp4iwo/30P0Om/hC7zCj/lBZG10F86clPwco2DHqZadLOA6ldLEP/VPo
	 RuTlrZ0EO7eEssTX4i+3aH3X1adAZAPSr0EArAUE9aAYVpFlB3pU4CMG2MQ4coPpsk
	 29d/bDhdNI6GZ+3AwRvxEkUkcIZdAjFu9QvOZQUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 130/145] ALSA: hda: realtek: fix incorrect IS_REACHABLE() usage
Date: Mon, 10 Mar 2025 18:07:04 +0100
Message-ID: <20250310170440.012879200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,6 +183,7 @@ comment "Set to Y if you want auto-loadi
 
 config SND_HDA_CODEC_REALTEK
 	tristate "Build Realtek HD-audio codec support"
+	depends on INPUT
 	select SND_HDA_GENERIC
 	select SND_HDA_GENERIC_LEDS
 	help
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4865,7 +4865,6 @@ static void alc298_fixup_samsung_amp(str
 	}
 }
 
-#if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
 {
@@ -4974,10 +4973,6 @@ static void alc233_fixup_lenovo_line2_mi
 		spec->kb_dev = NULL;
 	}
 }
-#else /* INPUT */
-#define alc280_fixup_hp_gpio2_mic_hotkey	NULL
-#define alc233_fixup_lenovo_line2_mic_hotkey	NULL
-#endif /* INPUT */
 
 static void alc269_fixup_hp_line1_mic1_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)


