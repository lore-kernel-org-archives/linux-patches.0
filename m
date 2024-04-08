Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4146442046;
	Mon,  8 Apr 2024 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584372; cv=none; b=OliUc/osgmUG4BfoDLsWZpQrhHU8QZp5DE1UJpfJ/zrpUI6p/rRCX0v1buZEEjvExdiLu52FVc8j0g9h7L+Wa1je7ZDxknobJCi4RXqXComBw/nE08R95g6Wjmivgy8nzAt/PsqWAtG2+P81b6MpCxOx2ywrq22tyCo1j2xiNHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584372; c=relaxed/simple;
	bh=YaFpXzc41gsFWvHTHGrzZjb6BRAjMPBC2XvKASQVo4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aG6PAdL1dmx31IGiVc7k2ROCNk74VrH+D7wF8tOYRScoBccMhOTwvM5Bov+0Ntd8guikMGWYX4Hqvn6csFgjTy19D9IKFfbbjWIEjiMKxgqXwJ97LWacHyFCbAdBiiW2IAZSRMdP0Zj0QLOJFxr2DwJ4PW9mN+e5wRmjW+g6p0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lJsP+BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lJsP+BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A4DC433C7;
	Mon,  8 Apr 2024 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584372;
	bh=YaFpXzc41gsFWvHTHGrzZjb6BRAjMPBC2XvKASQVo4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lJsP+BQYWc8E86dz62kSWdiEr19FSBv+ay/1/aS2REGQqc37CIdMrsXbwz3eN24y
	 kATCXFx3U0X/5rylUT5KVp8bt0EOrJSzDpA+T4epsD10K4y3FOB5JeqnXpfi+X/wjz
	 SUnUAlVSwAIy5uCvz0tSl9fUYE6CgkxxbCuoK6pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 414/690] NFSD: fix regression with setting ACLs.
Date: Mon,  8 Apr 2024 14:54:40 +0200
Message-ID: <20240408125414.587326363@linuxfoundation.org>
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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 66d4a126f20ab..ad689215b1f37 100644
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
@@ -354,7 +358,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 
@@ -392,13 +396,6 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -449,8 +446,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			goto out_unlock;
 	}
 
-	iap->ia_valid |= ATTR_CTIME;
-	host_err = notify_change(&init_user_ns, dentry, iap, NULL);
+	if (iap->ia_valid) {
+		iap->ia_valid |= ATTR_CTIME;
+		host_err = notify_change(&init_user_ns, dentry, iap, NULL);
+	}
 
 out_unlock:
 	if (attr->na_seclabel && attr->na_seclabel->len)
-- 
2.43.0



