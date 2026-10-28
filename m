Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212175;
	b=iWQW14lfe5RgwCqYUk9UKvlAhKjKdzhRNtnkowtaqdyHG1eg6V0TVFY0UPa/qxdwU03r
	 cMtynqY1/4suyhgPapVsnB0SPnsrsSTNRYZ3ZKEDxLSKnRi++0ypC+Y7biD/NWI18tPbI
	 KQhbTIxMFJlYRE5UuQIxrdxx2sHCA4+h39+svZlCUm34vxfbtwVIjId8iH/XlDQDNAdeu
	 xY0jIAS2I3vostDcvz+y9PjLn57qsiIvReUbPGs7Nw4IVn1+GQxjuToONmR9+az0iHt8n
	 kO6KMcbCfTRIVYgldNbyUeyE1Ne/Bmsud+zXxNB8ZA01Uhd70Jjwru1+A6LCvlLlJmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQi8H+8N0P2/9T7c+hV1eVal8gQQrzfBJ6oFoBeTTrA=;
	b=WPYok67/+Arl/L3NkwZTueVCaTFYYwkPVXHwkhRPu+yOOqHesRMMhlF6jwhAlW5QBUPu
	 IrRa3TEpURzWcjIoINvhHIXoVS/USnTA7Ph4sBDR32ECPY68Ycev5k216Ym9W1Yt69Qwx
	 jFiMcVRObWl2uYHyScempF8p8OgzXGi4zqSABC5M1yHbrnhFjyR7awXBTABDJvwA6mG7T
	 Up9ThbCGmOD4TmQMbTgIxJHsKkMylYI1XSYgFtxDxh5S4ajc0FujaRc89Ky6F7YxdcOC0
	 7cBaM2bQPdujeYpjZPBhQ3lkEb2r3bj1eUVnh122p3wNg6A6/qCzTkVgnavkVQXypsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nX78rKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D263606A31C;
	Wed, 28 Oct 2026 18:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nX78rKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD701F01825;
	Wed, 28 Oct 2026 18:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212175;
	bh=ZQi8H+8N0P2/9T7c+hV1eVal8gQQrzfBJ6oFoBeTTrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nX78rKjGUJ1alW2mmu/XN45CCB9S3laCmfZo3P32VKi5DCxyPzKAJgcFj+XzYZMO
	 Q9E9QEc1KAj0GrrZntwUmMSTAIrAaC1cMrW+6y+B4EJyBqUl/YuSqqIqv4XRNdu6FB
	 J+2vpOYYMaX9G5oVafC0SOABx+F9vhQV4wbTKkIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0020/1887] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed, 28 Oct 2026 17:35:16 +0100
Message-ID: <20261028170459.681157018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 85f85d573ffa7772e1ad4504d0cec5113a5c5cf1 upstream.

io_flush_timeouts() measures the events since the last flush as the
distance of the current sequence from ->cq_last_tm_flush. A fired
timeout bumps ->cq_timeouts before its CQE is posted, so until it is
the sequence can be behind the last flush, and the distance wraps:

  last flush: seq 100, cq_last_tm_flush = 100
  Y: IORING_OP_TIMEOUT, off 50, target_seq 150
  pure timeout A fires, cq_timeouts = 1
  task_work posts A's CQE, cached_cq_tail = 101
  pure timeout B fires before the flush, cq_timeouts = 2
  io_flush_timeouts(): seq = 99, events_got = 0xffffffff

Y, and every sequence timeout behind it, is ended with -ETIME although
no event happened. Two timeouts expiring close together is all it takes,
a completion with IOSQE_CQE_SKIP_SUCCESS after a single one does it too.

Nothing but those in flight CQEs separates the two, so count from the
last flush when the sequence is behind it, as io_timeout() does.

Fixes: f010505b78a4 ("io_uring: flush timeouts that should already have expired")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -78,6 +78,14 @@ __cold void io_flush_timeouts(struct io_
 	spin_lock_irq(&ctx->timeout_lock);
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
+	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. No event has
+	 * happened then, see io_timeout().
+	 */
+	if ((s32)(seq - ctx->cq_last_tm_flush) < 0)
+		seq = ctx->cq_last_tm_flush;
+
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;


