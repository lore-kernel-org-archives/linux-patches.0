Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C89345736
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301856; cv=none; b=I8vrVfs8WnZTYIAAoZOOMNt5AmbuFB30P2eOnNC0jpbipJTP8VO0jkNKH3okBj4OgP0faKnupDugVOpFQiO5ob2tjhKzH6litZJ0ZJLdoXmaPmlD/M/odK/IYx2vK5YFFkZns4KmIGooj3qiOtT4ndEIKTuKfZDKmrxHLDoiWlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301856; c=relaxed/simple;
	bh=cDaYe7sCREJ7qimZ/bLKSrMdjpu80G8He0B9EiKXQpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt5ikUqAYzVunsWcsxjNuntmhHvuBPTaW52cW6dJrunSjpGC9Kjudruj8ZLfLHxNnBicrNll6DWVezHeTkT2eB3LA3MsN2sSLcbniFuPpJbpOUjvEF/ZR1j36N8HK4Vsbc16Gm5w+95YmteuFIBgbN73Kd9NEkJTMCInisj1o8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaC2hx0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaC2hx0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38CCC116D0;
	Sat, 28 Feb 2026 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301856;
	bh=cDaYe7sCREJ7qimZ/bLKSrMdjpu80G8He0B9EiKXQpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaC2hx0IzW7y6Y0K6BL+Fgo0E7CrlEGsLykF6+rzTeCcqe7Awa/KKtsBOVUc2sLBS
	 YguhXTWovtXB+JUPaEjKtiaXpB2kRBUP0x3kl/5dBLpQmPxiPtQwjW9inBo4TeOIpP
	 288eiz7rXjUSkIW4/ylQIjbMDUPDFqtWDQiJhnNJ8q6bh7ibjqoHw0nYBGswRn0C6Q
	 l+k34LebNyjAFCXtq3In/eodD147TLj0SkQ/EXGivyTscUw0/jQTbQSKd0rtQuoGdC
	 hNIJxWNZ7LS31cr3hgTBDSd+1uQ3US3Hs+icR+IDW7cZ8x9USUrOeMpLUNxXAPua4o
	 WDiaOIF8vWdFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/385] nfs/localio: eliminate unnecessary kref in nfs_local_fsync_ctx
Date: Sat, 28 Feb 2026 12:58:19 -0500
Message-ID: <20260228180011.1568201-277-sashal@kernel.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 894f5c5593cdb57841318597a800ad1d3cb45a52 ]

nfs_local_commit() doesn't need async cleanup of nfs_local_fsync_ctx,
so there is no need to use a kref.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 9bb0060f7860 ("NFS/localio: use GFP_NOIO and non-memreclaim workqueue in nfs_local_commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 82a053304ad59..70dfcca96f922 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -43,7 +43,6 @@ struct nfs_local_fsync_ctx {
 	struct nfsd_file	*localio;
 	struct nfs_commit_data	*data;
 	struct work_struct	work;
-	struct kref		kref;
 	struct completion	*done;
 };
 static void nfs_local_fsync_work(struct work_struct *work);
@@ -775,30 +774,17 @@ nfs_local_fsync_ctx_alloc(struct nfs_commit_data *data,
 		ctx->localio = localio;
 		ctx->data = data;
 		INIT_WORK(&ctx->work, nfs_local_fsync_work);
-		kref_init(&ctx->kref);
 		ctx->done = NULL;
 	}
 	return ctx;
 }
 
-static void
-nfs_local_fsync_ctx_kref_free(struct kref *kref)
-{
-	kfree(container_of(kref, struct nfs_local_fsync_ctx, kref));
-}
-
-static void
-nfs_local_fsync_ctx_put(struct nfs_local_fsync_ctx *ctx)
-{
-	kref_put(&ctx->kref, nfs_local_fsync_ctx_kref_free);
-}
-
 static void
 nfs_local_fsync_ctx_free(struct nfs_local_fsync_ctx *ctx)
 {
 	nfs_local_release_commit_data(ctx->localio, ctx->data,
 				      ctx->data->task.tk_ops);
-	nfs_local_fsync_ctx_put(ctx);
+	kfree(ctx);
 }
 
 static void
@@ -831,7 +817,7 @@ int nfs_local_commit(struct nfsd_file *localio,
 	}
 
 	nfs_local_init_commit(data, call_ops);
-	kref_get(&ctx->kref);
+
 	if (how & FLUSH_SYNC) {
 		DECLARE_COMPLETION_ONSTACK(done);
 		ctx->done = &done;
@@ -839,6 +825,6 @@ int nfs_local_commit(struct nfsd_file *localio,
 		wait_for_completion(&done);
 	} else
 		queue_work(nfsiod_workqueue, &ctx->work);
-	nfs_local_fsync_ctx_put(ctx);
+
 	return 0;
 }
-- 
2.51.0

