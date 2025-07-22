Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C02ED15A;
	Tue, 22 Jul 2025 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193389; cv=none; b=Q5k3RfPOor63SB2VZUbg/7cVl66QwXit8l++Qt7J1tsf1qKPtzBGAPNiOfH+6s4jNp3lxUWaE4wo8liq72W/un6PUjdKjNVak0wLqKpVhhAxfX9CRX2mBOpuHf9QG2dm6rpotv4Ci7VQ1tQme6+9rFmtGKLZR0nekgSYl1wcSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193389; c=relaxed/simple;
	bh=xftYUfwnuGMiFnbZ0p+WSvBWX8RdwhqbMyIu258e6b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv9UICd2ncWZxm2Kkmh2Zw29JL25qS/0e2conuUqvCk4xjDA87a/TXbgHtvf/gkyXgwaaZtqgzC3jFaV7h1oTPWV2JaDC+O9vriXC9wQyPKeDTJMWSof43aBCHoiUMza6k06eBp56xSRgm1ZhKAt47UnCgqu7AfFg2eHdQC16ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3qw81id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3qw81id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C96C4CEEB;
	Tue, 22 Jul 2025 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193389;
	bh=xftYUfwnuGMiFnbZ0p+WSvBWX8RdwhqbMyIu258e6b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3qw81idzshxx/NjObPyDvGndd81RaHd9h3+0FKVl+0F2ikxjOHnicL9neP0YmuUy
	 Twk/ORmEs/B8yw50nSnhK72XgDbstmGFufrndW8US+vf+EEriyC2zv8z9P9tMLsF5M
	 1iJQAa+Dpz2AP5iTM34I5KG/dl8Ab9Arg21AW9rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.15 078/187] xfs: dont allocate the xfs_extent_busy structure for zoned RTGs
Date: Tue, 22 Jul 2025 15:44:08 +0200
Message-ID: <20250722134348.632558742@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 5948705adbf1a7afcecfe9a13ff39221ef61e16b upstream.

Busy extent tracking is primarily used to ensure that freed blocks are
not reused for data allocations before the transaction that deleted them
has been committed to stable storage, and secondarily to drive online
discard.  None of the use cases applies to zoned RTGs, as the zoned
allocator can't overwrite blocks before resetting the zone, which already
flushes out all transactions touching the RTGs.

So the busy extent tracking is not needed for zoned RTGs, and also not
called for zoned RTGs.  But somehow the code to skip allocating and
freeing the structure got lost during the zoned XFS upstreaming process.
This not only causes these structures to unnecessarily allocated, but can
also lead to memory leaks as the xg_busy_extents pointer in the
xfs_group structure is overlayed with the pointer for the linked list
of to be reset zones.

Stop allocating and freeing the structure to not pointlessly allocate
memory which is then leaked when the zone is reset.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # v6.15
[cem: Fix type and add stable tag]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_group.c | 14 +++++++++-----
 fs/xfs/xfs_extent_busy.h  |  8 ++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index e9d76bcdc820..20ad7c309489 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -163,7 +163,8 @@ xfs_group_free(
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 
 	if (uninit)
@@ -189,9 +190,11 @@ xfs_group_insert(
 	xg->xg_type = type;
 
 #ifdef __KERNEL__
-	xg->xg_busy_extents = xfs_extent_busy_alloc();
-	if (!xg->xg_busy_extents)
-		return -ENOMEM;
+	if (xfs_group_has_extent_busy(mp, type)) {
+		xg->xg_busy_extents = xfs_extent_busy_alloc();
+		if (!xg->xg_busy_extents)
+			return -ENOMEM;
+	}
 	spin_lock_init(&xg->xg_state_lock);
 	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
@@ -210,7 +213,8 @@ xfs_group_insert(
 out_drain:
 	xfs_defer_drain_free(&xg->xg_intents_drain);
 #ifdef __KERNEL__
-	kfree(xg->xg_busy_extents);
+	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
+		kfree(xg->xg_busy_extents);
 #endif
 	return error;
 }
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index f069b04e8ea1..3e6e019b6146 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -68,4 +68,12 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+/*
+ * Zoned RTGs don't need to track busy extents, as the actual block freeing only
+ * happens by a zone reset, which forces out all transactions that touched the
+ * to be reset zone first.
+ */
+#define xfs_group_has_extent_busy(mp, type) \
+	((type) == XG_TYPE_AG || !xfs_has_zoned((mp)))
+
 #endif /* __XFS_EXTENT_BUSY_H__ */
-- 
2.50.1



