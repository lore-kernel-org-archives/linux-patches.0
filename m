Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590026;
	b=s6lnYSboyGDhRKKc/Lqu8Vy2qCmfLUh/tBmCs3WhurqvuRpKWKvDo5BRL7qUgPxYylcE
	 Vx934Yum8fpQZnthfVIgg8T68ycSg5Op42ivE6dtB3rPWZzCq2n9Ar/xEArYLjlYphjNC
	 ufGztgymDilq8lZzAUiCAdv9YiHYl/3yISRGCBs4prinL2t11FDdUeCqqYCB5uGJSqfI9
	 zgZ1jCNosjXs0ccO1PPJJD2cxc79nVUl0OWOSULXkXn6LWXpDU/wTdTwTveefiDlctkXW
	 4HMByLieqqTlIL96upz2pbjNjDwRVVFrdeK3qPvTik2iVS9Jhp8gJ6GeIAM2C0Tfr/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WmmXSVeCKV9g/PQLlrXHorskxo2J5GarOxcRjApIOHc=;
	b=rCJEagqDOoQS0GPMUtWcro39Rz263vgpajGLWdOAiHiFqRoXsFOogU+x5RhnasLpJe1w
	 iGe9oqQxK7j3LpDeRKVFzRHGJAPIryRPECWJhC+2OmxZ+FaE66gc2jRfdqkRflgLJglLi
	 Ug5Lzfpda/bHP1+9zW0jFRLCv9AmU3zLt9+g7gvPzaHDoATR/b3R3OA9cTb06PzzecA8Y
	 9g89Bk0219SR/lqD/d3hb3lVlmbhCDiWDCku86pbsQ/9GQ1N1755kE0bnPcj4iQgTQXNN
	 ooIQKGyXrPQU0ReZhzWGLHGM7Sxz/c2cYcugrpE4tryKw1gjovTjSaNOTUsNrZhZXNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiBsfcmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935EA60A2602;
	Fri, 13 Nov 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiBsfcmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24CC1F000C4;
	Fri, 13 Nov 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590026;
	bh=WmmXSVeCKV9g/PQLlrXHorskxo2J5GarOxcRjApIOHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiBsfcmQNNpr6PkhnFG8bXxwmwFl0LbWnPzyynkrxb5jhydHfm18i2etdiy44vqhd
	 1/qOxpj4Y5i9D793UsL57yam1UiN7a5wbsVOFuAVmBqfs23mo8Sal9NZWxHfFI8+QC
	 VjvGpB8m28HX4lMR2s0V+dj04KPazZN3Q+yynk+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/686] io_uring/poll: cancel all matching requests in one pass
Date: Fri, 13 Nov 2026 10:43:18 -0500
Message-ID: <20261113153823.134184491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c |  2 +-
 io_uring/poll.c   | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 1db26c66e45c6..471d6f2e5f18f 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -192,7 +192,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			break;
 		if (!all)
 			return ret;
-		/* futex and waitid return how many they cancelled */
+		/* poll, futex and waitid return how many they cancelled */
 		nr += max(ret, 1);
 	} while (1);
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 48381f0cbe327..6af64c7618e5a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -824,12 +824,47 @@ static int io_poll_disarm(struct io_kiocb *req)
 	return 0;
 }
 
+/*
+ * Cancel every request matching @cd in one pass. Cancelled requests stay
+ * hashed until their task work runs, so finding them one at a time would
+ * walk past all the earlier ones on each lookup.
+ */
+static int io_poll_cancel_all(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+{
+	unsigned int nr_buckets = 1U << ctx->cancel_table.hash_bits;
+	unsigned int i = 0;
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
+			   IORING_ASYNC_CANCEL_ANY))) {
+		/* keyed by user_data, so only one bucket can match */
+		i = hash_long(cd->data, ctx->cancel_table.hash_bits);
+		nr_buckets = i + 1;
+	}
+
+	for (; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
+
+		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
+			if (!io_cancel_req_match(req, cd))
+				continue;
+			io_poll_cancel_req(req);
+			nr++;
+		}
+	}
+	return nr ?: -ENOENT;
+}
+
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
 	struct io_kiocb *req;
 
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
-			 IORING_ASYNC_CANCEL_ANY))
+	if (cd->flags & (IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_ANY))
+		return io_poll_cancel_all(ctx, cd);
+
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP))
 		req = io_poll_file_find(ctx, cd);
 	else
 		req = io_poll_find(ctx, false, cd);
-- 
2.53.0



