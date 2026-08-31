Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5176353ED0D;
	Mon, 31 Aug 2026 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183951; cv=none; b=R2HCBcEeNQsHzYbxpvqDV75qroWtZ/4vSLStm5JaLWDJMHfcGnuBXl9DFs0/UpRt3/dZIpiUBJIGPd6SWvhbWKBcYnZZh27nkdcuA3B8UQuYjgUwqW1Y6LTvVoKa4X8tBsJzPfT2iwZaYDsgTDJAFWSov2yzstkIIzvWvtInvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183951; c=relaxed/simple;
	bh=cU3Ei3XmhIVP4T2tIPb+eCUVRfJAHAw728LFsVwX7bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNfujpvAuzy6j1yUNltWshM4Nc1AOlVUqyJvDBG5iW9hP++gg3p4Nr3XCbWC/OVhsD6AdqBwz0cO+sGZytjCx/mUE4INDXlr4ML5uV946aNVRMSxkhpIF8948JhRkA4gSiF2D6KQ/5cVj4lap9HBO4DACCxoPVi2QlKB5dadrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsER7IX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsER7IX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE41C1F00A3F;
	Mon, 31 Aug 2026 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183948;
	bh=HaqI7wAxuvOIosI/9HoFAeT6ripVTI7wGEpUaCIqGWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsER7IX6Ruhovh1QalbJ+IZftrV2OvljC+KDSzCLCAZTPO/wEn7AKgpYY19H9G2un
	 TE0OBM7SsZR2EudksuyX8oUQDtUwEGlVIvCq3aOz9TJWacD/sS4yYDo3cDJTeE7K1f
	 T6BB7K1WtRpCR1LRVfWI5NERRcO9TYrRaPM5OfuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 20/83] io_uring/futex: only mark private futex waits as inflight
Date: Mon, 31 Aug 2026 15:33:56 +0200
Message-ID: <20260831133400.254984027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 4d327bbd1cd2485783553b6b2b401aa475f90dd0 upstream.

Inflight tracking of futex wait requests exists to ensure that do_exit()
-> io_uring_files_cancel() cancels them before the mm goes away, as a
private futex wait depends on the mm private futex hash staying alive
for the duration of the request.

Shared futexes have no such dependency. A FLAGS_SHARED request always
resolves to either an inode based key or an mm-shared key, both of which
fail futex_key_is_private() and hence always hash into the global futex
hash, whose lifetime isn't tied to the mm.

Only mark vectored futex waits as inflight if the futex is private.

Cc: stable@vger.kernel.org
Fixes: 079afb081c42 ("io_uring/futex: mark wait requests as inflight")
Link: https://lore.kernel.org/io-uring/CANGjgdn=R_qyUdE=j9za+vkmqcxacbP-84OHXF4nZ4ho9qRyVg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ kept 6.18's `struct futex_vector *futexv` declaration and changed `ifd->futexv[i].w.flags` to `futexv[i].w.flags` since `struct io_futexv_data` is absent, retaining the `iof->futexv_owned = 0;` init ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -149,14 +149,16 @@ int io_futex_prep(struct io_kiocb *req,
 
 int io_futex_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	int ret;
 
 	ret = io_futex_prep(req, sqe);
 	if (unlikely(ret))
 		return ret;
 
-	/* Mark as inflight, so file exit cancelation will find it */
-	io_req_track_inflight(req);
+	/* inflight tracking only needed for mm private hash */
+	if (!(iof->futex_flags & FLAGS_SHARED))
+		io_req_track_inflight(req);
 	return 0;
 }
 
@@ -179,6 +181,7 @@ int io_futexv_prep(struct io_kiocb *req,
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv;
+	unsigned int i;
 	int ret;
 
 	/* No flags or mask supported for waitv */
@@ -202,8 +205,14 @@ int io_futexv_prep(struct io_kiocb *req,
 		return ret;
 	}
 
-	/* Mark as inflight, so file exit cancelation will find it */
-	io_req_track_inflight(req);
+	/* inflight tracking only needed for mm private hash */
+	for (i = 0; i < iof->futex_nr; i++) {
+		if (!(futexv[i].w.flags & FLAGS_SHARED)) {
+			io_req_track_inflight(req);
+			break;
+		}
+	}
+
 	iof->futexv_owned = 0;
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;


