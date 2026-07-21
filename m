Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCDD46EF88;
	Tue, 21 Jul 2026 20:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664929; cv=none; b=qJC0mfu8RDUmxMQRxNYZYbksjtVdNOmXdwmgRgJVRsOov4o0qZwG+fZ0sr0dWPNICogulQk/ly/yIeinXXKVnjvCa594XgTaGJadQKEXP/I4Fn/FA9EaVPqM1dzPdYjF9LbdQ+bgFckl0UPh+WL92Nxr8AG+cPAzeWVvzk3pbnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664929; c=relaxed/simple;
	bh=q3n3U+ZB5PPhnz+G67ksfVplc+dyeTYbTjEDUz5mzYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aNbOoOWc+eXhI40/hG8x7AWCIp2hnm4KIFBQQaqBr6KuUuSBNzxA9x7m8Ecvx+t3szGxM4aTGuHFZceAKbbfsCFePxrABDr5VnLqwDSU0+cnK6ra59Iea+MnRXKQsDuMPEN8aKZ1qHmXIg3GZe5Yg54QkJ8eWi4Oss9pgbbNOX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Geax1FqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Geax1FqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088621F00A3A;
	Tue, 21 Jul 2026 20:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664928;
	bh=1hlIXadE6qVR3sCzXEzhjUW0Ur0eJTBJ87y1fFj0za4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Geax1FqXJBYKI2y4qgXewjXirBNbjZup7t00Yn97YLIQp++GxcGE26QGsWxBT7Njx
	 sj6CJB7LLO37yxiLR3hMD7Jv4U4F0IFNs3VLe3DT6zITj7P9kPDWBOHe37WFwxyq0J
	 74Dj1tahdfkUhMUg8IjCDO1pRCcU15+7O8+IsO2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0112/1266] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Tue, 21 Jul 2026 17:09:09 +0200
Message-ID: <20260721152444.307565028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 0f25cf1f02e3dba626791d949c759a48c0a44996 upstream.

scarlett_ctl_enum_put() ignores the return value from
snd_usb_set_cur_mix_value() and reports success whenever the
requested enum value differs from the current one.

If the SET_CUR request fails, the callback still returns success even
though neither the hardware state nor the cached mixer value changed.

Fixes: 76b188c4b370 ("ALSA: usb-audio: Scarlett mixer interface for 6i6, 18i6, 18i8 and 18i20")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-2-5a3bd4a673ae@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -438,7 +438,9 @@ static int scarlett_ctl_enum_put(struct
 	val = ucontrol->value.integer.value[0];
 	val = val + opt->start;
 	if (val != oval) {
-		snd_usb_set_cur_mix_value(elem, 0, 0, val);
+		err = snd_usb_set_cur_mix_value(elem, 0, 0, val);
+		if (err < 0)
+			return err;
 		return 1;
 	}
 	return 0;


