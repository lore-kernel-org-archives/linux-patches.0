Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34E8256C84;
	Wed, 25 Feb 2026 01:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983694; cv=none; b=u2aOm52dFhbnxsCdCb4pHxybg669SLOmAILY76HJ2JbgcJK6qnDGJ55rNK1uXd9CEUfXt2fIw+sw8iKLivTN22TRXnvTsNzc6YClc3p6kz2u0f2FymUU8uCuaDKEexIGLFTeyMgDOlTR7Y1+Hl5Zc7U5PTImBLkwvwafh1TLmkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983694; c=relaxed/simple;
	bh=yXZZlKz4FMIHEgeLKz5ll8FXv+hlClY7eLg5vQTioOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nlch0kmEgG3oUF2iYFVSetQ7a6ghdoRokMMUGeXjDDEpnaZUVPQdABQ5+Sgz2AfbM8KR3qq/PnTeaFXEoBtEY8ikKDCxhylZi6drg+HXAkfX9ixIguQWH5TjPCXyvu/5tUAOfXujCOLNCAxfIKDyzHJ3XB0l6Ko2DXaK+S1O9Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We6TVv4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We6TVv4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C846C19423;
	Wed, 25 Feb 2026 01:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983694;
	bh=yXZZlKz4FMIHEgeLKz5ll8FXv+hlClY7eLg5vQTioOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We6TVv4kVM/IpQWxh6HCr94mtggCB8gZHHQQ81/JjJbwfS5DCdv1r5Sa2Sk+iVc2c
	 5yKXAdOwighbP6+u7CuiBH5mR9OtA6FAAFhTb8THz+nGpDZyWgqBLpqAmOLRHmFWQi
	 pd17DtIF5hlkQQ+S08pUKVdlZKElivqf09+0M8Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 776/781] ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314
Date: Tue, 24 Feb 2026 17:24:45 -0800
Message-ID: <20260225012418.747788624@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7bc0df86c2384bc1e2012a2c946f82305054da64 upstream.

Acer Swift SF314 (SSID 1025:136d) needs a bit of tweaks of the pin
configurations for NID 0x16 and 0x19 to make the headphone / headset
jack working.  NID 0x17 can remain as is for the working speaker, and
the built-in mic is supported via SOF.

Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221086
Link: https://patch.msgid.link/20260217104414.62911-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/conexant.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -299,6 +299,7 @@ enum {
 	CXT_PINCFG_SWS_JS201D,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
+	CXT_FIXUP_ACER_SWIFT_HP,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -1024,6 +1025,14 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_hp_a_u,
 	},
+	[CXT_FIXUP_ACER_SWIFT_HP] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x16, 0x0321403f }, /* Headphone */
+			{ 0x19, 0x40f001f0 }, /* Mic */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk cxt5045_fixups[] = {
@@ -1073,6 +1082,7 @@ static const struct hda_quirk cxt5066_fi
 	SND_PCI_QUIRK(0x1025, 0x0543, "Acer Aspire One 522", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054c, "Acer Aspire 3830TG", CXT_FIXUP_ASPIRE_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054f, "Acer Aspire 4830T", CXT_FIXUP_ASPIRE_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x136d, "Acer Swift SF314", CXT_FIXUP_ACER_SWIFT_HP),
 	SND_PCI_QUIRK(0x103c, 0x8079, "HP EliteBook 840 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x807C, "HP EliteBook 820 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x80FD, "HP ProBook 640 G2", CXT_FIXUP_HP_DOCK),


