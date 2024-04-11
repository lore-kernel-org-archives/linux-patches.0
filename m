Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ED513D258;
	Thu, 11 Apr 2024 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831785; cv=none; b=lCbiBG3WLhsQLKLRkRuh6tfSTKmGwZMIQ3R59wsySlG15dRkvT/awekL/IbsVPoGyLux0nw1vAPRPakAIvhZRV4ZiZnZRxjaXMaZxNyeaV+dU9yscNCY4TD3/CnZ8BlNdNXAfDCQQwY9mX7wlYPEqOzVpR7BBjD8k2oyABtOs1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831785; c=relaxed/simple;
	bh=1kKNv1OUzZNbMdhCvielnTVOC+tV0LJPrNrw6+9+/aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUUDBOI14QdbhD7LzR1y0tENKOhKQRGINkHouwC/lzMeUtrq1sO+obfZ7kRm/jujs0RZOhzVMluBSGp1ALzuEWWR23iUDYh/mspMtwfC9If8HEGXtyAmBuprV76/kz3+AnjLRXQIYE1tFRJLMel3GKb1VidVgcv6LsQvTZqh1pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYWTZfxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYWTZfxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4233C433F1;
	Thu, 11 Apr 2024 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831785;
	bh=1kKNv1OUzZNbMdhCvielnTVOC+tV0LJPrNrw6+9+/aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYWTZfxgEPYT4fhL5WFPaqtJsUs5fdywS5nexI4agpsUluJ1N3t6DCfMKZaeHVcs8
	 nNILBFw4i7cDSCKSzrkCnHu/szB0eR21ZU7i9MUuHUbrt2sbPqO9bI5c2DKqOpM1hS
	 LWWqurqUEDHO5t0gkPQ1Bb3vDjcVd/yqF7gI8GL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 125/294] ALSA: hda/realtek - Fix headset Mic no show at resume back for Lenovo ALC897 platform
Date: Thu, 11 Apr 2024 11:54:48 +0200
Message-ID: <20240411095439.426448767@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10692,8 +10692,7 @@ static void alc897_hp_automute_hook(stru
 
 	snd_hda_gen_hp_automute(codec, jack);
 	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
-	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    vref);
+	snd_hda_set_pin_ctl(codec, 0x1b, vref);
 }
 
 static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
@@ -10702,6 +10701,10 @@ static void alc897_fixup_lenovo_headset_
 	struct alc_spec *spec = codec->spec;
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+		spec->no_shutup_pins = 1;
+	}
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		snd_hda_set_pin_ctl_cache(codec, 0x1a, PIN_IN | AC_PINCTL_VREF_100);
 	}
 }
 


