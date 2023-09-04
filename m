Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EF3C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D99C433C7;
	Mon,  4 Sep 2023 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852384;
	bh=YjAahdiGvpJT0s9zV1A5nWBgu6rzjYoe7xG5lVGy6/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txNrBS15Fco/kpfMoJc45WJP/UttToYGeZc7IWJBq/1yyUL9X/1xhqk0wcdXd4iUE
	 5KYRYEgTlZWXeVdSQQXmzH6Zbmquo9u9W2sxNiSz9YqGsxlUcMv5OmXdceWmltbuSI
	 rx+desjmiwuW9Z02JJVtqXWvek61W1Uwec3KVX5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: [PATCH 6.4 13/32] ALSA: usb-audio: Fix init call orders for UAC1
Date: Mon,  4 Sep 2023 19:30:11 +0100
Message-ID: <20230904182948.504031009@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
References: <20230904182947.899158313@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5fadc941d07530d681f3b7ec91e56d8445bc3825 upstream.

There have been reports of USB-audio driver spewing errors at the
probe time on a few devices like Jabra and Logitech.  The suggested
fix there couldn't be applied as is, unfortunately, because it'll
likely break other devices.

But, the patch suggested an interesting point: looking at the current
init code in stream.c, one may notice that it does initialize
differently from the device setup in endpoint.c.  Namely, for UAC1, we
should call snd_usb_init_pitch() and snd_usb_init_sample_rate() after
setting the interface, while the init sequence at parsing calls them
before setting the interface blindly.

This patch changes the init sequence at parsing for UAC1 (and other
devices that need a similar behavior) to be aligned with the rest of
the code, setting the interface at first.  And, this fixes the
long-standing problems on a few UAC1 devices like Jabra / Logitech,
as reported, too.

Reported-and-tested-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Closes: https://lore.kernel.org/r/202bbbc0f51522e8545783c4c5577d12a8e2d56d.camel@infinera.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230821111857.28926-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1093,6 +1093,7 @@ static int __snd_usb_parse_audio_interfa
 	int i, altno, err, stream;
 	struct audioformat *fp = NULL;
 	struct snd_usb_power_domain *pd = NULL;
+	bool set_iface_first;
 	int num, protocol;
 
 	dev = chip->dev;
@@ -1223,11 +1224,19 @@ static int __snd_usb_parse_audio_interfa
 				return err;
 		}
 
+		set_iface_first = false;
+		if (protocol == UAC_VERSION_1 ||
+		    (chip->quirk_flags & QUIRK_FLAG_SET_IFACE_FIRST))
+			set_iface_first = true;
+
 		/* try to set the interface... */
 		usb_set_interface(chip->dev, iface_no, 0);
+		if (set_iface_first)
+			usb_set_interface(chip->dev, iface_no, altno);
 		snd_usb_init_pitch(chip, fp);
 		snd_usb_init_sample_rate(chip, fp, fp->rate_max);
-		usb_set_interface(chip->dev, iface_no, altno);
+		if (!set_iface_first)
+			usb_set_interface(chip->dev, iface_no, altno);
 	}
 	return 0;
 }


