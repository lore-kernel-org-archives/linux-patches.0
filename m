Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86315AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB93C433C7;
	Tue, 25 Jul 2023 10:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282767;
	bh=O24xe5R+zlm7ilmdcmfoiuKJ9QfysNFmg+CmLlFYgI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1V0DCzKftW6ABYGm25fy2eK+a70Rj1GXOso8DdZ+SnZRh2Df2ZzLQ5gj9ht2lNYmz
	 wjb+n8DyuywdIDVdjtPpL9WeCw8nGgVJHT6E1+pdF2fQOA2chDGwBoTfGqaBL+3jPz
	 vSCwhV4W3VXlGFKsScLbHh6wm9IIZfrj7kni21QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	"Joseph C. Sible" <josephcsible@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 002/183] ALSA: hda/realtek - remove 3k pull low procedure
Date: Tue, 25 Jul 2023 12:43:50 +0200
Message-ID: <20230725104507.855830338@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

commit 69ea4c9d02b7947cdd612335a61cc1a02e544ccd upstream.

This was the ALC283 depop procedure.
Maybe this procedure wasn't suitable with new codec.
So, let us remove it. But HP 15z-fc000 must do 3k pull low. If it
reboot with plugged headset,
it will have errors show don't find codec error messages. Run 3k pull
low will solve issues.
So, let AMD chipset will run this for workarround.

Fixes: 5aec98913095 ("ALSA: hda/realtek - ALC236 headset MIC recording issue")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Reported-by: Joseph C. Sible <josephcsible@gmail.com>
Closes: https://lore.kernel.org/r/CABpewhE4REgn9RJZduuEU6Z_ijXNeQWnrxO1tg70Gkw=F8qNYg@mail.gmail.com/
Link: https://lore.kernel.org/r/4678992299664babac4403d9978e7ba7@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -122,6 +122,7 @@ struct alc_spec {
 	unsigned int ultra_low_power:1;
 	unsigned int has_hs_key:1;
 	unsigned int no_internal_mic_pin:1;
+	unsigned int en_3kpull_low:1;
 
 	/* for PLL fix */
 	hda_nid_t pll_nid;
@@ -3622,6 +3623,7 @@ static void alc256_shutup(struct hda_cod
 	if (!hp_pin)
 		hp_pin = 0x21;
 
+	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
 	if (hp_pin_sense)
@@ -3638,8 +3640,7 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (codec->core.vendor_id != 0x10ec0236 &&
-	    codec->core.vendor_id != 0x10ec0257)
+	if (spec->en_3kpull_low)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)
@@ -10599,6 +10600,8 @@ static int patch_alc269(struct hda_codec
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
+		if (codec->bus->pci->vendor == PCI_VENDOR_ID_AMD)
+			spec->en_3kpull_low = true;
 		break;
 	case 0x10ec0257:
 		spec->codec_variant = ALC269_TYPE_ALC257;


