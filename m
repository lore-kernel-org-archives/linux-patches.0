Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F4A4E8DFB;
	Fri,  9 Oct 2026 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557050; cv=none; b=KIDfmDcrMNuSwArwi+4GkJlF33CWnYvtveOyCwC4TObpexiurX3SyQnKMEwYTvMiepbsL3uNFpjICFW+kQrT4mnl9jSkOdBIVcZrufxLI74iDNn7qW/Kviwo61LODrrFx4ZARgiQO7Xfy/nf26h5BnXpRTvGjvmGn6gkeuZAHjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557050; c=relaxed/simple;
	bh=mH5/2cjrZeya+BNkvvDx4eM78KSXBIhlN5mPtRqczTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRNJ71+G6QnlyxdiJxdZjG7ElarLA3fb6ZcDnhXhg2NxRupUJOYYoMYXai507YunVWOG/Vpj7anuX30vEqIBtoHMqTkFc2MRSa6980OVdcUI7WVyvs8SnTk0WEHXaBkiJipiC0cH45Lq8Ea/U97OY9zsgEPqM+GOHJ+I6ATROg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ocd+qFwB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ocd+qFwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD461F000FF;
	Fri,  9 Oct 2026 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557049;
	bh=NtNht+OXQZgGylwJ2NKBvx64H5z+C5ikWZEiG3jybew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ocd+qFwBh0FtqyAJr0r/b18j+Kp30I+3fW7jt6SHcObQx3W+acHJVxF+LKc8YLVHN
	 Dop/hnx3jrCzrY8L9N7VLlpkRqyx/WJh1bmIV8Wft9L+I++TXXHsii5ash6h55C76R
	 FAd+i6PozJfHMOs3/Srd7qxnJ9P0lXy+oa9v7Qoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Aleksei Arsenev <alesharik4@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 270/428] ALSA: hda/realtek: Fix square wave output on ASUS Strix G615LR
Date: Fri,  9 Oct 2026 16:10:07 +0200
Message-ID: <20261009140952.024468866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

commit cfc0a117d773eb585ca7e87d20c50d1c415058e5 upstream.

ASUS ROG Strix G16 G615LR (PCI SSID 1043:3f20) outputs a loud
full-scale square wave from internal speakers since the TAS2781
amplifier driver started loading. The quirk was using
ALC287_FIXUP_TXNW2781_I2C which chains to the ThinkPad headset
jack fixup, but this is an ASUS device that should use
ALC287_FIXUP_TXNW2781_I2C_ASUS which chains to ALC294_FIXUP_ASUS_SPK
for proper EAPD and pin configuration.

Fixes: f7cede182c96 ("ALSA: hda/realtek: Add Asus quirk for TAS amplifiers")
Cc: stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>
Cc: Antheas Kapenekakis <lkml@antheas.dev>
Reported-by: Aleksei Arsenev <alesharik4@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=222045
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260923121640.272509-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7682,7 +7682,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x3ef0, "ASUS Strix G635LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3f00, "ASUS Strix G815LH_LM_LP", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3f10, "ASUS Strix G835LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x3f30, "ASUS Strix G815LR_LW", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3fd0, "ASUS B3605CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3ff0, "ASUS B5405CVA", ALC245_FIXUP_CS35L41_SPI_2),


