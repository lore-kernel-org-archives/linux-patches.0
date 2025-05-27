Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27F41E89C;
	Tue, 27 May 2025 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366495; cv=none; b=N+REoMfEfCxDlb/fX+17PYYFn/paSJDVWo2ltsjh0w3v5BqMn8VxSRyGO2FHZQMSh9kHX8WAP77HJk5Oc+hFRgy5OQDiUUPOBbOTARLx4GQ/iLGbZM1H7K7sjKl3wI4O6crlLDK21o3G0gxNxfxCauJVpVOJNTcpIEwiq6ynfGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366495; c=relaxed/simple;
	bh=C2uaDYJaF0v42ZqmtrM1fVZGzPZWi8SN+Ex3OYOWYjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HistH+JYmdpZQr3H4ZbDZ7AjwbaDzOVrlyiGnb+7A5RoE1v5Do3TD9wkPxQwuzl8dfvB0JeWO56z9hzP/7LJzhtlyED59mJmo7/mGQA18MsTTE/Lf3XWv/TyNblI2fxq1rCPAUSCwwVBTYHd8MvxG9uG4D6YXsYUziGv13nye9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNyLu9yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNyLu9yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386B2C4CEE9;
	Tue, 27 May 2025 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366495;
	bh=C2uaDYJaF0v42ZqmtrM1fVZGzPZWi8SN+Ex3OYOWYjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNyLu9yL2GgP5pR7599g7tupYAemXSn9xRDPA8zeYa4jewehzlaO48bj6CaUNFNyu
	 gISudstID0UGryFx2ZwjFUAHSWMz/8Vat4BerJ7xuyjg4mhSLcCFuRcfQSx4F19PGz
	 B+XSDEoaIM+wWTdNXPVwkzIzotVYSjKJbXfykhg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 056/783] NFS: Dont allow waiting for exiting tasks
Date: Tue, 27 May 2025 18:17:33 +0200
Message-ID: <20250527162515.410365321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8d3ca331026a7f9700d3747eed59a67b8f828cdc ]

Once a task calls exit_signals() it can no longer be signalled. So do
not allow it to do killable waits.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c    | 2 ++
 fs/nfs/internal.h | 5 +++++
 fs/nfs/nfs3proc.c | 2 +-
 fs/nfs/nfs4proc.c | 9 +++++++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1aa67fca69b2f..119e447758b99 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -74,6 +74,8 @@ nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
 
 int nfs_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	schedule();
 	if (signal_pending_state(mode, current))
 		return -ERESTARTSYS;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 59bb4d0338f39..3cedb7979fcd0 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -905,6 +905,11 @@ static inline u32 nfs_stateid_hash(const nfs4_stateid *stateid)
 				NFS4_STATEID_OTHER_SIZE);
 }
 
+static inline bool nfs_current_task_exiting(void)
+{
+	return (current->flags & PF_EXITING) != 0;
+}
+
 static inline bool nfs_error_is_fatal(int err)
 {
 	switch (err) {
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 0c3bc98cd999c..c1736dbb92b63 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -39,7 +39,7 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 		__set_current_state(TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
 		schedule_timeout(NFS_JUKEBOX_RETRY_TIME);
 		res = -ERESTARTSYS;
-	} while (!fatal_signal_pending(current));
+	} while (!fatal_signal_pending(current) && !nfs_current_task_exiting());
 	return res;
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 810cfd9b7e533..cfdbd521fc7b6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -443,6 +443,8 @@ static int nfs4_delay_killable(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!__fatal_signal_pending(current))
@@ -454,6 +456,8 @@ static int nfs4_delay_interruptible(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!signal_pending(current))
@@ -1774,7 +1778,8 @@ static void nfs_set_open_stateid_locked(struct nfs4_state *state,
 		rcu_read_unlock();
 		trace_nfs4_open_stateid_update_wait(state->inode, stateid, 0);
 
-		if (!fatal_signal_pending(current)) {
+		if (!fatal_signal_pending(current) &&
+		    !nfs_current_task_exiting()) {
 			if (schedule_timeout(5*HZ) == 0)
 				status = -EAGAIN;
 			else
@@ -3578,7 +3583,7 @@ static bool nfs4_refresh_open_old_stateid(nfs4_stateid *dst,
 		write_sequnlock(&state->seqlock);
 		trace_nfs4_close_stateid_update_wait(state->inode, dst, 0);
 
-		if (fatal_signal_pending(current))
+		if (fatal_signal_pending(current) || nfs_current_task_exiting())
 			status = -EINTR;
 		else
 			if (schedule_timeout(5*HZ) != 0)
-- 
2.39.5



