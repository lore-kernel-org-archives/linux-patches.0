Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826848;
	b=KExyQrUliLxsTRapJo1Adj1t7Oy9A3MX3pZ+h3StR6V33X9dV4SF1siIObsCIKjv/ToM
	 QdYk8agPGeyJdZoGCT6kKIWIVRkP+8Vrnbffb2N9MCuXep27MSEitDja7fIsfeyfcsclK
	 GCFXYiIcol2EDtqC9ijPZCIS612MUGi2e3EveDkGmsgE6VsGAHd6D55sBUzobrE60fE6Z
	 wvRAHJQF8ea5k2DCleFc1ByfontVzvu+dXvHUnS/hCsWRwsGzg6tesaS/WwiKvKxuiCS5
	 D+gPFCdOveuRNeazolNhZgFnvc0E93Q1FtGMSizM4gZktjyUQA4q3VRCQv8cnE93krA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3bAsWq3rvFwx7h4bKVfqVgSnXnmz+Hav2hvuzP8Quz8=;
	b=QDcLGW75cKaOOMSdjVg1qgPcs6xrg3P9wSdBzusE9fT04QBHpPS+X+Gsm2sm672gE7Je
	 wbCr4Nllelm8RoCa+/hRlSRIgBaoe90OEF1lLBgpOCGvNStRinUjJOCtoErktDxt+1hL+
	 fZDMjmwYMj/zY0UMWfPEvo8+2d3HcVMCzznIqJj0RTAjk0BpeixZSan1yAsDSqDQCr9op
	 t2HXPtIdfdLxpz8bNhn3rzNxf91uhBPIhtC58nYXmCYLmcnnri9bFTgvnJORW7W3Xpv/v
	 wA4JWQxIiV7Mm1hRc2kJ14X73Cbn8iRZot8d8AbsX+gyqwul3CIlgxNQrGva7lVG4IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fySaKy6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6112D607E116;
	Wed,  4 Nov 2026 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fySaKy6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7221F0093A;
	Wed,  4 Nov 2026 21:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826848;
	bh=3bAsWq3rvFwx7h4bKVfqVgSnXnmz+Hav2hvuzP8Quz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fySaKy6qPmOD+1M3GICOtVG0aT6p5dQMTdlFyFFC8TXntnTNbv4P7E8QN3bFQxQzw
	 DwY9RiwOdWtJ8NzvfFoJT7zmIeoTs79tws7Rn6rsJ0SFecRV4rhcNe/x8idKFOT5fo
	 GvIpm8Ks2imUDxLeVCPiUUBhVjILvuzA46EsOsrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 043/547] io_uring/register: keep 128b SQEs intact on resize
Date: Wed,  4 Nov 2026 16:03:47 -0500
Message-ID: <20261104211039.545546370@linuxfoundation.org>
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

[ Upstream commit 0feb5bcd2d4261d656729892aef4d643461ea5ac ]

On a ring with IORING_SETUP_SQE_MIXED a 128b SQE takes two entries that
have to be contiguous in memory, io_init_req() fails it with -EINVAL if
it starts on the last entry of the SQ ring. The entry a pending SQE ends
up in after IORING_REGISTER_RESIZE_RINGS depends on the size of the new
ring, and nothing takes care of that. With four entries instead of eight,
a 128b SQE which was fine in entries 3 and 4 is split up between entry 3
and entry 0. The resize succeeds, and the request fails later on.

If the ring has an SQ array, the second half is also taken from the
wrong place unless the array happens to map the following index to the
following entry. The submission side doesn't look at the array for the
second half.

Do what is done for 32b CQEs on IORING_SETUP_CQE_MIXED rings: fail the
resize with -EOVERFLOW if a 128b SQE would wrap. And copy the second half
from where it is.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-27-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index bce4473dc2ddb..2ce36623e25a6 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -496,6 +496,17 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
 			 IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
 
+static bool io_sqe_is_128(struct io_ring_ctx *ctx,
+			  const struct io_uring_sqe *sqe)
+{
+	u8 opcode = READ_ONCE(sqe->opcode);
+
+	if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || opcode >= IORING_OP_LAST)
+		return false;
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+	return io_issue_defs[opcode].is_128;
+}
+
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_ctx_config config;
@@ -506,6 +517,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_rings_layout *rl = &config.layout;
 	u32 *o_sq_array, *n_sq_array = NULL;
 	bool cqe32_tail = false;
+	unsigned int sqe128_src = 0;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -605,12 +617,19 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
 	for (i = old_head; i != tail; i++) {
+		bool sqe128_tail = sqe128_src;
 		unsigned int dst, src;
 		size_t sq_size;
 
 		dst = i & (p->sq_entries - 1);
 		src = i & (ctx->sq_entries - 1);
-		if (n_sq_array) {
+		if (sqe128_tail) {
+			/* it follows the first half, whatever the array says */
+			src = sqe128_src;
+			sqe128_src = 0;
+			if (n_sq_array)
+				WRITE_ONCE(n_sq_array[dst], dst);
+		} else if (n_sq_array) {
 			src = READ_ONCE(o_sq_array[src]);
 			if (unlikely(src >= ctx->sq_entries)) {
 				WRITE_ONCE(n_sq_array[dst], UINT_MAX);
@@ -619,6 +638,19 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 			WRITE_ONCE(n_sq_array[dst], dst);
 		}
 
+		/*
+		 * A 128b SQE on a SQE_MIXED ring takes two contiguous entries
+		 * and must not wrap. A smaller ring may place it on the last
+		 * entry, fail the resize if that happens.
+		 */
+		if (!sqe128_tail && i + 1 != tail &&
+		    src < ctx->sq_entries - 1 &&
+		    io_sqe_is_128(ctx, &o.sq_sqes[src])) {
+			if (dst == p->sq_entries - 1)
+				goto overflow;
+			sqe128_src = src + 1;
+		}
+
 		sq_size = sizeof(struct io_uring_sqe);
 		if (ctx->flags & IORING_SETUP_SQE128) {
 			dst <<= 1;
-- 
2.53.0



