Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A6159207;
	Tue, 18 Jun 2024 13:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716549; cv=none; b=kNvLIdks8CbD0jUy/RC9VAzTBduRPuvoUoyK57vKsiuAJvbLLMJS6isetmf/nNP8fiPKytImsY4VPjy8BhW2YG5vR2XGZ0RhPaQrlzec2urBzrlIwF0d9Pq51pJcT1Wy2rbCLZczj939ElpSWnHfA6bnehAFoSkaD6So1S/AyOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716549; c=relaxed/simple;
	bh=0h1XQRn1bOCGpiE/awrFpsP4SUIGKdRKtKIaQVJJL+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhhENJaZr11kvJjSk9UNSXdXMVzjo0OORTYvEIH9wquNwV4xjYOOUSlKOQb3P/f7biaT4rsndJoPbYHEi5xktaubvHWsyKiW21YHmGLbO5uNvMuSA5lJk+yvtCcYkP2D1c6fevyLqi25Z3ZsXSHvMIkUGA074c0wbnhUnYekoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS+7nsE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS+7nsE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C332FC3277B;
	Tue, 18 Jun 2024 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716549;
	bh=0h1XQRn1bOCGpiE/awrFpsP4SUIGKdRKtKIaQVJJL+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS+7nsE3qVqOCeHAO4X33rIzy1Ot8qVECOuTzjClt29xfcV5SoCQoEJWVNTFJQ5qZ
	 E86G9aQM0CGuJjblny0n2SAaOAQFQNg+rw9mG5AZBVaHEBXKdOFrWa+bnxqAZEOvh0
	 6VosCtwKRNjQH4aiPt84KQS1g9a74Tw+cYb2KNjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 681/770] nfsd: use locks_inode_context helper
Date: Tue, 18 Jun 2024 14:38:54 +0200
Message-ID: <20240618123433.562868050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 77c67530e1f95ac25c7075635f32f04367380894 ]

nfsd currently doesn't access i_flctx safely everywhere. This requires a
smp_load_acquire, as the pointer is set via cmpxchg (a release
operation).

Acked-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 10915c72c7815..2d09977fee83d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4773,7 +4773,7 @@ nfs4_share_conflict(struct svc_fh *current_fh, unsigned int deny_type)
 
 static bool nfsd4_deleg_present(const struct inode *inode)
 {
-	struct file_lock_context *ctx = smp_load_acquire(&inode->i_flctx);
+	struct file_lock_context *ctx = locks_inode_context(inode);
 
 	return ctx && !list_empty_careful(&ctx->flc_lease);
 }
@@ -5912,7 +5912,7 @@ nfs4_lockowner_has_blockers(struct nfs4_lockowner *lo)
 
 	list_for_each_entry(stp, &lo->lo_owner.so_stateids, st_perstateowner) {
 		nf = stp->st_stid.sc_file;
-		ctx = nf->fi_inode->i_flctx;
+		ctx = locks_inode_context(nf->fi_inode);
 		if (!ctx)
 			continue;
 		if (locks_owner_has_blockers(ctx, lo))
@@ -7740,7 +7740,7 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 	}
 
 	inode = locks_inode(nf->nf_file);
-	flctx = inode->i_flctx;
+	flctx = locks_inode_context(inode);
 
 	if (flctx && !list_empty_careful(&flctx->flc_posix)) {
 		spin_lock(&flctx->flc_lock);
-- 
2.43.0



