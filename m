Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F53244AB6A;
	Tue, 21 Jul 2026 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673141; cv=none; b=sINq/TaQf7vtp1xIKEVK05RcujJJWiCfSx3IFY6AP2JHQUTuBLlTcsqHxsJXo4D7LiOdxKErnrgHRC4V6ibWlvMO5mMQl6bj5THKwkek8QhsYZ0hAlw0mtTxemF7oa4CkCUASX4RabDjvYq/4UaRAZ25pifyyrvHPNr5ThUGTIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673141; c=relaxed/simple;
	bh=D07WKO34i4YRY8UrC/gekbHcmB9DAlCGDuZfmqCAACU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLMy2FZmwr3nNvet2AyH4U1I54kTukHgKbX9M9X6/x3U8QSZa/582TIwluEtM5zwylLa8pyHh96W9cIZXj3uPHazysSZLss6qoyDIQFrstzxR70sB95JjmBCsI8VHp7pMFY6/oCeH0EBNo5n8t+lcbD+1AVtxI07U6T18ookbe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhOUxV2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhOUxV2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1B61F000E9;
	Tue, 21 Jul 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673140;
	bh=LFWJnQMXbW670JD0ZlZMdm4eJpruYgbqgrkbfoPB1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhOUxV2ZTAWwqQGGfhHfzzzFX4Z2fw9zT/iAvb0P6Remi5PXv5MKGRGVyPpKo9HYb
	 SMs8fDT46gpqD76Iho4AuncU0tyMKRmPuQ6L0EGXbFjI6nSmKaLZgDnD2CqrZfrXFl
	 2M3fBR9d9P33hAmIsw3fbOInmhDnKLE+/E5y1juU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 051/699] ALSA: caiaq: fix out-of-bounds read in the Traktor Kontrol S4 input parser
Date: Tue, 21 Jul 2026 17:16:50 +0200
Message-ID: <20260721152356.862117747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


