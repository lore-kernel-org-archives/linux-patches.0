Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15A53B95FA;
	Fri,  4 Sep 2026 05:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500088; cv=none; b=kzIy20IWhPnJ3Rm0j21dVqytkbHcGZI7sA8HtIh+yc23Ys3ioxFpWbYgy73UwT9+h+BP+rWp38PSKJ3Rhm/wPsbjRmGRjmr3QoYUAIgCruoS5zjgpvi9n06oMltVKSWmof9JIVzaeosVCPYUbFZ66DhECPQNB32ncZ0N9Mt8nWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500088; c=relaxed/simple;
	bh=elSRaaorc95t9sD3+mhlLlASjj+RjMuhqksZEcbCgLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ8qFZvyVbPzNd0zV2iXiR5nu7VPUxd3StP5vNbyztmpuoOPz0fM+MvYf50PxaBMXRT2Wx2GuXuIAvSZW1PgWmd2rOP2ZFsHuZNDX2gvs+1FUml6tLWE1m5tlRi07vfQhsNFAsDaPQOH/AjUFLZJ5bt4ttDkfYy+X59sljpVxnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs5ahwGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs5ahwGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485031F00A3D;
	Fri,  4 Sep 2026 05:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500086;
	bh=+SMyKpxsC+27wQvEHZtI6mb+x1Tx/cHQFcsZJssrFEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vs5ahwGw4J5dNms866txJs+T2K+K5JsvrQbVMi1EVngYyiVv+vr1D3hDn3S7M93p+
	 eNuqNG8llxIXAUX/WD7pGMDU1Pdvt4dCmPyIf0X+h4AS+zD/L0UPYQpDzXO/0Qy38Q
	 aRmhFRry5TcyWQZAfnrLNsDCllsOkj/5RM+LDbxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajrat Makhmutov <rauty@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 647/713] ALSA: hda/realtek: Enable headset mic on F+ FLAPTOP r
Date: Fri,  4 Sep 2026 07:00:15 +0200
Message-ID: <20260904045818.335529458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajrat Makhmutov <rauty@altlinux.org>

commit 7097666b993b37f4e47982026b703b2379a364f8 upstream.

The BIOS of the F+ FLAPTOP r laptop (Realtek ALC897, SSID 1e63:6d9a)
declares only pin 0x1b, the headphone output of the 3.5 mm combo jack.
Every other external pin is left at 0x411111f0, so the headset mic pin
0x19 is never parsed and no headset mic input exists. The pin is wired
on this board - retasking it makes the headset mic record.

Reuse ALC897_FIXUP_HP_HSMIC_VERB, which already sets the pin config this
machine needs: 0x19 as a headset mic without its own presence detect.
Only 0x1b reports jack presence here, so a mic pin with presence detect
would leave the driver in auto-mic mode waiting for an event that never
arrives.

Without the quirk the generic parser retasks the lone headphone pin as
an input instead. That surfaces as a "Headphone Mic" input which records
only the internal mic bleed, so the headset mic appears present but dead.

Tested on ALT Linux, kernel 6.12, by recording a CTIA headset mic on the
combo jack with the internal mic as a reference.

ALSA info before the patch:
https://alsa-project.org/db/?f=18363eddea933baee100c9bf461d0e5cf74c8de2

ALSA info after the patch:
https://alsa-project.org/db/?f=48ae2cd7aaf1eb0f24639ce83cd38cfd93b25f76

Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Ajrat Makhmutov <rauty@altlinux.org>
Link: https://patch.msgid.link/20260808185500.2564948-1-rauty@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc662.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc662.c
+++ b/sound/hda/codecs/realtek/alc662.c
@@ -852,6 +852,7 @@ static const struct hda_quirk alc662_fix
 	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
 	SND_PCI_QUIRK(0x1c6c, 0x1239, "Compaq N14JP6-V2", ALC897_FIXUP_HP_HSMIC_VERB),
+	SND_PCI_QUIRK(0x1e63, 0x6d9a, "F+ FLAPTOP r", ALC897_FIXUP_HP_HSMIC_VERB),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


