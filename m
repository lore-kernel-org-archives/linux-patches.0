Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1E15099C;
	Tue, 18 Jun 2024 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715082; cv=none; b=fy3y52V+TfTz7U1UQzrMWWg6RwzvISOn2QLETPIJnKBkSPMnJkoVyZebXBswKsI62aUcUWFzVLqizaDe/BBmWd6iyPznlurQEQs4i4Q+XHpvBAzi6vDQnqZJ5YrucfLtOro73StdBR6Atm0zYofuaxbU/1XcXksWuKW4jwWGwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715082; c=relaxed/simple;
	bh=YBtO0njoL3x0fvyy4GKu4E3KCM2DYO8t077Bjrqjs8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTkvNliSdL0ErHgJ4pqmqT3nhspbOXflNxk6ODT9wa7Y+yGse/pfsKk+n8qRASn1BV8m865MTpTbu9KBCGZBj+kaB5vkQsqeFxs4I+heXoVHSp6pBMr0VB0telsEDuegon8LtJuiwX9ay+PQLWNMLQbIkNMLoGU3Kt5fGP7kE0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zi8FHVhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zi8FHVhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71F8C3277B;
	Tue, 18 Jun 2024 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715082;
	bh=YBtO0njoL3x0fvyy4GKu4E3KCM2DYO8t077Bjrqjs8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zi8FHVheqwePI1mNsApshpT2Ubs7mm9SCkf5jLAdIP2n5DcE/3dsl6RyC9D9q6aUU
	 zN9qWhiADqyYG11V6IcC81d/ZfdAhxj88NRqBxMjnK/4TPU40EyhNbao7fGOxdNJX+
	 xeCkpM/o9HCUX4so1g/M7+4prtO8OBw9UMyacnbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/770] nfsd: skip some unnecessary stats in the v4 case
Date: Tue, 18 Jun 2024 14:30:42 +0200
Message-ID: <20240618123414.571009419@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 428a23d2bf0ca8fd4d364a464c3e468f0e81671e ]

In the typical case of v4 and an i_version-supporting filesystem, we can
skip a stat which is only required to fake up a change attribute from
ctime.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 00a96054280a6..9d9a01ce0b270 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -364,6 +364,11 @@ encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 	return encode_post_op_attr(rqstp, p, fhp);
 }
 
+static bool fs_supports_change_attribute(struct super_block *sb)
+{
+	return sb->s_flags & SB_I_VERSION || sb->s_export_op->fetch_iversion;
+}
+
 /*
  * Fill in the pre_op attr for the wcc data
  */
@@ -372,24 +377,26 @@ void fill_pre_wcc(struct svc_fh *fhp)
 	struct inode    *inode;
 	struct kstat	stat;
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
-	__be32 err;
 
 	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return;
 	inode = d_inode(fhp->fh_dentry);
-	err = fh_getattr(fhp, &stat);
-	if (err) {
-		/* Grab the times from inode anyway */
-		stat.mtime = inode->i_mtime;
-		stat.ctime = inode->i_ctime;
-		stat.size  = inode->i_size;
+	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
+		__be32 err = fh_getattr(fhp, &stat);
+
+		if (err) {
+			/* Grab the times from inode anyway */
+			stat.mtime = inode->i_mtime;
+			stat.ctime = inode->i_ctime;
+			stat.size  = inode->i_size;
+		}
+		fhp->fh_pre_mtime = stat.mtime;
+		fhp->fh_pre_ctime = stat.ctime;
+		fhp->fh_pre_size  = stat.size;
 	}
 	if (v4)
 		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 
-	fhp->fh_pre_mtime = stat.mtime;
-	fhp->fh_pre_ctime = stat.ctime;
-	fhp->fh_pre_size  = stat.size;
 	fhp->fh_pre_saved = true;
 }
 
@@ -400,7 +407,6 @@ void fill_post_wcc(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	struct inode *inode = d_inode(fhp->fh_dentry);
-	__be32 err;
 
 	if (fhp->fh_no_wcc)
 		return;
@@ -408,12 +414,16 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	err = fh_getattr(fhp, &fhp->fh_post_attr);
-	if (err) {
-		fhp->fh_post_saved = false;
-		fhp->fh_post_attr.ctime = inode->i_ctime;
-	} else
-		fhp->fh_post_saved = true;
+	fhp->fh_post_saved = true;
+
+	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
+		__be32 err = fh_getattr(fhp, &fhp->fh_post_attr);
+
+		if (err) {
+			fhp->fh_post_saved = false;
+			fhp->fh_post_attr.ctime = inode->i_ctime;
+		}
+	}
 	if (v4)
 		fhp->fh_post_change =
 			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
-- 
2.43.0



