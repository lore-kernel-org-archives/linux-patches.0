Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9733831CA60;
	Mon, 18 Aug 2025 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522900; cv=none; b=U7Yq332xhtR4DIv2rs9NH2m41XxgM3+N0GbfOkbb1uugDFwcQq4SfXHsuibePrmjyDmyOfqHekSlcudp75kaCDZfqfhVgNjnKJUxY95HRKrmav3fbOMjO36LXPl4v+Pn5L0zLHs4F3MGZeHnhu5wOLH3+LzxomYGRxE/sf8Kb1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522900; c=relaxed/simple;
	bh=8kix8Sc95lutV767cZoyDI8M5nKSSvc8AY9AtWYVLCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvK6jcLTjztJOReBjYRivJHRiLJT6SkOE7cAUMiIDGTqOh85C7hPIbB7eBLtF7bbfFc0YNG6Eq8jDmwNL+gbhS8JtraaT0fPKMhPCu8xeOtoUa5Nl54WqWjGGb1+ne/wYTkMAGX7dQ2Xw+4aJTcCfroWvBxkjxj7qMmi7NeiIdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcWCE3KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcWCE3KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C85FC4CEEB;
	Mon, 18 Aug 2025 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522900;
	bh=8kix8Sc95lutV767cZoyDI8M5nKSSvc8AY9AtWYVLCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcWCE3KZqX62Hz20MX+GC6GbyKBJNUQO9bshLGYLZNJyyuKLx8PoYL10fyYrLiXv7
	 XtgnHqocrTY2otFaZopaByjcQMg4tpZvfEdXlOvvV0Glo2cGq36dusV0EDQ4zeXWMA
	 RPEYeAAKJ37sovki2B76M54IeAdTP+1CLRz2Wm7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 002/515] io_uring: export io_[un]account_mem
Date: Mon, 18 Aug 2025 14:39:48 +0200
Message-ID: <20250818124458.431817960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 11fbada7184f9e19bcdfa2f6b15828a78b8897a6 upstream.

Export pinned memory accounting helpers, they'll be used by zcrx
shortly.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9a61e54bd89289b39570ae02fe620e12487439e4.1752699568.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    4 ++--
 io_uring/rsrc.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -55,7 +55,7 @@ int __io_account_mem(struct user_struct
 	return 0;
 }
 
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	if (ctx->user)
 		__io_unaccount_mem(ctx->user, nr_pages);
@@ -64,7 +64,7 @@ static void io_unaccount_mem(struct io_r
 		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 }
 
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	int ret;
 
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -146,6 +146,8 @@ int io_files_update(struct io_kiocb *req
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
 
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)


