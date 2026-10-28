Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209797;
	b=zn3y6qcJaLgDGL/gQrxpTwgxz1c/DA9rQ8v9xw0qkJ/tRgv6D/mQEZU7mg7liDIPuYUj
	 tleUTIvyynwhvb+Jm+SE5m/QwDoFmo/MtWzmRPspgBmj8WT/spbj78X6V4lQBpsdfa1sV
	 0EEogGewZiKfEc7ggGuAn5lqn4cfNT+11fceDpj/g9rYtxFsGs4ncGfu4Ik2RIlHsQNJt
	 lj3BzuHHoFhHAS6kddj+T+xmFLYtEex133ViWi49qm8SyJCo2Lsm0Ca5Jblc058p1AWNm
	 c7IWCXJyalKGAPhg7H9ySe+SnTrZ6PD1zRljMmAav2Hc6MFj5Fq59h7hmh9ztU4QXZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MFaKXWjV4ksx2oGvomE7nJVC3c2d0br6RtTPOwZL3hM=;
	b=qeQPpO/SXJVgtWmUxLR4KcEXOUORPJX6RT/lR4doR35SnE5XmJAa8pSScTwmjtkyx+tk
	 FZ57NdAK6CKhROnw/9n4G4sjPFh2v3AyWbtwoqjMim1ZhWmfyXsbL7jIvaaqInLUU3fw9
	 2KFLQyA1XmYUrFgxG8hC4X1s2pXqawr1CzdVZPWOprJH7p2KzR1P1N5whB9AiTB+o3J4E
	 jgXTk0aMJCCcpyIrfu1cMhAHFc8qBI7ZPnYxG/a+QLzWWMBZAqdAUMJew0rVLWA4RHH+P
	 +u124JGtTVjF28qy7wsrz4Im4HeH6MCheFhQ4swz20f26rD68CK5JXhsxn3jZo0/ZMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuxQXaZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D5F606A31D;
	Wed, 28 Oct 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RuxQXaZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2C01F01825;
	Wed, 28 Oct 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209796;
	bh=MFaKXWjV4ksx2oGvomE7nJVC3c2d0br6RtTPOwZL3hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuxQXaZCc+0UcmN+/gZOZUJ+FR+an+Ewcp6BPfhoqc2BlNSl0Jn3rYpBUNpFySjzu
	 Vv33K1/GGiyQP6A+bcI4+WFXMeE0TKxbMNi8VQao1cbqnHSZZON13wBlJkJoGF9Q46
	 3butaJsDgJ7sYD/mMqPBL6H3vkxoMqK4JTcPZQDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 078/109] io_uring/timeout: no ABS update of multishot timeouts
Date: Wed, 28 Oct 2026 18:01:02 +0100
Message-ID: <20261028165944.193036898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -278,22 +278,29 @@ static enum hrtimer_restart io_timeout_f
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
 
@@ -426,14 +433,21 @@ static int io_timeout_update(struct io_r
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


