Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93709253339;
	Wed,  5 Mar 2025 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198602; cv=none; b=D6WLYBNl5oj8EVIwXmjqrqdZhbZq8bhPBTSYmEVap7OHh3/GQ/ddCltHWhDMuW8bAPleC8VOCVVhgzYA6/FqvTkJnORwm/aB1T6hef3bzco36a0OyRGJYHXHhQfIvCz2kKbWZ34YLGYudL2B2sWa+3Q11GOfv0Gb+x685D0hP+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198602; c=relaxed/simple;
	bh=VsGuDAJb2/LZ0ZxD8Vfu1yJhtbLfSsKdwKS59L/dtzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWAN3YGaj/Zz9QvdP4/t1OKE/uNGWr/ix6SKLVq3E8vNsGbOwsk3ik1Yyqjj6+wzkMN3hn6PZ4eqkGREDAKr/30bZ/mHfK3A8AKtdwiLieEPKVl/UK/ifsqVr/JiIRLqJHDIqaB1sDdvwYQ/T/m+AY42GIlQul55j/UHuH6VB40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5dkD22Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5dkD22Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE92C4CEE0;
	Wed,  5 Mar 2025 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198602;
	bh=VsGuDAJb2/LZ0ZxD8Vfu1yJhtbLfSsKdwKS59L/dtzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5dkD22YthFAHngJ5eALOhANmy+lWIvJrH4IltNEQDRjR37kRppbTi+qMd2GH6RdQ
	 mfSUyVWDOMOqG75AXA/M6KavfrUDhPb4GJrlQLnOI60d6ok8GinDBxMoYLljtYOm9s
	 1ld5JhkogWigcHoMztbZaKdhNaDBQj8tl9wPmFd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Chris Chiu <chris.chiu@canonical.com>,
	=?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 084/157] ALSA: hda/realtek: Fix microphone regression on ASUS N705UD
Date: Wed,  5 Mar 2025 18:48:40 +0100
Message-ID: <20250305174508.685929679@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrien Vergé <adrienverge@gmail.com>

commit c6557ccf8094ce2e1142c6e49cd47f5d5e2933a8 upstream.

This fixes a regression introduced a few weeks ago in stable kernels
6.12.14 and 6.13.3. The internal microphone on ASUS Vivobook N705UD /
X705UD laptops is broken: the microphone appears in userspace (e.g.
Gnome settings) but no sound is detected.
I bisected it to commit 3b4309546b48 ("ALSA: hda: Fix headset detection
failure due to unstable sort").

I figured out the cause:
1. The initial pins enabled for the ALC256 driver are:
       cfg->inputs == {
         { pin=0x19, type=AUTO_PIN_MIC,
           is_headset_mic=1, is_headphone_mic=0, has_boost_on_pin=1 },
         { pin=0x1a, type=AUTO_PIN_MIC,
           is_headset_mic=0, is_headphone_mic=0, has_boost_on_pin=1 } }
2. Since 2017 and commits c1732ede5e8 ("ALSA: hda/realtek - Fix headset
   and mic on several ASUS laptops with ALC256") and 28e8af8a163 ("ALSA:
   hda/realtek: Fix mic and headset jack sense on ASUS X705UD"), the
   quirk ALC256_FIXUP_ASUS_MIC is also applied to ASUS X705UD / N705UD
   laptops.
   This added another internal microphone on pin 0x13:
       cfg->inputs == {
         { pin=0x13, type=AUTO_PIN_MIC,
           is_headset_mic=0, is_headphone_mic=0, has_boost_on_pin=1 },
         { pin=0x19, type=AUTO_PIN_MIC,
           is_headset_mic=1, is_headphone_mic=0, has_boost_on_pin=1 },
         { pin=0x1a, type=AUTO_PIN_MIC,
           is_headset_mic=0, is_headphone_mic=0, has_boost_on_pin=1 } }
   I don't know what this pin 0x13 corresponds to. To the best of my
   knowledge, these laptops have only one internal microphone.
3. Before 2025 and commit 3b4309546b48 ("ALSA: hda: Fix headset
   detection failure due to unstable sort"), the sort function would let
   the microphone of pin 0x1a (the working one) *before* the microphone
   of pin 0x13 (the phantom one).
4. After this commit 3b4309546b48, the fixed sort function puts the
   working microphone (pin 0x1a) *after* the phantom one (pin 0x13). As
   a result, no sound is detected anymore.

It looks like the quirk ALC256_FIXUP_ASUS_MIC is not needed anymore for
ASUS Vivobook X705UD / N705UD laptops. Without it, everything works
fine:
- the internal microphone is detected and records actual sound,
- plugging in a jack headset is detected and can record actual sound
  with it,
- unplugging the jack headset makes the system go back to internal
  microphone and can record actual sound.

Cc: stable@vger.kernel.org
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Chris Chiu <chris.chiu@canonical.com>
Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Tested-by: Adrien Vergé <adrienverge@gmail.com>
Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
Link: https://patch.msgid.link/20250226135515.24219-1-adrienverge@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10629,7 +10629,6 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
-	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),


