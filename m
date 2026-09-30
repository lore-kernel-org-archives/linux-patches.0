Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0DD4E4305;
	Wed, 30 Sep 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787994; cv=none; b=YgM9V78Aw56SLWXXTbb9oumSkSSYsKxRQEvDbCHmdxigXLrF+/8BTZCcZ7pU+hF9Xg+rTGcQrb+6PSxQ6FELv+vXjqujqEX+A+2kfCZuYw3gYv8x9mtl2e5GgLQrIjPAuYXuDYvfiHlFyHytVdvjk8bXCj3s7i6TwYD+U2X+eLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787994; c=relaxed/simple;
	bh=xIkxTaLV8UJ1YhRG+AyikdIX1Ea/WWI45wHujY0+4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsF6faCE9fOHD9wV4QYYA2WMhBjKgXYeKN7WCFLaBQDlnjiM2M/nBjTXXwCNsboCYviDLrzNpf2wBMv8ApemzACSvtspcD3el11VeiSdpUckrPmHktZhkfLRZnZIOM2q8gxaG5cLSoQgDVJILSZFCiKQmP1N9opR1RWxLPM+gNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNitpnO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNitpnO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431401F000FF;
	Wed, 30 Sep 2026 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787992;
	bh=axgpWyig0r+o8yO6TJFoxN5DCy1WAz8WzF8xoA/wUW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNitpnO+TDtPv32yd7Xi+wbfY0XMoNhfLb/AqG+tRkXnLKXBg+b40x1UqxhEctt5U
	 p7vDfhk9x1xiiqpnOcfNy0uHUhklPETFbZVjUQlnnsvTuGlWnWlIxzYOAv/9RdX/gJ
	 A/ADeEyEqwt6U2YPkkbzy251xfL7BoVUNrwAr0ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 425/457] xfs: fix rtgroup repair estimations
Date: Wed, 30 Sep 2026 17:28:50 +0200
Message-ID: <20260930152355.159978650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 41c4c41cf6c44f98db2916e1781f537d9ba6461a upstream.

When I added online fsck for realtime reflink, I forgot to update
xrep_calc_rtgroup_resblks to factor in the size of the refcount btree
when it guesses how much space we need to start a repair.  This hasn't
been a huge problem in practice because there are few filesystems with
(a) realtime, (b) rtgroups, (c) reflink, and (d) no rmap.  But let's fix
this before someone stumbles upon it, especially since LOLLM flagged
this for me.

Cc: stable@vger.kernel.org # v6.14
Fixes: 83ccffc489975d ("xfs: online repair of the realtime refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/repair.c |   19 +++++++++++++++++--
 fs/xfs/scrub/trace.h  |   12 ++++++++----
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -399,6 +399,7 @@ xrep_calc_rtgroup_resblks(
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_scrub_metadata	*sm = sc->sm;
 	uint64_t			usedlen;
+	xfs_extlen_t			refcbt_sz = 0;
 	xfs_extlen_t			rmapbt_sz = 0;
 
 	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -411,13 +412,27 @@ xrep_calc_rtgroup_resblks(
 	usedlen = xfs_rtbxlen_to_blen(mp, xfs_rtgroup_extents(mp, sm->sm_agno));
 	ASSERT(usedlen <= XFS_MAX_RGBLOCKS);
 
+	if (xfs_has_reflink(mp))
+		refcbt_sz = xfs_rtrefcountbt_calc_size(mp, usedlen);
+
 	if (xfs_has_rmapbt(mp))
 		rmapbt_sz = xfs_rtrmapbt_calc_size(mp, usedlen);
 
+	/*
+	 * Guess how many blocks we need to rebuild the rmapbt.  For
+	 * non-reflink filesystems we can't have more records than used blocks.
+	 * However, with reflink it's possible to have more than one rmap
+	 * record per rtgroup block.  We don't know how many rmaps there could
+	 * be in the rtgroup, so we start off with what we hope is an generous
+	 * over-estimation.
+	 */
+	if (refcbt_sz > 0 && rmapbt_sz > 0)
+		rmapbt_sz *= 2;
+
 	trace_xrep_calc_rtgroup_resblks_btsize(mp, sm->sm_agno, usedlen,
-			rmapbt_sz);
+			rmapbt_sz, refcbt_sz);
 
-	return rmapbt_sz;
+	return max(rmapbt_sz, refcbt_sz);
 }
 #endif /* CONFIG_XFS_RT */
 
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2376,25 +2376,29 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xrep_calc_rtgroup_resblks_btsize,
 	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno,
-		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz),
-	TP_ARGS(mp, rgno, usedlen, rmapbt_sz),
+		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz,
+		 xfs_rgblock_t refcbt_sz),
+	TP_ARGS(mp, rgno, usedlen, rmapbt_sz, refcbt_sz),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_rgnumber_t, rgno)
 		__field(xfs_rgblock_t, usedlen)
 		__field(xfs_rgblock_t, rmapbt_sz)
+		__field(xfs_rgblock_t, refcbt_sz)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->rgno = rgno;
 		__entry->usedlen = usedlen;
 		__entry->rmapbt_sz = rmapbt_sz;
+		__entry->refcbt_sz = refcbt_sz;
 	),
-	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u",
+	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u refcountbt %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rgno,
 		  __entry->usedlen,
-		  __entry->rmapbt_sz)
+		  __entry->rmapbt_sz,
+		  __entry->refcbt_sz)
 );
 #endif /* CONFIG_XFS_RT */
 


