Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D27B67E;
	Wed,  8 Apr 2026 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673614; cv=none; b=Ie1mEBadwfjXD5lMUEK4Wd++KWfZHtNeI9Ow85EucRyVoKz8oAZalIkHFU56uz9ddbFJsUno26dS72WaoA0rJGGRWz0ibmKz41LeuqmHBLVx8gRnQmu5f+BDngFiAxvgwP6H0nuoFoALGUWsCBkXftvci8W/SjUhgZEb1dwph78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673614; c=relaxed/simple;
	bh=kgPXMPsX2sWukcZ82JUDJHcjRktSM5S3TeW9rICTlAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpjRKst2w0YLimwDUxdblcasg369FB9Geuz6CfWzSgUjhli5VfFznlxFo4A0O4D61hHbadn1jD748uQHYwehqjckzNgHAGIWgOkev9se5ov9w9TX+cMcGEy300DDWtBgV+cPx4r1moa1up58xoOaMnS4IVMwcGI2ahTFh7SFvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2VL77Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2VL77Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C14AC19421;
	Wed,  8 Apr 2026 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673613;
	bh=kgPXMPsX2sWukcZ82JUDJHcjRktSM5S3TeW9rICTlAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2VL77Nn8Z1akLWkg1oyPAVG6rzuVkFleo+cN++Y5dBX/xPxuel336av7zZHw4tVY
	 4VkXI+qHBMSWmdb7k94DzoEY4qwZgbq8FYKZNsWLTRLm6qkbWDGxulOebIa/h3Oedd
	 kymo3hyukOyCC3CZsY7FTnvXhkrDBZsRv2/ecujQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 022/242] io_uring/kbuf: use READ_ONCE() for userspace-mapped memory
Date: Wed,  8 Apr 2026 20:01:02 +0200
Message-ID: <20260408175927.902568786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

Commit 78385c7299f7514697d196b3233a91bd5e485591 upstream.

The struct io_uring_buf elements in a buffer ring are in a memory region
accessible from userspace. A malicious/buggy userspace program could
therefore write to them at any time, so they should be accessed with
READ_ONCE() in the kernel. Commit 98b6fa62c84f ("io_uring/kbuf: always
use READ_ONCE() to read ring provided buffer lengths") already switched
the reads of the len field to READ_ONCE(). Do the same for bid and addr.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -44,7 +44,7 @@ static bool io_kbuf_inc_commit(struct io
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
 		if (buf_len || !this_len) {
-			buf->addr += this_len;
+			buf->addr = READ_ONCE(buf->addr) + this_len;
 			buf->len = buf_len;
 			return false;
 		}
@@ -185,9 +185,9 @@ static struct io_br_sel io_ring_buffer_s
 	if (*len == 0 || *len > buf_len)
 		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -278,7 +278,7 @@ static int io_ring_buffers_peek(struct i
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	do {
 		u32 len = READ_ONCE(buf->len);
 
@@ -293,7 +293,7 @@ static int io_ring_buffers_peek(struct i
 			}
 		}
 
-		iov->iov_base = u64_to_user_ptr(buf->addr);
+		iov->iov_base = u64_to_user_ptr(READ_ONCE(buf->addr));
 		iov->iov_len = len;
 		iov++;
 


