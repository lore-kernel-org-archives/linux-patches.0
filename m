Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C2C6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E33C433EF;
	Tue, 10 Jan 2023 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374989;
	bh=V8JDEOHxZYVaGl2463GBfoBZjYbsHwH465h8fIzUM6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfpGtSxjXNf/vy7MLWI+IbvDnBumj1YtS7BA2vUrTGZ23vGmDNPwtIK1mNQYZJrTQ
	 1W3l7ymQMtHIt9uRzHuVl9hcl8swb6jRDup0H5Uqh+0wFi2lCBDg+kR2tS+u5FdmDG
	 ZB7cONlbuhm+XmAVkOw1d/+0Xa7oHdaCllN7Xcpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Egorkine <arteme@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 042/290] ALSA: line6: fix stack overflow in line6_midi_transmit
Date: Tue, 10 Jan 2023 19:02:14 +0100
Message-Id: <20230110180033.042665821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Egorkine <arteme@gmail.com>

commit b8800d324abb50160560c636bfafe2c81001b66c upstream.

Correctly calculate available space including the size of the chunk
buffer. This fixes a buffer overflow when multiple MIDI sysex
messages are sent to a PODxt device.

Signed-off-by: Artem Egorkine <arteme@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221225105728.1153989-2-arteme@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/midi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -44,7 +44,8 @@ static void line6_midi_transmit(struct s
 	int req, done;
 
 	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		req = min3(line6_midibuf_bytes_free(mb), line6->max_packet_size,
+			   LINE6_FALLBACK_MAXPACKETSIZE);
 		done = snd_rawmidi_transmit_peek(substream, chunk, req);
 
 		if (done == 0)


