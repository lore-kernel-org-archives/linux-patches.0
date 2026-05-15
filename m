Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2683E0089;
	Fri, 15 May 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862196; cv=none; b=fQ4OC661DQD72Gy1yum6xXOMp8kIYJrnGuKjoJF4taPe6w3IOboOOelHjFNJ3CojcXioQijRRrwuRwF4/qmoxXzEqBtr6HfzEcvtaLu2/ZYgO5jY0nVRTzB+ZyO8Zlc9Jx5dH6dpBFeTHf8lm4yA5OyEWV4Ykkjy2Vb1yRDCjVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862196; c=relaxed/simple;
	bh=M/06DO8ufQgpjDZCgQ50u5f2txH0c9j9bqZ9Yl+gb1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h41s1AbN1Xe5IOay7KQC0+tCuxeY3kRtmaBBwIrKGwrUCSBDymhQ7LK83EFOg4CnVRk8KnThmGvHtI16xzlHl2jfsyhwJiMlc8yd8XhLBMg0RREEReKl7PfYXeTGUS2ZSAyPhVEHeA3An+ISCVNYV/1/Y8FQNsRkRGRQGMqEdZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZTr17qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZTr17qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DACBC2BCB0;
	Fri, 15 May 2026 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862196;
	bh=M/06DO8ufQgpjDZCgQ50u5f2txH0c9j9bqZ9Yl+gb1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZTr17qP4RXQCy2hlZXfAI41otDzapc82Vp6gToAyvr0FqWEgLyXci6Ha2EFnR3DF
	 nRfwLlVSA7sgq67lVCXf+DNI9kbCOouBbOlgJOabsckxo2x12VBpWD9jfXNZZFlkQO
	 upZL00hi0kBiq9DQEIw8CW5I07ZY0+83/aABx4cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.18 144/188] io_uring/zcrx: use guards for locking
Date: Fri, 15 May 2026 17:49:21 +0200
Message-ID: <20260515154700.448436941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 898ad80d1207cbdb22b21bafb6de4adfd7627bd0 upstream.

Convert last several places using manual locking to guards to simplify
the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/eb4667cfaf88c559700f6399da9e434889f5b04a.1774261953.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -696,9 +696,8 @@ static void io_zcrx_return_niov_freelist
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
 	area->freelist[area->free_count++] = net_iov_idx(niov);
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static void io_zcrx_return_niov(struct net_iov *niov)
@@ -829,7 +828,8 @@ static void io_zcrx_refill_slow(struct p
 {
 	struct io_zcrx_area *area = ifq->area;
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
+
 	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
 		struct net_iov *niov = __io_zcrx_get_free_niov(area);
 		netmem_ref netmem = net_iov_to_netmem(niov);
@@ -838,7 +838,6 @@ static void io_zcrx_refill_slow(struct p
 		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
@@ -975,10 +974,10 @@ static struct net_iov *io_alloc_fallback
 	if (area->mem.is_dmabuf)
 		return NULL;
 
-	spin_lock_bh(&area->freelist_lock);
-	if (area->free_count)
-		niov = __io_zcrx_get_free_niov(area);
-	spin_unlock_bh(&area->freelist_lock);
+	scoped_guard(spinlock_bh, &area->freelist_lock) {
+		if (area->free_count)
+			niov = __io_zcrx_get_free_niov(area);
+	}
 
 	if (niov)
 		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);


