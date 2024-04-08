Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B907C6C8;
	Mon,  8 Apr 2024 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583681; cv=none; b=kiSy4QKTTAAVtbaE3AN2X0lOeIGKhS/+BP8mgre2KVc6zP5o/79oSfe0RLe+eli+IGbClGgo7WND69MxCSXuQ0p7vCo8EyEPdtZEnhZvukwjnoNEDSjpNAt9UJ2tnggT5tdQDesfkk0G7DG176p4wrbEJaT4Mdxx5Va9X+b7PNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583681; c=relaxed/simple;
	bh=KmoPHWARIQSdTVwCHwRB6I+2Dzs6XcZ47xMryaxnrj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6eG6o0a66E3jF2PgUxcSBmdGOM635DYPLinspjIL8VEUNzmTrJwehtoYVQPYLyYc6Jg29GXsSikYjnyV75uZwbpSHqczbxYMrjxYU64G5UuDsIuf3S0OauSrZYDTzJaMfJ2I9kl4OgoOGKrUj5jVuFstsvS+DJGJGoIZuB9JPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5XLVH3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5XLVH3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A6FC433F1;
	Mon,  8 Apr 2024 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583681;
	bh=KmoPHWARIQSdTVwCHwRB6I+2Dzs6XcZ47xMryaxnrj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5XLVH3BEyxNLdBKTxU1Xp9tYqqDRb3hLqh1f5sAJOGDbG+GFfb6tid499zJIxJIF
	 6bjT8KBU7t6Sbac8qDPHPckisVJNsYczbiwmMnQOpcAgtYxgqaE4LGZAvVIU+NC8y3
	 RC+XuiP+Ei9R91FYid1v9HojO8uqZQOwRrICcnEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 208/273] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Mon,  8 Apr 2024 14:58:03 +0200
Message-ID: <20240408125315.808075795@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,6 +61,7 @@ static int io_buffer_add_list(struct io_
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -274,6 +275,14 @@ static int __io_remove_buffers(struct io
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
@@ -283,8 +292,7 @@ void io_destroy_buffers(struct io_ring_c
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	/*
@@ -689,9 +697,8 @@ int io_unregister_pbuf_ring(struct io_ri
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


