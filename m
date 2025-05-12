Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BD925A32E;
	Mon, 12 May 2025 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071943; cv=none; b=lBjGDza1xk70sornns1wjF1iq9SenVHw4HrQnArK4nljEnXPgdB+yhMaG/InuxYtm2N8RwbOKwsmkRF8cfmLVaoHcDda/p5rkn+2WY6t1JbJOZOqUrsmc77Gbz57tEK2TbFsAhNmMHWCh3SZCqo/nvPREWTfcOErfeVNyORhMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071943; c=relaxed/simple;
	bh=4pIWORGf2fTD3ryuc10fMTBjw5DmihQQU8vK3cODDBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaIt427Urrm+aRxWGPJm9CS4EYPIJqWVP7ViQcgW1EnCyqJxS86G5XHekDO9wfNJtxzq2dhJd71AgbTm+leATVIvLLpN+k4vfDqvIVdGoQd5pvFXG/UtBxg2uV+Z/Z8Vp6xY20zZ5f/v8HCy9DNmNTPGct+YshnZuRtAFzggtAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWwKu3p2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWwKu3p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD56C4CEE7;
	Mon, 12 May 2025 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071943;
	bh=4pIWORGf2fTD3ryuc10fMTBjw5DmihQQU8vK3cODDBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWwKu3p2SAj1m+Rgr8GrTRya+a+aLnrVLlzk6uWDDrT2w/Neir0buQ0xCS6AwD/pX
	 tjRWYxupCp7MWzq3+uM1fJwW0+YGDEN0CQiFjyK3+pwFiTXt9KBTwdZbqS5rk7uz2w
	 oBgbI5JxqjxHgXU5iJxzNn+9QS92Hdas47fVkVW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 085/197] io_uring: ensure deferred completions are flushed for multishot
Date: Mon, 12 May 2025 19:38:55 +0200
Message-ID: <20250512172047.832146762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Multishot normally uses io_req_post_cqe() to post completions, but when
stopping it, it may finish up with a deferred completion. This is fine,
except if another multishot event triggers before the deferred completions
get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
as new multishot completions get posted before the deferred ones are
flushed. This can cause confusion on the application side, if strict
ordering is required for the use case.

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
@@ -874,6 +874,14 @@ bool io_req_post_cqe(struct io_kiocb *re
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
+	/*
+	 * If multishot has already posted deferred completions, ensure that
+	 * those are flushed first before posting this one. If not, CQEs
+	 * could get reordered.
+	 */
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 


