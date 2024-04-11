Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28B12EAE5;
	Thu, 11 Apr 2024 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829696; cv=none; b=syQwGRKivFMYa1TH3+qY3e6nLbjT8Kd1gMMr5dGxCgi1/ZfLu6i+2x3iZwavmH5uyqt8AviNG79Vjfi07+CmLnsTo6Amj0o6XDYrk1o2mbStywu4G1RWAFQs01eA8LLnWQFSLgc2zzXeV2Mc9fAfjZ/Bc2Sdwtr/639UBuZ3UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829696; c=relaxed/simple;
	bh=mFHUZZRyC4k72y3cls+vCB4+QAvzn/gS0azCZP1sm9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdOtj8DR4dNgOFwuTJuAaL1lSc+qV8PRsExhUbDk1F2TQTxY15P81VWVqN8+8B9RMAxsrdfAFHhMjzpZNiVC+Hh8XrnuVSrb/ooDZU+OTrupxAOBLnosulxLjw0SvnghvVfftr1ZJATbKLrZTYyMqaX1npi5EFfRc3EXzlbCTwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWY/VwwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWY/VwwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A16C433C7;
	Thu, 11 Apr 2024 10:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829696;
	bh=mFHUZZRyC4k72y3cls+vCB4+QAvzn/gS0azCZP1sm9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWY/VwwLuXHXnDVOdzHLUPd67B7xc/gqyqhlD14hk7ff1La2TcvOabvJ2YeEKk1kB
	 HBTVoY+FISzeH7FkPTj5lLIcKEpZLNjVzsZIqg7k6ykwutoR0bhtkJlU910Ig6j6Vn
	 sDFeq5oHGPsoLCbyju2C+3ROeRJv+ilxB11FxJ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 073/175] ALSA: hda/realtek - Fix headset Mic no show at resume back for Lenovo ALC897 platform
Date: Thu, 11 Apr 2024 11:54:56 +0200
Message-ID: <20240411095421.760982129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8593,8 +8593,7 @@ static void alc897_hp_automute_hook(stru
 
 	snd_hda_gen_hp_automute(codec, jack);
 	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
-	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    vref);
+	snd_hda_set_pin_ctl(codec, 0x1b, vref);
 }
 
 static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
@@ -8603,6 +8602,10 @@ static void alc897_fixup_lenovo_headset_
 	struct alc_spec *spec = codec->spec;
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+		spec->no_shutup_pins = 1;
+	}
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		snd_hda_set_pin_ctl_cache(codec, 0x1a, PIN_IN | AC_PINCTL_VREF_100);
 	}
 }
 


