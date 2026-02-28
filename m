Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229AF359A91
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302462; cv=none; b=hVnVkpVJf/U1EvWhF30dftBMSuYgYEw91YF6jB3IOIbNx4kEOCA5WujoSYVdAZpt6do6Kky3ZYjt6/Zek2CYlJSDjmQ8ObZPauEDULcv2P/JIMS73EBoukQLrzIzqH6ADZuEwUDypSauMuqjoULW1yT0rXbrVqAru1kshZieV54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302462; c=relaxed/simple;
	bh=NTpzyVGphc0P0tAYQ6I8zigee/QHZFnKPWnI+ftga+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6adsryD4TmAbWL5vatMuljx56B/xs1sgQau++/mHtZDbBn+14+xIGudSlUF1jQ49DZvq6+n3XROT+iZYTQo/u+4ck5R14kvjrohgPUj9WhF179IZ8K7b9WM9jL6aH+erM7ybB1MGNENLeFpU/hH/HQd5hnqSzFGwetsJ64U02U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOzCKk4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOzCKk4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963AFC19424;
	Sat, 28 Feb 2026 18:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302462;
	bh=NTpzyVGphc0P0tAYQ6I8zigee/QHZFnKPWnI+ftga+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOzCKk4ig9p8S09T3doKS+INWJhuhg/SiWnptO2VSfho32v0mPqvryaZxDybDXqWw
	 q2p39EMtqKpcw/XtTe3AOT8kAQJYIz0/xPKPp0fHGDy37D1cK6TZuroNcIL1h7wceD
	 Sn0l7B5Kl0FihWovhDREF7LIAcdxyttYedqvtRZJSEx8putCVKr826ridzKl3xxUZ+
	 SLS+2dzA/FixTKjFAvHpADbtY6QstPEJC3oTB/V2uO/9RFRxXL20b2uRP/L9Rx4iPV
	 oOqnrPwW4Mtdi3jAA+Qgzd3TE3/me3t/dCtXoPOhQLd2MY4qcPgeEs5ORjphi0AAHI
	 lED+beabCf1SA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/232] io_uring/cancel: fix sequence matching for IORING_ASYNC_CANCEL_ANY
Date: Sat, 28 Feb 2026 13:10:57 -0500
Message-ID: <20260228181127.1592657-204-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 3a372b66923e4af966af2900da588e3b3de6fcd2 ]

We always need to check/update the cancel sequence if
IORING_ASYNC_CANCEL_ALL is set. Also kill the redundant check for
IORING_ASYNC_CANCEL_ANY at the end, if we get here we know it's
not set as we would've matched it higher up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22dbb0987bd1 ("io_uring/cancel: de-unionize file and user_data in struct io_cancel_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 88586911b516b..c27e10e3dd8c3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -35,7 +35,7 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (req->ctx != cd->ctx)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
-		;
+		goto check_seq;
 	} else if (cd->flags & IORING_ASYNC_CANCEL_FD) {
 		if (req->file != cd->file)
 			return false;
@@ -43,7 +43,8 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		if (req->cqe.user_data != cd->data)
 			return false;
 	}
-	if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
+	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+check_seq:
 		if (cd->seq == req->work.cancel_seq)
 			return false;
 		req->work.cancel_seq = cd->seq;
-- 
2.51.0

