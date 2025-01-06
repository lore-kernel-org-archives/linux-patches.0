Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59E3DF71;
	Mon,  6 Jan 2025 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177956; cv=none; b=VqTs+UCKbAdNt1QJUCWx8YZBTNlkRGtmIfzez941IWJJyxieBApin+9FZJRZDgM7dfEFMtBhw/9eFIP9WVyrC+wLMv/KPNZioN+sF8DtKDiYDDFIUyvVaruJUm36Ouh+9JRy3U/h1OWSeaEwWd7r60vneCBmtiyFJ6Ww276YO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177956; c=relaxed/simple;
	bh=Z5DE41UUzw0iAPx/SVGELuLlZEYpRVxDKgcXV7V53X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArD2jW19JzRbptwIzIgsh8nkXeXVW4MjyLrlHI+JTczkz/iKWpGkaCQGJYjZWfFoUvtpCNOIEmxNRDb9jLZq1UOX53/Ng4GrEutpRDsUI2hVPLAXfoADhgXeOKXnCB1VYZYX6NuNJTrH5XJboUFVnORSnughwgOP5N/JsbCpAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICQ/Tvr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICQ/Tvr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DECEC4CED2;
	Mon,  6 Jan 2025 15:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177956;
	bh=Z5DE41UUzw0iAPx/SVGELuLlZEYpRVxDKgcXV7V53X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICQ/Tvr/Qzwiq4SPIfeXI4YpjYrMXaFn0FH74yxsiPa/OhwmoOLub4/RP0zJTZ+Bn
	 98nNKbZY31uJ83WXn6U9tUIc86be+KkBrEAv03853c0M+8UPYvKU3czZVBmib/dWfc
	 +Ge5Eei9uM3GMYytrAo+9qeWr+3ea/qTqvadm2z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Fernet <gwendalfernet@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 112/156] io_uring/kbuf: use pre-committed buffer address for non-pollable file
Date: Mon,  6 Jan 2025 16:16:38 +0100
Message-ID: <20250106151145.945914906@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit ed123c948d06688d10f3b10a7bce1d6fbfd1ed07 upstream.

For non-pollable files, buffer ring consumption will commit upfront.
This is fine, but io_ring_buffer_select() will return the address of the
buffer after having committed it. For incrementally consumed buffers,
this is incorrect as it will modify the buffer address.

Store the pre-committed value and return that. If that isn't done, then
the initial part of the buffer is not used and the application will
correctly assume the content arrived at the start of the userspace
buffer, but the kernel will have put it later in the buffer. Or it can
cause a spurious -EFAULT returned in the CQE, depending on the buffer
size. As bounds are suitably checked for doing the actual IO, no adverse
side effects are possible - it's just a data misplacement within the
existing buffer.

Reported-by: Gwendal Fernet <gwendalfernet@gmail.com>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..eec5eb7de843 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -139,6 +139,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
+	void __user *ret;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -153,6 +154,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
+	ret = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -168,7 +170,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
-	return u64_to_user_ptr(buf->addr);
+	return ret;
 }
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-- 
2.47.1



