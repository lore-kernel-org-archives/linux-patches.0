Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208118;
	b=E7hbXDZdsq6Bqh63YamUQnmsAHV9b5hJ7cLzLVq0Zg9pWMpRiNn9hs9uKt104l90Uyia
	 xVxuNvMj21s35LKp6nycphry83GxGHoPq2lKjypLjTNYWluIuhO73x5bJg5VgsWcHD2Bc
	 IYi7jW5mogAAzQgGdXYDd/+TBsSfW8HUi4AjSg1WjBHTsWgbdEpQoIyYp8ir6Ax+FbiLx
	 E9Uk5a9PPaQiVn6FywKH6uYigM+jzCWx0Sq4VyDl2NQrksj3sONKP3pj3hb5FU+wmY0pL
	 nTALAV+25fWR34WhSYk+DVC0C2meSGd1GdZ7o0GspIAj1KCLKtcZeao+O/kQIgyoDGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbx9hAZNGVQv1qqSjudAmp4OsNGdD5a1kQyxKo9AOq4=;
	b=g4V3AH8qOQc7M5AYdqLRoFKa6M6amDvA2kGfTIkhdzUKIR+sEzXpTvsN4K2yK5S33vqh
	 QlwTZ1/mtP999ubLuvoG4ouW3Pq47KXmIInkNEEtOaFL5C6pefm3fnBmbooDwD7hLdXDA
	 bW6x6er4MxVhamq24WtN6xKH9/jVYJRkEZqMXtJMfB1xuKtcao/EmvbvaMa1BfmsfOdGq
	 dTBtqGAcZO95qbILLCI/QK/IHBRBV+3zl/gTboeXh+tEKuai8LREc+t7kLg7Gy+1SXnPP
	 hf9KhXQj9iVR52sZ+GQjM9n+yq2v+ikrnQqwLaLlDaM9nbmpa/xnbz36SNRYCZ2RfbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo8jOvqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91DA606A324;
	Wed, 28 Oct 2026 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo8jOvqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9411F031E2;
	Wed, 28 Oct 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208117;
	bh=tbx9hAZNGVQv1qqSjudAmp4OsNGdD5a1kQyxKo9AOq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oo8jOvqnpqfHkngdJj72l6UauFG5EXO4lVgusZGbLtBKHeTl7VeMoYjj9HOSgQZ0z
	 sQlUibHNnvb5iAL7gvnYcaDrMfZkIxVJwjREoKYK7lDCGJutBTRtMV/WQmX/1lrwqw
	 SMBembjvd1YmDv6PKL2+q0C3ytg8lPwaYbh3obS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 219/247] io_uring/timeout: no ABS update of multishot timeouts
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028165952.608240458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit b088ae34d4da730dc647261b893a6eb622fe5e1f upstream.

IORING_TIMEOUT_MULTISHOT can't be combined with IORING_TIMEOUT_ABS, prep
rejects that, as the request is armed again with the same value each time
it fires. IORING_TIMEOUT_UPDATE doesn't check and takes an absolute time
for a multishot timeout. The first expiry is as asked for, but
io_timeout_complete() then arms the timer with ->mode of the original
request, i.e. it uses the absolute time as the interval. With
CLOCK_MONOTONIC the next expiry is an uptime away, with CLOCK_REALTIME
more than fifty years.

Fail such an update with -EINVAL, and do so before the timeout is
touched.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-41-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -254,22 +254,29 @@ static enum hrtimer_restart io_timeout_f
 	return HRTIMER_NORESTART;
 }
 
-static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
-					   struct io_cancel_data *cd)
+static struct io_kiocb *io_timeout_find(struct io_ring_ctx *ctx,
+					struct io_cancel_data *cd)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_timeout *timeout;
-	struct io_timeout_data *io;
-	struct io_kiocb *req = NULL;
 
 	list_for_each_entry(timeout, &ctx->timeout_list, list) {
-		struct io_kiocb *tmp = cmd_to_io_kiocb(timeout);
+		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
-		if (io_cancel_req_match(tmp, cd)) {
-			req = tmp;
-			break;
-		}
+		if (io_cancel_req_match(req, cd))
+			return req;
 	}
+	return NULL;
+}
+
+static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
+					   struct io_cancel_data *cd)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_kiocb *req = io_timeout_find(ctx, cd);
+	struct io_timeout *timeout;
+	struct io_timeout_data *io;
+
 	if (!req)
 		return ERR_PTR(-ENOENT);
 
@@ -400,14 +407,21 @@ static int io_timeout_update(struct io_r
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_cancel_data cd = { .ctx = ctx, .data = user_data, };
-	struct io_kiocb *req = io_timeout_extract(ctx, &cd);
+	struct io_kiocb *req = io_timeout_find(ctx, &cd);
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
 
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (!req)
+		return -ENOENT;
 
 	data = req->async_data;
+	/* multishot requests only make sense with rel values */
+	if ((data->flags & IORING_TIMEOUT_MULTISHOT) && mode == HRTIMER_MODE_ABS)
+		return -EINVAL;
+
+	req = io_timeout_extract(ctx, &cd);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 	/* for a multishot request this isn't a sequence, keep the repeats */
 	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
 		timeout->off = 0; /* noseq */


