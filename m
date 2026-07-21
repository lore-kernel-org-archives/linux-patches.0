Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91E843B490;
	Tue, 21 Jul 2026 21:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670977; cv=none; b=hGsKg1vk7eGqEmq7GlVrhUHpJ4fWqQ2t3ghFgNNNMXCc+06dfElwaB9OopLt3iPrggW21xdcC/nqUGwOqxX2huZlsereTbqxdBe3BleBcDAGN2GPU9g6GdTcRnzmsnrVup0ZkgoOXQWCBYzmmK/dMWgZIbDU/hH9bEfNBTyj7E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670977; c=relaxed/simple;
	bh=sI2X0oXBAK2FoBnOvbngOrJqNiFvzLtMv1haySByMyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fr9cFKW32OJ/Dq3s+md6Gy5pMt1ryKyZ4jhlcHpC+ZQR10Jyyjxsj9+DGvDuQCFv/pgyRBxmeSJ4f2HJPgf+O6aQ8Ukjpl4eclHcBRyPTpKo8DOAch3sjXEzs0HcaKHRwlXjkrV4f4bq7fMfE/K4KH20zYXbzJaqgio+CWxP0FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWFKdKdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWFKdKdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB371F000E9;
	Tue, 21 Jul 2026 21:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670976;
	bh=4yssvuMt4dKcY6k29Kto8+SOzW1TSJZUSkI9ftU2Iuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWFKdKdrdv7MaK3xHCzNccvIHMqXR9F6zU3rWZjgr1vdDwIOOFLdmNBiIr9oWuRj9
	 MvSvUtJyUL8MbzE8pi1UPPu7P4YMdAYVCrPkQbGzdV3SdWGjAHiD/8z6YZMnlheaYJ
	 Qjdnw1HCGnPdmbuYWApsEHsuj7hYxPRYKJwYFFJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 071/843] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Tue, 21 Jul 2026 17:15:06 +0200
Message-ID: <20260721152407.586753317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


