Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766DE1EE7C6;
	Mon, 23 Jun 2025 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714767; cv=none; b=EjgNjqTfPBvl7C/eTAu9wE9qRPC0MbgiD9wUtYb7Bl9aGXXua0kryLcdQJTjGaIZ6wLC22uOEp0ZYf+OrwnJLG8XxIaClPp69DErtmUiuug3/4siydCIFcOqgNJ3bKRYpTPkDp8204Ewr6N20cbTlQYqkwmTNg70ENAZhNASW6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714767; c=relaxed/simple;
	bh=WoGNGZACru0JOr0/ejmsVs4H/nsWXHhQK2Hc2P37k7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiai94CJSLIpn43o2d/dtgJua3QV7crqSBDWI6sUxbIhi6ZQuYgOVQ8JlP3nvcQP2c+GVmVY6uMwNi6O+RpF4/c7CRrzpQhcmufk7j9Ppq6DR5+hOOkMinMzHeWIoYwdWyRCq5nbnVaoJ1UVxS1Nz4DJT7tCOP23lg1TtAzQ9m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAVk7Nx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAVk7Nx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E288C4CEED;
	Mon, 23 Jun 2025 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714767;
	bh=WoGNGZACru0JOr0/ejmsVs4H/nsWXHhQK2Hc2P37k7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAVk7Nx8qDzrBQ3jA78RtO1bbUiT8cqzG5bikj/E0+oW3zJ742Pn77qavQz4wOuPf
	 qwUcQewmteh6kZtQ1b4ebd3BqYlLRK0VLflqORxKTi23JHRrYXNHBKE3iyTc1DkyL/
	 z/dsYl3YsUr7Yn8oY7tL0N8OnxqlA4G6TnYjOKO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/508] xfs: clean up the rtbitmap fsmap backend
Date: Mon, 23 Jun 2025 15:03:59 +0200
Message-ID: <20250623130650.044561515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit f045dd00328d78f25d64913285f4547f772d13e2 ]

The rtbitmap fsmap backend doesn't query the rmapbt, so it's wasteful to
spend time initializing the rmap_irec objects.  Worse yet, the logic to
query the rtbitmap is spread across three separate functions, which is
unnecessarily difficult to follow.

Compute the start rtextent that we want from keys[0] directly and
combine the functions to avoid passing parameters around everywhere, and
consolidate all the logic into a single function.  At one point many
years ago I intended to use __xfs_getfsmap_rtdev as the launching point
for realtime rmapbt queries, but this hasn't been the case for a long
time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 62 +++++++---------------------------------------
 fs/xfs/xfs_trace.h | 25 +++++++++++++++++++
 2 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7b72992c14d94..202f162515bd5 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -512,22 +512,21 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
 }
 
-/* Execute a getfsmap query against the realtime device. */
+/* Execute a getfsmap query against the realtime device rtbitmap. */
 STATIC int
-__xfs_getfsmap_rtdev(
+xfs_getfsmap_rtdev_rtbitmap(
 	struct xfs_trans		*tp,
 	const struct xfs_fsmap		*keys,
-	int				(*query_fn)(struct xfs_trans *,
-						    struct xfs_getfsmap_info *,
-						    xfs_rtblock_t start_rtb,
-						    xfs_rtblock_t end_rtb),
 	struct xfs_getfsmap_info	*info)
 {
+
+	struct xfs_rtalloc_rec		alow = { 0 };
+	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
 	uint64_t			eofs;
-	int				error = 0;
+	int				error;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rextents * mp->m_sb.sb_rextsize);
 	if (keys[0].fmr_physical >= eofs)
@@ -536,14 +535,7 @@ __xfs_getfsmap_rtdev(
 				keys[0].fmr_physical + keys[0].fmr_length);
 	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
-	/* Set up search keys */
-	info->low.rm_startblock = start_rtb;
-	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
-	if (error)
-		return error;
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (keys[0].fmr_length > 0) {
@@ -552,32 +544,8 @@ __xfs_getfsmap_rtdev(
 			return 0;
 	}
 
-	info->high.rm_startblock = end_rtb;
-	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
-	if (error)
-		return error;
-	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
-	info->high.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
-
-	return query_fn(tp, info, start_rtb, end_rtb);
-}
-
-/* Actually query the realtime bitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap_query(
-	struct xfs_trans		*tp,
-	struct xfs_getfsmap_info	*info,
-	xfs_rtblock_t			start_rtb,
-	xfs_rtblock_t			end_rtb)
-{
-	struct xfs_rtalloc_rec		alow = { 0 };
-	struct xfs_rtalloc_rec		ahigh = { 0 };
-	struct xfs_mount		*mp = tp->t_mountp;
-	int				error;
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
 
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
 
@@ -609,18 +577,6 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
 	return error;
 }
-
-/* Execute a getfsmap query against the realtime device rtbitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
-	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
-			info);
-}
 #endif /* CONFIG_XFS_RT */
 
 /* Execute a getfsmap query against the regular data device. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 20e2ec8b73aa8..a9e3081b6625d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3491,6 +3491,31 @@ DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
 DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
 DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
 
+DECLARE_EVENT_CLASS(xfs_fsmap_linear_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno),
+	TP_ARGS(mp, keydev, bno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_fsblock_t, bno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->bno = bno;
+	),
+	TP_printk("dev %d:%d keydev %d:%d bno 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->bno)
+)
+#define DEFINE_FSMAP_LINEAR_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_linear_class, name, \
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno), \
+	TP_ARGS(mp, keydev, bno))
+DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_low_key_linear);
+DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_high_key_linear);
+
 DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap),
 	TP_ARGS(mp, fsmap),
-- 
2.39.5



