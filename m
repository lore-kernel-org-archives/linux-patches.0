Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A8739C00E;
	Thu, 30 Jul 2026 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423066; cv=none; b=HFplaWNv691myMuxszvsBasoOPL6hmtX8qVvf5se2JxkqsiVtbjN/EMCr/xvwhJhnyW+rE1CIN6Lka7GS1+Q0vRmUeR+4uZrBQKJxX+vPmDlrsrNNOBVOJfB7qlJYFM6k0HoF5tXXbV9wUG9/aXUfqhVm1JUNwkREntPu9/tvWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423066; c=relaxed/simple;
	bh=J0Eni4/i18Q3Nt6TsdzRCHXNcTW4Rk0Ya8I7Oho+tB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqsiLuQJ3WWp4FFPqj+AnbGHdj/iHGksalKzLzqIdMnl8hd6T0McgmLTknEv5PRQbrb67Ec2SaaCK9w3BkozMiqkfjLOMYUz0HEE2f5lcNK8JZ4esHjYaiVpb6Z0whLdC/fUUYHTngyQP0PfF7uU2J43Mdw4EOcuuLTHAig0XTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/zZDwLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/zZDwLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B478F1F000E9;
	Thu, 30 Jul 2026 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423065;
	bh=93S+jXr5yRpDSxiJgTEEwZ0b0mOwA8V9Ch+qA1g2TQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/zZDwLgmFM8B1Yvb5zUd9eSAVfQUmVpnU3rL9PK6RT2GYFv5wJe1TljfhBqshxmc
	 K6WxcbKiZhwaHHRR/407f/pfTYpYI+uO0oIJIvSL7KDOlXX2iA4MlaHn/1QsBGnslh
	 uUSgJSAnJXj/4f62cFZMi15Lo7oTC1HmwNNUsleA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 647/744] io_uring/rw: fix missing ERESTARTSYS conversion in read paths
Date: Thu, 30 Jul 2026 16:15:20 +0200
Message-ID: <20260730141458.022334880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Yitang Yang <yi1tang.yang@gmail.com>

commit ab05caca123c6d0b41850b7c05b246e4dca4a770 upstream.

Both read and write may receive internal restart error codes from
the filesystem layer and should be converted to -EINTR. However,
when multishot read support was added, the error code normalization
was lost for both io_read() and io_read_mshot().

Extract the conversion into io_fixup_restart_res() and apply it
in all three locations: io_rw_done(), io_read(), and io_read_mshot().

Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Cc: stable@vger.kernel.org
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Link: https://patch.msgid.link/20260722124551.130563-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -615,6 +615,24 @@ static void io_complete_rw_iopoll(struct
 	smp_store_release(&req->iopoll_completed, 1);
 }
 
+static inline ssize_t io_fixup_restart_res(ssize_t ret)
+{
+	switch (ret) {
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail
+		 * this IO with EINTR.
+		 */
+		return -EINTR;
+	default:
+		return ret;
+	}
+}
+
 static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -624,21 +642,8 @@ static inline void io_rw_done(struct io_
 		return;
 
 	/* transform internal restart error codes */
-	if (unlikely(ret < 0)) {
-		switch (ret) {
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-		case -ERESTARTNOHAND:
-		case -ERESTART_RESTARTBLOCK:
-			/*
-			 * We can't just restart the syscall, since previously
-			 * submitted sqes may already be in progress. Just fail
-			 * this IO with EINTR.
-			 */
-			ret = -EINTR;
-			break;
-		}
-	}
+	if (unlikely(ret < 0))
+		ret = io_fixup_restart_res(ret);
 
 	if (req->flags & REQ_F_IOPOLL)
 		io_complete_rw_iopoll(&rw->kiocb, ret);
@@ -1034,7 +1039,8 @@ int io_read(struct io_kiocb *req, unsign
 
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
-	return ret;
+
+	return io_fixup_restart_res(ret);
 }
 
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
@@ -1068,8 +1074,10 @@ int io_read_mshot(struct io_kiocb *req,
 		return IOU_RETRY;
 	} else if (ret <= 0) {
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
-		if (ret < 0)
+		if (ret < 0) {
+			ret = io_fixup_restart_res(ret);
 			req_set_fail(req);
+		}
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		cflags = io_put_kbuf(req, ret, sel.buf_list);
 	} else {


