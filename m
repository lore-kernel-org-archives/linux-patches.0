Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC402BEFFF;
	Wed,  8 Apr 2026 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673590; cv=none; b=ocSuG+Y8qQ9uqlyr5EKEpfCfgzICuLWVsnwopmREdqhg6yrpWooBBGL9Ztsn9GNxwsbOfiWrbbrrOXtN27UyDj/aq/vwpj8gYjVRfzgJgjJdPVKt7L9AFOuBrjbDwXkvKAV0BEfBSSgeIi7QkcrTbivoSOVU/rocfKxj0UVdHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673590; c=relaxed/simple;
	bh=72rqT9SAyhp4igCq8lBmpBCLIT9JdIulhGtA1xjxj1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV6jkHG7Fs8WNJvzeCMQvB0+GEjlG1hxS1JGWSRYD6VUid3WbiOOBZxDXjoxoUTm8KNXH1iEhHBh3XG3dDmbZcMoCS/FvaQA3B96oGY2cIub9jWV1auav4TBYhyFUOKDXqldC0SUTw8HJB/IIcEtjrQWj8VtuNlUjiKj6VAloPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqi8ii1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqi8ii1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5C7C2BCB2;
	Wed,  8 Apr 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673590;
	bh=72rqT9SAyhp4igCq8lBmpBCLIT9JdIulhGtA1xjxj1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqi8ii1wlTF8ZYOLac4yGz708Uct2fEMs1kZ1Pj8yP6Y/seIObgE9J6p+kZD4ggGL
	 1frnJcictHTxTFDhJX9pRIMYFb2EZvWc/eMGGcAm8wk3kHKTTe5ynbtUKfz9R9hHlC
	 D9xIp7wyAOf8OIqjE+xCd8njSHhYQ/0OfTVy7OpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 014/242] io_uring/net: use struct io_br_sel->val as the recv finish value
Date: Wed,  8 Apr 2026 20:00:54 +0200
Message-ID: <20260408175927.604780289@linuxfoundation.org>
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

Commit 58d815091890e83aa2f83a9cce1fdfe3af02c7b4 upstream.

Currently a pointer is passed in to the 'ret' in the receive handlers,
but since we already have a value field in io_br_sel, just use that.
This is also in preparation for needing to pass in struct io_br_sel
to io_recv_finish() anyway.

Link: https://lore.kernel.org/r/20250821020750.598432-10-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -857,9 +857,10 @@ int io_recvmsg_prep(struct io_kiocb *req
  * Returns true if it is actually finished, or false if it should run
  * again (for multishot).
  */
-static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
+static inline bool io_recv_finish(struct io_kiocb *req,
 				  struct io_async_msghdr *kmsg,
-				  bool mshot_finished, unsigned issue_flags)
+				  struct io_br_sel *sel, bool mshot_finished,
+				  unsigned issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags = 0;
@@ -868,7 +869,7 @@ static inline bool io_recv_finish(struct
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		size_t this_ret = *ret - sr->done_io;
+		size_t this_ret = sel->val - sr->done_io;
 
 		cflags |= io_put_kbufs(req, this_ret, req->buf_list, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->retry_flags & IO_SR_MSG_RETRY)
@@ -889,7 +890,7 @@ static inline bool io_recv_finish(struct
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, req->buf_list);
+		cflags |= io_put_kbuf(req, sel->val, req->buf_list);
 	}
 
 	/*
@@ -897,7 +898,7 @@ static inline bool io_recv_finish(struct
 	 * receive from this socket.
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
-	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
+	    io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE)) {
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
 		io_mshot_prep_retry(req, kmsg);
@@ -910,20 +911,20 @@ static inline bool io_recv_finish(struct
 			mshot_retry_ret = IOU_REQUEUE;
 		}
 		if (issue_flags & IO_URING_F_MULTISHOT)
-			*ret = mshot_retry_ret;
+			sel->val = mshot_retry_ret;
 		else
-			*ret = -EAGAIN;
+			sel->val = -EAGAIN;
 		return true;
 	}
 
 	/* Finish the request / stop multishot. */
 finish:
-	io_req_set_res(req, *ret, cflags);
+	io_req_set_res(req, sel->val, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)
-		*ret = IOU_STOP_MULTISHOT;
+		sel->val = IOU_STOP_MULTISHOT;
 	else
-		*ret = IOU_OK;
+		sel->val = IOU_OK;
 	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
@@ -1090,10 +1091,11 @@ retry_multishot:
 	else
 		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
+	sel.val = ret;
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	return ret;
+	return sel.val;
 }
 
 static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
@@ -1236,10 +1238,11 @@ out_free:
 	else
 		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
+	sel.val = ret;
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	return ret;
+	return sel.val;
 }
 
 void io_send_zc_cleanup(struct io_kiocb *req)


