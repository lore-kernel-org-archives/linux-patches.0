Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E17C4F402E;
	Tue, 13 Oct 2026 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892750; cv=none; b=cJ8gy814+OD1GsawrdtK9d32jbFObL5yNJc+U3OseiFfI31N4nZqfQZ3C6f7C9QO/6RWZWAh3vQXskeHLSmE061Pbod6rJguGodcIrOaJvt5Th5emYg1MNbI0qV5TM+EISCyHFK837/f8xu5Hyt+PYKF5dpHOHQcflyAQxVHDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892750; c=relaxed/simple;
	bh=sPRcK8aGO7hG9/ELY1DcyXekqKUceyukHgMECJAKPbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwMafcP7zKNW0gkxs5WkxjUiy1/Pify/AEF4NAx2kUE6JpbLZUQRFKKm9xWwfyGITe6dE7HuduDKH/dATbPZybpK6jduNBsL1lxRbR/YXaKTgNPTZic6Wsf1bm0qjs3BRZ3o7vwJ4/3aQGonmqbZe6uhmw3OecOYEPqtp/PGeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk6bjAsh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk6bjAsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257761F00898;
	Tue, 13 Oct 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892748;
	bh=P8L1BMtWUNcJVvR08cQH8X3SODrlRYRM/rxCZDZe32Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk6bjAshNHvM1JT+0FyP4cQrhcqKYQRCZ5I9/cM1t4Y6CvUzLMqZyL9LJY7l3jvZY
	 LERZ3sdE8N7K2AJfS4i8XJib4bv2o7G1iMG9GdPhc+ddEDAgeIatv/yWG+7/kBwnQC
	 lXFURiOK/g8l/NM/lZCxtW6KVluuoQ682rMBBF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 278/281] io_uring/memmap: account the pages a compound region really uses
Date: Tue, 13 Oct 2026 13:39:54 +0200
Message-ID: <20261013112901.885405162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit f12f0234cc14886bcfd53ffb7c8df4216dad51f1 ]

io_mem_alloc_compound() allocates get_order(size) pages, which rounds a
region size that is not a power of two up to the next order. The pages
past the region are part of the same allocation and cannot be used for
anything else, but io_create_region() accounts reg->size >> PAGE_SHIFT,
so they are never charged against RLIMIT_MEMLOCK. For a ring with 4096
SQ entries and the default CQ size the region is 37 pages while the
allocation is 64.

Account the tail pages together with the region, and fall back to the
exact sized bulk allocation when they do not fit the limit, so a user
close to their limit still gets the region rather than an error.
io_free_region() gives the same amount back, the compound case being the
one that set IO_REGION_F_SINGLE_REF.

Counting how many 4096 entry rings an unprivileged user can create under
a given RLIMIT_MEMLOCK, before and after:

	limit (pages)	before	after
	256		2	2
	300		2	2
	350		3	2
	400		3	3
	512		5	4

Five rings under a 512 page limit really pin 640 pages.

Fixes: dfbbfbf19187 ("io_uring: introduce concept of memory regions")
Link: https://lore.kernel.org/all/87ik5ncj8d.fsf@mailhost.krisman.be/
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260806180044.275543-1-ali@iusegentoo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b59cabf9b4ac ("io_uring: do not charge the SQ/CQ rings to RLIMIT_MEMLOCK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/memmap.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -16,8 +16,10 @@
 #include "zcrx.h"
 
 static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
-				  size_t size, gfp_t gfp)
+				  size_t size, gfp_t gfp,
+				  struct user_struct *user)
 {
+	unsigned long nr_compound, extra;
 	struct page *page;
 	int i, order;
 
@@ -27,9 +29,22 @@ static bool io_mem_alloc_compound(struct
 	else if (order)
 		gfp |= __GFP_COMP;
 
+	/*
+	 * get_order() rounds a non power of two size up, so the allocation
+	 * can hold more pages than the region exposes. Account those too,
+	 * and leave the compound allocation alone if they do not fit.
+	 */
+	nr_compound = 1UL << order;
+	extra = nr_compound - nr_pages;
+	if (extra && user && __io_account_mem(user, extra))
+		return false;
+
 	page = alloc_pages(gfp, order);
-	if (!page)
+	if (!page) {
+		if (extra && user)
+			__io_unaccount_mem(user, extra);
 		return false;
+	}
 
 	for (i = 0; i < nr_pages; i++)
 		pages[i] = page + i;
@@ -105,8 +120,15 @@ void io_free_region(struct user_struct *
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
 		vunmap(mr->ptr);
-	if (mr->nr_pages && user)
-		__io_unaccount_mem(user, mr->nr_pages);
+	if (mr->nr_pages && user) {
+		unsigned long nr_accounted = mr->nr_pages;
+
+		/* a compound region was accounted for the whole allocation */
+		if (mr->flags & IO_REGION_F_SINGLE_REF)
+			nr_accounted = 1UL << get_order(io_region_size(mr));
+
+		__io_unaccount_mem(user, nr_accounted);
+	}
 
 	memset(mr, 0, sizeof(*mr));
 }
@@ -151,7 +173,8 @@ static int io_region_pin_pages(struct io
 
 static int io_region_allocate_pages(struct io_mapped_region *mr,
 				    struct io_uring_region_desc *reg,
-				    unsigned long mmap_offset)
+				    unsigned long mmap_offset,
+				    struct user_struct *user)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
 	size_t size = io_region_size(mr);
@@ -162,7 +185,7 @@ static int io_region_allocate_pages(stru
 	if (!pages)
 		return -ENOMEM;
 
-	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
+	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp, user)) {
 		mr->flags |= IO_REGION_F_SINGLE_REF;
 		goto done;
 	}
@@ -217,7 +240,7 @@ int io_create_region(struct io_ring_ctx
 	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
 		ret = io_region_pin_pages(mr, reg);
 	else
-		ret = io_region_allocate_pages(mr, reg, mmap_offset);
+		ret = io_region_allocate_pages(mr, reg, mmap_offset, ctx->user);
 	if (ret)
 		goto out_free;
 


