Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED52E8897;
	Thu, 16 Jul 2026 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209443; cv=none; b=DqF39wZ7cqhtxw8mi3/pMpptPiAhNyss0C5GCHGjfeHrPB7fHvm+ecyBOygiEBz9XdAp+AV9KNFd6S/vOvPUkM5lfef8STxuxU28B3nw/2h4b/0ySO6uIg98XF5bvrt57OcbrMnj9+rgYJsf23GVcGd79Yk5y24Lfi5735QHnm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209443; c=relaxed/simple;
	bh=whFg1nXTLMHjeNnrYumHg7fyJ/oT1vyeGxOfGnJMDE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxnHmsqUObGxkUeb9kl67/hrCEPUAEkY+gFp9KAPYF/vWG3hK+ROa9xWMjwxxwqF+7ErcH+hxsg3MTH5aJ+m1xdzx3Ka9ctkm7zXr993uhFkLZjya5DFEE7aKljxuQjYP1A9vps/2y1Tbz4gJXj3nmpeSAdssvUeHEZHuPEp4Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVVv7FZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVVv7FZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F051F00A3A;
	Thu, 16 Jul 2026 13:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209440;
	bh=oa+gGaQauJrXJVbfrefE4hHknnkR4Qh1AniLrorrmw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVVv7FZ+drc9h5pKx5glWU1eX49lnrlACh4LtZ5M7lWWwEHjJE8OE65RgQfZhzezW
	 IB/aPDDQqghEe33QtLz/8FM0kHJHHBK8AUMEFuKRXU9En8pE4/h42+XIkLBXOcIiEy
	 cGnrJiXQgGKKz4qtBW0EshXjVG0sHfjtAYoGBydA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wigham <michael@wigham.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 186/518] io_uring/rw: preserve partial result for iopoll
Date: Thu, 16 Jul 2026 15:27:34 +0200
Message-ID: <20260716133051.905327674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Wigham <michael@wigham.net>

commit c554246ff4c68abf71b61a89c6e39d3cf94f523e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -601,15 +601,15 @@ static void io_complete_rw_iopoll(struct
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


