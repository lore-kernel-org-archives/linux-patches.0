Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046048;
	b=BsUArtc7ZeTi0Bi2LM29YobXWH+EiJEJTDRDr496gAk5BtRg+eoF+cMjqnD4Wz5G79rw
	 auh+jGpQhjeOk8FzMd9A0Z2nk2Frl3llUnja4p6z5R6BjW7gv69YjtCKz6mdj8vftv8mV
	 ZZsxX0yZhKEbOaGTriR2MZqCUqDNc7Dy3myPELZHQrFzKfKhDmn2cOsp2xtV4ant1+G//
	 +5+TXmXnLnClH/8cHZuejfUk1EJk1wFYxmIvVTiVOL9gI+6M0DT7VNNOh+EU9f914+qIL
	 Gou831cyvZ9m6IaTFtusoUGlQ0nu2OP1sLtNWdDEjZRQSBfjUint6p2vWlw063ll47g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fukymk2ysYWNx9OW66AQJIc9Zh6j5OzrM10t8okODuA=;
	b=aHE3R9oQveJGreLjy/7/fLcby9D0jf0e2KEpG1/7WvMpzwOZcndSwcLNKeq4cSYs4/pT
	 cX0WnZwSI08qCroGf0ml+vzW+m/VkQMQwQMQTpI2hrQdca2MVFXWbpHH04byMtb0Wq0oA
	 448D2MLAe+K1vrwCrHZUjv+uRLbyvw2k5YVNEpQ9Kjg4J15zPEFFqcxz0D1godX8ejAED
	 QnW9bQzobcLo23mP/AC51968VNi4LLpzM9+l2jGBoCYHw5JUd6/IlFzyfVN2IvTDEb1tm
	 ciYj3NVg0VSk/1P97ZqyM/encU6XJ/toa22O66rRNomBf0UCgMqclQWntsvFfpTursw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ+1z126;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02997606A320;
	Wed, 18 Nov 2026 23:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ+1z126
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548271F000C4;
	Wed, 18 Nov 2026 23:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046047;
	bh=fukymk2ysYWNx9OW66AQJIc9Zh6j5OzrM10t8okODuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ+1z126zIXw9DHMXLWOpcAIzPTZIaPvoQuaTfNDe441PPEU4RVifyWvncn8LO0EB
	 7ZLuYUIXaqwFUZdxNSyJa/9yGL9pIDj7C6vTb4Yu0Ee4LewseazihYynUTUtoQ5V3z
	 g741ET+9j8dR8c/2t2eTlmpQyQvCS6qts4xT7T2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1142/2857] io_uring/poll: cancel all matching requests in one pass
Date: Wed, 18 Nov 2026 15:36:16 +0100
Message-ID: <20261118150242.705862461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 has bucket locks and two poll hash tables, take each bucket
lock while walking it, and sum what both tables cancelled. 6.1 has no
futex or waitid, so have __io_async_cancel() add up what poll returns]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c |  3 ++-
 io_uring/poll.c   | 54 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 91ed58712b430..6b82f485b39d8 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -180,7 +180,8 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			break;
 		if (!all)
 			return ret;
-		nr++;
+		/* poll returns how many it cancelled */
+		nr += max(ret, 1);
 	} while (1);
 
 	/* slow path, try all io-wq's */
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 904a5a0bae2e7..2b4c3550c455f 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -895,14 +895,52 @@ static int io_poll_disarm(struct io_kiocb *req)
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
@@ -917,16 +955,22 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
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



