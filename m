Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBD51F8F0E;
	Wed,  6 Nov 2024 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897212; cv=none; b=p0iJsb92hYB0l/H6aTeFv0ZMXkd3Lu9eVbjGY5hvPxw4FxmFr/gU8XicPmQjxh5ax3TB59G3Ul1oUY7NHMfmiQtOFj2g3pIEbN5tAKmU22aIfd2cMOs9D2LcyUo3v5ubiBIzSiwon8z0QMYP+QdxdfCwmPBLRG7bi71WqdvlIOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897212; c=relaxed/simple;
	bh=M/Y8COOCxjjXNdI3IESA7SrfHKNuL4Bn7iaHiiJV0Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDwDs6iTpomdAbYlT8mDVByekHUyav7wUK1subdQVHWr35j0I6wF6X7+SWtX1vd3sCBUBWXd9fANy8/2CHk8vz7HWG2w6f0c1hdl4Pek2EM5a0s4XwQm1cpWVTMNaPvdWQEwUwuMrhuhDVF19yyj6aJA2i+vn8Nevp3Pvy1V90M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fW1NLE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fW1NLE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964B4C4CECD;
	Wed,  6 Nov 2024 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897212;
	bh=M/Y8COOCxjjXNdI3IESA7SrfHKNuL4Bn7iaHiiJV0Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fW1NLE6ZYq6HTKOuNiVZwkX570wY+ayT8VK9ys0nVLLySoECAqaVcyhRfp7XB7e5
	 gm9KuM9KkaGnjYUlXk8P5jfc6MggP96A9pjB9Z8MJDhDoNMCud18BjXtszPbRJNk/P
	 3D10gwnqjZiv0UyJGPHVorBN556S2VUKpos4P0J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/126] io_uring: use kiocb_{start,end}_write() helpers
Date: Wed,  6 Nov 2024 13:05:04 +0100
Message-ID: <20241106120308.845040929@linuxfoundation.org>
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

[ Upstream commit e484fd73f4bdcb00c2188100c2d84e9f3f5c9f7d ]

Use helpers instead of the open coded dance to silence lockdep warnings.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Message-Id: <20230817141337.1025891-5-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 1d60d74e8526 ("io_uring/rw: fix missing NOWAIT check for O_DIRECT start write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4eb42fc29c151..c15c7873813b3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -222,15 +222,10 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 
 static void io_req_end_write(struct io_kiocb *req)
 {
-	/*
-	 * Tell lockdep we inherited freeze protection from submission
-	 * thread.
-	 */
 	if (req->flags & REQ_F_ISREG) {
-		struct super_block *sb = file_inode(req->file)->i_sb;
+		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
-		sb_end_write(sb);
+		kiocb_end_write(&rw->kiocb);
 	}
 }
 
@@ -897,18 +892,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	}
 
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
 
 	if (likely(req->file->f_op->write_iter))
-- 
2.43.0



