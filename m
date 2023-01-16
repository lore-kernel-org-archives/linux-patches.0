Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B0BC433F0;
	Mon, 16 Jan 2023 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886535;
	bh=j7Py4CpAgmMYqU3vIJVSPv/PRMSwRBsWOuRqV2FNloo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO2fHfX2jcmrSy7ukTpZu3By8+/jLTjdb5/CKkYNKMT780i6eJ4e3Y7Kfz9H26f6/
	 h5sK1Eob6q7rdYRPcKkSBj3P9f49+vXv446ZxDG2Vpny4GZlCyYEhVNfFfN+xX4AOo
	 BRm8XsjzDGjcme5Mwivv+MfknE/aon2/gxRPbQV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Egorkine <arteme@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 467/658] ALSA: line6: correct midi status byte when receiving data from podxt
Date: Mon, 16 Jan 2023 16:49:15 +0100
Message-Id: <20230116154930.860574847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

commit 8508fa2e7472f673edbeedf1b1d2b7a6bb898ecc upstream.

A PODxt device sends 0xb2, 0xc2 or 0xf2 as a status byte for MIDI
messages over USB that should otherwise have a 0xb0, 0xc0 or 0xf0
status byte. This is usually corrected by the driver on other OSes.

This fixes MIDI sysex messages sent by PODxt.

[ tiwai: fixed white spaces ]

Signed-off-by: Artem Egorkine <arteme@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221225105728.1153989-1-arteme@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/driver.c  |    3 ++-
 sound/usb/line6/midi.c    |    3 ++-
 sound/usb/line6/midibuf.c |   25 +++++++++++++++++--------
 sound/usb/line6/midibuf.h |    5 ++++-
 sound/usb/line6/pod.c     |    3 ++-
 5 files changed, 27 insertions(+), 12 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -303,7 +303,8 @@ static void line6_data_received(struct u
 		for (;;) {
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
-						LINE6_MIDI_MESSAGE_MAXLEN);
+						   LINE6_MIDI_MESSAGE_MAXLEN,
+						   LINE6_MIDIBUF_READ_RX);
 
 			if (done <= 0)
 				break;
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -56,7 +56,8 @@ static void line6_midi_transmit(struct s
 
 	for (;;) {
 		done = line6_midibuf_read(mb, chunk,
-					  LINE6_FALLBACK_MAXPACKETSIZE);
+					  LINE6_FALLBACK_MAXPACKETSIZE,
+					  LINE6_MIDIBUF_READ_TX);
 
 		if (done == 0)
 			break;
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -9,6 +9,7 @@
 
 #include "midibuf.h"
 
+
 static int midibuf_message_length(unsigned char code)
 {
 	int message_length;
@@ -20,12 +21,7 @@ static int midibuf_message_length(unsign
 
 		message_length = length[(code >> 4) - 8];
 	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line 6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+		static const int length[] = { -1, 2, 2, 2, -1, -1, 1, 1, 1, -1,
 			1, 1, 1, -1, 1, 1
 		};
 		message_length = length[code & 0x0f];
@@ -125,7 +121,7 @@ int line6_midibuf_write(struct midi_buff
 }
 
 int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
-		       int length)
+		       int length, int read_type)
 {
 	int bytes_used;
 	int length1, length2;
@@ -148,9 +144,22 @@ int line6_midibuf_read(struct midi_buffe
 
 	length1 = this->size - this->pos_read;
 
-	/* check MIDI command length */
 	command = this->buf[this->pos_read];
+	/*
+	   PODxt always has status byte lower nibble set to 0010,
+	   when it means to send 0000, so we correct if here so
+	   that control/program changes come on channel 1 and
+	   sysex message status byte is correct
+	 */
+	if (read_type == LINE6_MIDIBUF_READ_RX) {
+		if (command == 0xb2 || command == 0xc2 || command == 0xf2) {
+			unsigned char fixed = command & 0xf0;
+			this->buf[this->pos_read] = fixed;
+			command = fixed;
+		}
+	}
 
+	/* check MIDI command length */
 	if (command & 0x80) {
 		midi_length = midibuf_message_length(command);
 		this->command_prev = command;
--- a/sound/usb/line6/midibuf.h
+++ b/sound/usb/line6/midibuf.h
@@ -8,6 +8,9 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
+#define LINE6_MIDIBUF_READ_TX 0
+#define LINE6_MIDIBUF_READ_RX 1
+
 struct midi_buffer {
 	unsigned char *buf;
 	int size;
@@ -23,7 +26,7 @@ extern void line6_midibuf_destroy(struct
 extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
 extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
 extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
-			      int length);
+			      int length, int read_type);
 extern void line6_midibuf_reset(struct midi_buffer *mb);
 extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -159,8 +159,9 @@ static struct line6_pcm_properties pod_p
 	.bytes_per_channel = 3 /* SNDRV_PCM_FMTBIT_S24_3LE */
 };
 
+
 static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
+	0xf0, 0x7e, 0x7f, 0x06, 0x02
 };
 
 static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,


