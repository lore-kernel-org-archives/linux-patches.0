Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588B1E525;
	Mon,  1 Apr 2024 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990011; cv=none; b=MFBcl9fIhKLDPwDjRwXZx8vqUpIWAf7pTV7RdzHxTOK2hrX8NZemeb0wTScslGPoqv3yrpt13h/hnZ/wPyKoeD2QPtTbJ/aESUPSCa5JaueN9JnfegrUS2jqLB75TSfs2+UOLzotnbnfjdLO1NFD5Y6VWDTKXLWggaCrUCfHQBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990011; c=relaxed/simple;
	bh=2ela1B7qnq+5k06GW1vebAs38nPPE9y6T4c2SsvhS9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI3j0swq/Qx45FlAU4CUz4mBkyZ3p7nM6hjjnLWOQMgz/j+w3DoEGmZt7OITlbGmhiH4fHTnR/b95VPGmqjoQIKkRcSGCa4VTrigWVdTFQhqfzwFdqGZyymsiZCmvtqTl3R4mZVEWxSWSGWlIO6arZnauA3lN+3wNNPR0c1KJoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZyspUfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZyspUfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28662C433F1;
	Mon,  1 Apr 2024 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990010;
	bh=2ela1B7qnq+5k06GW1vebAs38nPPE9y6T4c2SsvhS9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZyspUfY2PG29KfZXQ/jSKWvKZzEuPfwJTcBzcyMWqCB/tCc56QSpEtmi6SDwmMgu
	 usdJq8TlYcQuhobvu6RSKj2HuPRGEqLEIWxkb+3Ge2+aciOcNEmQ4yQRwa4IMU0mn0
	 sohHEHb9rLFfTycDEb5DF2kd4QSamFvXbvS7VNes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 220/396] ALSA: hda/realtek - Fix headset Mic no show at resume back for Lenovo ALC897 platform
Date: Mon,  1 Apr 2024 17:44:29 +0200
Message-ID: <20240401152554.480220140@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kailang Yang <kailang@realtek.com>

commit d397b6e56151099cf3b1f7bfccb204a6a8591720 upstream.

Headset Mic will no show at resume back.
This patch will fix this issue.

Fixes: d7f32791a9fc ("ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/4713d48a372e47f98bba0c6120fd8254@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11624,8 +11624,7 @@ static void alc897_hp_automute_hook(stru
 
 	snd_hda_gen_hp_automute(codec, jack);
 	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
-	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    vref);
+	snd_hda_set_pin_ctl(codec, 0x1b, vref);
 }
 
 static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
@@ -11634,6 +11633,10 @@ static void alc897_fixup_lenovo_headset_
 	struct alc_spec *spec = codec->spec;
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+		spec->no_shutup_pins = 1;
+	}
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		snd_hda_set_pin_ctl_cache(codec, 0x1a, PIN_IN | AC_PINCTL_VREF_100);
 	}
 }
 


