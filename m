Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7212C21216C;
	Tue, 12 Nov 2024 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407102; cv=none; b=nUHiPMRFAdjZOyEgfHs0t7UK1wVRjR4QmfiR7I6J/fE5vB4FSVOW7eMhSTE3IDTaiY9muG2oUPaWScojdNalquANZFR5cVoxzw/1r9+fM4skqXXLAsovUP3uFhp5D9l3hIx0kdk/UX6pOzFgWwDaCWh0+mrN3MnZ/AWF11gaAFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407102; c=relaxed/simple;
	bh=ntLewRwRsbQ86A5F+sQ7/CZXuK3K451djtpJil8ZeKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIynVDWjopuS0Uf5wKgcT8byylEIoh8Ouy1JBq0G7fDrP7vCtQAtZH+w5z0IOQ+EYeG0NhQhLk8brywXEE0GJul17fihOAXjbHMDgHDiXbRLS4EZGUv5dY6c8dc/HYKzQ/JyG7zFM/FbNjkM1ZJMAwuQ0MuDwX/TsXnKoDiNkIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMSNC6FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMSNC6FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8721DC4CECD;
	Tue, 12 Nov 2024 10:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407102;
	bh=ntLewRwRsbQ86A5F+sQ7/CZXuK3K451djtpJil8ZeKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMSNC6FUx3MY8Ssvp0ZBnLJvDz4YoL6FsPaOBdLTXJvFTsjQdGcf/bkg3NP+MQWBA
	 NLJi9wYMwBQf4dMn1Sbp+4H+GV54MaoAWHpj7K1FhLkOAB85h8b/LRvVrLgtPlZMBp
	 8Tt9rOq3Gsi9AdXnJpsZM10Z4eVOXfCRez6LyGQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/76] io_uring: rename kiocb_end_write() local helper
Date: Tue, 12 Nov 2024 11:21:15 +0100
Message-ID: <20241112101841.689321485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1ab0cd987273..7afa3827bfd5e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2672,7 +2672,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	return ret;
 }
 
-static void kiocb_end_write(struct io_kiocb *req)
+static void io_req_end_write(struct io_kiocb *req)
 {
 	/*
 	 * Tell lockdep we inherited freeze protection from submission
@@ -2742,7 +2742,7 @@ static void io_req_io_end(struct io_kiocb *req)
 	struct io_rw *rw = &req->rw;
 
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
+		io_req_end_write(req);
 		fsnotify_modify(req->file);
 	} else {
 		fsnotify_access(req->file);
@@ -2822,7 +2822,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
-		kiocb_end_write(req);
+		io_req_end_write(req);
 	if (unlikely(res != req->result)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
@@ -3822,7 +3822,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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



