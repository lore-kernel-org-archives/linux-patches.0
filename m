Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829222;
	b=XzPa8Gvq4fhmRKsfJWVsCnGvtCNTLWER3MINKXuhyJil6mm09N2wqogQ6dZUPSww8tfK
	 +uEZ1Gcp7xL7f1VQ0SOKqypK7jYnxBd0tNyYfb5/X1IVl5ef+L3yBxtRauCkELGVfFRFL
	 i/WUBQvaSMgK3aa2msztSRHg1vFGTq/kBaN2EQ3euG7vxE6zpmcGy8EubiigelwOUl9px
	 K2xwcttLzX3d+qzSdaX3QlyFWsAPD3auJGj14upVpJRyXbwXOrJ4NztrrjdwC5+s9KO2o
	 gTrJL/x/ACCVxycR+KY9eNc7slLMRr16/9GWbxi8lMmTRSnBYhuQ54bBC6Gd4qszjsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=orkEhTzDjvoWYxDPK/4AEUDmljFNxp3JikruRGp4ha4=;
	b=rceVgFpmVcLjtlLyDK+LqY9B7XD3CTo1iLjDOwXnEACKEpBwbfC0yxaSOnNRjKTDlviR
	 ZN8In4P0fCO+kk7QmmaBzBhDKn9GZpxKj83aI0PQtVWvRrV7g83bckzL4bBlTLfJm1v3P
	 9HDMCoF9ZSNZ2EDlvF4Z/q5ra3V2pR2r8ZjtqWTBgsLdgi9snMznbAcW/G4XdwXYxqZBk
	 4XlWJxdyVtPCGpjZWkhzZr+D5W9TElRYj3EWoP35lxbSXm1+vmYHV7XtGIau2Ml0fD6xF
	 AaJjkWged8jh32oRY8llPQIsAo0scXv/ajkx8LLOCzGLgLXdRkPCLfbsJIqlwBRYf9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvHZHYGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A66070A88;
	Wed,  4 Nov 2026 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvHZHYGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552E61F0093A;
	Wed,  4 Nov 2026 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829221;
	bh=orkEhTzDjvoWYxDPK/4AEUDmljFNxp3JikruRGp4ha4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvHZHYGo0bTg9zpBD/PiofEGQXragADJWJlXGCK+E+jSz5jpn9NADAVxijIrl9ATh
	 E8e+T2wuHsG/Fe4TBy/ihAKoOGPVi9magwNvLuA2z+SBPbm4pPrms6kxD93H23r0gK
	 7PSkopydkWH47AbyiB3M3wTdhaKLJaD42QrnxI3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 525/547] io_uring/rsrc: charge buffer arrays and nodes to memcg
Date: Wed,  4 Nov 2026 16:11:49 -0500
Message-ID: <20261104211053.310656194@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -162,8 +162,9 @@ static struct io_mapped_ubuf *io_alloc_i
 					   int nr_bvecs)
 {
 	if (nr_bvecs <= IO_CACHED_BVECS_SEGS)
-		return io_cache_alloc(&ctx->imu_cache, GFP_KERNEL);
-	return kvmalloc_flex(struct io_mapped_ubuf, bvec, nr_bvecs);
+		return io_cache_alloc(&ctx->imu_cache, GFP_KERNEL_ACCOUNT);
+	return kvmalloc_flex(struct io_mapped_ubuf, bvec, nr_bvecs,
+			     GFP_KERNEL_ACCOUNT);
 }
 
 static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
@@ -229,7 +230,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(
 {
 	struct io_rsrc_node *node;
 
-	node = io_cache_alloc(&ctx->node_cache, GFP_KERNEL);
+	node = io_cache_alloc(&ctx->node_cache, GFP_KERNEL_ACCOUNT);
 	if (node) {
 		node->type = type;
 		node->refs = 1;


