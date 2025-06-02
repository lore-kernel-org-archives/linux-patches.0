Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678961DF73C;
	Mon,  2 Jun 2025 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876638; cv=none; b=E/e/P/BiTl6Ry3Vx83MhmwGHatljPlu8UkVIeTkTiZFhpbImc/pSxHg05weRL5ym1zk+uUSR/3NLSA253TnP5Y8W9Jx8fYGLc+SdSj4Sajtg6WNUnGLsQcJMfd6AphEm/aLLw3HXLM2CpzBhlkLS76bk7x4KqEZtQuWRvyT3WN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876638; c=relaxed/simple;
	bh=pT+A5vtYZGr45K1UyGRE8rwmv+9r5lQCkuuOoi+Gev8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOmhpCM3h9Qpbrz26DbFpF3X1L+MukjtsUS9ckg6xcuztkfnysLCy0KOXETU/axIN18XqEGaSgm/j00qp21amzJk9AxXUYenJ459+tx9Rs9Djn4OLVbd3KvemdHUnDAft2Y4D24n0UFs5D0qnOw/Kwjp9xU/YXCmtv5bTXDpFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfcSSsQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfcSSsQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB808C4CEEB;
	Mon,  2 Jun 2025 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876638;
	bh=pT+A5vtYZGr45K1UyGRE8rwmv+9r5lQCkuuOoi+Gev8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfcSSsQSqSbZ47fHOTK00shRr2JkUQ2isNh5gjae3Y0ytvf2hqcXKgMuOvqQjeBE6
	 rbOGZjoYQX8p9Z/WcWlbOcdaamwKrpJ/d8/GxFC3ytxvXh2iUEeZ017KQmqCj9OTLQ
	 AB+PveqJeBg5h43CGpFi1a43bLBi+eLj+cdTEW38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/325] NFS: Dont allow waiting for exiting tasks
Date: Mon,  2 Jun 2025 15:45:02 +0200
Message-ID: <20250602134320.799110950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index 964df0725f4c2..f2e66b946f4b4 100644
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
index ece517ebcca0b..84361674bffc7 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -832,6 +832,11 @@ static inline u32 nfs_stateid_hash(const nfs4_stateid *stateid)
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
index 2e7579626cf01..f036d30f7515c 100644
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
index acef50824d1a2..0f28607c57473 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -422,6 +422,8 @@ static int nfs4_delay_killable(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!__fatal_signal_pending(current))
@@ -433,6 +435,8 @@ static int nfs4_delay_interruptible(long *timeout)
 {
 	might_sleep();
 
+	if (unlikely(nfs_current_task_exiting()))
+		return -EINTR;
 	__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE_UNSAFE);
 	schedule_timeout(nfs4_update_delay(timeout));
 	if (!signal_pending(current))
@@ -1712,7 +1716,8 @@ static void nfs_set_open_stateid_locked(struct nfs4_state *state,
 		rcu_read_unlock();
 		trace_nfs4_open_stateid_update_wait(state->inode, stateid, 0);
 
-		if (!fatal_signal_pending(current)) {
+		if (!fatal_signal_pending(current) &&
+		    !nfs_current_task_exiting()) {
 			if (schedule_timeout(5*HZ) == 0)
 				status = -EAGAIN;
 			else
@@ -3500,7 +3505,7 @@ static bool nfs4_refresh_open_old_stateid(nfs4_stateid *dst,
 		write_sequnlock(&state->seqlock);
 		trace_nfs4_close_stateid_update_wait(state->inode, dst, 0);
 
-		if (fatal_signal_pending(current))
+		if (fatal_signal_pending(current) || nfs_current_task_exiting())
 			status = -EINTR;
 		else
 			if (schedule_timeout(5*HZ) != 0)
-- 
2.39.5



