Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B6C29A304;
	Mon, 12 May 2025 18:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073485; cv=none; b=JMRtO3aVnS4WRHwWsctC5brfxPS/FGWKLbIA+sxZeObuBL3zVUz1xCPXQsmaPhF2xEglLCibp0DWP7OYs3E1mkgScbqDgQAbp4UyX49HIFLldf8RnmJ03mNn2KwQfRlzlqsT90BawUwqsyahm4BFBvCjKiCbUuTUJxBOvY9pfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073485; c=relaxed/simple;
	bh=2GrB2pF2gPzuM6J1tK4oMS6CTwI8jT7bH3gQjVIqpr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhD265q7ZLhIefkilnBUl0ublJPVVPBZDbzvu6cKnmeFuKtMJEKzdwnGAHIgqk9t60TJFrLb12dReKNpApq1Pisgvx555sypvqVbg2d5c7knOPQEHdc8tRua+iyzn17iul2VNMRMHs6FzAkE/wl6xvJRCP4p5S3/Xf0j8Vse2VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Chno9U9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Chno9U9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F4C4CEE9;
	Mon, 12 May 2025 18:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073485;
	bh=2GrB2pF2gPzuM6J1tK4oMS6CTwI8jT7bH3gQjVIqpr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Chno9U9j9QNpkraA5b702OwMgu5v43ZKGMBlZFbgAjAbrIoMqKZNu+3nPbJFFereU
	 fT8f2VcJkIfinC12w5fMKI56xsdZ0+qKxlvZmMjAN5ovuuj6M/1AXHHVJukiw3bVn5
	 1TDypIsBOiWEs411LmrPIaQiYxNlXKRJGRm2Hyg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 091/113] io_uring: ensure deferred completions are posted for multishot
Date: Mon, 12 May 2025 19:46:20 +0200
Message-ID: <20250512172031.386636019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Multishot normally uses io_req_post_cqe() to post completions, but when
stopping it, it may finish up with a deferred completion. This is fine,
except if another multishot event triggers before the deferred completions
get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
and cause confusion on the application side.

When multishot posting via io_req_post_cqe(), flush any pending deferred
completions first, if any.

Cc: stable@vger.kernel.org # 6.1+
Reported-by: Norman Maurer <norman_maurer@apple.com>
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -919,6 +919,14 @@ static bool __io_post_aux_cqe(struct io_
 {
 	bool filled;
 
+	/*
+	 * If multishot has already posted deferred completions, ensure that
+	 * those are flushed first before posting this one. If not, CQEs
+	 * could get reordered.
+	 */
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled && allow_overflow)


