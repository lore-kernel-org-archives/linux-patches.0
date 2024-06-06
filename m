Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA3219924D;
	Thu,  6 Jun 2024 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683200; cv=none; b=tgh19++ltlpJlRO0mRQfbJ7N84uej8a29n5lMA40jv292g1uhW0BZzYqdbnS3Kgg1WoplZQnROWcMYyYHR2DNuJFveXnMhhO2/pEZyfFVzeqDo1a23xg1rHxyyOtzKGLw77B2Rk/yKSqV1sknpLfS06MobYt3r/MOXUxuc3tB0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683200; c=relaxed/simple;
	bh=wnwTtQbCRMUGRIoDkmdwEQOX83C+6M+BXSBEAnyp/NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2HCE4UZl0eJuBZKZr9KmPaGCnRG161Vt4Wuqc7WLFs0FlRcXCuKIYVTo6aNkBb0Ly4ROaddsihd/3rKi80Qy5OKJ14EVlx8z7bZSVkty1QvT41G2dOvaTnYAkCxkBm2D7hd3Im+iq7HRZghMvhN8SFQvqbSy9rRmtMUOWjRSIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBBZ2rEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBBZ2rEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7ACC2BD10;
	Thu,  6 Jun 2024 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683200;
	bh=wnwTtQbCRMUGRIoDkmdwEQOX83C+6M+BXSBEAnyp/NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBBZ2rEdhlQ9nevhTD5f4BOBeRnqrfM/VtGjKQCf+PG7haiHt+RnpI3eo/9voFCif
	 9W/xEJybsQL/mVxA2oPMG5zvx6osxCLpOcLsgTqYq2aQ3DF9MMQwZ+jChG4rmvOSyH
	 6xxRjF0pisPGtSvYkuea7Ya1K2xQpyXNaIRR4I3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/473] io_uring: dont use TIF_NOTIFY_SIGNAL to test for availability of task_work
Date: Thu,  6 Jun 2024 16:00:07 +0200
Message-ID: <20240606131702.493265745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6434ec0186b80c734aa7a2acf95f75f5c6dd943b ]

Use task_work_pending() as a better test for whether we have task_work
or not, TIF_NOTIFY_SIGNAL is only valid if the any of the task_work
items had been queued with TWA_SIGNAL as the notification mechanism.
Hence task_work_pending() is a more reliable check.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22537c9f7941 ("io_uring: use the right type for work_llist empty check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 59e6f755f12c6..9e74f7968e059 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -275,8 +275,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return test_thread_flag(TIF_NOTIFY_SIGNAL) ||
-		!wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
 static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
-- 
2.43.0



