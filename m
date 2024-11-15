Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013C1885B3;
	Fri, 15 Nov 2024 06:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653802; cv=none; b=pYIqGNJQZ0w2Km9bVGyW6odRcD/ZK+FREQ+Fuabpk50oCAjf8J3arpkWnNG6YrO5hgVjr1nYzc7/hHVmxyrykVpNF1/GA6+XJU2v3jHpegwQDVrtc8XzxXClXFocyThl4EmutFCfGmBepIJy5kQHFkX5ChCE92n/DfzS6n0RSSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653802; c=relaxed/simple;
	bh=wviWTF6oL+yq8ZZckWiA7IV7fs8ujjM1FXXHvcSbhvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaLK0ZIl0hSdWHIse6WCHccfKRjRR8GpNwEAGPWmrO/3+32gtWuJWlGZkb+/hxWmO/hys53DtZPtLEhOyEUySZlnQygXVKoUvdk4N7YBKPlgcEdZPiFRNU3nNbBj2qA6cq6to6bCDO+lghO1Wr4MXfEqyZy9nhW+hxt61yjJwk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCopJMmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCopJMmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C026EC4CECF;
	Fri, 15 Nov 2024 06:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653802;
	bh=wviWTF6oL+yq8ZZckWiA7IV7fs8ujjM1FXXHvcSbhvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCopJMmXvxjGlDGuJOByeEgwYekAjjdVRhTBTYwuC9kxZDQVVN+p2aUwgOmOwCngx
	 01WA4jRbnjqJzI0lsMWPiuldn/oWqq187+mGWefJbyrrnvzJSTESZWxE/DyXS6YP4S
	 ejeDinGGOr1kTIBv688bFJ+QScUwxlbQk/40As68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/82] io_uring: rename kiocb_end_write() local helper
Date: Fri, 15 Nov 2024 07:38:18 +0100
Message-ID: <20241115063727.039990798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

Commit a370167fe526123637965f60859a9f1f3e1a58b7 upstream.

This helper does not take a kiocb as input and we want to create a
common helper by that name that takes a kiocb as input.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Message-Id: <20230817141337.1025891-2-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da07fba75827c..ec55f2788ac64 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2667,7 +2667,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	return ret;
 }
 
-static void kiocb_end_write(struct io_kiocb *req)
+static void io_req_end_write(struct io_kiocb *req)
 {
 	/*
 	 * Tell lockdep we inherited freeze protection from submission
@@ -2737,7 +2737,7 @@ static void io_req_io_end(struct io_kiocb *req)
 	struct io_rw *rw = &req->rw;
 
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
+		io_req_end_write(req);
 		fsnotify_modify(req->file);
 	} else {
 		fsnotify_access(req->file);
@@ -2817,7 +2817,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
-		kiocb_end_write(req);
+		io_req_end_write(req);
 	if (unlikely(res != req->result)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
@@ -3817,7 +3817,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret) {
 			if (kiocb->ki_flags & IOCB_WRITE)
-				kiocb_end_write(req);
+				io_req_end_write(req);
 			return -EAGAIN;
 		}
 		return ret;
-- 
2.43.0



