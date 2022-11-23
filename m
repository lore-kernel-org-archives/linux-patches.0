Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCACE1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5A9C4347C;
	Wed, 23 Nov 2022 09:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194547;
	bh=0EYjDFr7xoTV+UFs7GGOGr0QDiqFY7bNb4GAVBRtLdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkmC2h61pA9hWGyIenf469IF6DUbg+YbdjSdapgC8mSVwuaLEnRXwgTouCGSB9+L8
	 j3g002IeRuVjfVtWC/z+yE3d5UpDpBFtTpFrae44B0vgOIxzg14VjE8o8pvdqs6PCS
	 T6+sgN5tjo+b5ov2iKu9afF2F5gl+zvRwmL2o6ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 079/114] ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
Date: Wed, 23 Nov 2022 09:51:06 +0100
Message-Id: <20221123084555.014973046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit ad72c3c3f6eb81d2cb189ec71e888316adada5df upstream.

snd_usbmidi_output_open() has a check of the NULL port with
snd_BUG_ON().  snd_BUG_ON() was used as this shouldn't have happened,
but in reality, the NULL port may be seen when the device gives an
invalid endpoint setup at the descriptor, hence the driver skips the
allocation.  That is, the check itself is valid and snd_BUG_ON()
should be dropped from there.  Otherwise it's confusing as if it were
a real bug, as recently syzbot stumbled on it.

Reported-by: syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/syzbot+9abda841d636d86c41da@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20221112141223.6144-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1149,10 +1149,8 @@ static int snd_usbmidi_output_open(struc
 					port = &umidi->endpoints[i].out->ports[j];
 					break;
 				}
-	if (!port) {
-		snd_BUG();
+	if (!port)
 		return -ENXIO;
-	}
 
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;


