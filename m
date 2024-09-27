Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190D136352;
	Fri, 27 Sep 2024 12:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440334; cv=none; b=pO/cbQNjPhQgyIcwF0Mw3/hBK6lm6HYdS607ie647bf+TTtnJpa2ybvDKlnw2HYmVTy5eUBI3CGs+LYlJVc+NTWlWAxfaB3i6mSPXKRWa9oHdFP7a947C5ytUNX3GdlvPTz+V36uVV/7d8YrYqSyjCyVkf9qxD0CVxlF2Tmf8oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440334; c=relaxed/simple;
	bh=vTljDYVH4Z1nT5C3bJo2EWcC4bZqFfjMvWosQkFv2dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXEgbQUas6jO6fO8WxHVNapNxQTsS8P2m959NSV9WedrZWUc6JTLAL81Jn5dRvmC8URDmGlk4w3fA/EfYBnr7RTBmM14YOVO536LW+/sftzh8iLML5wj3rTA79wXFHC2J91chfW8D+AOQJOjZHqBd2hdswmG/LXduB8dXD1Wm8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ylrUh2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ylrUh2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49A7C4CEC4;
	Fri, 27 Sep 2024 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440334;
	bh=vTljDYVH4Z1nT5C3bJo2EWcC4bZqFfjMvWosQkFv2dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ylrUh2CueZWMN7NtgdDb7LW38albK28ScvCMThQ/crsYR2lEaQHw6jY+1NecQkZ+
	 hUes1x3IEzZhZlhHcNMz2pNa8gdnfQ+QdaalaK+LWtiM3gDMjv3cfsj0vs8+Vwogpv
	 xZQhw6kzMnydmW1DkhTAo+oA1twFbeLTc+30awIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 45/73] xfs: collect errors from inodegc for unlinked inode recovery
Date: Fri, 27 Sep 2024 14:23:56 +0200
Message-ID: <20240927121721.748274024@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f ]

Unlinked list recovery requires errors removing the inode the from
the unlinked list get fed back to the main recovery loop. Now that
we offload the unlinking to the inodegc work, we don't get errors
being fed back when we trip over a corruption that prevents the
inode from being removed from the unlinked list.

This means we never clear the corrupt unlinked list bucket,
resulting in runtime operations eventually tripping over it and
shutting down.

Fix this by collecting inodegc worker errors and feed them
back to the flush caller. This is largely best effort - the only
context that really cares is log recovery, and it only flushes a
single inode at a time so we don't need complex synchronised
handling. Essentially the inodegc workers will capture the first
error that occurs and the next flush will gather them and clear
them. The flush itself will only report the first gathered error.

In the cases where callers can return errors, propagate the
collected inodegc flush error up the error handling chain.

In the case of inode unlinked list recovery, there are several
superfluous calls to flush queued unlinked inodes -
xlog_recover_iunlink_bucket() guarantees that it has flushed the
inodegc and collected errors before it returns. Hence nothing in the
calling path needs to run a flush, even when an error is returned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c      |   46 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_icache.h      |    4 ++--
 fs/xfs/xfs_inode.c       |   20 ++++++--------------
 fs/xfs/xfs_inode.h       |    2 +-
 fs/xfs/xfs_log_recover.c |   19 +++++++++----------
 fs/xfs/xfs_mount.h       |    1 +
 fs/xfs/xfs_super.c       |    1 +
 fs/xfs/xfs_trans.c       |    4 +++-
 8 files changed, 60 insertions(+), 37 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -454,6 +454,27 @@ xfs_inodegc_queue_all(
 	return ret;
 }
 
