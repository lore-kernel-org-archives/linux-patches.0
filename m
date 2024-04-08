Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E9C42046;
	Mon,  8 Apr 2024 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584530; cv=none; b=IJEQMNaDI+cb3rvwc+iT2hC1nx3MfaOsUSY+1vavh3O8F2xmPVwI2mIR3TXIkiSSlwjH1iw4dJG2smFq2WT0pEq8WZjxE/rS1eQGSdGL4qU0FeLf1I/y3LFnFc6dcO4CJkZoA0bXaZnhCBIqAn6+BPHd/YFrnvWmr8WCAngIOSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584530; c=relaxed/simple;
	bh=silBsAkx2SwCUIgNDtzi5SSAdGKL/a+3+FmsvwQ4sow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8ojpCqvbhw8jyZ1HmzSP+vqH3Cie/qAYK057UK1MsiIlwZ4uEuqjKLRUS5BAKkRqfOFyJpgP5RAGVSHP/avNyHlvO1vQ+zOySd++WFaNQBcpOLZllgU3dS11UVG913v54MjM0b08rLe9tTC3x+9cKG0GY+veOURcbTf/rYAV6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJn+wTlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJn+wTlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77F9C433F1;
	Mon,  8 Apr 2024 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584530;
	bh=silBsAkx2SwCUIgNDtzi5SSAdGKL/a+3+FmsvwQ4sow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJn+wTlRRk7Ysa3kQrIGuC4I5beHyHI32TUM/3lv4xhdHOILFW8iB0Te9hui9CtAB
	 fmnPVelPvW3TKMlylS+WYoZV3ulcDHA8WDRy4HIRJFm81sE/RmJYldp8wchkN15++e
	 6v+jpXlZIYn4H05uhm8rleWk0ukj6kUe9vk58PeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 469/690] nfsd: use locks_inode_context helper
Date: Mon,  8 Apr 2024 14:55:35 +0200
Message-ID: <20240408125416.603950700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 77c67530e1f95ac25c7075635f32f04367380894 ]

nfsd currently doesn't access i_flctx safely everywhere. This requires a
smp_load_acquire, as the pointer is set via cmpxchg (a release
operation).

Acked-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 7cfc92aa2a236..dbcdb74e9ff6f 100644
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
@@ -7726,7 +7726,7 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 	}
 
 	inode = locks_inode(nf->nf_file);
-	flctx = inode->i_flctx;
+	flctx = locks_inode_context(inode);
 
 	if (flctx && !list_empty_careful(&flctx->flc_posix)) {
 		spin_lock(&flctx->flc_lock);
-- 
2.43.0



