Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED601E0B62;
	Wed,  6 Nov 2024 12:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897206; cv=none; b=jZzrZWf6oBLYUwuNRDrtQr3vL6MS9EBzfB2ITVL0HZ4riQEJhlNzIWo7wkfcL7pyz7FPpBEWh7ORd9uqVo6vJ1xWpIr/kPusY6b+Fw94sP/w3AgTbZnEr0cMF+Zowp9NxUYjOaV0vV5kip9sg0+dmE8zgnJd0UzrAiceqZyFMrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897206; c=relaxed/simple;
	bh=gIMbGBLefe0rwIWuSwndeUQn8xKv22G7im0RxukLmWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ianiFuexlpbfp4bD7hxL9Fm2RoW52N9NBWto7PtYTU1FIwTMKIkfb791/730gjOiLNeVRRjpZZAU0bWnMpc9oHu2ftzFKkhG6w/aZCXAFYm4s4488hHgydiDxJegh/tuRLqQ9RtAxO30hrviKFU2QJ8x3LFbzbEue4wK9YlANck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRreTlBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRreTlBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8673C4CECD;
	Wed,  6 Nov 2024 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897206;
	bh=gIMbGBLefe0rwIWuSwndeUQn8xKv22G7im0RxukLmWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRreTlBqr4u6es+MsDOXmhpENz73qo7li7E5lBDLsA67zplNl+7vjc0k7WHViIRs7
	 UHauDLBXJ3W4yanSYerii2ydKgLMtW1SDHVEAbX2xXGUP8oys1LAJiHzYJ6pKGGULw
	 YEq5A4F0unmhVuHO4hoMn5mS9As4MKDtoSAs82gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/126] io_uring: rename kiocb_end_write() local helper
Date: Wed,  6 Nov 2024 13:05:02 +0100
Message-ID: <20241106120308.792473139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a370167fe526123637965f60859a9f1f3e1a58b7 ]

This helper does not take a kiocb as input and we want to create a
common helper by that name that takes a kiocb as input.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Message-Id: <20230817141337.1025891-2-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 1d60d74e8526 ("io_uring/rw: fix missing NOWAIT check for O_DIRECT start write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 038e6b13a7496..4eb42fc29c151 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -220,7 +220,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
-static void kiocb_end_write(struct io_kiocb *req)
+static void io_req_end_write(struct io_kiocb *req)
 {
 	/*
 	 * Tell lockdep we inherited freeze protection from submission
@@ -243,7 +243,7 @@ static void io_req_io_end(struct io_kiocb *req)
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
+		io_req_end_write(req);
 		fsnotify_modify(req->file);
 	} else {
 		fsnotify_access(req->file);
@@ -307,7 +307,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
-		kiocb_end_write(req);
+		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
@@ -956,7 +956,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 				io->bytes_done += ret2;
 
 			if (kiocb->ki_flags & IOCB_WRITE)
-				kiocb_end_write(req);
+				io_req_end_write(req);
 			return ret ? ret : -EAGAIN;
 		}
 done:
@@ -967,7 +967,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_setup_async_rw(req, iovec, s, false);
 		if (!ret) {
 			if (kiocb->ki_flags & IOCB_WRITE)
-				kiocb_end_write(req);
+				io_req_end_write(req);
 			return -EAGAIN;
 		}
 		return ret;
-- 
2.43.0



