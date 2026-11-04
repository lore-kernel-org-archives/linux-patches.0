Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831887;
	b=NoJPwHPpmSrA/rxQUSn9qgolhzj5vukh/SghGwQTpZUUN4r5QAOoa8kVKXRRfYRDOzBD
	 f43ESYdr71RZmUP30SCL2SFjNViE/t3J6c9rdotg5YGwtKzUVmRg7d/PTenkhDcYaarE8
	 iuJ4vV7Csa/N0TaoXPioLdWPBX3Dw6qYwIyUEOUszZU481f36SkStFj+/8Oe9fZY7w6eD
	 LVmPfsc+xPAqiYN6Zh+WLFqgpWihSMOLqrCyLw86COuinJDeMLch4azuRPQODpn7AX4Gg
	 iOrLj1cfbbWRjS4wXZ8weT85p2y880VhHasfH26Xho6mphXr47vCp0Is+Fx7HWCmj9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6LblGlb/kHyFxlL7JTSxm36SGBRjHs1FArkraHvYHs=;
	b=g6pBvznLdneZFrQ5I23yvaoJCOjxA1jtbVPjlPlxznBh1h9/p8QsnGVFyEGLNTGpQfx7
	 dzeBccCmdR030ocR0hlUkLxzvk/ouu0k4Uz+oLfugmhGDeRZKuGVZb4/TKFQrSn8aH/s5
	 P2AidomB84ljOMMIh1h3C69oAf0k4SOJ9q9I0DToMWiGqHij2VLmPaeADY80mgoBO3AW1
	 8fShN7zsa9+Bw6MZo02SMeeQ/fN/gJ/nRItdx+zYzhs1eR6B4xEoRliZG7rLPFSyJSEW7
	 kO8aeLzzwhCMQ09niyvuQmB52SmO2DhUo/aIWgvDmtXz32gZkAGkiUvOoZ9/GEQW8Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWkO8d+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C0B606A33D;
	Wed,  4 Nov 2026 22:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWkO8d+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DF11F000C1;
	Wed,  4 Nov 2026 22:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831886;
	bh=b6LblGlb/kHyFxlL7JTSxm36SGBRjHs1FArkraHvYHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWkO8d+wiDuqf39YJ4fG0BKVF/ltvX6fu7/cdlTlOq/bG6dgA5m3LgQSmbW7WUB5T
	 Vrsq09f9rF8WI9dtNZrBu/uloo3R/qzSTmEBwsWzYwJNcvd7aIz/cdzTduNS8keT0q
	 MoRYCzLuD9W4mfwO3Qjj2UGqfr2LTuvKsdt/9oyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0975/1005] io_uring/rsrc: charge buffer arrays and nodes to memcg
Date: Wed,  4 Nov 2026 16:11:48 -0500
Message-ID: <20261104211110.370668828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 075d5837bafc317e796548f721b8fbf7add6821d upstream.

The io_mapped_ubuf of a registered buffer has one bio_vec per page,
unless the pages coalesce into huge pages. Huge pages only count against
RLIMIT_MEMLOCK once per ring, so a buffer that maps the same 2MB folio
over and over in a way that defeats coalescing gets a full bvec array
per registration while only the one folio counts as locked. 1GB of that
registered in 100 slots took several times a 64MB memory.max, with 2.6MB
charged.

Allocate the io_mapped_ubuf and the io_rsrc_node with
GFP_KERNEL_ACCOUNT. An object reused from the ring caches stays charged
to whoever allocated it first, same as the io_kiocb cache.

Fixes: de2939388be5 ("io_uring: improve registered buffer accounting for huge pages")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.18 uses kvmalloc() + struct_size_t() rather than
kvmalloc_flex()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -110,9 +110,9 @@ static struct io_mapped_ubuf *io_alloc_i
 					   int nr_bvecs)
 {
 	if (nr_bvecs <= IO_CACHED_BVECS_SEGS)
-		return io_cache_alloc(&ctx->imu_cache, GFP_KERNEL);
+		return io_cache_alloc(&ctx->imu_cache, GFP_KERNEL_ACCOUNT);
 	return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_bvecs),
-			GFP_KERNEL);
+			GFP_KERNEL_ACCOUNT);
 }
 
 static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
@@ -140,7 +140,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(
 {
 	struct io_rsrc_node *node;
 
-	node = io_cache_alloc(&ctx->node_cache, GFP_KERNEL);
+	node = io_cache_alloc(&ctx->node_cache, GFP_KERNEL_ACCOUNT);
 	if (node) {
 		node->type = type;
 		node->refs = 1;


