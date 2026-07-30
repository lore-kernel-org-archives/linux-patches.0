Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7AF44C670;
	Thu, 30 Jul 2026 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427980; cv=none; b=UZmyHsyDh19HzjaFRPahfJMwK1oVmxS8ea/nzF1W3MzMDOylferBxrz94bkpZaBZa8vYhrIjutzPHrLBj2fV04dpSUmEtOLLpZ1k6FVdhP9g1qIytKwkfoA+zxIkYa7XkvxM95Vs0raHgEEFAHyRQQq7m1D5k79LxeHHXfBrk48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427980; c=relaxed/simple;
	bh=DlbgXvFPC8YKGB5xEC7ZjL0zPhnLjnrMPEfL4Q/S4uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbD9WQwOB1xQREOGpp9Sb5gmLCMxqwPy4g8J8HQsoceY1y040cgB52VnnAlebTJwOkUmztrajszz2Spp9eZO0Mvec3NYhVWjUG1j9RX2QhBXcBXLOjl72Zy+CPcnbJa4QGAgOxtFm+VEq7rP6kVT2uGtnxPHn2y6EhebYNBb2vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6MPoJ6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6MPoJ6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169981F000E9;
	Thu, 30 Jul 2026 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427979;
	bh=Y8DtW3yFBZD/hpL68rkc65una/rMfggpnQE8Z8DksbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6MPoJ6D/daEWrGm1/8zeyOUmtQUNt2NNUSTHJTX9OyApUYEyu8gvLl92q++th0by
	 h8/sppFY/tj36dlenswA4jAyuRo/XGcv06Ys+o+CGPHMeGkHdwftyFWhXQN1eisfYR
	 IDNAoLyvXs+acFpMIk1BxAPexL2aqxB4ICxePKag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/484] io_uring/rw: fix missing ERESTARTSYS conversion in read paths
Date: Thu, 30 Jul 2026 16:14:17 +0200
Message-ID: <20260730141431.296644697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yitang Yang <yi1tang.yang@gmail.com>

commit ab05caca123c6d0b41850b7c05b246e4dca4a770 upstream.

Both read and write may receive internal restart error codes from
the filesystem layer and should be converted to -EINTR. However,
when multishot read support was added, the error code normalization
was lost for both io_read() and io_read_mshot().

Extract the conversion into io_fixup_restart_res() and apply it
in all three locations: io_rw_done(), io_read(), and io_read_mshot().

[ 6.6 doesn't have multishot read, drop the io_read_mshot() hunk and
  adapt io_rw_done() to the older calling convention ]

Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Cc: stable@vger.kernel.org
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Link: https://patch.msgid.link/20260722124551.130563-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4ff3442ac2eeea..f2ab967b95072a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -140,27 +140,37 @@ void io_readv_writev_cleanup(struct io_kiocb *req)
 	kfree(io->free_iovec);
 }
 
-static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+static inline ssize_t io_fixup_restart_res(ssize_t ret)
 {
 	switch (ret) {
-	case -EIOCBQUEUED:
-		break;
 	case -ERESTARTSYS:
 	case -ERESTARTNOINTR:
 	case -ERESTARTNOHAND:
 	case -ERESTART_RESTARTBLOCK:
 		/*
 		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail this
-		 * IO with EINTR.
+		 * submitted sqes may already be in progress. Just fail
+		 * this IO with EINTR.
 		 */
-		ret = -EINTR;
-		fallthrough;
+		return -EINTR;
 	default:
-		kiocb->ki_complete(kiocb, ret);
+		return ret;
 	}
 }
 
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	/* IO was queued async, completion will happen later */
+	if (ret == -EIOCBQUEUED)
+		return;
+
+	/* transform internal restart error codes */
+	if (unlikely(ret < 0))
+		ret = io_fixup_restart_res(ret);
+
+	kiocb->ki_complete(kiocb, ret);
+}
+
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -885,7 +895,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
-	return ret;
+	return io_fixup_restart_res(ret);
 }
 
 static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
-- 
2.53.0



