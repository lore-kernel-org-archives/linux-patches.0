Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C60224257;
	Wed, 28 May 2025 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469368; cv=none; b=d825mgpex23i3bcl2qDrh6tJ4+fF5oU1BSnV2tONnSZNIRhWqIvRMsbCrbYqK5yLjHTqUb5rnnFetpHIXhMbxa5L1iwGTZw7gfp0SH/ZWB0E7xbPsYPJsR0wjHGwmMeDmfNwGXMbgO2ot9Xe964RdQHMLsMT/2DOdxeNab6Zp2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469368; c=relaxed/simple;
	bh=eZmB1vW6zR2Keqol2bNfYjBg98phmtbCVpcb3O5Z08k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CcUv7+WJ9TBp4PYcxy1Gx5iiGcmJkdSW1aQ5KbOT7fiKdsxfDaP54r+T+FYZqN7YUaCg4d4nWoHxWZOsTOYdUfc6Ih2odi++r/Lkrx64cqFqXXNF/4M/0ag69sbSIfnj1BgAOCC5IJvTIMgKXGa+NOYjWkUueKVB86KTabDE3rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUL4C5o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUL4C5o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC792C4CEE7;
	Wed, 28 May 2025 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469368;
	bh=eZmB1vW6zR2Keqol2bNfYjBg98phmtbCVpcb3O5Z08k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUL4C5o5tUlhNrRYH8BkwvL4gBS/dstpAZuzwtIG2W8e0HnPPwVBbw/jNOH/Zh/HY
	 wRSeynEqYj+8COXOzLwUaC9z/7VrJg8hBh8cbve/PeX8JocXuQIoMNGsgZVfMXeidF
	 5eE19Uqcm8jiXGBRFCD7D0UWpbt0gYuX9bRB/e4FBsCRxeQNICcmzbVl6kgMB3PLm4
	 8v19jGuCt9QckrzuZ5bzAok9TvOnxsC121lf0GK8TA0EdtlYOs3w6qoZsp7dNeEpvl
	 SN+3iD9xNdKjHSD3ZcoLvFc/YAu0pgCaVbZQfFLCQlHNwZ02Fy2Zfq1WwR+NLEP2Lt
	 txHK5BR6fjVGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 7/9] io_uring: fix spurious drain flushing
Date: Wed, 28 May 2025 17:55:57 -0400
Message-Id: <20250528215559.1983214-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250528215559.1983214-1-sashal@kernel.org>
References: <20250528215559.1983214-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fde04c7e2775feb0746301e0ef86a04d3598c3fe ]

io_queue_deferred() is not tolerant to spurious calls not completing
some requests. You can have an inflight drain-marked request and another
request that came after and got queued into the drain list. Now, if
io_queue_deferred() is called before the first request completes, it'll
check the 2nd req with req_need_defer(), find that there is no drain
flag set, and queue it for execution.

To make io_queue_deferred() work, it should at least check sequences for
the first request, and then we need also need to check if there is
another drain request creating another bubble.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/972bde11b7d4ef25b3f5e3fd34f80e4d2aa345b8.1746788718.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Let me analyze the commit by examining the differences between what the
commit shows and what should be the fix: Based on my analysis of the
commit message and code changes, here is my evaluation: **YES** This
commit should be backported to stable kernel trees. Here's my extensive
analysis: ## Bug Analysis The commit fixes a serious correctness issue
in the io_uring drain mechanism. The problem described is: 1. **Spurious
drain flushing**: The original `io_queue_deferred()` function was not
tolerant to spurious calls 2. **Race condition**: When a drain-marked
request is inflight and another request gets queued into the defer list,
calling `io_queue_deferred()` before the first request completes could
incorrectly queue the second request for execution 3. **Incorrect
sequence checking**: The function only checked `req_need_defer()` which
looks for the drain flag, but didn't properly handle the sequencing
requirements ## Code Changes Analysis The fix introduces several
important changes: 1. **New helper function `io_drain_defer_seq()`**:
```c static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq) {
struct io_ring_ctx *ctx = req->ctx; return seq +
READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail; } ``` This properly
checks sequence ordering for drain requests. 2. **Enhanced
`io_queue_deferred()` logic**: - Tracks if any drain request has been
seen (`drain_seen`) - Uses `first` flag to handle the initial request
specially - Replaces the simple `req_need_defer()` check with
`io_drain_defer_seq()` when drain semantics are involved 3. **Proper
drain bubble handling**: The new logic ensures that when there's a drain
request, subsequent requests wait for proper sequencing, preventing the
"spurious drain flushing" problem. ## Backport Criteria Assessment ✅
**Fixes important bug**: This addresses a correctness issue in
io_uring's drain mechanism that could lead to out-of-order execution of
requests, violating user expectations and potentially causing data
corruption or race conditions. ✅ **Small and contained**: The changes
are minimal and focused - adding one helper function and modifying the
logic in one existing function. The change is about 20 lines total. ✅
**No architectural changes**: This doesn't change the overall io_uring
architecture, just fixes the drain sequencing logic. ✅ **Low regression
risk**: The fix makes the drain checking more conservative (stricter),
which is safer than the current buggy behavior. ✅ **Critical
subsystem**: io_uring is a critical high-performance I/O subsystem used
by databases, storage systems, and other performance-critical
applications. ## Comparison with Similar Commits Looking at the provided
similar commits: - Most drain-related fixes were marked as **NO**
because they were optimizations or refactoring - However, the one marked
**YES** (commit about "counter inc/dec mismatch") was a correctness fix
similar to this one - This commit fits the pattern of the **YES**
example: it fixes a functional bug rather than optimizing code ## Risk
Assessment **Minimal risk**: The change makes drain checking more
conservative, so the worst case would be slightly more restrictive
ordering, which maintains correctness. There's no risk of introducing
the opposite problem (allowing incorrect reordering). ## Conclusion This
commit fixes a real correctness bug in a critical kernel subsystem with
minimal, conservative changes. It prevents potential data races and
ordering violations in io_uring drain operations, making it an excellent
candidate for stable backporting.

 io_uring/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index edda31a15c6e6..9266d4f2016ad 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -537,18 +537,30 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
+static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+}
+
 static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	bool drain_seen = false, first = true;
+
 	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
-		if (req_need_defer(de->req, de->seq))
+		drain_seen |= de->req->flags & REQ_F_IO_DRAIN;
+		if ((drain_seen || first) && io_drain_defer_seq(de->req, de->seq))
 			break;
+
 		list_del_init(&de->list);
 		io_req_task_queue(de->req);
 		kfree(de);
+		first = false;
 	}
 	spin_unlock(&ctx->completion_lock);
 }
-- 
2.39.5

