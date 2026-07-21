Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD6A472F62;
	Tue, 21 Jul 2026 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664905; cv=none; b=VlkzO3CHXq2QESTV4+/NbWl4r2dVM0M/5f0EGlJDyT4KKHjhMgDpgbjjkDOJQxh+YMkjyymsP2rTZ7PSbBst5k5SNExBWTA+D93N6t438nWz7ET8GdQhENh4KSNNaxlEZT4uA+JfKZGPpld3s0/ChEMam3ptYzcZg0GcPJHfhls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664905; c=relaxed/simple;
	bh=rixbwuC2m+H/ozH3J4NTP+icW4B19OzxyUawga5KDAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY/ikEKoEnbDRhmqkdhH6KgFJ1VKG9oAbBM8EqXEAIqWRYw1+8v9czqo3wGpczU5RoL9lZ3RZhffAL+8GNGrDHHPe2tYe5dfqlc26E3cSvfSud66ar7ulhRaOIygkK12/zdcrsDuQPxbJWjqU5WQTpoXrTEe4EY3uTg162fNocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdSPfDlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdSPfDlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391741F000E9;
	Tue, 21 Jul 2026 20:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664904;
	bh=qYsJdnjFZmQ8+ZZZAM8JtlR7BsrPdy06EQGxhc6tP3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdSPfDlcFVGK6FAIK3TuGnYxlFbUcjrrVKjn04j77EGdVS6gsea9Zsss5HlWxBChZ
	 Iwp3XXzbMMNZl7elQWoiVz6SctP35Y3Qg7/DnKlmP0b9GdKVTrvK6MNOfJ79NnMwQX
	 /1PU6itorfd+PouD9DUE/c1g/ldaDCMpxRNtCfEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0104/1266] ALSA: caiaq: fix out-of-bounds read in the Traktor Kontrol S4 input parser
Date: Tue, 21 Jul 2026 17:09:01 +0200
Message-ID: <20260721152444.127020575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit f7f3f9fd81e7adbaa12c2e62ee07f0e094a543fd upstream.

snd_usb_caiaq_tks4_dispatch() decodes the Traktor Kontrol S4 input
stream in fixed 16-byte (TKS4_MSGBLOCK_SIZE) message blocks. On every
iteration it advances buf and subtracts the block size while looping on
"while (len)".

len is urb->actual_length. That value is supplied by the device and is
not guaranteed to be a multiple of 16. When a final short block leaves
len between 1 and 15, the loop runs once more, reads up to buf[15], and
then does "len -= TKS4_MSGBLOCK_SIZE". As len is unsigned this underflows
to a huge value. The loop then keeps iterating and walking buf far past
the end of the 512-byte ep4_in_buf, reading out of bounds until a bogus
block id happens to be hit.

Iterate only while a full message block is available. This stops the
unsigned underflow and silently drops any trailing partial block, which
carries no complete control value anyway.

The sibling endpoint-4 parsers are not affected. The Traktor Kontrol X1
and Maschine arms in snd_usb_caiaq_ep4_reply_dispatch() floor
urb->actual_length before dispatching.

Fixes: 15c5ab607045 ("ALSA: snd-usb-caiaq: Add support for Traktor Kontrol S4")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/178176259547.3343534.2724779296835237429@maoyixie.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -330,7 +330,7 @@ static void snd_usb_caiaq_tks4_dispatch(
 {
 	struct device *dev = caiaqdev_to_dev(cdev);
 
-	while (len) {
+	while (len >= TKS4_MSGBLOCK_SIZE) {
 		unsigned int i, block_id = (buf[0] << 8) | buf[1];
 
 		switch (block_id) {


