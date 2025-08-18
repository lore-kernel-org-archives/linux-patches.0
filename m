Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599682C235C;
	Mon, 18 Aug 2025 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524647; cv=none; b=BJYJFZ0do0R9/bGFLUSd9ziIKTSnLW0CK19d10Sbbe/31v2EX1+o388V889Z2KVn73wkNJaPjLahBQRJLe3v2Ph5lWV7wG2TDg6m9XxJtM7Uduh1yGQ36Zv/ORqtfwl4iJ6W5hzSDEyhZZhCN/2j3+IbObEswnHjMAuaG7Aoew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524647; c=relaxed/simple;
	bh=r2J2CE8fVudcpHHr+W7BBYtXL6rI02kO8DG1Gg4F7go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J986L1yRgb0Q0j/cHweGXOddDlLuM/ffNbzXNh9VqEN0Pv/mg5LbFYjX/x0j5YuZYnRNn8+ktD/ueY0r9KgBCidtDPGs/k0laepPyatgoaQXsMsDPmgOPyzR4PerINlbbCqyM0hMw465Av+nvHD2AuISVut1sk/4Y9rbgNy3YZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy7oCgaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy7oCgaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FEBC4CEEB;
	Mon, 18 Aug 2025 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524647;
	bh=r2J2CE8fVudcpHHr+W7BBYtXL6rI02kO8DG1Gg4F7go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy7oCgaMcxm8KkVhSkPDKkc21UBuY3zau8nOEy23PvmUfey19QE09KqE4wu0ygeB8
	 CEARo9btuD0Zk0txt3rSP6p0WJXRgoh38eRHJtFzH+rYPIpaYV+aI5p/MhpWHFmq4K
	 cHSSjvKNzefFRWhXWhs4kNC0S01WD7VGNNvmBNvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 002/570] io_uring: export io_[un]account_mem
Date: Mon, 18 Aug 2025 14:39:49 +0200
Message-ID: <20250818124505.882099503@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,6 +120,8 @@ int io_files_update(struct io_kiocb *req
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
 
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)


