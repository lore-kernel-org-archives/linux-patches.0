Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23108415F04;
	Tue, 21 Jul 2026 20:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664343; cv=none; b=iMbnqxv8pdTZG4wHbh8kb3kd9aVKZmjk2gAu3OXcFTREepv6Wy+672tgc9ZEVUbyBFniS1tqJrjE42OTDtifU3D8kyTF+4Sj24TYvTvofww3IPAkJEtHQrEqmot9aw9y4KFnFFePAyOwZ3sHgH+tMyzSST1mpAzMNaBu+R02lAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664343; c=relaxed/simple;
	bh=7+/3k+2VDB2p0s+jZcQ0gUhrr7agBOQM7mg196kKXjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOmqvc1YyKIzeeSEdFospGXgWqHb2b+cytKhC069TYyY92jr7tAx+noFD8BKKgfBMGOmO9ceodIreQw68U4HARhuqIXPEiYPlJ5tZUSddaHqbp22hVDpbX5aDGHoPcuL0tnIG71b66Ne3MFJx/fVAits8u6VlUhxeoD5hsNzeWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBlKCGaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBlKCGaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2B01F000E9;
	Tue, 21 Jul 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664342;
	bh=STBwNlgOPL3cur5INnSbwoHJSC1Uzd0tqk6zjPloqNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBlKCGaWxzp+VeA+cVZuKyrPWR8RuKyQHZSNpYcEYR4hrm5lE2BoZNMZJcXvb9nV0
	 D2y8v4hF37CnzJApGXZaNcfD+REbiZfGbHynQCf5v7mMfrfZP6FnZ9cUg8VTj/Tkgt
	 QdzcoG0D604M89srLeRc0iENIfMs/bdw3tDRuxGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wigham <michael@wigham.net>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1165/1276] io_uring/rw: preserve partial result for iopoll
Date: Tue, 21 Jul 2026 17:26:48 +0200
Message-ID: <20260721152512.089878659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Michael Wigham <michael@wigham.net>

[ Upstream commit c554246ff4c68abf71b61a89c6e39d3cf94f523e ]

A partial read will store the completed byte count in io->bytes_done.
The regular completion path applies io_fixup_rw_res() so that, when the
following operation reaches EOF, the number of bytes already read is
returned.

The iopoll completion path does not apply this fixup to the return value
and can return zero instead.

Use the fixup result when updating the CQE, and the raw result for the
reissue check.

Cc: stable@vger.kernel.org
Fixes: 4d9cb92ca41d ("io_uring/rw: fix short rw error handling")
Signed-off-by: Michael Wigham <michael@wigham.net>
Link: https://patch.msgid.link/20260613225240.34032-1-michael@wigham.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -546,15 +546,15 @@ static void io_complete_rw_iopoll(struct
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
+	int final_res = io_fixup_rw_res(req, res);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
-	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req))
-			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-		else
-			req->cqe.res = res;
-	}
+
+	if (res == -EAGAIN && io_rw_should_reissue(req))
+		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
+	else if (unlikely(final_res != req->cqe.res))
+		req->cqe.res = final_res;
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);


