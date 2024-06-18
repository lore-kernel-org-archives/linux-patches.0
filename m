Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CCC1A256C;
	Tue, 18 Jun 2024 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716370; cv=none; b=f2x1m2bQPPpW/j8jGlaRxbDZG5uEz+uKxmjaNN1wqEXsSLtKPtMR7qtRsOGsYGDGk6Dam0Tpu5moYDALS9XyQLjJcTbz5P532kZ3VmVcv1s5Uepjg30OMXjky1S3GAgSEsxSpjZcWroTF29fMj2KqnYJG/KRkEVVTo6IoyP0/ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716370; c=relaxed/simple;
	bh=66IkhP0AOutLiVmHIttN56yDxWvdXO23Ul8D8KG27OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVmoGX9zURJUTxupa5H+vpZuuj6+T1zz74kCP5ZxEYLzirh95jrTcZR2gr+EoGPgfjk5u0S5X/QHdVN1EFB8vGo0gHv6qRH6Nu1kdE9s9ubyf5P5Gd3QajWMYh5uQvFhSh0GwKjYxpBWAkcjkEssv85+ElDI8iQXRQH4MC+i2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLtKn5iZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLtKn5iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB95FC3277B;
	Tue, 18 Jun 2024 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716370;
	bh=66IkhP0AOutLiVmHIttN56yDxWvdXO23Ul8D8KG27OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLtKn5iZ8sq0RG2705x0MlvC6oyEmzOu1IPtO0Q9ddYB9bsAbssR/cwWfHKT2WRgU
	 z/q2savpiRuXu2LnRSeBsNwvOoVm8MBnR7zVuUjVrajIz0kUC5u7YxlFEwFHq6WDc1
	 +cTG3ke5fMR8pX40RFlE3GLUj8WVmEsfUAM+kPZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 624/770] NFSD: fix regression with setting ACLs.
Date: Tue, 18 Jun 2024 14:37:57 +0200
Message-ID: <20240618123431.373040571@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 00801cd92d91e94aa04d687f9bb9a9104e7c3d46 ]

A recent patch moved ACL setting into nfsd_setattr().
Unfortunately it didn't work as nfsd_setattr() aborts early if
iap->ia_valid is 0.

Remove this test, and instead avoid calling notify_change() when
ia_valid is 0.

This means that nfsd_setattr() will now *always* lock the inode.
Previously it didn't if only a ATTR_MODE change was requested on a
symlink (see Commit 15b7a1b86d66 ("[PATCH] knfsd: fix setattr-on-symlink
error return")). I don't think this change really matters.

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5a7fee4ee2079..95f2e4549c034 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -299,6 +299,10 @@ commit_metadata(struct svc_fh *fhp)
 static void
 nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
 {
+	/* Ignore mode updates on symlinks */
+	if (S_ISLNK(inode->i_mode))
+		iap->ia_valid &= ~ATTR_MODE;
+
 	/* sanitize the mode change */
 	if (iap->ia_valid & ATTR_MODE) {
 		iap->ia_mode &= S_IALLUGO;
@@ -366,7 +370,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 
@@ -404,13 +408,6 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	dentry = fhp->fh_dentry;
 	inode = d_inode(dentry);
 
-	/* Ignore any mode updates on symlinks */
-	if (S_ISLNK(inode->i_mode))
-		iap->ia_valid &= ~ATTR_MODE;
-
-	if (!iap->ia_valid)
-		return 0;
-
 	nfsd_sanitize_attrs(inode, iap);
 
 	if (check_guard && guardtime != inode->i_ctime.tv_sec)
@@ -461,8 +458,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			goto out_unlock;
 	}
 
-	iap->ia_valid |= ATTR_CTIME;
-	host_err = notify_change(dentry, iap, NULL);
+	if (iap->ia_valid) {
+		iap->ia_valid |= ATTR_CTIME;
+		host_err = notify_change(dentry, iap, NULL);
+	}
 
 out_unlock:
 	if (attr->na_seclabel && attr->na_seclabel->len)
-- 
2.43.0



