Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0820AD5A;
	Tue, 27 May 2025 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364397; cv=none; b=mwNBiugq0NgVE3dTMhYFvcyMNaBIkI/blO1tQV3e/d1GrN6JCi8bnyS7v2YU4+9vvUo6vp0F6pc/jTkD27Ypq3gnlYGSjmG6IDSesu+NMWXJ3gMCHGa2rMy7szNPJ0d8WqMXtz+mHKu9uKmdRJk43y9UAZHwAnxOtomNe8YKeRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364397; c=relaxed/simple;
	bh=0JVhKY1fCPXxF6fgTmOppU9xddxKyI50mJah7XaLSlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAh85cs4tGzuhEW2K8+YVdmdsVQrU4bo3+gufCJjnpB1zD2F8gq9TmYVdqVNIKU2kteb7LeRB2XmzX953Wf5J1wZ2pVE8ZRb2542z7KQ8VXLKFW9W2tWuDzSyUbTRqzZ2Miof+9lqutif+aOc2mNvMi2VPL4/Sd/KtzY6y9DPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw05Phgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw05Phgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9256C4CEE9;
	Tue, 27 May 2025 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364397;
	bh=0JVhKY1fCPXxF6fgTmOppU9xddxKyI50mJah7XaLSlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw05PhggYisEABBM/AjnnPBfc3FJgf0i0R46KWiHWsDk6N0HPOWj0zzIhHxIteD2D
	 YxRSTk/W3Knu5wmlMizuMH7bZQZr8pqiuik1BC/QGO9L2v1zfdqVJU5o1UqzmeY5+B
	 yxzVHVrTp9uMUpoybH4nAGTPLFlDNbi+NHN8eIr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/626] io_uring: dont duplicate flushing in io_req_post_cqe
Date: Tue, 27 May 2025 18:18:54 +0200
Message-ID: <20250527162446.731902941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5e16f1a68d28965c12b6fa227a306fef8a680f84 ]

io_req_post_cqe() sets submit_state.cq_flush so that
*flush_completions() can take care of batch commiting CQEs. Don't commit
it twice by using __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8ef0603c07f11..985c87ea09a90 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -874,10 +874,15 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	__io_cq_lock(ctx);
-	posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	}
+
 	ctx->submit_state.cq_flush = true;
-	__io_cq_unlock_post(ctx);
 	return posted;
 }
 
-- 
2.39.5



