Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8789F2DC334;
	Fri, 15 May 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860544; cv=none; b=ZuXT/bqDsG00GFPZNUm1Bu7WGzLPQVnkCqj0OEfot75IfOGoXoZCsrzCPnMOKAuRGvK2qndWljsv58Bbiv1QdO9T/B0d1XdRclkkXEBvmfOmL9RjE/2f80CVeNY6VEcXlviqqPTl/pop3DBoL7DCj7jzTexVqUbzXrZfUIeBzCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860544; c=relaxed/simple;
	bh=0UfN7Tx+OBoSHl16bet/g7n0rhOzKyy990/N1ivdexU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeUGr3Hq/kE6x4tgMCvCihcEI1KBFyjqe/pPROF7q9ERY8ATmycfiH1pB+1Gs75OUXG/uM0icfvOiLFapvOiEQVVlLNW4CMcP73t5rErYWHEY1OsSet38t0S5g8yWdJ1q7OHbSAqahCSlijA8aIXemxtB9r4aHWU90pjV9qZw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5tlsRaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5tlsRaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C0C2BCB3;
	Fri, 15 May 2026 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860544;
	bh=0UfN7Tx+OBoSHl16bet/g7n0rhOzKyy990/N1ivdexU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5tlsRaFlrcXJ/dNNFwgjH7Kxs+JZTygl/9K915Sv+zL+Hg/Wz4tq9h9zx0Jc4krk
	 Pn/QHAHVhb0JncLa6lvfZYBGRtBYIkCq5AMsdf/4NT6AAm+D8O9EvzhcPNpYMrTIe1
	 Rz+9/SoEhcfmnBQ9RzVLmU/Mhe1Ww84TmOCUY7IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 130/144] io_uring/kbuf: support min length left for incremental buffers
Date: Fri, 15 May 2026 17:49:16 +0200
Message-ID: <20260515154656.529062291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Martin Michaelis <code@mgjm.de>

commit 7deba791ad495ce1d7921683f4f7d1190fa210d1 upstream.

Incrementally consumed buffer rings are generally fully consumed, but
it's quite possible that the application has a minimum size it needs to
meet to avoid truncation. Currently that minimum limit is 1 byte, but
this should be a setting that is the hands of the application. For
recvmsg multishot, a prime use case for incrementally consumed buffers,
the application may get spurious -EFAULT returned at the end of an
incrementally consumed buffer, as less space is available than the
headers need.

Grab a u32 field in struct io_uring_buf_reg, which the application can
use to inform the kernel of the minimum size that should be available
in an incrementally consumed buffer. If less than that is available,
the current buffer is fully processed and the next one will be picked.

Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1433
Signed-off-by: Martin Michaelis <code@mgjm.de>
[axboe: write commit message, change io_buffer_list member name]
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/io_uring.h |    3 ++-
 io_uring/kbuf.c               |    8 +++++++-
 io_uring/kbuf.h               |    7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -758,7 +758,8 @@ struct io_uring_buf_reg {
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	flags;
-	__u64	resv[3];
+	__u32	min_left;
+	__u32	resv[5];
 };
 
 /* argument for IORING_REGISTER_PBUF_STATUS */
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io
 		this_len = min_t(u32, len, buf_len);
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
-		if (buf_len || !this_len) {
+		if (buf_len > bl->min_left_sub_one || !this_len) {
 			WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
 			WRITE_ONCE(buf->len, buf_len);
 			return false;
@@ -727,6 +727,10 @@ int io_register_pbuf_ring(struct io_ring
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
+	/* minimum left byte count is a property of incremental buffers */
+	if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
+		return -EINVAL;
+
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -747,6 +751,8 @@ int io_register_pbuf_ring(struct io_ring
 	if (!ret) {
 		bl->nr_entries = reg.ring_entries;
 		bl->mask = reg.ring_entries - 1;
+		if (reg.min_left)
+			bl->min_left_sub_one = reg.min_left - 1;
 		if (reg.flags & IOU_PBUF_RING_INC)
 			bl->flags |= IOBL_INC;
 
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -38,6 +38,13 @@ struct io_buffer_list {
 	__u16 flags;
 
 	atomic_t refs;
+
+	/*
+	 * minimum required amount to be left to reuse an incrementally
+	 * consumed buffer. If less than this is left at consumption time,
+	 * buffer is done and head is incremented to the next buffer.
+	 */
+	__u32 min_left_sub_one;
 };
 
 struct io_buffer {


