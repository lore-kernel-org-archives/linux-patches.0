Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7950C3D75AF;
	Wed,  8 Apr 2026 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673593; cv=none; b=WWGBzItKS44Yd8fMIN4ECKqW4/qxEwCVj+1II4Kf30fv6LPNlQnMxBmkh1wNRUnkuFlM/S00h7fBVADDFTQlAcV4MTEBP6QFCGAMEXLr1REX8kLqm1Mbas/kmpYaIJviARJahhloT/LfLob5mCawA8Uel2mVCQndE2Cpi61NJpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673593; c=relaxed/simple;
	bh=gFAJ5tgGwRY92Wq4CCVG4JEwGSFcn4spCy/KPECmwws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Lk99UBOa66XOoiDSwe2AoIiVIZ8DHzzSqGaJEFEs/dKM3Y5T+M3e90vII+GCqbQvQ2Q+8o51g2Fn0l42iiBz6Iwu4VuEANfPlbIIW7RJ3QicthwSjx2X4Nx2Nd5gykl+lMXGZsQ9QAvLpMkMn7KjvzbbkedwBMFbDXO3aEMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtfHHnJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtfHHnJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108BFC2BCB0;
	Wed,  8 Apr 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673593;
	bh=gFAJ5tgGwRY92Wq4CCVG4JEwGSFcn4spCy/KPECmwws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtfHHnJWqLM7lVd7H+5HsLSGNixqxD/uYXz3SxFZlZLK9yw49L4MLjJyLm9C3Xoi+
	 /7NplQEdvecR008kD+fXtxJJbCO6e8qcBK9g9oPFeALA6Z4InOHeDesUiX5Ngkfo73
	 JHGTs/NO2YE8V8dquw8b1hfMF1nUniovhMqIWSlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 015/242] io_uring/net: use struct io_br_sel->val as the send finish value
Date: Wed,  8 Apr 2026 20:00:55 +0200
Message-ID: <20260408175927.641828581@linuxfoundation.org>
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

Commit 461382a51fb83a9c4b7c50e1f10d3ca94edff25e upstream.

Currently a pointer is passed in to the 'ret' in the send mshot handler,
but since we already have a value field in io_br_sel, just use that.
This is also in preparation for needing to pass in struct io_br_sel
to io_send_finish() anyway.

Link: https://lore.kernel.org/r/20250821020750.598432-11-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -507,19 +507,20 @@ static int io_net_kbuf_recyle(struct io_
 	return -EAGAIN;
 }
 
-static inline bool io_send_finish(struct io_kiocb *req, int *ret,
-				  struct io_async_msghdr *kmsg)
+static inline bool io_send_finish(struct io_kiocb *req,
+				  struct io_async_msghdr *kmsg,
+				  struct io_br_sel *sel)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	bool bundle_finished = *ret <= 0;
+	bool bundle_finished = sel->val <= 0;
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, req->buf_list);
+		cflags = io_put_kbuf(req, sel->val, req->buf_list);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, req->buf_list, io_bundle_nbufs(kmsg, *ret));
+	cflags = io_put_kbufs(req, sel->val, req->buf_list, io_bundle_nbufs(kmsg, sel->val));
 
 	/*
 	 * Don't start new bundles if the buffer list is empty, or if the
@@ -532,15 +533,15 @@ static inline bool io_send_finish(struct
 	 * Fill CQE for this receive and see if we should keep trying to
 	 * receive from this socket.
 	 */
-	if (io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
+	if (io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE)) {
 		io_mshot_prep_retry(req, kmsg);
 		return false;
 	}
 
 	/* Otherwise stop bundle and use the current result. */
 finish:
-	io_req_set_res(req, *ret, cflags);
-	*ret = IOU_OK;
+	io_req_set_res(req, sel->val, cflags);
+	sel->val = IOU_OK;
 	return true;
 }
 
@@ -687,11 +688,12 @@ retry_bundle:
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	if (!io_send_finish(req, &ret, kmsg))
+	sel.val = ret;
+	if (!io_send_finish(req, kmsg, &sel))
 		goto retry_bundle;
 
 	io_req_msg_cleanup(req, issue_flags);
-	return ret;
+	return sel.val;
 }
 
 static int io_recvmsg_mshot_prep(struct io_kiocb *req,


