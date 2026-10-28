Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207261;
	b=1vdCh33iRHXJrn2xbLimTcDXYJI5bDs7SWAo1DnSSHpRFtjqUK+CkuoGuFEQJ6O08rko
	 G0/2CEe9NRLZI6B786YwNYX8tvHp3AfvKys73dUpyQw2VhrNfnNbLpRFLq8KIU/QYG6Jj
	 vAIFyzRrUCVUr7zVfTNd9V3kTQluxJaPZjX9uk9ZsOpuQAXvgQu2EtrvpMDSq36EA5DwR
	 LTR+suqmwmY0RilTFcCxc/DdK6lDZk9tW0mgPkcgrjhbeCPdvHC1n6N997bqQlShYiDOD
	 ohU02+Vhxv24XYeGuAKOLzZ7SCJ1p9I3cBmlEVp14RlkIzOExHXPedC+VjHIRIEDf9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4pUlcwx0lJVwY7CtbDgKum549/sYFcAhMlEYjzr+TE=;
	b=w0oMiFFr54zOcwgwtqehsXEVFweDrXkx+n2oDkdX23CAS97H7v1imsXUz+BzzzgY4hCQ
	 uEkTpRDXHzBd1W0EvAd5t1rwurPQSrf4gNsE+s+5dYdQDrQLzDY93+uYBHRGhP5Ajyd3H
	 XG4uQ6BSmCVXJpiDS3RjfzvB+Ekw983KljVxyF353vRT/jO6UsewGBsctjwlaaTlGyjoS
	 VKaUJRRMP6uunsMjpD1cIid5XuvQuMbAhaNbdqzQOCqBNSWUJ/WprRBdVuqYnwULmUpSh
	 bRfCL8jaiHQJRnphQBAamYuDPkrzmYJ7czShModR4wNkR5T10hHnbQRczlHdEPvzXkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKeOt9Kq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D9A606A321;
	Wed, 28 Oct 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKeOt9Kq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B8C1F01825;
	Wed, 28 Oct 2026 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207260;
	bh=U4pUlcwx0lJVwY7CtbDgKum549/sYFcAhMlEYjzr+TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKeOt9KqFiCSxQeThkyZbXmEBLX4ym5z3GoeKUk3XW4z9aD6YycJrS448LGt4swGu
	 BIAEmPsM+CWeAwSdWhvq3EryceUsq5vMpvVurk9UB3IdDqgeenkYm4PJwjK28WAjqz
	 5lLV2T1KgEz72+0oeEr/lhwQcNcI0BETBy/tfvy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 43/88] io_uring/register: keep 128b SQEs intact on resize
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028165943.127590170@linuxfoundation.org>
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

Commit 0feb5bcd2d4261d656729892aef4d643461ea5ac upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -496,6 +496,17 @@ static void io_register_free_rings(struc
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
@@ -506,6 +517,7 @@ static int io_register_resize_rings(stru
 	struct io_rings_layout *rl = &config.layout;
 	u32 *o_sq_array, *n_sq_array = NULL;
 	bool cqe32_tail = false;
+	unsigned int sqe128_src = 0;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -605,12 +617,19 @@ static int io_register_resize_rings(stru
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
@@ -619,6 +638,19 @@ static int io_register_resize_rings(stru
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


