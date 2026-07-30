Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F042330C143;
	Thu, 30 Jul 2026 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426554; cv=none; b=iYEE3KUDN3nGNeop0p1fSef4AYPnFhmU9Hq2gxHA4TRJK87HhsgAVXIr7cQ2c8uqLEDiTqvQg13LNjbHTiNj4u2x6a0vlz219+N2ll0e9t7h2yh8Ae0OM638kOegKAweUQ6o5GLuInrZaMPyKtNmondPkmnK7/FnZJ0oNZIWnCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426554; c=relaxed/simple;
	bh=lck7zC+tQjCCs+FJfdlHVkHHD9xa0pxhMKxIaV3wFXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq2hJCzrDPuSe1dCRR6DrA6gwWrAXl9G9pZ2mKpDNaTyP7uX/I7LtEDHjKOgrGVuHqslgOUUgdUgeZbpCQAh74M1Wzz1i+Ux1gA1z5DFGPeyKPy73eQnA/IbyhaHIh5IdSfn20AhWCmOLBmo5F9BfA77PIe57aWWbUzjIcJwM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQjXlzYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQjXlzYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F1C1F000E9;
	Thu, 30 Jul 2026 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426552;
	bh=jgzQZ60+8DrlQHpfNwz0k4rIFCUiCIPUdgipR5hhU88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQjXlzYhEjNgmUOmyjR/P8evPxa6j6rSOtgCNNVyh7Dq8fC+VTNgddXW5rNKBtHRd
	 d7TQdobg7suUWizYh3PelK/42heIRskCEEgwabf7I4pVCb9Dd5dGBbWYEgz3jXriu/
	 BN2A2Cn45dvhDlx3DIN99sCH1UukZjmFvQkPUK1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/602] io_uring/rw: fix missing ERESTARTSYS conversion in read paths
Date: Thu, 30 Jul 2026 16:14:11 +0200
Message-ID: <20260730141445.604523660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index a744cb5d235a6a..a74664c4a05efe 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -560,6 +560,24 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
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
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
 	/* IO was queued async, completion will happen later */
@@ -567,21 +585,8 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
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
 
 	INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
 			io_complete_rw, kiocb, ret);
@@ -961,7 +966,8 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
-	return ret;
+
+	return io_fixup_restart_res(ret);
 }
 
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
@@ -995,8 +1001,10 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
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
-- 
2.53.0



