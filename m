Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06B12ED143;
	Thu,  3 Jul 2025 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554430; cv=none; b=dYTD/4U768Krh2k4azfhw84KdnsDUzSYa7PMydxIzJexYwxvha4XWqbudK/H5fJc/LSKx8B9riDOJWaO/zDNg+Pgbj0LNzcGsVvVzxvPqWlBispQfP1pPxnhUrUgfJnqT3AETkrLb9pX/W9Zvsi2Jv008tYGEVm1lhlScY5UeyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554430; c=relaxed/simple;
	bh=xCCELqQ49aqNSKDxjMmkGGfWxUO/WC5VlFtSldckLN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVzAw8Ipa0VEeXZsNLaN3p7Xt5E5SCj8Ca+vd/f7OzBkfPk9Lf0d6J8STBH/dGQ1OGeE6UySuxTTZj/5SxkIMdhhfXn/0a76PFIJoLSWNYOY69kHzqMXiV6sn/pG9JJNWk3yyttmikpVGESBAyfAulnAIA+s+CQGVNLm05CxKJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAS/LSnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAS/LSnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C362C4CEE3;
	Thu,  3 Jul 2025 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554430;
	bh=xCCELqQ49aqNSKDxjMmkGGfWxUO/WC5VlFtSldckLN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAS/LSnAeHljajgspxYfIGX4aYralY5IKSqrdJQvZz+eUumt0Uni0ucZmG8K+Cqnm
	 3ZXvgSsIK2jCmLYuE8hIHlFs0yLcqQv5stsgLvabxTUWE2QppXM/T9aK5JB3CVAs/W
	 UKA6wT/DrQMEjamRDWjwJ2JCdDK5vSWsf1HxCEyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 185/218] io_uring/net: only retry recv bundle for a full transfer
Date: Thu,  3 Jul 2025 16:42:13 +0200
Message-ID: <20250703144003.578207538@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

Commit 3a08988123c868dbfdd054541b1090fb891fa49e upstream.

If a shorter than assumed transfer was seen, a partial buffer will have
been filled. For that case it isn't sane to attempt to fill more into
the bundle before posting a completion, as that will cause a gap in
the received data.

Check if the iterator has hit zero and only allow to continue a bundle
operation if that is the case.

Also ensure that for putting finished buffers, only the current transfer
is accounted. Otherwise too many buffers may be put for a short transfer.

Link: https://github.com/axboe/liburing/issues/1409
Cc: stable@vger.kernel.org
Fixes: 7c71a0af81ba ("io_uring/net: improve recv bundles")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -852,18 +852,24 @@ static inline bool io_recv_finish(struct
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
+		size_t this_ret = *ret - sr->done_io;
+
+		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
 		if (sr->retry)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
-		/* if more is available, retry and append to this one */
-		if (!sr->retry && kmsg->msg.msg_inq > 0 && *ret > 0) {
+		/*
+		 * If more is available AND it was a full transfer, retry and
+		 * append to this one
+		 */
+		if (!sr->retry && kmsg->msg.msg_inq > 0 && this_ret > 0 &&
+		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
-			sr->done_io += *ret;
+			sr->done_io += this_ret;
 			sr->retry = true;
 			return false;
 		}


