Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9D4A24;
	Mon, 14 Oct 2024 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916575; cv=none; b=QZsO8h1f2rp0jlpQZQqTmkFScyaKKfeqliT02cpueaDW5qhjKqEHfVz5GfkY0kfbYGp4W5LdYwF3tLHzrDyzDl20q+llRABAAaJpTUgNIt/oK0ash90bTrAe/KtwCCglYBWHqywal/AiAiT/iGXRdusfI1OjZoORbEAdUuIpi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916575; c=relaxed/simple;
	bh=e5r201K0kw7qCo2KjtbAXfD/RxQ9jxqd8ej6pZI41j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtkO+PPWZ/lwd5FHGzt0WB7te1w4Z/rmZGl3SpmfhFgcVtDVbb0rntddnMuWHBmmM3owH08eOdZ92fLpgIEoI8ERbIGnHd0cqV2O8il87LMtnLOawW1TFqAoAD61VSscYMDujet3cD5xRnWZaifK2HA2D+AlbvHSemBLCszEA2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXjkr9QL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXjkr9QL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE352C4CEC3;
	Mon, 14 Oct 2024 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916575;
	bh=e5r201K0kw7qCo2KjtbAXfD/RxQ9jxqd8ej6pZI41j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXjkr9QLUg4Sndjten/v4H4Nq7N4cOVeLNLjoyfrh9j9xJHPDrcJAq0tz0ksgRDEl
	 tDob9mjkZmWKwx9sKmurU6Cd8F0j0fl3lcOs2Mtu5ZQM0e4Cnt1KTlsO46FEFVCETx
	 T9g7Jshua8aJBRNMLOo+n3ut1eyyiK/m0r0X4JDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 214/214] io_uring/rw: fix cflags posting for single issue multishot read
Date: Mon, 14 Oct 2024 16:21:17 +0200
Message-ID: <20241014141053.326812530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit c9d952b9103b600ddafc5d1c0e2f2dbd30f0b805 upstream.

If multishot gets disabled, and hence the request will get terminated
rather than persist for more iterations, then posting the CQE with the
right cflags is still important. Most notably, the buffer reference
needs to be included.

Refactor the return of __io_read() a bit, so that the provided buffer
is always put correctly, and hence returned to the application.

Reported-by: Sharon Rosner <Sharon Rosner>
Link: https://github.com/axboe/liburing/issues/1257
Cc: stable@vger.kernel.org
Fixes: 2a975d426c82 ("io_uring/rw: don't allow multishot reads without NOWAIT support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -973,17 +973,21 @@ int io_read_mshot(struct io_kiocb *req,
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
-	}
-
-	/*
-	 * Any successful return value will keep the multishot read armed.
-	 */
-	if (ret > 0 && req->flags & REQ_F_APOLL_MULTISHOT) {
+	} else if (ret <= 0) {
+		io_kbuf_recycle(req, issue_flags);
+		if (ret < 0)
+			req_set_fail(req);
+	} else {
 		/*
-		 * Put our buffer and post a CQE. If we fail to post a CQE, then
+		 * Any successful return value will keep the multishot read
+		 * armed, if it's still set. Put our buffer and post a CQE. If
+		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
 		cflags = io_put_kbuf(req, issue_flags);
+		if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+			goto done;
+
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1004,6 +1008,7 @@ int io_read_mshot(struct io_kiocb *req,
 	 * Either an error, or we've hit overflow posting the CQE. For any
 	 * multishot request, hitting overflow will terminate it.
 	 */
+done:
 	io_req_set_res(req, ret, cflags);
 	io_req_rw_cleanup(req, issue_flags);
 	if (issue_flags & IO_URING_F_MULTISHOT)


