Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AD01D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9719BC433C7;
	Wed,  4 Oct 2023 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442685;
	bh=MKU+TqpuQIc4fITuixcZr/IhU0gpwWLp14szS9sphOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11lJC5vT+GJa5fzmdjk2DDybP/Lr6yShup9t4vX7/g6vCEnRkDhHFMxeJsM4P/IDp
	 y41qW8m7DslViRSZQxbLWnZyeOd25iYXltcvdccsBK9MsttxfGqP/69grtlTTN8rrX
	 42HKQBEC4y8/YtbeU5L+YjvTY3yPLSBepLktUJLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Dunlop <chris@onthe.net.au>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/183] xfs: introduce xfs_inodegc_push()
Date: Wed,  4 Oct 2023 19:55:04 +0200
Message-ID: <20231004175206.922817429@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5e672cd69f0a534a445df4372141fd0d1d00901d ]

The current blocking mechanism for pushing the inodegc queue out to
disk can result in systems becoming unusable when there is a long
running inodegc operation. This is because the statfs()
implementation currently issues a blocking flush of the inodegc
queue and a significant number of common system utilities will call
statfs() to discover something about the underlying filesystem.

This can result in userspace operations getting stuck on inodegc
progress, and when trying to remove a heavily reflinked file on slow
storage with a full journal, this can result in delays measuring in
hours.

Avoid this problem by adding "push" function that expedites the
flushing of the inodegc queue, but doesn't wait for it to complete.

Convert xfs_fs_statfs() and xfs_qm_scall_getquota() to use this
mechanism so they don't block but still ensure that queued
operations are expedited.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
[djwong: fix _getquota_next to use _inodegc_push too]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_icache.c      | 20 +++++++++++++++-----
 fs/xfs/xfs_icache.h      |  1 +
 fs/xfs/xfs_qm_syscalls.c |  9 ++++++---
 fs/xfs/xfs_super.c       |  7 +++++--
 fs/xfs/xfs_trace.h       |  1 +
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2c3ef553f5ef0..e9ebfe6f80150 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,19 +1872,29 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately and
- * wait for the work to finish.
+ * Expedite all pending inodegc work to run immediately. This does not wait for
+ * completion of the work.
  */
 void
-xfs_inodegc_flush(
+xfs_inodegc_push(
 	struct xfs_mount	*mp)
 {
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
+	trace_xfs_inodegc_push(mp, __return_address);
+	xfs_inodegc_queue_all(mp);
+}
 
+/*
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-
-	xfs_inodegc_queue_all(mp);
 	flush_workqueue(mp->m_inodegc_wq);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2e4cfddf8b8ed..6cd180721659b 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_push(struct xfs_mount *mp);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 47fe60e1a8873..322a111dfbc0f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -481,9 +481,12 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	/* Flush inodegc work at the start of a quota reporting scan. */
+	/*
+	 * Expedite pending inodegc work at the start of a quota reporting
+	 * scan but don't block waiting for it to complete.
+	 */
 	if (id == 0)
-		xfs_inodegc_flush(mp);
+		xfs_inodegc_push(mp);
 
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
@@ -525,7 +528,7 @@ xfs_qm_scall_getquota_next(
 
 	/* Flush inodegc work at the start of a quota reporting scan. */
 	if (*id == 0)
-		xfs_inodegc_flush(mp);
+		xfs_inodegc_push(mp);
 
 	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
 	if (error)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fe6ca9208de6..9b3af7611eaa9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -795,8 +795,11 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
-	/* Wait for whatever inactivations are in progress. */
-	xfs_inodegc_flush(mp);
+	/*
+	 * Expedite background inodegc but don't wait. We do not want to block
+	 * here waiting hours for a billion extent file to be truncated.
+	 */
+	xfs_inodegc_push(mp);
 
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1033a95fbf8e6..ebd17ddba0243 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -240,6 +240,7 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
 	TP_ARGS(mp, caller_ip))
 DEFINE_FS_EVENT(xfs_inodegc_flush);
+DEFINE_FS_EVENT(xfs_inodegc_push);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
-- 
2.40.1



