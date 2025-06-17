Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608361B4257;
	Tue, 17 Jun 2025 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177026; cv=none; b=li5B7DAGuYDbi46TlPnnwiZ6hOpmrRBPn5r2Obd9WNCCJgpGe33Mw8/9EQ49EbjBjwRje0Ql0o86dQitSMnQQu4qpXjdPHDqH1c379LGBr5WqfZaWi2K2ar8qvX9mScgDM084Lj42uEVKZ5YxqUqbitN6GOJFLMdZ8L4DY4mI1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177026; c=relaxed/simple;
	bh=uLg6ZqQDNGNdIaYTFm6SjcjN5gWJA8I6jweXlWyhWLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akpgqKJK3bkW/k9ZqkSMPr5rooUxcL93XFkEoyqt93Fwl1/jQ563DkB3lKMOrGlm31M3vi647I55PpGYkrqvrRxkiqlBP+8lJtED86c2wQTlhte145vG4gXRbydZEaz5SlEWbv72hMmTemnSysxUNu/yn8hWmDX2FUFfBO92l10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFu2gDvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFu2gDvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDCC4CEE3;
	Tue, 17 Jun 2025 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177026;
	bh=uLg6ZqQDNGNdIaYTFm6SjcjN5gWJA8I6jweXlWyhWLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFu2gDvqEjRXgGRgQMHnahIdhcJGZMAODwz9UTSSHIy1SuqMyxfRgjaU0c80BSn6y
	 brlAWYLT6FapBm14LIkn1ZX4wIIX8glbqWDiIZeJMDQzgehUbftz89ntxRVnfYzv2D
	 30cfqOP+oMU5nnCeujJznKSctLado43QunfUTTSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 340/356] io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT
Date: Tue, 17 Jun 2025 17:27:35 +0200
Message-ID: <20250617152351.822987870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit f7c9134385331c5ef36252895130aa01a92de907 upstream.

The checking for whether or not io_uring can do a non-blocking read or
write attempt is gated on FMODE_NOWAIT. However, if the file is
pollable, it's feasible to just check if it's currently in a state in
which it can sanely receive or send _some_ data.

This avoids unnecessary io-wq punts, and repeated worthless retries
before doing that punt, by assuming that some data can get delivered
or received if poll tells us that is true. It also allows multishot
reads to properly work with these types of files, enabling a bit of
a cleanup of the logic that:

c9d952b9103b ("io_uring/rw: fix cflags posting for single issue multishot read")

had to put in place.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -28,9 +28,19 @@ struct io_rw {
 	rwf_t				flags;
 };
 
-static inline bool io_file_supports_nowait(struct io_kiocb *req)
+static bool io_file_supports_nowait(struct io_kiocb *req, __poll_t mask)
 {
-	return req->flags & REQ_F_SUPPORT_NOWAIT;
+	/* If FMODE_NOWAIT is set for a file, we're golden */
+	if (req->flags & REQ_F_SUPPORT_NOWAIT)
+		return true;
+	/* No FMODE_NOWAIT, if we can poll, check the status */
+	if (io_file_can_poll(req)) {
+		struct poll_table_struct pt = { ._key = mask };
+
+		return vfs_poll(req->file, &pt) & mask;
+	}
+	/* No FMODE_NOWAIT support, and file isn't pollable. Tough luck. */
+	return false;
 }
 
 #ifdef CONFIG_COMPAT
@@ -685,8 +695,8 @@ static int io_rw_init_file(struct io_kio
 	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
+	if (kiocb->ki_flags & IOCB_NOWAIT ||
+	    ((file->f_flags & O_NONBLOCK && (req->flags & REQ_F_SUPPORT_NOWAIT))))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
@@ -752,7 +762,7 @@ static int __io_read(struct io_kiocb *re
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req, EPOLLIN))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
@@ -927,7 +937,7 @@ int io_write(struct io_kiocb *req, unsig
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req, EPOLLOUT)))
 			goto copy_iov;
 
 		/* File path supports NOWAIT for non-direct_IO only for block devices. */


