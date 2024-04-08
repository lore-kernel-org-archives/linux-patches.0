Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34AD6A352;
	Mon,  8 Apr 2024 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583657; cv=none; b=lRtuJw+3BycIGDEhXNUbDdydPBE0AxhNA18WLAnOEwbpRvsYqFOs8glDtLT5hdi3Aty3NYZ4rhyWuTWGFtRlqng1pa2JQZyzWYm66hsRGLQHtGvCGA4/78BWpiMy2Z3mTCQ7e3gpYFkrafaua0tKQhEbHI6DCiWFvpmUTtr9B1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583657; c=relaxed/simple;
	bh=WX5+aRYmF4S00B7AzIyoxRq1x7uTfLe581XSCTqmtDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/1R3tttTW/AKyftxRMJwNfdlO/jdjH2nEl8O1aQIlCvt8UY+nx1cO3x2K48HgJ29AQXPey6FN+ExXeQl74iehrK2e44Mfxpp5erN1EjfT1cQ049lwQ4ZO2/qR8ZZ8ADpLOr1kW0yMBWwfm8DGzZlZfG5N9nxv2e/ENbqp14OLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUoztUzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUoztUzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B108C433F1;
	Mon,  8 Apr 2024 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583657;
	bh=WX5+aRYmF4S00B7AzIyoxRq1x7uTfLe581XSCTqmtDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUoztUzO/4hOOj96jaFeZd4JFuVv3G+LQ/ixNpbWdWQpWRelipYW53Bvyf3fuxzTK
	 mqSHsikklrCgrFr5MBzlsJP14jnZZang3zSvNXezEuH9LxNmlFwUCBZLJlwYQZt+HM
	 wDIN87+YWdXYSCotI5K2s2GLQDaZ76KTL7pPVpTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 211/252] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Mon,  8 Apr 2024 14:58:30 +0200
Message-ID: <20240408125313.201817428@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit 6b69c4ab4f685327d9e10caf0d84217ba23a8c4b upstream.

No functional changes in this patch, just in preparation for being able
to keep the buffer list alive outside of the ctx->uring_lock.

Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   15 +++++++++++----
 io_uring/kbuf.h |    2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -59,6 +59,7 @@ static int io_buffer_add_list(struct io_
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -272,6 +273,14 @@ static int __io_remove_buffers(struct io
 	return i;
 }
 
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (atomic_dec_and_test(&bl->refs)) {
+		__io_remove_buffers(ctx, bl, -1U);
+		kfree_rcu(bl, rcu);
+	}
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -279,8 +288,7 @@ void io_destroy_buffers(struct io_ring_c
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	while (!list_empty(&ctx->io_buffers_pages)) {
@@ -676,9 +684,8 @@ int io_unregister_pbuf_ring(struct io_ri
 	if (!bl->is_mapped)
 		return -EINVAL;
 
-	__io_remove_buffers(ctx, bl, -1U);
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
-	kfree_rcu(bl, rcu);
+	io_put_bl(ctx, bl);
 	return 0;
 }
 
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,6 +25,8 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
+	atomic_t refs;
+
 	/* ring mapped provided buffers */
 	__u8 is_mapped;
 	/* ring mapped provided buffers, but mmap'ed by application */


