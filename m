Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207303;
	b=BG/GET63qdAZ/KVH4GCSoQa2ndT9Tig4sHR3bm6s38BzgfZUjsMA6+oCzkHtfv+9D8zU
	 d7YQxt2+DgebpTMIK8SLU2AcTJqIlcM22CH7war+JJVU+mL8o59TcyC9NSB6Ym+URW9O8
	 9G1VilnMsgrcFBQ6T5trhi4ZhMW565sN7bGndN9KNZiQeaH4oDi69kVRH1vQQuDROPwV6
	 FuXEU8flLpwpQru/31GlonHCf1y9W33heVCTH1makCLI7ikNxqm89+U0YITwieKn8Aooq
	 FaChgP7WeD+UUjMtijIq1ssmEJJAJoNta5/izAu3+0awef7zHAaOKKEoQ5iNjB2DQrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8fG4xflSzArtS3wrqadN9Mmgb2YpKiqUVGuefstLnU4=;
	b=g3ga7aCcxT2QgIsHZXbHIKTvr0JZTWmwIsmdYE5fJH6kXmPUNkrn3WTl4vv9ffQhdzI3
	 WSLKJN0YDkg3pu7Hf127lGMwjHf+pSpzu7TrZPqfUyTqYNXKPYsrsAyH99pUHt0zbUAGe
	 XxwCbfp2avcf3DxuBF+etSJhm/ragk3LVALTEv3cdS8KCTpPJ+y3QErP67EBMFmSMZY+3
	 VXD7IN5rQRy5HX3GUN2gEAm/stNPwevKkflL7YZ7yXYAuwYvW7cZiZ6wCm9NilulzIWR4
	 z+Rk/gXEPjTfGXoFVu6QoQSY9pR2xuAuXnnHVCBj+K+gikixRO3ZRbBMGGmd+eS9IBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMHDemNA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06FA606A321;
	Wed, 28 Oct 2026 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMHDemNA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF00C1F01825;
	Wed, 28 Oct 2026 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207303;
	bh=8fG4xflSzArtS3wrqadN9Mmgb2YpKiqUVGuefstLnU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMHDemNA7Tyt+wxNRqjFlEDS/m9Wnsnc6BGWbSrG1FFjcTEQENL2IQD3wdbCrr7o8
	 QVjqnIUZngIZNQh9TVb3p3Gv8GwJtfIqfZT9Ckn9jrH5FVSyINgfITlXJ9t4ZnN9zl
	 652Qv9XBFsoMzj7kp2vcGcMtBHOOHvHHnVjRgbo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 57/88] io_uring/timeout: no ABS update of multishot timeouts
Date: Wed, 28 Oct 2026 18:00:05 +0100
Message-ID: <20261028165943.455295125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,22 +321,29 @@ static enum hrtimer_restart io_timeout_f
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
 
@@ -470,14 +477,21 @@ static int io_timeout_update(struct io_r
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


