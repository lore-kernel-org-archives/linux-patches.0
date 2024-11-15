Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AB617DFFD;
	Fri, 15 Nov 2024 06:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653809; cv=none; b=EkqwAbc6YKNSa7Gxr2GMUKvt5Du8yrlts2BOXHh2qgZehYk9q05c2WpJ34p/3ZgdwXv8uaAL1Gw1bfdcY7PuUEEv8h8cpaq7DMq8dr9AvDm9gEaxFnplzzgadIutvljx0dOdiFbhfbO9kBQE1XVyg8balMTCL4d5O3Da05vveTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653809; c=relaxed/simple;
	bh=cN7JSKkBcokG4CEuoCpTTMGoBS9zplLOrY9SxXTgXKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjmiQcPauGPSIft3hethOqx6dii8MQYN3oBDERVfIXdDKfQONlXpwYGwpOYcBt0745SvHqJy7b5NWryhctfF3BAi+Ev14SuuZt5fUw/RrvDo+MKWXv9+2Avp3WfQ/5/qRkgbhbjbWAT28bRIq+TBPTCut1v87hWNFrqYOcwtLhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uz6xS2bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uz6xS2bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF761C4CECF;
	Fri, 15 Nov 2024 06:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653809;
	bh=cN7JSKkBcokG4CEuoCpTTMGoBS9zplLOrY9SxXTgXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz6xS2bGyaLyOf/fSjSfMpV6sKFbG6zD+KBmsyvSR4YS+BfFCZ6MC8qWFnQgLB6Mc
	 1qLA1cdZ+z4kcWmqSHWRh0nOsOYClS3XJqoW3//Roy523LML60z3JsHxA/cLDgLHzU
	 CLxzQueDRMTaGmo1tEijJTfPlYLlb7PeHYg5jK/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/82] io_uring: use kiocb_{start,end}_write() helpers
Date: Fri, 15 Nov 2024 07:38:20 +0100
Message-ID: <20241115063727.110711185@linuxfoundation.org>
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

Commit e484fd73f4bdcb00c2188100c2d84e9f3f5c9f7d upstream.

Use helpers instead of the open coded dance to silence lockdep warnings.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Message-Id: <20230817141337.1025891-5-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec55f2788ac64..a6afdea5cfd8e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2669,15 +2669,10 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 static void io_req_end_write(struct io_kiocb *req)
 {
-	/*
-	 * Tell lockdep we inherited freeze protection from submission
-	 * thread.
-	 */
 	if (req->flags & REQ_F_ISREG) {
-		struct super_block *sb = file_inode(req->file)->i_sb;
+		struct io_rw *rw = &req->rw;
 
-		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
-		sb_end_write(sb);
+		kiocb_end_write(&rw->kiocb);
 	}
 }
 
@@ -3770,18 +3765,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
-	/*
-	 * Open-code file_start_write here to grab freeze protection,
-	 * which will be released by another thread in
-	 * io_complete_rw().  Fool lockdep by telling it the lock got
-	 * released so that it doesn't complain about the held lock when
-	 * we return to userspace.
-	 */
-	if (req->flags & REQ_F_ISREG) {
-		sb_start_write(file_inode(req->file)->i_sb);
-		__sb_writers_release(file_inode(req->file)->i_sb,
-					SB_FREEZE_WRITE);
-	}
+	if (req->flags & REQ_F_ISREG)
+		kiocb_start_write(kiocb);
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (req->file->f_op->write_iter)
-- 
2.43.0



