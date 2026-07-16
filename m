Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5E298CAB;
	Thu, 16 Jul 2026 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210606; cv=none; b=DjKTVLLcl3Iu9cfN3LLjNJT5UXDMk5OzTuJd5l/P/N7Uo7HBjXgqpA0pvtoLcXw4wXrA1ZMV3pzNoqOTcKVGyM85ewSCb/CKkMRFpwmil06YgVsYBDxEF+p3Oq8Tws7WaBvLIWynFYcWGOy1PrBDNAtrGOe+1iALmYBzBQsJFng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210606; c=relaxed/simple;
	bh=4tzM5EI0QbeptLTMWOu98tvgMkPppCwqMLXXs0+k1QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+6Em5quQIgD9kfud3pnRpBG+C0Ln+CC/4+PSq5dOMWxaz654a+b+7V21RQE00L+nwn8qvt/ZJ0v1gpccvJoytKFFel3mrTprky5Y61N5jX4Nl4n6b07Coo/0r5DTsrl/nDRfCPO44aZvHyP+MLM+IQIcVNaLm4o932Z5JuPLa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIf2mmq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIf2mmq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DF81F000E9;
	Thu, 16 Jul 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210605;
	bh=q41j8cJQ/pKNZfDukba7UAdaTSwifZzqBMqXtHLqNNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIf2mmq08JXqWc8WQUISq+0qkZl4YEN/OZ2zrOK1U70iIXg6v5hTTezQFKFkvCoZm
	 6cI3PNWVJWhVuGNUnfoIOtZj61CBg6gUnv8IEJRBNSh8CoQ9nH0ZnpZ8AzuzCBmD1o
	 U+qCgMSMzOWFxfTB/G/jMw3Jxjmnylr0ZTe2+zbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 111/480] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Thu, 16 Jul 2026 15:27:38 +0200
Message-ID: <20260716133047.109079954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -439,7 +439,9 @@ static int scarlett_ctl_enum_put(struct
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


