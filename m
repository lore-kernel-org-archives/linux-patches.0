Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF6541F7D5;
	Thu, 16 Jul 2026 13:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209214; cv=none; b=Bfh6yQyzOnVatKCzY/o6e1uPvSo548PPQhvbuDiBYc6FZWEPYHaijDH13mO59olELLeYwpGvBApfhB1RVZwzCuecmGBhXKbqdsKXanJLefjgmvXiLFPRr1qPxX98qMAT6+O5O/gY3F9ceb8hzjdbT4nadJrIDg3bHfbsL6psvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209214; c=relaxed/simple;
	bh=2xTqnmjNVcXVGA09ieMqsAsK/mXVxiAS61b4KeRaYWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZov9k5+tFbKj+3+nbNsY6wFNWIg0EnGfiulHszcCuYsLMJK8fFgm0KrB+S5Vie53RcI0MbGE8XVtze42pLZVGF2P3z3kSJx8AM3mGZpUf7RtdL2agnjXF3Kn30PVp576a0UiCtNsTZehEoz29ZC11vzCYl/9HdZghuSOQ0Hv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOSRsJEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOSRsJEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3581F000E9;
	Thu, 16 Jul 2026 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209213;
	bh=1qTOui6RoH5D5AwqX8Yvu6Ps8gxjVlYRTL4hOJUbIg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOSRsJEflmVAcYeLom7jNj9/+69h3oe0ffJcnJURmQsjKb2dxRLbYExrLfmm0RGrS
	 HcsVsiTJiVzGawS+yTgb3g3RCEmrsj67CFHXDEBvchXsqtd3wSFGy3ppWAt4bdh5aF
	 4KNNcrpUJ/JdazBjhHflXak0tR83KsSy4KwUUyt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 100/518] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Thu, 16 Jul 2026 15:26:08 +0200
Message-ID: <20260716133050.052108101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -680,7 +680,9 @@ static int scarlett_ctl_enum_put(struct
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


