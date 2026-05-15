Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1805830566D;
	Fri, 15 May 2026 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862787; cv=none; b=dUsX2vAVsFamHpg5sS0aKPhenQ6IF1qJOOyxvwT603leWc3t14We1BrBFqmI1TgO6PVCKaJN6r2lo8GNYvewAOMaHBIqbKSVbjImPojwR5DXSCMf8/YUy2sfbsqMdmDZXF5zKoR/7pqe6mFGR3ZlcTfE7Y3t7fpb6cdBIBQGBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862787; c=relaxed/simple;
	bh=fcdqAataBzmCJV0B9NPFNYfjVvxCI/9zcOJnU7BNRI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZMXB6evCDbYvODJTO8Sen64fO5g/h6LMwRQE6EYY1KAY/PwosmH4u1jzelIzBkooGd1VRpsVsn9AmDjKo6SS7Uu2ugxIkasbjHsb7/6gGf8d5+k9/ij9LFlotnaPOfe4MaAGMUa/NYrQwoV2RGIAZtfSdcS04SSqFbFahrwJ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHPIBh6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHPIBh6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BC5C2BCB0;
	Fri, 15 May 2026 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862786;
	bh=fcdqAataBzmCJV0B9NPFNYfjVvxCI/9zcOJnU7BNRI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHPIBh6Nv9KI+FqcSETNEFcBd84qhndhmPPQrWxBywFd7e4SGzN3HtXkapxAX9cPA
	 ASczvE2up1qJnfpxviLkzEbsiIdG0frUn2mzoLsYkmwqT21u1U5mWOlQR07v9PIyRS
	 KnOEzEsXiM0N8G8hRkdC67R2C766JsMohRievi+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 7.0 183/201] io_uring/zcrx: use guards for locking
Date: Fri, 15 May 2026 17:50:01 +0200
Message-ID: <20260515154702.541815391@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -586,9 +586,8 @@ static void io_zcrx_return_niov_freelist
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
 	area->freelist[area->free_count++] = net_iov_idx(niov);
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static void io_zcrx_return_niov(struct net_iov *niov)
@@ -1029,7 +1028,8 @@ static void io_zcrx_refill_slow(struct p
 {
 	struct io_zcrx_area *area = ifq->area;
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
+
 	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
 		struct net_iov *niov = __io_zcrx_get_free_niov(area);
 		netmem_ref netmem = net_iov_to_netmem(niov);
@@ -1038,7 +1038,6 @@ static void io_zcrx_refill_slow(struct p
 		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
@@ -1264,10 +1263,10 @@ static struct net_iov *io_alloc_fallback
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


