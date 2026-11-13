Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585818;
	b=kRHQmEUq2wFKXvn+bcgVkWcc9YQguhLDF+J5/9MxvQlgnx/yUzvMD5mTj1RTuKLEUG3M
	 HhxLfN4bQsBtQsekYcC71x2MX1pm2CD+WQPR9zzixgMXLCmt5Os41nqyZ1QSBhlw3d7X7
	 2HS9TnwA0ZHaDEKkgvkg6Vieybb2dqINSHvhYwO77senBCTD61zcMwzO5etFAXipI5bKO
	 5abm07uTxsv1+UsIStNznicsOzQ6WrhCx6s5v6o/J3pyBYuTm6b7tR6vUqxs4rZ46U+ld
	 Kb4FDyvIlRQsI2Ur0cU8CUjl8i34LTWrtaCY6+hBX38DN8nZJPLLmKdsuJQi3bxqHlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXqwba4KuflhJlfOk7HOVg2dyyYf2P7qOMiACOBqlYk=;
	b=Blr9CuRWMSw90n9TA4r4u7x48cuAK1ElkzvVIBabMomRMXVosqpdz602W6F1AJyMJ2nC
	 ZiHtFFd/wGWsaKcVRQdoVi7DyAWP0ME2MJuTnNYJOdlMhMViOuJjM+LyD2DcRBHWwJmkL
	 SktkU7LqAZHmDEWBaYFyjN7/Qg4RgaESf7l2P6eyfhhbnqQtdfOmvMcjOWH2ljj5b4ais
	 NWVpkHV+nbJiNa/a1x++/esR5FqTVTPWmfNnzc9ORQBRxp2+GLOA51KSH9ZxZWZ4g7NXz
	 /+IGi+A4+iaHUlikiYbaOWvwFs9ok01zX0OaBOfRhrsAm31wHlXFmxiilBI3lseD8Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcXa0ee7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD360A261C;
	Fri, 13 Nov 2026 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcXa0ee7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C001F000C7;
	Fri, 13 Nov 2026 16:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585817;
	bh=IXqwba4KuflhJlfOk7HOVg2dyyYf2P7qOMiACOBqlYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcXa0ee7YFZCGBYfTr/mEkwKTvNSa8EvZpvTqXezWD4RiN8ZsJs8zn7KQL503HF2Y
	 k580h/hIXXsrZ2zJtk4jS2d+B4p2W7181V7tDEENxz6bbXUyTswTGzHtHOAhsaZevX
	 6gk2VvKvVE7M1sC6HTVK33urGQ7UmfEDtZqUNVw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 399/507] ALSA: line6: Reject capture buffers smaller than two packets
Date: Fri, 13 Nov 2026 10:51:43 -0500
Message-ID: <20261113153810.270222139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit db51425c9eb038a8e40e09b837afde015ae9e3ec ]

line6_capture_copy() splits the copy into the ALSA ring buffer once at
the buffer end and wraps pos_done once, which is only correct when one
packet holds at most buffer_size frames. The packet size comes from the
device's endpoint, and the per-device hw structs allow 64-byte periods
with periods_min 1, so a packet can be larger than the whole buffer.
audio_in_callback() logs an oversized packet and then copies it anyway.

The packet size is known at probe time, so constrain
SNDRV_PCM_HW_PARAM_BUFFER_BYTES in snd_line6_capture_open() to at least
twice the larger of the two endpoints' packet sizes. Two rather than
one, because pos_done advances by the packet and wraps once, so a buffer
of exactly one packet leaves the position unchanged after every packet.
hw_params then rejects a buffer that cannot hold two packets, and the
single wrap is valid for every configuration that gets through. Keep a
guard in line6_capture_copy() that drops an oversized packet with a
ratelimited error, for the case that should no longer be reachable.

Reproduced on 7.3-rc7 with a USB/IP device presenting the GuitarPort
interface layout and 1024-byte packets into a 128-byte buffer: ALSA
logged "invalid position: pos = 224, buffer size = 32" and the driver
logged "driver bug: len" on every following packet. With this patch a
1024-byte buffer is refused at hw_params, and a 2048-byte buffer streams
for 30 s with no report and with the position moving inside the buffer.

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Link: https://patch.msgid.link/20261103132227.696-1-enscrpt@pm.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/capture.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/usb/line6/capture.c b/sound/usb/line6/capture.c
index ceee51eeda0df..32922b7f2ffc7 100644
--- a/sound/usb/line6/capture.c
+++ b/sound/usb/line6/capture.c
@@ -94,6 +94,18 @@ void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf, int fsize)
 	if (runtime == NULL)
 		return;
 
+	/*
+	 * snd_line6_capture_open() constrains the buffer to hold at least
+	 * two packets, so this cannot happen for a conforming device. Drop
+	 * the packet rather than overrun the single wrap below.
+	 */
+	if (unlikely(frames > runtime->buffer_size)) {
+		dev_err_ratelimited(line6pcm->line6->ifcdev,
+				    "packet of %d frames exceeds %lu-frame buffer, dropping\n",
+				    frames, runtime->buffer_size);
+		return;
+	}
+
 	if (line6pcm->in.pos_done + frames > runtime->buffer_size) {
 		/*
 		   The transferred area goes over buffer boundary,
@@ -231,6 +243,23 @@ static int snd_line6_capture_open(struct snd_pcm_substream *substream)
 	if (err < 0)
 		return err;
 
+	/*
+	 * line6_capture_copy() wraps the ring buffer once per packet and
+	 * advances pos_done by the packet, which only works when the buffer
+	 * holds more than one packet: with exactly one, pos_done gains a
+	 * buffer and loses it again on every packet. The packet size comes
+	 * from the device, so bound the buffer by two packets here. The
+	 * impulse-response path copies a playback URB into this ring, so
+	 * take the larger of the two endpoints.
+	 */
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+					   2 * max(line6pcm->max_packet_size_in,
+						   line6pcm->max_packet_size_out),
+					   UINT_MAX);
+	if (err < 0)
+		return err;
+
 	line6_pcm_acquire(line6pcm, LINE6_STREAM_CAPTURE_HELPER, false);
 
 	runtime->hw = line6pcm->properties->capture_hw;
-- 
2.53.0



