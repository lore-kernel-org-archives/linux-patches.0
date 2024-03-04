Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606A97BAF5;
	Mon,  4 Mar 2024 21:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588999; cv=none; b=LpqnYjblhGQrGEk91kEW68ejAoyTUsA7/QepxH3n8XzpNMXcVQ7v0LYyJsDW1DRXHmdN5zf4NxwrKlbJYT5G+phkvwipSt4i3yZD9Ql4l3WgJdxlNxp640iTan318H4JTpCglpSXmSh3k/Zb14R19o7/Famctmk9CKnWIxlLgNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588999; c=relaxed/simple;
	bh=Sb/X1zJUcPLaYnkvjllOPMHQwKmHga6t6UjtExXj244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnWMCEFplL7mDqcMrPJG7hNEtz2l3Di+UqHE/In2P3Ap0nE7PdlKGPvUxS/ryxa9/9NIrGE19fs2M9qGcUWfw2mzuphlP6aXsRSGmiIou72G3QUjxJ9RIc/Rb0kval0HkAb7qvpdvLKxq0I4lV2uwVO6PIY7lHcsTbkKEWEMks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9yZmEcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9yZmEcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3D4C433C7;
	Mon,  4 Mar 2024 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588999;
	bh=Sb/X1zJUcPLaYnkvjllOPMHQwKmHga6t6UjtExXj244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9yZmEcC/EG6B9jPjdWbLpLRiUiNAVcqAQv65UEE0CX2vBkrFX5X1Mmjk4xSVWi60
	 Lt1dIWAT7XfnC9v83Y9ZSEC+c8GGJfeqPQc11CgMzwnicT3kAxBbDfCG14KqNIVaU1
	 p0wBxWrTZFuIMlXxtR4zY36wJxMl0QZ6XVpgHZu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 163/215] nfsd: use locks_inode_context helper
Date: Mon,  4 Mar 2024 21:23:46 +0000
Message-ID: <20240304211602.145845880@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 77c67530e1f95ac25c7075635f32f04367380894 ]

nfsd currently doesn't access i_flctx safely everywhere. This requires a
smp_load_acquire, as the pointer is set via cmpxchg (a release
operation).

Acked-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4784,7 +4784,7 @@ nfs4_share_conflict(struct svc_fh *curre
 
 static bool nfsd4_deleg_present(const struct inode *inode)
 {
-	struct file_lock_context *ctx = smp_load_acquire(&inode->i_flctx);
+	struct file_lock_context *ctx = locks_inode_context(inode);
 
 	return ctx && !list_empty_careful(&ctx->flc_lease);
 }
@@ -5944,7 +5944,7 @@ nfs4_lockowner_has_blockers(struct nfs4_
 
 	list_for_each_entry(stp, &lo->lo_owner.so_stateids, st_perstateowner) {
 		nf = stp->st_stid.sc_file;
-		ctx = nf->fi_inode->i_flctx;
+		ctx = locks_inode_context(nf->fi_inode);
 		if (!ctx)
 			continue;
 		if (locks_owner_has_blockers(ctx, lo))
@@ -7761,7 +7761,7 @@ check_for_locks(struct nfs4_file *fp, st
 	}
 
 	inode = locks_inode(nf->nf_file);
-	flctx = inode->i_flctx;
+	flctx = locks_inode_context(inode);
 
 	if (flctx && !list_empty_careful(&flctx->flc_posix)) {
 		spin_lock(&flctx->flc_lock);


