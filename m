Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590888;
	b=A2ifk7pTtZajFoieZ+tmm3kUxjwVek7q/8zRfopDpCpa2sffCar3m0uL2fqh59NI+Pqd
	 Bd+N/XJeDrUmTC0r5N3y8YBQrQ7GgIL9df3nW1pgI4J5CSDA2MkCHA2JbKxMgFFFZAZrx
	 kFRxyGnEg8mPvOivXankB/+CqDcbpVGneY0IO3wqDXGHK90wbz4k7OEM5EkhlKt3SO+ui
	 chSE9YLQA3wd/0K3cHcR1+gp0Q5t1GN4xJX7Fl8lDEynNqqq7T3be51aSyqPmeqznzKiy
	 ZHpJTYkpoOPVfcp5B/j+XmTywKh2GisoMT1SY/6+VqSHl73CMabzsEDQz58l7EnTVaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOuKgibUD8Ya/bC/sQ1+wRNyqS7IU0fWIL5kqGdyA54=;
	b=t2vHlEz5ewSMSi0nMgZuKhRvwcKwBBmTo70HH6gOxkj1gRNPjerqTjQRnTDpngXGrCYm
	 HxxnEdcNZTTBCQruL+ytz6gnfzwJaoGUoYwdm43iHEQXJzZVFpi/vFEZwDwF3ARqu8tDz
	 qeLBgk7m77mLhrAXDmO+BxW7GeG8v83UbTAUgF11KDlvQhK3oUnsk97ad38UKI3LvZqnV
	 Ff3a5uhuRXACnh6J/SqlWqb0P2E8a/PAwGMgSHZIGb/T9elyvd2rANiJ6aY+pQWtzT0Af
	 cvsfXumfb/SCkBbaatikiK3jrg8FbyFDQKh/Cs8EqG/gigJpU/9SUNWEdbyYSuhZ2GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULb6frbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB245606D87E;
	Fri, 13 Nov 2026 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULb6frbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B3B1F000C4;
	Fri, 13 Nov 2026 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590888;
	bh=ZOuKgibUD8Ya/bC/sQ1+wRNyqS7IU0fWIL5kqGdyA54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULb6frbkqJ8C40pG9zjEFYsh/KSNi1qVhAMFtkd+PWJisOgh/66demPWCI8319RBj
	 cvLcXMmZ4U6sQnXu+08eXJxeFtHKqORYmOwetQG6WKD9Jfo/dDyhLSugENSD+ZspZv
	 UWxMHsJKnVzKbOsgkfdkJ/GqBiUXUT8AJ9A//tRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/670] io_uring/poll: cancel all matching requests in one pass
Date: Fri, 13 Nov 2026 10:43:39 -0500
Message-ID: <20261113153813.336838750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shang En Sim <sim@shangen.org>

Commit 9eff9c07e927dcd9c57150cd6fb3d4ec76f00480 upstream.

With IORING_ASYNC_CANCEL_ALL, __io_async_cancel() calls io_try_cancel()
until nothing is found, and io_poll_cancel() cancels one request per
call, starting each lookup at the beginning of the hash. A cancelled
request stays hashed until its task work runs, so every lookup walks
past the ones already cancelled. Cancelling K of N pending polls visits
about K*N/2 requests in one io_uring_enter(), with uring_lock held.

A single CANCEL_FD|ALL on 80000 polls on one eventfd takes 17.06s,
0.02s with this change. With voluntary preemption the soft lockup
watchdog fires:

  watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [repro:100]
  RIP: 0010:io_cancel_req_match+0x19/0xa0
   io_poll_cancel+0x73/0x170
   io_try_cancel+0x7b/0xf0
   __io_async_cancel+0x41/0x110

Walk the hash once and cancel every match, as io_cancel_remove() does
for futex and waitid. Cancel by user_data only needs its own bucket.
__io_async_cancel() still loops until nothing is found, so a request
that io-wq parks in the poll hash meanwhile is still cancelled.

A cancel that matches one request now walks the whole hash twice instead
of stopping at the match.

Cc: stable@vger.kernel.org
Fixes: 8e29da69fead ("io_uring: add support for IORING_ASYNC_CANCEL_ALL")
Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20261030050319.1448530-3-sim@shangen.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.12 has bucket locks and two poll hash tables, take each bucket
lock while walking it, and sum what both tables cancelled]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c |  2 +-
 io_uring/poll.c   | 54 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 16dd8af6ac981..727166a2ba3e9 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -189,7 +189,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			break;
 		if (!all)
 			return ret;
-		/* futex and waitid return how many they cancelled */
+		/* poll, futex and waitid return how many they cancelled */
 		nr += max(ret, 1);
 	} while (1);
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 31454c27072bc..39418fe05d59c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -892,14 +892,52 @@ static int io_poll_disarm(struct io_kiocb *req)
 	return 0;
 }
 
+/*
+ * Cancel every request matching @cd in one pass. Cancelled requests stay
+ * hashed until their task work runs, so finding them one at a time would
+ * walk past all the earlier ones on each lookup.
+ */
+static int io_poll_cancel_all(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			      struct io_hash_table *table)
+{
+	unsigned int nr_buckets = 1U << table->hash_bits;
+	unsigned int i = 0;
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
+			   IORING_ASYNC_CANCEL_ANY))) {
+		/* keyed by user_data, so only one bucket can match */
+		i = hash_long(cd->data, table->hash_bits);
+		nr_buckets = i + 1;
+	}
+
+	for (; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb = &table->hbs[i];
+
+		spin_lock(&hb->lock);
+		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
+			if (!io_cancel_req_match(req, cd))
+				continue;
+			io_poll_cancel_req(req);
+			nr++;
+		}
+		spin_unlock(&hb->lock);
+	}
+	return nr;
+}
+
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 			    struct io_hash_table *table)
 {
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
-			 IORING_ASYNC_CANCEL_ANY))
+	if (cd->flags & (IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_ANY))
+		return io_poll_cancel_all(ctx, cd, table) ?: -ENOENT;
+
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP))
 		req = io_poll_file_find(ctx, cd, table, &bucket);
 	else
 		req = io_poll_find(ctx, false, cd, table, &bucket);
@@ -914,16 +952,22 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags)
 {
-	int ret;
+	bool all = cd->flags & (IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_ANY);
+	int ret, nr;
 
 	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table);
-	if (ret != -ENOENT)
+	if (ret != -ENOENT && !all)
 		return ret;
+	nr = max(ret, 0);
 
 	io_ring_submit_lock(ctx, issue_flags);
 	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table_locked);
 	io_ring_submit_unlock(ctx, issue_flags);
-	return ret;
+	if (!all)
+		return ret;
+	/* with ALL or ANY, both tables return how many they cancelled */
+	nr += max(ret, 0);
+	return nr ?: -ENOENT;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
-- 
2.53.0



