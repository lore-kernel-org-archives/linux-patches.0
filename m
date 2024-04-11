Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90AB13E897;
	Thu, 11 Apr 2024 10:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830692; cv=none; b=LPdkghQQsXoNJ0yfySy3tfk6wQWx8V/itRpSGJfWGbSbMPZ0aMk8bQu1OMmoGpNb1hlnBM/1YeBNdoOOQ1CpTenDMm+HB9+ZDtKp0tA9W2lcIsn+m4WcBujwV2d0wWc0fDTxMbVznThHB4VlHsYqK6w5jdqHYDnuoVE2/+lK6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830692; c=relaxed/simple;
	bh=eqB8LERlJGb+9bkAXx+vniePJCLRAhSyfVkVUjfhlNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc0NObq0yX4vMFHtdB9IAcrpQpZPm2vUQR39sZKUtEmXfMAYWo+NPfnASEq3Mnb3P6iLlLnh5C5Ln7KC/8EzTR4V6Asv7cMrF+DcTVtYGwn219jcZdveEQN44159uoHCy78AqHgGJ50ux9MmDi6/U/66m4TAplenLiGDGUMylfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aASAu8d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aASAu8d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6465AC433F1;
	Thu, 11 Apr 2024 10:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830691;
	bh=eqB8LERlJGb+9bkAXx+vniePJCLRAhSyfVkVUjfhlNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aASAu8d+s0DMl/miS2kN+WdUlOqhyY4BT5j0J5TcVSE6fu1CmSUFZJoiliLIzLXZw
	 06vvV7MRZyydoUbJz2EeTpcXZiedYYkz3daBIG2+4zVkWSqU1vMeOh633eC0SyfVp/
	 wwetQymsmtzjfimUqWnFbWcnez9XVr51WwZEykV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 085/215] ALSA: hda/realtek - Fix headset Mic no show at resume back for Lenovo ALC897 platform
Date: Thu, 11 Apr 2024 11:54:54 +0200
Message-ID: <20240411095427.461623304@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9796,8 +9796,7 @@ static void alc897_hp_automute_hook(stru
 
 	snd_hda_gen_hp_automute(codec, jack);
 	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
-	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    vref);
+	snd_hda_set_pin_ctl(codec, 0x1b, vref);
 }
 
 static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
@@ -9806,6 +9805,10 @@ static void alc897_fixup_lenovo_headset_
 	struct alc_spec *spec = codec->spec;
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+		spec->no_shutup_pins = 1;
+	}
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		snd_hda_set_pin_ctl_cache(codec, 0x1a, PIN_IN | AC_PINCTL_VREF_100);
 	}
 }
 


