Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DFD1E009E;
	Wed,  6 Nov 2024 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897100; cv=none; b=TIod9UPsXt7jSr7ZQ6OfY3C8npyjds+YecDhYYAb4f6v/sKZmB7h7szvKUiTNS08kszu4MnnlS18DJ1MIHjueleW2krXVQeil2v6VIgzmYM0T4YOuHPee+JolvT84ic9ksTDVFZWTr/cmHgU5xmy5E48H/rywwk9qwKNU81mPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897100; c=relaxed/simple;
	bh=SgXf7W4ZGMQKUOBlEBULFVwr5TT9NyZg6RZgD5N+KSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TYsHWrsx3fTYcwxt82BQjUaWR3/Q+o7iK7LKqIZoDZmbfukIKwtlhBnyNWahmJqXE0DaA+yAZCDB17icvV5IfKPwOm3rNHpOI63w3JKSSh43hscH9CfAjtL/xgzzePWcQSUEWXNyett34UHH2RxMwby/4wZJ1ZWgDbtmLRAxa1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaYMaXJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaYMaXJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D0FC4CECD;
	Wed,  6 Nov 2024 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897100;
	bh=SgXf7W4ZGMQKUOBlEBULFVwr5TT9NyZg6RZgD5N+KSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaYMaXJ4v7p9TDDXAJfVzxUoZbPRSe+3DfXo4MDydd68AG2vtgfvx5fbuc6dehHNr
	 mgU34DsVHn5BLW6nQosX48i6gYmFAuAf9M3MQE+CrrLvqjgt68VBuv7WKJEm/XETFI
	 zehUfWJ60rxPp413L7+w58q7t7G3hNZbUxPlAwik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 065/126] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Wed,  6 Nov 2024 13:04:26 +0100
Message-ID: <20241106120307.847460411@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

commit 4413665dd6c528b31284119e3571c25f371e1c36 upstream.

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3465,6 +3465,9 @@ int snd_usb_mixer_apply_create_quirk(str
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */


