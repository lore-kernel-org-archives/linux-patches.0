Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E764972624;
	Mon, 23 Jun 2025 21:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715573; cv=none; b=tz6qs+mWGJg+y9H6Si8mf0t9GmBDNhtSJIv54cW9fsdIAnGm8w+5kpU3ZyeqAN1P6gqmy0XdhJfl4LuKGSudCld0D17fXqfJAy1kUONPmi2qAkg+g7GW1jCf3E3uXtGVAakw4fVU0lnRdBagCcLsq9OUxWJhn5+4WGXbd+VtC/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715573; c=relaxed/simple;
	bh=tEXMoqpAwbVrijksfwbI0VQJyJn4xgivgLi0wm9k+Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i27FL3SMge56EuPxOU3gtrPGHcGHEz+QD81s00cphgB4ny1iOi6C9qFAC5YZ2hlxWclB9/kJlN8/xfZ2ZCN+sFhCFpCRILpVjY1J+Ro3CCm9Wl8YQseBuoXiIxhLywZM3Q7RsEQat2yCU1WQPw3oWnqy+yxY+UxLD3Z6Ucbkqpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkqdhcq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkqdhcq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5B6C4CEEA;
	Mon, 23 Jun 2025 21:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715572;
	bh=tEXMoqpAwbVrijksfwbI0VQJyJn4xgivgLi0wm9k+Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkqdhcq5ENnCf4ULYlB4qNmtlohpRnMtveaGTnyVn0XwLsfRbUg0EfbslEC44fkZ/
	 LhzAv0kP/M2f9KTnPA6J2I/X2srj4g2Vtr1wCsMWhiVFeZC5A0WiUkWgbg0KiFa/2V
	 A80/Gv2zXnTfohz0dn/CGHQdoL6Ye9YRIj3Qv+/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 269/508] Revert "io_uring: ensure deferred completions are posted for multishot"
Date: Mon, 23 Jun 2025 15:05:14 +0200
Message-ID: <20250623130651.864576415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b82c386898f7b00cb49abe3fbd622017aaa61230 which is
commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Jens writes:
	There's some missing dependencies that makes this not work
	right, I'll bring it back in a series instead.

Link: https://lore.kernel.org/r/313f2335-626f-4eea-8502-d5c3773db35a@kernel.dk
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -820,14 +820,6 @@ bool io_post_aux_cqe(struct io_ring_ctx
 {
 	bool filled;
 
-	/*
-	 * If multishot has already posted deferred completions, ensure that
-	 * those are flushed first before posting this one. If not, CQEs
-	 * could get reordered.
-	 */
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
-		__io_submit_flush_completions(ctx);
-
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags, allow_overflow);
 	io_cq_unlock_post(ctx);


