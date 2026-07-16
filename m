Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AFB2475F7;
	Thu, 16 Jul 2026 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209169; cv=none; b=Gcp+FIhYnwxYOo8ygOwBASU3dduai77f4LCmIbEzUdqSNpuZBLFIsLQ6R1R3kcJ2YWAutFQf7lf47RCzOEdLxYo7A60xcAuz0iy7K0ZMfeekI1PvGBVrhA4FRWQ0WheqIx3lLUknA5PyccGuWYHT5UreLAz7yZyNFVPt2Bt6S4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209169; c=relaxed/simple;
	bh=Vabj7MbKVu64k4m/sg6+nY1wXvPOPp14vcRI5JEnXYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNJ3zMDngcfDtSDIZkD/551bcVkQ4Gn0VtWI8JzZP/shxY89GkDROlqRvLzjGKdpiY2Sv9VPaD7/kKSrI4j9wj06bWrVCsUaOOxGkH8hmXByAvGxi+E1Cx8bP31sAXRjuZO2cIW5KzvzxVz6oQG7tK+EDqe6vVGJ4z5Jw8Ra7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWN4GnyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWN4GnyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CF01F00A3D;
	Thu, 16 Jul 2026 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209168;
	bh=4IoluAj29j+mgfMZWJrsnM7OFh63WEKnAwAFALfTq1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWN4GnyHUYf6qzl8SRsVjgkESEVtQlYzZ5JEbJ/NSHOknzc37EIbbajKxGqdRVLVX
	 XkAvwcau2qBwpEixM+8tDy6WGaF0phmv2rCwFW48Xl5e56IkofT3aZvvQO9BD/cMKP
	 IStZW5RUQcq0VgczxZ4dDWtW6PkfbJ4g6NAbkSnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 084/518] ALSA: caiaq: fix out-of-bounds read in the Traktor Kontrol S4 input parser
Date: Thu, 16 Jul 2026 15:25:52 +0200
Message-ID: <20260716133049.700734841@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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


