Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1621525743D;
	Tue, 25 Mar 2025 12:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905651; cv=none; b=AqxaBhlHnLoHPsRKXOXTZcfqSiSlzX2qyr11RFMTUoi2juWh5hnc2Wn8rbeFgMVSUD8mLyc1ehRrlja6VRiCl2k0xVLDCUPMODA3Y4B/lfVi1Au922UUPxIeQGTw0STWaEtt9/A+uGkfwWVC/4Nra96Oceg+4aeiPn/FYinsZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905651; c=relaxed/simple;
	bh=eDQvQ5HtviaaZJ7qgL6ke177Rw2PahsLQTj9D7EuKT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3FDaCR48h8MjAWz9AcJfmVWO4VSjhpwn4G/lSSW/LIP9PLFdruIl6JAiS4N2sT/0NNja8eCtwrFNYiLJJODux2Q6UI3xWRC40epPZXq95SO4jHUMWZV4QtqSSAiiw2JRR15xJ/ADHMioJwniNlfyGXkmm+Emxvv8VExNxy1FYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBwvhi0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBwvhi0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE799C4CEE4;
	Tue, 25 Mar 2025 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905651;
	bh=eDQvQ5HtviaaZJ7qgL6ke177Rw2PahsLQTj9D7EuKT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBwvhi0undHwDoaACgxqOObVGjvwkGJG3jA6xlya3NZgtaGwVE2I3LSzB/bPB+H4Z
	 n9QK8O16fdOJBn6SrAFPydRAQWkm3jvrrYCewgZHDXQBLmwKi/KSFF46cRx21nGMss
	 U0QvHK4zSY/rT0PQYXTW/Rx4UyiNFRetvXTBReZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 072/198] io_uring: return error pointer from io_mem_alloc()
Date: Tue, 25 Mar 2025 08:20:34 -0400
Message-ID: <20250325122158.530269171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit e27cef86a0edd4ef7f8b4670f508a03b509cbbb2 upstream.

In preparation for having more than one time of ring allocator, make the
existing one return valid/error-pointer rather than just NULL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2528,8 +2528,12 @@ static void io_mem_free(void *ptr)
 static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+	void *ret;
 
-	return (void *) __get_free_pages(gfp, get_order(size));
+	ret = (void *) __get_free_pages(gfp, get_order(size));
+	if (ret)
+		return ret;
+	return ERR_PTR(-ENOMEM);
 }
 
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
@@ -3422,6 +3426,7 @@ static __cold int io_allocate_scq_urings
 {
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
+	void *ptr;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
@@ -3432,8 +3437,8 @@ static __cold int io_allocate_scq_urings
 		return -EOVERFLOW;
 
 	rings = io_mem_alloc(size);
-	if (!rings)
-		return -ENOMEM;
+	if (IS_ERR(rings))
+		return PTR_ERR(rings);
 
 	ctx->rings = rings;
 	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
@@ -3452,13 +3457,14 @@ static __cold int io_allocate_scq_urings
 		return -EOVERFLOW;
 	}
 
-	ctx->sq_sqes = io_mem_alloc(size);
-	if (!ctx->sq_sqes) {
+	ptr = io_mem_alloc(size);
+	if (IS_ERR(ptr)) {
 		io_mem_free(ctx->rings);
 		ctx->rings = NULL;
-		return -ENOMEM;
+		return PTR_ERR(ptr);
 	}
 
+	ctx->sq_sqes = ptr;
 	return 0;
 }
 


