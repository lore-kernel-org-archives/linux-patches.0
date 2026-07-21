Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C803744AB6A;
	Tue, 21 Jul 2026 21:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668169; cv=none; b=ZysaukePd2ph6hOfkxzTrNgka5oB0qQM7rRVKMkXSOS4yZbDJGilPltESfa3rqACE6T98Yy5PvpedrtB7HJp358DaUvBLkPQ6+NEzTY+1ur5zfsdEeKZr1PZupGMN924i0HOnqBuwrCfBgIyoz/XFkDKjQpXZQlS+GgzBBw71IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668169; c=relaxed/simple;
	bh=/FTLW/mFg5I0oiy5cCfO4j+4avz3izzZ0Bfl/keCoGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N78gW7ol3H94YUpF9M+wiD0gU+5zqhtSFK1xdrzzoYueQ0PHdtrWMVqUOfIlikL/XkF4cNMjBA8MW7uoW8T27dEpm31Q0ovHBh0tMPIVNw2JeYoqp0KcDXxFl7Y/W3zlm77+sS4esMLtMsN1UWA4RbGKt54Sb9fHHNauDMW9/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FjP+xcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FjP+xcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C081F000E9;
	Tue, 21 Jul 2026 21:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668168;
	bh=tMQlGX+0aZ61cag0TxOV0ad50j8UZmGX+DfCNntJtyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FjP+xcOW60CfFE70AEO/G+8gvkMTvX8Nx2LD1YIMVrcBBd1aq6jfVHlfi/VB1JOi
	 f6Dg9ApJ4LXiJOylM1mTopkJEC0WWVuc/X35g+bDlqMVgEvMnZNX2QwhQuGKO3GQpf
	 0fxywKJ9TlrhVUWeU08AuBD2y08Fez2+aPY5jXq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0074/1067] ALSA: caiaq: fix out-of-bounds read in the Traktor Kontrol S4 input parser
Date: Tue, 21 Jul 2026 17:11:15 +0200
Message-ID: <20260721152426.226639731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


