Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE72824E4C6;
	Tue, 20 May 2025 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750483; cv=none; b=uOfsq8fAKO5kGu5H4TN0gGwcOJi4OponvmJPEvj2BFRtrcFJ5mwY+0L782ZOMxXih/PGFyCzYnfK/dKmADCris5Xwfy3hF7QJw6VBtM6CcsUyB3yo+5x50D/9aWghsotRVgE9jjvh7WDQLtMtqXbM+lvJmGTKGP4/xcf/61AULU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750483; c=relaxed/simple;
	bh=bVNXBy6rdfwr5iPdaSi9XomDnvJu7AUqRFNWu+R2xBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJZCoNyW3ovDastnD2C50WPftj7yL+lndtshXwUYI6xUCQCahXht38mQiF46lF1myQYp+YL6+h3lOOCbbPa6lgrr5lm3MnMu7jQmvM8ae96ZAn9taDBPBzOGXI3OEzTxdHFHA/0zO6OB4fXjg4rXBuGYp9AJ8YzA+Rs8sUiM8eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7Aq434K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7Aq434K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE3BC4CEE9;
	Tue, 20 May 2025 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750482;
	bh=bVNXBy6rdfwr5iPdaSi9XomDnvJu7AUqRFNWu+R2xBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7Aq434KF4XlD8Y/G/bWpUfUO0fDnINr6KUmVg6WFrBoVy1BZ0albDbdKm/qC4zcL
	 8KIo4AEOIIIebih28/1eeh2GbG3fIVp983IUuWfmfr06SAGRUX8f92YQg3P1gM3BDI
	 N6YX2J1LbD0grzWrWImvbG8+IHR+YXSf65bEFCOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/145] nfs: handle failure of nfs_get_lock_context in unlock path
Date: Tue, 20 May 2025 15:49:53 +0200
Message-ID: <20250520125811.465517347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit c457dc1ec770a22636b473ce5d35614adfe97636 ]

When memory is insufficient, the allocation of nfs_lock_context in
nfs_get_lock_context() fails and returns -ENOMEM. If we mistakenly treat
an nfs4_unlockdata structure (whose l_ctx member has been set to -ENOMEM)
as valid and proceed to execute rpc_run_task(), this will trigger a NULL
pointer dereference in nfs4_locku_prepare. For example:

BUG: kernel NULL pointer dereference, address: 000000000000000c
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP PTI
CPU: 15 UID: 0 PID: 12 Comm: kworker/u64:0 Not tainted 6.15.0-rc2-dirty #60
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40
Workqueue: rpciod rpc_async_schedule
RIP: 0010:nfs4_locku_prepare+0x35/0xc2
Code: 89 f2 48 89 fd 48 c7 c7 68 69 ef b5 53 48 8b 8e 90 00 00 00 48 89 f3
RSP: 0018:ffffbbafc006bdb8 EFLAGS: 00010246
RAX: 000000000000004b RBX: ffff9b964fc1fa00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: fffffffffffffff4 RDI: ffff9ba53fddbf40
RBP: ffff9ba539934000 R08: 0000000000000000 R09: ffffbbafc006bc38
R10: ffffffffb6b689c8 R11: 0000000000000003 R12: ffff9ba539934030
R13: 0000000000000001 R14: 0000000004248060 R15: ffffffffb56d1c30
FS: 0000000000000000(0000) GS:ffff9ba5881f0000(0000) knlGS:00000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000000c CR3: 000000093f244000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __rpc_execute+0xbc/0x480
 rpc_async_schedule+0x2f/0x40
 process_one_work+0x232/0x5d0
 worker_thread+0x1da/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x10d/0x240
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x34/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
CR2: 000000000000000c
---[ end trace 0000000000000000 ]---

Free the allocated nfs4_unlockdata when nfs_get_lock_context() fails and
return NULL to terminate subsequent rpc_run_task, preventing NULL pointer
dereference.

Fixes: f30cb757f680 ("NFS: Always wait for I/O completion before unlock")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20250417072508.3850532-1-lilingfeng3@huawei.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6e95db6c17e92..810cfd9b7e533 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7049,10 +7049,18 @@ static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
 	struct nfs4_unlockdata *p;
 	struct nfs4_state *state = lsp->ls_state;
 	struct inode *inode = state->inode;
+	struct nfs_lock_context *l_ctx;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == NULL)
 		return NULL;
+	l_ctx = nfs_get_lock_context(ctx);
+	if (!IS_ERR(l_ctx)) {
+		p->l_ctx = l_ctx;
+	} else {
+		kfree(p);
+		return NULL;
+	}
 	p->arg.fh = NFS_FH(inode);
 	p->arg.fl = &p->fl;
 	p->arg.seqid = seqid;
@@ -7060,7 +7068,6 @@ static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
 	p->lsp = lsp;
 	/* Ensure we don't close file until we're done freeing locks! */
 	p->ctx = get_nfs_open_context(ctx);
-	p->l_ctx = nfs_get_lock_context(ctx);
 	locks_init_lock(&p->fl);
 	locks_copy_lock(&p->fl, fl);
 	p->server = NFS_SERVER(inode);
-- 
2.39.5



