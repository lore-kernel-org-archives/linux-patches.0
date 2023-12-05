Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B4A6AA0;
	Tue,  5 Dec 2023 03:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwOFlPbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ECBC433C7;
	Tue,  5 Dec 2023 03:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746568;
	bh=ri4YeSWR7w/MLtUayKh5SPeIA56egAnBT10No+XStbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwOFlPbAdR4PlROxGhhzo9ZktZd2EEvjSing0clGqkso4R4PCybHJ271tGdmMbk6l
	 ulSpJkkLx39MrrHM4TFTM7b/ecF/KgCC8nhQ/0PNaCK6t61ItfJC47IQkEZAC9vAZR
	 1baQ5kD/pUHiEykCpiUVcB/dU/06vcs1LjnQKuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 073/134] io_uring/kbuf: recycle freed mapped buffer ring entries
Date: Tue,  5 Dec 2023 12:15:45 +0900
Message-ID: <20231205031540.128968428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit b10b73c102a2eab91e1cd62a03d6446f1dfecc64 upstream.

Right now we stash any potentially mmap'ed provided ring buffer range
for freeing at release time, regardless of when they get unregistered.
Since we're keeping track of these ranges anyway, keep track of their
registration state as well, and use that to recycle ranges when
appropriate rather than always allocate new ones.

The lookup is a basic scan of entries, checking for the best matching
free entry.

Fixes: c392cbecd8ec ("io_uring/kbuf: defer release of mapped buffer rings")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 66 insertions(+), 11 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -44,6 +44,8 @@ static struct io_buffer_list *__io_buffe
 struct io_buf_free {
 	struct hlist_node		list;
 	void				*mem;
+	size_t				size;
+	int				inuse;
 };
 
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
@@ -231,6 +233,24 @@ static __cold int io_init_bl_list(struct
 	return 0;
 }
 
+/*
+ * Mark the given mapped range as free for reuse
+ */
+static void io_kbuf_mark_free(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	struct io_buf_free *ibf;
+
+	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
+		if (bl->buf_ring == ibf->mem) {
+			ibf->inuse = 0;
+			return;
+		}
+	}
+
+	/* can't happen... */
+	WARN_ON_ONCE(1);
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
@@ -247,6 +267,7 @@ static int __io_remove_buffers(struct io
 			 * io_kbuf_list_free() will free the page(s) at
 			 * ->release() time.
 			 */
+			io_kbuf_mark_free(ctx, bl);
 			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
@@ -560,6 +581,34 @@ error_unpin:
 	return -EINVAL;
 }
 
+/*
+ * See if we have a suitable region that we can reuse, rather than allocate
+ * both a new io_buf_free and mem region again. We leave it on the list as
+ * even a reused entry will need freeing at ring release.
+ */
+static struct io_buf_free *io_lookup_buf_free_entry(struct io_ring_ctx *ctx,
+						    size_t ring_size)
+{
+	struct io_buf_free *ibf, *best = NULL;
+	size_t best_dist;
+
+	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
+		size_t dist;
+
+		if (ibf->inuse || ibf->size < ring_size)
+			continue;
+		dist = ibf->size - ring_size;
+		if (!best || dist < best_dist) {
+			best = ibf;
+			if (!dist)
+				break;
+			best_dist = dist;
+		}
+	}
+
+	return best;
+}
+
 static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 			      struct io_uring_buf_reg *reg,
 			      struct io_buffer_list *bl)
@@ -569,20 +618,26 @@ static int io_alloc_pbuf_ring(struct io_
 	void *ptr;
 
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
-	ptr = io_mem_alloc(ring_size);
-	if (!ptr)
-		return -ENOMEM;
 
-	/* Allocate and store deferred free entry */
-	ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
+	/* Reuse existing entry, if we can */
+	ibf = io_lookup_buf_free_entry(ctx, ring_size);
 	if (!ibf) {
-		io_mem_free(ptr);
-		return -ENOMEM;
+		ptr = io_mem_alloc(ring_size);
+		if (!ptr)
+			return -ENOMEM;
+
+		/* Allocate and store deferred free entry */
+		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
+		if (!ibf) {
+			io_mem_free(ptr);
+			return -ENOMEM;
+		}
+		ibf->mem = ptr;
+		ibf->size = ring_size;
+		hlist_add_head(&ibf->list, &ctx->io_buf_list);
 	}
-	ibf->mem = ptr;
-	hlist_add_head(&ibf->list, &ctx->io_buf_list);
-
-	bl->buf_ring = ptr;
+	ibf->inuse = 1;
+	bl->buf_ring = ibf->mem;
 	bl->is_mapped = 1;
 	bl->is_mmap = 1;
 	return 0;


