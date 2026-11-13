Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590485;
	b=VFg6fPiRHiT4EhZIiZmn6wcSqamAtadOZNEfArkeEGhvL0LDX31otkStHSy0k1m7gy9V
	 0WVFrQvVHvHEhuLPyorYmYDdftPYcXan5YYfsJOvYMj+obqHp1VWNl3gQfDYUVPPO50nI
	 h3CiSabXy9c9fLvN3D+G+y2oC6j7htPlcE/RQ0w5Y/isfzJVR+pkij+Dw2hnVqto1U0Gy
	 xIye5+mVpZ48A71yEvycK9X2xJsb1jToueBPjnguliuR7CDotufTsMvlys92GgSrduyWn
	 pA86gSOEWe6HuSj5PAQFqac1mepm6KnMXgZohumWgXkBPtfDIixhBlj7AK8DxEjHU4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i8v27y2Zbb9oIzFE/MlvJOxcYO0RFdQQzvGpSPgQvG8=;
	b=a4bx6sL7wAX9wswIP0NxxT1iYGYZtFIeFT1o6LLZfJf9qmwcCfefiLEBfEQSkiXUjp/l
	 KCe36NK1rCkjnuCNn0JoUA8WozXjo70zDj0ARf3h/sGPnZWsHTHenDnslyx7T+6fQMnIP
	 7kv/mFw/W9XLupY2TtszkWB5sgA891ZrFgy5j0so5+JXp9HrggfNrcOfCF5eUODQK2PTl
	 NvPQwmrHtJzDR/h/aW1mPPVaZ9msiXVfLgR8CVCHEOnpajoNqZ2Dy4UQsxahH+GpG6dCx
	 GSLRw03p4o0DfQ8I2MELFuPD88c8reMvalFVHlIDXh4cFyRwhywa3bcePwtzrKTbmRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTXfpOzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC6606B819;
	Fri, 13 Nov 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTXfpOzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086171F000C4;
	Fri, 13 Nov 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590485;
	bh=i8v27y2Zbb9oIzFE/MlvJOxcYO0RFdQQzvGpSPgQvG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTXfpOzB9ilMvRoZPmVE0IrdJmb2SYP49Bovv898Osb/GQVtBQMkAV6UugjbSdCdE
	 hoNBboljObXMlBfV8Aha02Vzlqn6RFIz8GOifS6P0OLAfx5gvA1B5/E7ikMkg/+2s9
	 MnO5IXSiFKS00OpMy1hSmKPH/Bud77b4QjWXQg5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/686] ALSA: usx2y: Guard the playback copy
Date: Fri, 13 Nov 2026 10:49:29 -0500
Message-ID: <20261113153835.678791593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit e2c6de52ffacb2c0f4076884ee3fdb744735a4cb ]

usx2y_urb_play_prepare() sums the packet lengths of a whole URB, copies
that many frames with a single wrap, and sizes each playback packet from
the capture packet's actual_length. Three things are unchecked: that the
URB fits in the ring buffer, that a packet fits in the playback
endpoint's maxpacksize, from which tmpbuf is allocated, and that
actual_length is a whole number of frames. The ISO descriptors take the
raw actual_length while transfer_buffer_length and the copies take
count * stride, so a packet that is not a multiple of the stride makes
the descriptors add up to more than the buffer, by up to stride - 1
bytes per packet.

Return -EPIPE, as the existing packet-size check does, when the URB is
larger than the buffer or a packet is larger than maxpacksize, and size
each descriptor from whole frames, so the descriptors add up to
transfer_buffer_length and each stays within maxpacksize. The buffer
case is prevented by the previous patch and this is the guard for it;
the other two depend only on the device.

The first case is reachable on the unpatched driver with ordinary
packets: on 7.3-rc7, a USB/IP device presenting the US-122 interface
layout and sending 48-frame packets, with a 100-frame playback buffer
(two 50-frame periods, inside the stock constraints), KASAN reports:

  BUG: KASAN: out-of-bounds in i_usx2y_urb_complete+0x79b/0x1ac0
  Read of size 18446744073709551280 at addr ffff88800e6b02e0 by task vhci_rx/80

With both patches, the same device and a 200-frame playback buffer is
refused at hw_params with EINVAL, and a 400-frame buffer plays for 30 s
with the position advancing inside the buffer, no KASAN report and
neither guard message. The maxpacksize check is not exercised: the
emulated device reports the same wMaxPacketSize on both endpoints.

The descriptor case is visible with capture packets of 195 bytes at
stride 4 (48 frames and 3 bytes): without this change the four
descriptors add up to 780 bytes for 768 bytes of data, and USB/IP's
completion check refuses the URB ("total length of iso packets 780 not
equal to actual length of buffer 768", -EPROTO), after which the driver
stops the streams. With this patch every descriptor is 192 bytes, the
descriptors add up to the data in every URB for 30 s, the position
advances inside the buffer and KASAN reports nothing. The 48-frame
playback run above is unchanged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Link: https://patch.msgid.link/20261104122136.1518-3-enscrpt@pm.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2yaudio.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 12b1c890812ba..f035add1e1b5a 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -118,14 +118,31 @@ static int usx2y_urb_play_prepare(struct snd_usx2y_substream *subs,
 				__func__, counts);
 			return -EPIPE;
 		}
+		if (counts * usx2y->stride > subs->maxpacksize) {
+			dev_err_ratelimited(&usx2y->dev->dev,
+					    "%s: packet of %i bytes exceeds maxpacksize %u\n",
+					    __func__, counts * usx2y->stride,
+					    subs->maxpacksize);
+			return -EPIPE;
+		}
 		/* set up descriptor */
 		urb->iso_frame_desc[pack].offset = pack ?
 			urb->iso_frame_desc[pack - 1].offset +
 			urb->iso_frame_desc[pack - 1].length :
 			0;
-		urb->iso_frame_desc[pack].length = cap_urb->iso_frame_desc[pack].actual_length;
+		urb->iso_frame_desc[pack].length = counts * usx2y->stride;
 	}
 	if (atomic_read(&subs->state) >= STATE_PRERUNNING) {
+		/*
+		 * The copy below wraps once, which needs count <= buffer_size.
+		 * snd_usx2y_pcm_open() guarantees it; guard anyway.
+		 */
+		if (unlikely(count > runtime->buffer_size)) {
+			dev_err_ratelimited(&usx2y->dev->dev,
+					    "%s: URB of %i frames exceeds %lu-frame buffer, stopping\n",
+					    __func__, count, runtime->buffer_size);
+			return -EPIPE;
+		}
 		if (subs->hwptr + count > runtime->buffer_size) {
 			/* err, the transferred area goes over buffer boundary.
 			 * copy the data to the temp buffer.
-- 
2.53.0



