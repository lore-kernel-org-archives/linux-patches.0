Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051B7319601;
	Thu, 16 Jul 2026 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210843; cv=none; b=SvEIyUcZPd9Np8eVVJY3dloWYdapYAmOKAe1YsjJMf3V4TbLIyxX1ZX/rrKwJc2QnAULLkIsMNaraJCLYDA6T7Z2WBe/AY33O2bXrbdKcaobKcKDSn6PWm6sipwbdM1lgiYdlRfxeqg/FuxbpqGfZqumbJgC+NslrPKgDBR8Q2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210843; c=relaxed/simple;
	bh=bPF0pXwLMx2anq9dZPvt6BwQbgLaHOl+FA+WPGvDJDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnZQTvAZy5FNMZ5FZdMZtjWSHnTv+wM+EriI+scOo+OjzpuKzHSb8ya8+Kh9JfFdxmVQpqaqiM3Hig1s/oll1hfyIEqcOvBWfxza2nbjUjqVSFvsGJ2y3qLnRQBk73MLmoIcpm6v/hT77ZTYlp9cMJmjPHX4cPNJwCLjbrLcWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxoTWuds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxoTWuds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2647B1F00A3D;
	Thu, 16 Jul 2026 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210841;
	bh=+l8QN3le2aCLEn8zrEEIhRX81rM8VQ51J0omG3FKRnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxoTWuds602/R4BaWcuAnTBKRhbxVhA7MJMx4LBDigsx+5BrVK9yoEwDlNe1AhW/t
	 e1DV4uplGs0oJNqqpwrITrArSILUM27xR7h2P7AAI4N5Z+2oNjf3D2L5n6NFESFR6P
	 btJhYLLop17Z7YimmpWfO/zB83hoZBUjxqmX2BIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wigham <michael@wigham.net>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 184/480] io_uring/rw: preserve partial result for iopoll
Date: Thu, 16 Jul 2026 15:28:51 +0200
Message-ID: <20260716133048.706322708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -611,15 +611,15 @@ static void io_complete_rw_iopoll(struct
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


