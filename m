Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A57B2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301857; cv=none; b=ahLR15mz96BbyTj5+AAC1T3WvnzWA1MLRKpRTTJW13cQovtBUeDT0wMqB/0z31+mvT7CrZMUK6iVJHtMI36t41uazpLB61YKf/jwOK9PbOpmyPrH9/HPWOJcIL7lZRCl8RWBsJacU/eUb59Ko+cSxasPdRQdbYkQfBqYmlRylBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301857; c=relaxed/simple;
	bh=kyppM6Kwbttr3wUfp2tw8Lluvm9zhSd5scRPR7F4LxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGpQ8fwNzLpnSi7STDQYTme/TfN+/zQ9EQGuagJpA4Z5To2bDqxUqYnwfUJcNcev+r7tYieN9rH8XxqbJc6MudWzDMy81l6SICxtiDR17apMzdTay5bqT4B/IY5VTVil3bmifT20nW+3kgjyjma6Pr66SUKvnIt0tqTHL1zkAwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M70LJ3/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M70LJ3/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A2EC116D0;
	Sat, 28 Feb 2026 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301857;
	bh=kyppM6Kwbttr3wUfp2tw8Lluvm9zhSd5scRPR7F4LxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M70LJ3/s6O44HqJ1hyUU7mbqMri86bsEpMKGRV3LiqRTRdBeOLv7cQ79uqJhBxmez
	 93WPxtqikSHebgSpm4ifl2FddAtW58sEOZfDbf0T+NaDMeEaWLY19c2iSyjX6EwOzZ
	 MTPTPNmZFIrtw9xsdlWbsp+NzGr9aY4fpSowgIPb0x5gIwrkWjXlEipF+YGQT5BPDi
	 BqiTAUM+jH7xjfxzWm9BNhjKvz1JNCWENtKLyMjpVLnVOQUCvuA/46HbLW1Exi2Fh7
	 Op5zxZYaYqfiplqXHGsltzUpnTX7X1dqRisc+MAkrtIDZES5SjGUFueoMeQlYZyHO7
	 FH7F5sJBPtQ0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mike Snitzer <snitzer@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/385] NFS/localio: use GFP_NOIO and non-memreclaim workqueue in nfs_local_commit
Date: Sat, 28 Feb 2026 12:58:20 -0500
Message-ID: <20260228180011.1568201-278-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@hammerspace.com>

[ Upstream commit 9bb0060f7860aa4561c5b21163dd45ceb66946a9 ]

nfslocaliod_workqueue is a non-memreclaim workqueue (it isn't
initialized with WQ_MEM_RECLAIM), see commit b9f5dd57f4a5
("nfs/localio: use dedicated workqueues for filesystem read and
write").

Use nfslocaliod_workqueue for LOCALIO's SYNC work.

Also, set PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO in
nfs_local_fsync_work.

Fixes: b9f5dd57f4a5 ("nfs/localio: use dedicated workqueues for filesystem read and write")
Signed-off-by: Mike Snitzer <snitzer@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 70dfcca96f922..84fe3ef21b6da 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -790,17 +790,22 @@ nfs_local_fsync_ctx_free(struct nfs_local_fsync_ctx *ctx)
 static void
 nfs_local_fsync_work(struct work_struct *work)
 {
+	unsigned long old_flags = current->flags;
 	struct nfs_local_fsync_ctx *ctx;
 	int status;
 
 	ctx = container_of(work, struct nfs_local_fsync_ctx, work);
 
+	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
+
 	status = nfs_local_run_commit(nfs_to->nfsd_file_file(ctx->localio),
 				      ctx->data);
 	nfs_local_commit_done(ctx->data, status);
 	if (ctx->done != NULL)
 		complete(ctx->done);
 	nfs_local_fsync_ctx_free(ctx);
+
+	current->flags = old_flags;
 }
 
 int nfs_local_commit(struct nfsd_file *localio,
@@ -809,7 +814,7 @@ int nfs_local_commit(struct nfsd_file *localio,
 {
 	struct nfs_local_fsync_ctx *ctx;
 
-	ctx = nfs_local_fsync_ctx_alloc(data, localio, GFP_KERNEL);
+	ctx = nfs_local_fsync_ctx_alloc(data, localio, GFP_NOIO);
 	if (!ctx) {
 		nfs_local_commit_done(data, -ENOMEM);
 		nfs_local_release_commit_data(localio, data, call_ops);
@@ -821,10 +826,10 @@ int nfs_local_commit(struct nfsd_file *localio,
 	if (how & FLUSH_SYNC) {
 		DECLARE_COMPLETION_ONSTACK(done);
 		ctx->done = &done;
-		queue_work(nfsiod_workqueue, &ctx->work);
+		queue_work(nfslocaliod_workqueue, &ctx->work);
 		wait_for_completion(&done);
 	} else
-		queue_work(nfsiod_workqueue, &ctx->work);
+		queue_work(nfslocaliod_workqueue, &ctx->work);
 
 	return 0;
 }
-- 
2.51.0

