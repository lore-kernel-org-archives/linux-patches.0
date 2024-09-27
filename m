Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131E3C3C;
	Fri, 27 Sep 2024 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440361; cv=none; b=FX7YxotoYwoMmE/P9Xp3z1PlrCRj3txCEyUL1oWyaEuhKNtzbAV+1Ek4V3nkwnlUz+H1vCrjDEmD8w8wpTjQDLBxAg1VSyq82UPHI4jNjmLYMNO34q9LQzxyaloNQJUWXu/BeRKKwM6EKhZPpRDKv788CXA2YRhjbn7DsGIzcnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440361; c=relaxed/simple;
	bh=q2zdMqNq3u7DwMVt4nABxuVfPDDOiqWpj3CSFZ+a1q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooG9UiwDW6dMWVUwMudjqvSuqck9UNwSLNzkJH0232C12mfjFcOrRIcSzAJ8qX2H7Yw6zCImyZgdau7M0ZqFHXsg4OGLvebKwec5b/Y0lKzc6e+PZHL91pz9oow3J8w/pfEnb4E0ErebkHqky9tmeZXyGnHmkmf1BvQRLAHARiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4mFFeqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4mFFeqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D9CC4CEC6;
	Fri, 27 Sep 2024 12:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440361;
	bh=q2zdMqNq3u7DwMVt4nABxuVfPDDOiqWpj3CSFZ+a1q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4mFFeqr4ju8q07Ra0uXK8bxOyM3YW18GK3z98a9XqS0yvtjMYShlmuE2IAJk6/iE
	 qHP2/JA95a/FFTbo/17aN+S09vuOC00iHWSwT2+Nfffg/wt7xk8mSyKkBqYWes57dB
	 x+4N7TSfgoz8sd1F11NHj/yVI5s96Stvn50UPESM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 54/73] xfs: reload entire unlinked bucket lists
Date: Fri, 27 Sep 2024 14:24:05 +0200
Message-ID: <20240927121722.109533843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 83771c50e42b92de6740a63e152c96c052d37736 ]

The previous patch to reload unrecovered unlinked inodes when adding a
newly created inode to the unlinked list is missing a key piece of
functionality.  It doesn't handle the case that someone calls xfs_iget
on an inode that is not the last item in the incore list.  For example,
if at mount time the ondisk iunlink bucket looks like this:

AGI -> 7 -> 22 -> 3 -> NULL

None of these three inodes are cached in memory.  Now let's say that
someone tries to open inode 3 by handle.  We need to walk the list to
make sure that inodes 7 and 22 get loaded cold, and that the
i_prev_unlinked of inode 3 gets set to 22.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_export.c |    6 +++
 fs/xfs/xfs_inode.c  |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |    9 ++++
 fs/xfs/xfs_itable.c |    9 ++++
 fs/xfs/xfs_trace.h  |   20 ++++++++++
 5 files changed, 144 insertions(+)

--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,6 +146,12 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error) {
+		xfs_irele(ip);
+		return ERR_PTR(error);
+	}
+
 	if (VFS_I(ip)->i_generation != generation) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3622,3 +3622,103 @@ xfs_iunlock2_io_mmap(
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
 }
+
+/*
+ * Reload the incore inode list for this inode.  Caller should ensure that
+ * the link count cannot change, either by taking ILOCK_SHARED or otherwise
+ * preventing other threads from executing.
+ */
+int
+xfs_inode_reload_unlinked_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	struct xfs_agi		*agi;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		prev_agino, next_agino;
+	unsigned int		bucket;
+	bool			foundit = false;
+	int			error;
+
+	/* Grab the first inode in the list */
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_ialloc_read_agi(pag, tp, &agibp);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+	agi = agibp->b_addr;
+
+	trace_xfs_inode_reload_unlinked_bucket(ip);
+
+	xfs_info_ratelimited(mp,
+ "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating list recovery.",
+			agino, agno);
+
+	prev_agino = NULLAGINO;
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	while (next_agino != NULLAGINO) {
+		struct xfs_inode	*next_ip = NULL;
+
+		if (next_agino == agino) {
+			/* Found this inode, set its backlink. */
+			next_ip = ip;
+			next_ip->i_prev_unlinked = prev_agino;
+			foundit = true;
+		}
+		if (!next_ip) {
+			/* Inode already in memory. */
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* Inode not in memory, reload. */
+			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+					next_agino);
+			if (error)
+				break;
+
+			next_ip = xfs_iunlink_lookup(pag, next_agino);
+		}
+		if (!next_ip) {
+			/* No incore inode at all?  We reloaded it... */
+			ASSERT(next_ip != NULL);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		prev_agino = next_agino;
+		next_agino = next_ip->i_next_unlinked;
+	}
+
+	xfs_trans_brelse(tp, agibp);
+	/* Should have found this inode somewhere in the iunlinked bucket. */
+	if (!error && !foundit)
+		error = -EFSCORRUPTED;
+	return error;
+}
+
+/* Decide if this inode is missing its unlinked list and reload it. */
+int
+xfs_inode_reload_unlinked(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_inode_unlinked_incomplete(ip))
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_trans_cancel(tp);
+
+	return error;
+}
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -593,4 +593,13 @@ void xfs_end_io(struct work_struct *work
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
+static inline bool
+xfs_inode_unlinked_incomplete(
+	struct xfs_inode	*ip)
+{
+	return VFS_I(ip)->i_nlink == 0 && !xfs_inode_on_unlinked_list(ip);
+}
+int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_inode_reload_unlinked(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,6 +80,15 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked_bucket(tp, ip);
+		if (error) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			return error;
+		}
+	}
+
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3704,6 +3704,26 @@ TRACE_EVENT(xfs_iunlink_reload_next,
 		  __entry->next_agino)
 );
 
+TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),


