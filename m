Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E5A2236F2;
	Thu, 30 Jul 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424824; cv=none; b=FJccGXVd+p25uimkR05vR42PBsIHen+ExEHoxkYJCiGcnETi/cChocStnHZ79N5KH5mYcRDSQrMpOqOvResBN06I4adC6wof/dpIOoaQRNIMerKgRS5PS40hC+GGTiOGyR3hkZ+hG/9mbO17mqeUxFZt5ulG5xjDQp7KccoprSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424824; c=relaxed/simple;
	bh=t1xSFf170DmjX4crtcF/zmksZiIac5ECFHrgHmQ+Mlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNGihyeIFPsNXde3/Jwc8TX33qSeDJdY3J4X7bBR126Nqmr3LPly+U7a9U7vduut1FC6pRQrtl91NTLfN6zeD0gsLDP02eymBYbL3SN2+wr8cSAo0ujXyraadoAqMp1U7CR70Bez0JZCChakXlE4K65wN9NX2HFW5SiJJqcdoZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJ71NCw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJ71NCw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818311F000E9;
	Thu, 30 Jul 2026 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424823;
	bh=xtcF9s0rcJSDR5UKj9E626zjfpIuTimhq5PIoPr07xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJ71NCw3cQRIZMIW72ZOYA2MI/GN59mIHhqLyduVIhcxKjp20399Xy09n+im6w3UV
	 Sd4R+qfgDdTQcLjuItZ72PB27yhNE2cE3wDUWYNJ2/FmR9kPtxrmmfEF1dC8xbPy/U
	 KalwmrTxnvcUyqyJiDcK4lPSoxxo/rDsRatagB9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 529/675] io_uring/rw: fix missing ERESTARTSYS conversion in read paths
Date: Thu, 30 Jul 2026 16:14:19 +0200
Message-ID: <20260730141456.386764556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -625,6 +625,24 @@ static void io_complete_rw_iopoll(struct
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
@@ -634,21 +652,8 @@ static inline void io_rw_done(struct io_
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
 
 	if (req->ctx->flags & IORING_SETUP_IOPOLL)
 		io_complete_rw_iopoll(&rw->kiocb, ret);
@@ -1044,7 +1049,8 @@ int io_read(struct io_kiocb *req, unsign
 
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
-	return ret;
+
+	return io_fixup_restart_res(ret);
 }
 
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
@@ -1078,8 +1084,10 @@ int io_read_mshot(struct io_kiocb *req,
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


