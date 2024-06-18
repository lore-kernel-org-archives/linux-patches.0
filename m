Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D2A157493;
	Tue, 18 Jun 2024 13:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715882; cv=none; b=WWVm7zStyflO/HMU4aE3RRMLPMJq8CbuMNH0iHDM50F6rJW2ZYPgpckXMaQFefj9qMJqn2Ya16/x8m2oJg0sU4GwmxJEF1AJ1Q7KfiWZzhTzB1eSRJ4IWYDNpH8bSOkaN26VrgOogJGgs4ve/tS7Tm36melTvbs9HLbQxzY1638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715882; c=relaxed/simple;
	bh=efC32pHZ+3LyYyyt7OjQbLgVVefmR/jsTHcAq74+0Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0xqpF2RljZeicofFwitXgutxQ1Gz4XRpDCUv9gH2lMFG1pyU6XDpagE03xSNXEUj02hqIXugG1tMpzoRypQ93wWR63AVbctaoGdSzbR0cr4ZcmHgM3eIsDvaHz1aSfNx+gRSi1ZI12iwHwPbUHiPjcVyDF1LSvYI8mVoFkW2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UgeQfuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UgeQfuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B65C3277B;
	Tue, 18 Jun 2024 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715882;
	bh=efC32pHZ+3LyYyyt7OjQbLgVVefmR/jsTHcAq74+0Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UgeQfukaPH0FSM6xKbIhEV5g0fXkciZ8uzRoGlz02OMixA65qDQz+gXoWJO1Dy2i
	 /C4eY6SVAAr/M0BtOAfKuplyGuJ2NiC+Gxnj2Nc/TDGc7u926l+mk1+CbM57uuute0
	 vX0PcXCnYfBIDbgmtwGDH6/1M6etsSpri6TlIauM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/770] Revert "nfsd: skip some unnecessary stats in the v4 case"
Date: Tue, 18 Jun 2024 14:35:12 +0200
Message-ID: <20240618123425.030431114@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 58f258f65267542959487dbe8b5641754411843d ]

On the wire, I observed NFSv4 OPEN(CREATE) operations sometimes
returning a reasonable-looking value in the cinfo.before field and
zero in the cinfo.after field.

RFC 8881 Section 10.8.1 says:
> When a client is making changes to a given directory, it needs to
> determine whether there have been changes made to the directory by
> other clients.  It does this by using the change attribute as
> reported before and after the directory operation in the associated
> change_info4 value returned for the operation.

and

> ... The post-operation change
> value needs to be saved as the basis for future change_info4
> comparisons.

A good quality client implementation therefore saves the zero
cinfo.after value. During a subsequent OPEN operation, it will
receive a different non-zero value in the cinfo.before field for
that directory, and it will incorrectly believe the directory has
changed, triggering an undesirable directory cache invalidation.

There are filesystem types where fs_supports_change_attribute()
returns false, tmpfs being one. On NFSv4 mounts, this means the
fh_getattr() call site in fill_pre_wcc() and fill_post_wcc() is
never invoked. Subsequently, nfsd4_change_attribute() is invoked
with an uninitialized @stat argument.

In fill_pre_wcc(), @stat contains stale stack garbage, which is
then placed on the wire. In fill_post_wcc(), ->fh_post_wc is all
zeroes, so zero is placed on the wire. Both of these values are
meaningless.

This fix can be applied immediately to stable kernels. Once there
are more regression tests in this area, this optimization can be
attempted again.

Fixes: 428a23d2bf0c ("nfsd: skip some unnecessary stats in the v4 case")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index c3ac1b6aa3aaa..84088581bbe09 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -487,11 +487,6 @@ svcxdr_encode_wcc_data(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-static bool fs_supports_change_attribute(struct super_block *sb)
-{
-	return sb->s_flags & SB_I_VERSION || sb->s_export_op->fetch_iversion;
-}
-
 /*
  * Fill in the pre_op attr for the wcc data
  */
@@ -500,26 +495,24 @@ void fill_pre_wcc(struct svc_fh *fhp)
 	struct inode    *inode;
 	struct kstat	stat;
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	__be32 err;
 
 	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return;
 	inode = d_inode(fhp->fh_dentry);
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &stat);
-
-		if (err) {
-			/* Grab the times from inode anyway */
-			stat.mtime = inode->i_mtime;
-			stat.ctime = inode->i_ctime;
-			stat.size  = inode->i_size;
-		}
-		fhp->fh_pre_mtime = stat.mtime;
-		fhp->fh_pre_ctime = stat.ctime;
-		fhp->fh_pre_size  = stat.size;
+	err = fh_getattr(fhp, &stat);
+	if (err) {
+		/* Grab the times from inode anyway */
+		stat.mtime = inode->i_mtime;
+		stat.ctime = inode->i_ctime;
+		stat.size  = inode->i_size;
 	}
 	if (v4)
 		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 
+	fhp->fh_pre_mtime = stat.mtime;
+	fhp->fh_pre_ctime = stat.ctime;
+	fhp->fh_pre_size  = stat.size;
 	fhp->fh_pre_saved = true;
 }
 
@@ -530,6 +523,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	struct inode *inode = d_inode(fhp->fh_dentry);
+	__be32 err;
 
 	if (fhp->fh_no_wcc)
 		return;
@@ -537,16 +531,12 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	fhp->fh_post_saved = true;
-
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &fhp->fh_post_attr);
-
-		if (err) {
-			fhp->fh_post_saved = false;
-			fhp->fh_post_attr.ctime = inode->i_ctime;
-		}
-	}
+	err = fh_getattr(fhp, &fhp->fh_post_attr);
+	if (err) {
+		fhp->fh_post_saved = false;
+		fhp->fh_post_attr.ctime = inode->i_ctime;
+	} else
+		fhp->fh_post_saved = true;
 	if (v4)
 		fhp->fh_post_change =
 			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
-- 
2.43.0



