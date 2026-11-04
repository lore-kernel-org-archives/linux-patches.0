Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826937;
	b=LI9lLc3K3ijbHSpYjdSc12QFETMcAGhh51KPuCQaRbeqCHBWMJwBfghv8nfjPqwxoVNA
	 xzQ5sXE2IisV0Y+wP/oKSNF+ylHiW9PbZu2LeZdG2SPDHHpYgq1t7S/LRLCvaGoLaO5Rt
	 dNThr77C0YG9eJ9NUfSb8CJ3H2wL17/nokSK1j3uxZK3x3GTih+3uXtyNKan54WjyfnAB
	 hIUXtPY6tdQ/6qdfOLEYCH8ZHj/vI89blp644B2m+ZN2MkCGtCsy5eY2vv2ieT88aKVTr
	 i1rCRLajMHvPE6yk/8INOqIef4KYeee7+lx90R1MF3OOZzTj0wzr+i8axzONwDxZgGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4145kT7onkEouo6RRxEE2nCbslBx9aYZOiukRY6qFg=;
	b=pyvaIo2Zec4x19BRpFLNMXvulrKOGORNdiabvRVQqRE1VmoytHB4MoXV0Wb7kMwdHACj
	 c8mfkHsWFTkTUxQ9LPSwk/sHcS4j/q3/NgeHtrNQN6+u8Rq2em9iTdWF3dNOmmYmJBd1j
	 NhphUonstI3VMIX1M9B0LBJOTfhW9vH0a5UKaeJzZV0Wv7I03cvliuv8ABL+tVTi69XnF
	 5O8HMcLSI+9ieXQOg4HRG4T04biAsyloHCBpJmk2czmX7mkT49ZlguuHEREQrPPAk5/T3
	 qAl+D2i3Ug8MyHevl8VXcSYeI4H8lRqzCK1f1Iy6eHueSgTtmSVqr0CvkolLrY8ipaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bykc3lW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0CD6072FB2;
	Wed,  4 Nov 2026 21:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bykc3lW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E781F00A16;
	Wed,  4 Nov 2026 21:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826937;
	bh=f4145kT7onkEouo6RRxEE2nCbslBx9aYZOiukRY6qFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bykc3lW7tx8xgN8l44nBB2f8MJJyTKY7tR4Bo7Sh8sStZOZTbRx5rcCp1YQwudr+4
	 YzgDRwb+8BR7kuqBgCazjqwoxsMwhhE8jwJN1mhHTKsgQToz8PIRKt7FbJCc3KIf1q
	 Ups7ZZEyTP03MsecPOuGYyGpaJt+Cc+bUgH7zXmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 057/547] io_uring/timeout: no ABS update of multishot timeouts
Date: Wed,  4 Nov 2026 16:04:01 -0500
Message-ID: <20261104211039.908331354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b088ae34d4da730dc647261b893a6eb622fe5e1f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 2385adae72e01..75c5d22c1d7f1 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -321,22 +321,29 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
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
 
@@ -470,14 +477,21 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
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
-- 
2.53.0