+/* Wait for all queued work and collect errors */
+static int
+xfs_inodegc_wait_all(
+	struct xfs_mount	*mp)
+{
+	int			cpu;
+	int			error = 0;
+
+	flush_workqueue(mp->m_inodegc_wq);
+	for_each_online_cpu(cpu) {
+		struct xfs_inodegc	*gc;
+
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (gc->error && !error)
+			error = gc->error;
+		gc->error = 0;
+	}
+
+	return error;
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -1490,15 +1511,14 @@ xfs_blockgc_free_space(
 	if (error)
 		return error;
 
-	xfs_inodegc_flush(mp);
-	return 0;
+	return xfs_inodegc_flush(mp);
 }
 
 /*
  * Reclaim all the free space that we can by scheduling the background blockgc
  * and inodegc workers immediately and waiting for them all to clear.
  */
-void
+int
 xfs_blockgc_flush_all(
 	struct xfs_mount	*mp)
 {
@@ -1519,7 +1539,7 @@ xfs_blockgc_flush_all(
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		flush_delayed_work(&pag->pag_blockgc_work);
 
-	xfs_inodegc_flush(mp);
+	return xfs_inodegc_flush(mp);
 }
 
 /*
@@ -1841,13 +1861,17 @@ xfs_inodegc_set_reclaimable(
  * This is the last chance to make changes to an otherwise unreferenced file
  * before incore reclamation happens.
  */
-static void
+static int
 xfs_inodegc_inactivate(
 	struct xfs_inode	*ip)
 {
+	int			error;
+
 	trace_xfs_inode_inactivating(ip);
-	xfs_inactive(ip);
+	error = xfs_inactive(ip);
 	xfs_inodegc_set_reclaimable(ip);
+	return error;
+
 }
 
 void
@@ -1879,8 +1903,12 @@ xfs_inodegc_worker(
 
 	WRITE_ONCE(gc->shrinker_hits, 0);
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
+		int	error;
+
 		xfs_iflags_set(ip, XFS_INACTIVATING);
-		xfs_inodegc_inactivate(ip);
+		error = xfs_inodegc_inactivate(ip);
+		if (error && !gc->error)
+			gc->error = error;
 	}
 
 	memalloc_nofs_restore(nofs_flag);
@@ -1904,13 +1932,13 @@ xfs_inodegc_push(
  * Force all currently queued inode inactivation work to run immediately and
  * wait for the work to finish.
  */
-void
+int
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
 	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-	flush_workqueue(mp->m_inodegc_wq);
+	return xfs_inodegc_wait_all(mp);
 }
 
 /*
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -59,7 +59,7 @@ int xfs_blockgc_free_dquots(struct xfs_m
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
-void xfs_blockgc_flush_all(struct xfs_mount *mp);
+int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
@@ -77,7 +77,7 @@ void xfs_blockgc_start(struct xfs_mount
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_push(struct xfs_mount *mp);
-void xfs_inodegc_flush(struct xfs_mount *mp);
+int xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1620,16 +1620,7 @@ xfs_inactive_ifree(
 	 */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
 
-	/*
-	 * Just ignore errors at this point.  There is nothing we can do except
-	 * to try to keep going. Make sure it's not a silent error.
-	 */
-	error = xfs_trans_commit(tp);
-	if (error)
-		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
-			__func__, error);
-
-	return 0;
+	return xfs_trans_commit(tp);
 }
 
 /*
@@ -1696,12 +1687,12 @@ xfs_inode_needs_inactive(
  * now be truncated.  Also, we clear all of the read-ahead state
  * kept for the inode here since the file is now closed.
  */
-void
+int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
 	struct xfs_mount	*mp;
-	int			error;
+	int			error = 0;
 	int			truncate = 0;
 
 	/*
@@ -1742,7 +1733,7 @@ xfs_inactive(
 		 * reference to the inode at this point anyways.
 		 */
 		if (xfs_can_free_eofblocks(ip, true))
-			xfs_free_eofblocks(ip);
+			error = xfs_free_eofblocks(ip);
 
 		goto out;
 	}
@@ -1779,7 +1770,7 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	xfs_inactive_ifree(ip);
+	error = xfs_inactive_ifree(ip);
 
 out:
 	/*
@@ -1787,6 +1778,7 @@ out:
 	 * the attached dquots.
 	 */
 	xfs_qm_dqdetach(ip);
+	return error;
 }
 
 /*
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -470,7 +470,7 @@ enum layout_break_reason {
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
 int		xfs_release(struct xfs_inode *ip);
-void		xfs_inactive(struct xfs_inode *ip);
+int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct user_namespace *mnt_userns,
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2711,7 +2711,9 @@ xlog_recover_iunlink_bucket(
 			 * just to flush the inodegc queue and wait for it to
 			 * complete.
 			 */
-			xfs_inodegc_flush(mp);
+			error = xfs_inodegc_flush(mp);
+			if (error)
+				break;
 		}
 
 		prev_agino = agino;
@@ -2719,10 +2721,15 @@ xlog_recover_iunlink_bucket(
 	}
 
 	if (prev_ip) {
+		int	error2;
+
 		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
+
+		error2 = xfs_inodegc_flush(mp);
+		if (error2 && !error)
+			return error2;
 	}
-	xfs_inodegc_flush(mp);
 	return error;
 }
 
@@ -2789,7 +2796,6 @@ xlog_recover_iunlink_ag(
 			 * bucket and remaining inodes on it unreferenced and
 			 * unfreeable.
 			 */
-			xfs_inodegc_flush(pag->pag_mount);
 			xlog_recover_clear_agi_bucket(pag, bucket);
 		}
 	}
@@ -2806,13 +2812,6 @@ xlog_recover_process_iunlinks(
 
 	for_each_perag(log->l_mp, agno, pag)
 		xlog_recover_iunlink_ag(pag);
-
-	/*
-	 * Flush the pending unlinked inodes to ensure that the inactivations
-	 * are fully completed on disk and the incore inodes can be reclaimed
-	 * before we signal that recovery is complete.
-	 */
-	xfs_inodegc_flush(log->l_mp);
 }
 
 STATIC void
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -62,6 +62,7 @@ struct xfs_error_cfg {
 struct xfs_inodegc {
 	struct llist_head	list;
 	struct delayed_work	work;
+	int			error;
 
 	/* approximate count of inodes in the list */
 	unsigned int		items;
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1089,6 +1089,7 @@ xfs_inodegc_init_percpu(
 #endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
+		gc->error = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
 	}
 	return 0;
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -290,7 +290,9 @@ retry:
 		 * Do not perform a synchronous scan because callers can hold
 		 * other locks.
 		 */
-		xfs_blockgc_flush_all(mp);
+		error = xfs_blockgc_flush_all(mp);
+		if (error)
+			return error;
 		want_retry = false;
 		goto retry;
 	}


