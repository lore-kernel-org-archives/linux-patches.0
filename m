Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D98B21440C;
	Tue, 12 Nov 2024 10:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407108; cv=none; b=GBU8619DMod7AFwAYMZA9ArbeIkz+iMf/5NJT0RMqwfhBlzaSOnBWIGIn0+1pe8o3U63JSaeB4n6eO9z/nrNrrxtHlvSES30YB+sWz+mCE82V0h+QQQBxm7TwFSvz4i7Z+VM4p6gA5SWHADZ0YdadZxaVPf1Cr4Oo90Eu2LxoMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407108; c=relaxed/simple;
	bh=M3w2rKelqDeZb/niupc9//nSSplrOB73JOt2UEvhUd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVvrKc8qzqAtPHhTic6k3VP++8Ss4x6yhCfd6Rd+K6Og7yLYVCi4IOik4+C1L3WNCfnSOmzGxhPjhylNLTw3y5H6gQ/IOTjOCBIMqsaIXQJqPfBBklBIV/+o5m3EfEOPfOl9W3wQm9i/pul+1UFz5eYPzSWHnhenNCidGrNU3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhmD0VAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhmD0VAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BDCC4CED4;
	Tue, 12 Nov 2024 10:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407108;
	bh=M3w2rKelqDeZb/niupc9//nSSplrOB73JOt2UEvhUd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhmD0VATzJRHbQ1sIXh2ifdz2CVMWak3L4V9jWhBpBjbCAVk2GCCKw46QNgAW7Jre
	 Tgjs3+oWF7JK0BVV9nyHYxWgqZxWebRsl9U3zlQsyCOZQU6CkrED5T+Abxky7ceMFA
	 t6zu6ew+4AL8vvBSIs1AlGdDlgS56fl3rBahpRF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/76] io_uring: use kiocb_{start,end}_write() helpers
Date: Tue, 12 Nov 2024 11:21:17 +0100
Message-ID: <20241112101841.762689219@linuxfoundation.org>
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
index 7afa3827bfd5e..718ab6a418425 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2674,15 +2674,10 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
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
 
@@ -3775,18 +3770,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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



