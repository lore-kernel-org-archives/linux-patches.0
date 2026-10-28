Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209779;
	b=2E4VFhAvGYsnbAwNFX6fPbgN1bZ1EelOEYYZCCpRhLIQGv/lqnut4X4P7UVMl5mRtgpN
	 yy0CYnDuTNqJcKppeF9k63B1iY57qs3kNLZKYUSB9J0MraTSX0Pyds8VYh0P4rTmR8k42
	 8xQwlWLa8CDTVFBrAIhn8KkJbm0vomKbs5cc/tHtNjCIl9esLWi2zKyWBsIsAy+I0Nv3Q
	 BXQZJOj5NdSY/rim8g/9HpWXQ7zERkYuFeOpb3pyOxzb5B1E1hIz1XMcU6swFSu2hgcO1
	 vOZO8NzFnFekdLWSqK620Hi2dQ643h6A7ShnRAUplZ/EQrjpZaW0NN8vzW1PCIf+W6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgSNqoLTbbPGQxGND6lhKbn21vAhPnFrnnaU5vHboCg=;
	b=Tj6fz526CpBeoMg8C5T7DOv1TFmJUiwtfQeaJgUrh6NCWWP+KDOg3m75MvyU3/6YKnHk
	 StqLj9RwkHzfnvIEwTtf9hMh6sIzhHYdrGhf/a4aQ8QpeCdRCw61U2MMqHAsfz/q+vbQR
	 6KOBtrFqsHWZzCwfb4aTLhttZZeUsknbwZyAJxgaF7tJeksPtYBDRHcgT8DnJqmgpTHL1
	 dPU+GXEExYTmbqMuhc+93BvBIvKkKZThJu6K9PsClmf5r9F8ISYuqkFQGQ+2/alut5jz0
	 mBGPsDofyF3HnTe2nIYJNqD7gg9SBeOZ693QLR+OrKsiypGHSL1H/i3Ef0UOPNdY83w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXTgXkIy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D412606A31E;
	Wed, 28 Oct 2026 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXTgXkIy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF841F01829;
	Wed, 28 Oct 2026 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209779;
	bh=TgSNqoLTbbPGQxGND6lhKbn21vAhPnFrnnaU5vHboCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXTgXkIyhdK3vF231sp+zTer2WVCpVZCm06Hi4Yc6QaNRHIvWESS5mA8nzDUlwSEV
	 omf6aQTkLIKxIMpvjtot47SsKyzQlyYChpX42L+Im8n2/3fFlU8vLbbbJ6rxBXVeGK
	 DFnQfKIsq71RFmJIjzhmii3Bc0WdiaORAhaZZpEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 073/109] io_uring/kbuf: handle index wrap in last buffer check
Date: Wed, 28 Oct 2026 18:00:57 +0100
Message-ID: <20261028165944.075282584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 6e773b5161506a4d0e739eb3aa4667d28f20219c upstream.

io_ring_buffer_select() flags the request with REQ_F_BL_EMPTY if it takes
the last buffer of the ring. Head and tail are 16-bit counters, but
"head + 1" is computed as an int. If head is 65535 and tail has wrapped
to 0, that compares 65536 to 0 and the flag isn't set.

A bundle receive relies on the flag to tell that there is no point in
trying to get more data. Without it, it goes for another round, finds no
buffer, and the request, which has received data, is marked as failed on
account of the -ENOBUFS. That severs a link, and ends a multishot.

Fixes: c3f9109dbc9e ("io_uring/kbuf: flag request if buffer pool is empty after buffer pick")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-36-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -203,7 +203,7 @@ static struct io_br_sel io_ring_buffer_s
 	if (unlikely(tail == head))
 		return sel;
 
-	if (head + 1 == tail)
+	if ((__u16)(head + 1) == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);


