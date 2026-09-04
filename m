Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B83415F28;
	Fri,  4 Sep 2026 05:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498785; cv=none; b=AFm8mJJiNH0+Qq1nceXimTfqcWS10NaAdCxoTdtLAB0kGIE8vhY9hGSxOJVm2ywtgggbMO04JfG3+AYmZUWVo1r220LUDNSAeoQ1bWgBZWJU6DVgdSNmF6RxfAFQAI8jnzqtpx8/SfUuk0P6wmknh9p5xfoYpdM/OKarRzSYSSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498785; c=relaxed/simple;
	bh=2nO9DbcxVzMZYzNn8y54PDkE65h62H8bdvD5JMZYmH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAqrjMukzlFq+Z9YWJjvwAbIcKciVkRg/KQov30o9Kvke43NZ8hC53IU7CaBkf6SB4eUcdnSqKimKWfz7rv9mA9Q74tQeyqTtkKkcayHmvz1sM7ywQUTUh+10R/ibqfLUkwiO0XhulE3/yRhXU2GGaU5tuYLOF997WYUCwdDV2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmKpnl4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmKpnl4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F241F00A3D;
	Fri,  4 Sep 2026 05:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498784;
	bh=7vnEkV5DYklJsGGMLwOtaUAwCCz4sPvx9T9U8vUCVaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmKpnl4gfw3rVu59TlOtnr/nf+H3HMVwD/F/eEnz3sbupmgogQ7Mqpn7Z6OkBi9Pt
	 C2jb6CmwQsHa3xURGYWsl9lg3HP+xh2MHEyDHhXmBIOOhmadNSfwXUGQClqmykDlUu
	 5pg51IJPEMC6z5XXr6ShRCCYLsgYMZLBR1MSDx4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>
Subject: [PATCH 7.2 187/713] nfsd: fix possible fh_compose of wrong dentry in nfsd4_create_file()
Date: Fri,  4 Sep 2026 06:52:35 +0200
Message-ID: <20260904045808.005998683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit 3e2c79360c6a89975ec5b5a7d4ef937e4db91a27 upstream.

dentry_create() can hypothetically provide a different dentry than the
one passed in.  This could happen, for example, if the exported
filesystem is NFS, and the server returned to OPEN a filehandle which
matched a directory that was already in the dcache.  Clearly this would
not be expected!

If this were to happen the dentry (child) that was already stored in
resfhp could be freed and later dereferenced.

We shouldn't call fh_compose() until we are certain that we have the
final dentry, so this patch moved the fh_compose() call to two places:
one for the case where the target already exists, and one after
dentry_create() where it was created.

Fixes: 64a989dbd144 ("VFS/knfsd: Teach dentry_create() to use atomic_open()")
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260526053004.4014491-2-neilb@ownmail.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3024d51d6fb7..c16ccb403a8d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -306,10 +306,6 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			goto out;
 	}
 
-	status = fh_compose(resfhp, fhp->fh_export, child, fhp);
-	if (status != nfs_ok)
-		goto out;
-
 	v_mtime = 0;
 	v_atime = 0;
 	if (nfsd4_create_is_exclusive(open->op_createmode)) {
@@ -335,6 +331,10 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		if (status != nfs_ok)
 			goto out;
 
+		status = fh_compose(resfhp, fhp->fh_export, child, fhp);
+		if (status != nfs_ok)
+			goto out;
+
 		switch (open->op_createmode) {
 		case NFS4_CREATE_UNCHECKED:
 			if (!d_is_reg(child))
@@ -385,6 +385,10 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	open->op_created = true;
 	fh_fill_post_attrs(fhp);
 
+	status = fh_compose(resfhp, fhp->fh_export, child, fhp);
+	if (status != nfs_ok)
+		goto out;
+
 	/* A newly created file already has a file size of zero. */
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
 		iap->ia_valid &= ~ATTR_SIZE;
-- 
2.55.0



