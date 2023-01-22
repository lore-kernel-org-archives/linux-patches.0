Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9702590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB19CC433D2;
	Sun, 22 Jan 2023 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400477;
	bh=3tnUXVaN+1eNMKO1KZVaHGPZ0vBV7131K/j+FSC1twM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIPTYSfaE1GNUilRj1B6MEFEk5K/38amDWLTkkR/mPo9R7msPF7DK3ssbk0w3h/Vc
	 evPscSe4Hn6HJFGbmqOIAae2Gom01ANe2bzY0iuBTblwwOU9OMVfbNKL9L7OI41apC
	 +7r1ezhyUWptNm43GJg5akNk8+APDVOWS3/o36wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 90/98] io_uring: io_kiocb_update_pos() should not touch file for non -1 offset
Date: Sun, 22 Jan 2023 16:04:46 +0100
Message-Id: <20230122150233.225071093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 6f83ab22adcb77a5824d2c274dace0d99e21319f upstream.

-1 tells use to use the current position, but we check if the file is
a stream regardless of that. Fix up io_kiocb_update_pos() to only
dip into file if we need to. This is both more efficient and also drops
12 bytes of text on aarch64 and 64 bytes on x86-64.

Fixes: b4aec4001595 ("io_uring: do not recalculate ppos unnecessarily")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3011,19 +3011,18 @@ static inline void io_rw_done(struct kio
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
-	bool is_stream = req->file->f_mode & FMODE_STREAM;
 
-	if (kiocb->ki_pos == -1) {
-		if (!is_stream) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = req->file->f_pos;
-			return &kiocb->ki_pos;
-		} else {
-			kiocb->ki_pos = 0;
-			return NULL;
-		}
+	if (kiocb->ki_pos != -1)
+		return &kiocb->ki_pos;
+
+	if (!(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		kiocb->ki_pos = req->file->f_pos;
+		return &kiocb->ki_pos;
 	}
-	return is_stream ? NULL : &kiocb->ki_pos;
+
+	kiocb->ki_pos = 0;
+	return NULL;
 }
 
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,


