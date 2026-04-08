Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44913B0AFC;
	Wed,  8 Apr 2026 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673603; cv=none; b=Kobif//ZXPkr+T8Xg7L5y2WqNz2V7Zm3rL8QkrOPvfI6O+AgImY32+sFLD2wxMWZ0zuLBZ9gLTmpxKU+2KFPDdd9vVGilluj2507aR4Cm8AKruiFZS1np41pjVbOzr0Qk7f8/sOY8A0Bu8eDLctGjXhHAL20W2FZkL/BzxchRFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673603; c=relaxed/simple;
	bh=DCU+7awH5G52O/BMX5IztkPhri7TKCwCVFVgQGbnFeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCMAD5NNLpGRsjy1r1fUPRguXlqDnW345IAy1MNxx3IZfzjNrCMaDEqlAqo4QZ81xk15G6l0w5c6jKwRxc0wzOSCMfHKP/IsOlih5+h5tBAKBvlj19WJsaEaQHKvR2HShwf6cVJfqOR+x1dLYhHJ36gC+rTHsRldsHYpDjxy4J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StR4jKhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StR4jKhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C415C19421;
	Wed,  8 Apr 2026 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673603;
	bh=DCU+7awH5G52O/BMX5IztkPhri7TKCwCVFVgQGbnFeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StR4jKhLJ++LKxOU0LLlQc6c7fPuVk/35U4zjPIwAn0t1Yk09O3oRwlfYCg3TcUkm
	 RncrSqUONv/k+4mhwczfHHFXV8Ks6qhY7KkyFcchgrLNPmI2DBYr1a6U3HG2rhQ7y8
	 arwiTCy9gTMurd134YTJVcJ895b5Q4i/4pDcytww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 019/242] io_uring/rw: check for NULL io_br_sel when putting a buffer
Date: Wed,  8 Apr 2026 20:00:59 +0200
Message-ID: <20260408175927.790469166@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 18d6b1743eafeb3fb1e0ea5a2b7fd0a773d525a8 upstream.

Both the read and write side use kiocb_done() to finish a request, and
kiocb_done() will call io_put_kbuf() in case a provided buffer was used
for the request. Provided buffers are not supported for writes, hence
NULL is being passed in. This normally works fine, as io_put_kbuf()
won't actually use the value unless REQ_F_BUFFER_RING or
REQ_F_BUFFER_SELECTED is set in the request flags. But depending on
compiler (or whether or not CONFIG_CC_OPTIMIZE_FOR_SIZE is set), that
may be done even though the value is never used. This will then cause a
NULL pointer dereference.

Make it a bit more obvious and check for a NULL io_br_sel, and don't
even bother calling io_put_kbuf() for that case.

Fixes: 5fda51255439 ("io_uring/kbuf: switch to storing struct io_buffer_list locally")
Reported-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -598,13 +598,16 @@ static int kiocb_done(struct io_kiocb *r
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
+			u32 cflags = 0;
+
 			/*
 			 * Safe to call io_end from here as we're inline
 			 * from the submission path.
 			 */
 			io_req_io_end(req);
-			io_req_set_res(req, final_ret,
-				       io_put_kbuf(req, ret, sel->buf_list));
+			if (sel)
+				cflags = io_put_kbuf(req, ret, sel->buf_list);
+			io_req_set_res(req, final_ret, cflags);
 			io_req_rw_cleanup(req, issue_flags);
 			return IOU_OK;
 		}


