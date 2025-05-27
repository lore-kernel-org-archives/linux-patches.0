Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE201B6D08;
	Tue, 27 May 2025 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364434; cv=none; b=MKs2NakDJREyHm8UjoKujFMEqEZXDp+pWqrkKjw4ljdOZ1R/a39A0c1ZqGCX/67t1b8qmwRjENlkPN5Fe5ywPT6Xm50h36S2Id2b6s+wPh050tG9ZxYzzYxHIcdZlQRWdcb/7LQoRUXdxfStKBIWTm6ARgC4+ijcwAdD5Ru2Fkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364434; c=relaxed/simple;
	bh=6Bs5JWt8r5n5RJFSrJjUnBTJVoMgnBDOsZ40j2X0KPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzINL+7YMEo3gOlPMvbo2WhN9JGlE+NaSKhJj9lFWgxBPEuLicEnRGMIEZgQdXq6MSClSJ70LLvKz08VspNc0GL7eUgUmiBI7lp398vEzI3EKpE8PbI544Jn8TTCjzPk0sOYKT1ukBBWq7479zkBX88eQ5Jy4hRoICeP6JU2zxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGc2HuIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGc2HuIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4347BC4CEE9;
	Tue, 27 May 2025 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364434;
	bh=6Bs5JWt8r5n5RJFSrJjUnBTJVoMgnBDOsZ40j2X0KPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGc2HuIYIFKE7EnPehF8+RbFfPP5BWR65uwaUWyYMlSNtSr0RISb+LjDpPa/71mCs
	 I708NikMn0EhxAwnT5NTkpVOz4v1oZtuFiqeq2+KKykcXPtFhxH3jlEQiKN/Y5EvAJ
	 8YjLGpublOOsq5qUQu47Ek70/mNvExzJwcqqOM5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/626] NFS: Dont allow waiting for exiting tasks
Date: Tue, 27 May 2025 18:19:08 +0200
Message-ID: <20250527162447.296110104@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 596f351701372..330273cf94531 100644
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
index 8b568a514fd1c..1be4be3d4a2b6 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -901,6 +901,11 @@ static inline u32 nfs_stateid_hash(const nfs4_stateid *stateid)
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
index 1566163c6d85b..88b0fb343ae04 100644
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
index ca01f79c82e4a..11f2b5cb3b06b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -434,6 +434,8 @@ static int nfs4_delay_killable(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!__fatal_signal_pending(current))
@@ -445,6 +447,8 @@ static int nfs4_delay_interruptible(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!signal_pending(current))
@@ -1765,7 +1769,8 @@ static void nfs_set_open_stateid_locked(struct nfs4_state *state,
 		rcu_read_unlock();
 		trace_nfs4_open_stateid_update_wait(state->inode, stateid, 0);
 
-		if (!fatal_signal_pending(current)) {
+		if (!fatal_signal_pending(current) &&
+		    !nfs_current_task_exiting()) {
 			if (schedule_timeout(5*HZ) == 0)
 				status = -EAGAIN;
 			else
@@ -3569,7 +3574,7 @@ static bool nfs4_refresh_open_old_stateid(nfs4_stateid *dst,
 		write_sequnlock(&state->seqlock);
 		trace_nfs4_close_stateid_update_wait(state->inode, dst, 0);
 
-		if (fatal_signal_pending(current))
+		if (fatal_signal_pending(current) || nfs_current_task_exiting())
 			status = -EINTR;
 		else
 			if (schedule_timeout(5*HZ) != 0)
-- 
2.39.5



