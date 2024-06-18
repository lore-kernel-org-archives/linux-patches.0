Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8780513DDDF;
	Tue, 18 Jun 2024 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714805; cv=none; b=FgxBwfBJdD+zKor2eY8blXv6hH1PToBSa8WKoBApXBwZto9xMsX1ETcQDUBhR3zEJiVEuTgxJIccoXhmYS3qi4+mBLiPr94o2voVF9zup7XlTS6XsDxQLgguSdSYzAvNKxHTY9QmrgYZnwFzTNwmAqvA3UkieXVcdAhxg7OW0SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714805; c=relaxed/simple;
	bh=EznVb2W/h9NrY9y8qgdHHZjb6sYwNREYOQx41OZCfBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZOV9HJJfjuIt8VY78qYN/k+Ez8K7PxmofTpNEar2W7sF2ZcYvWvfW686k2Sl9Gw1SWBs0DBPJB0k3DqLECtmDU21JGg/wqsCUSTptRQgQgpFX0DbsFOlprLt92S4LqeCv/VvqrYzPx71mAcUf0dqm0dnBzSJVPZsK7k0kCTP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mxp5QDXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mxp5QDXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B344C3277B;
	Tue, 18 Jun 2024 12:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714805;
	bh=EznVb2W/h9NrY9y8qgdHHZjb6sYwNREYOQx41OZCfBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mxp5QDXaFMDg68Y7LSRDVYGvhMWjsAPQAXAevSkzEUEE+j2UYUjyiMtfFwG19E6U+
	 HqiFRWrsoBoVBhXe/rQHQKFKiHPK9VimmdqZDeniEoOhpMmOfAW+9NDLxcajdNienT
	 yMsziLOqB6UcnNyvsO/W7pbKNV4dbfh7ViCSWrlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daire Byrne <daire@dneg.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/770] nfsd: only call inode_query_iversion in the I_VERSION case
Date: Tue, 18 Jun 2024 14:29:07 +0200
Message-ID: <20240618123410.901675181@linuxfoundation.org>
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

[ Upstream commit 70b87f77294d16d3e567056ba4c9ee2b091a5b50 ]

inode_query_iversion() can modify i_version.  Depending on the exported
filesystem, that may not be safe.  For example, if you're re-exporting
NFS, NFS stores the server's change attribute in i_version and does not
expect it to be modified locally.  This has been observed causing
unnecessary cache invalidations.

The way a filesystem indicates that it's OK to call
inode_query_iverson() is by setting SB_I_VERSION.

So, move the I_VERSION check out of encode_change(), where it's used
only in GETATTR responses, to nfsd4_change_attribute(), which is
also called for pre- and post- operation attributes.

(Note we could also pull the NFSEXP_V4ROOT case into
nfsd4_change_attribute() as well.  That would actually be a no-op,
since pre/post attrs are only used for metadata-modifying operations,
and V4ROOT exports are read-only.  But we might make the change in
the future just for simplicity.)

Reported-by: Daire Byrne <daire@dneg.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c |  5 ++---
 fs/nfsd/nfs4xdr.c |  6 +-----
 fs/nfsd/nfsfh.h   | 14 ++++++++++----
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 0d75d201db1b3..5956b0317c55e 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -291,14 +291,13 @@ void fill_post_wcc(struct svc_fh *fhp)
 		printk("nfsd: inode locked twice during operation.\n");
 
 	err = fh_getattr(fhp, &fhp->fh_post_attr);
-	fhp->fh_post_change = nfsd4_change_attribute(&fhp->fh_post_attr,
-						     d_inode(fhp->fh_dentry));
 	if (err) {
 		fhp->fh_post_saved = false;
-		/* Grab the ctime anyway - set_change_info might use it */
 		fhp->fh_post_attr.ctime = d_inode(fhp->fh_dentry)->i_ctime;
 	} else
 		fhp->fh_post_saved = true;
+	fhp->fh_post_change = nfsd4_change_attribute(&fhp->fh_post_attr,
+						     d_inode(fhp->fh_dentry));
 }
 
 /*
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 315be1c1ab85c..bdcfb5f7021da 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2426,12 +2426,8 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
 	if (exp->ex_flags & NFSEXP_V4ROOT) {
 		*p++ = cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
 		*p++ = 0;
-	} else if (IS_I_VERSION(inode)) {
+	} else
 		p = xdr_encode_hyper(p, nfsd4_change_attribute(stat, inode));
-	} else {
-		*p++ = cpu_to_be32(stat->ctime.tv_sec);
-		*p++ = cpu_to_be32(stat->ctime.tv_nsec);
-	}
 	return p;
 }
 
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 56cfbc3615618..39d764b129fa3 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -261,10 +261,16 @@ static inline u64 nfsd4_change_attribute(struct kstat *stat,
 {
 	u64 chattr;
 
-	chattr =  stat->ctime.tv_sec;
-	chattr <<= 30;
-	chattr += stat->ctime.tv_nsec;
-	chattr += inode_query_iversion(inode);
+	if (IS_I_VERSION(inode)) {
+		chattr =  stat->ctime.tv_sec;
+		chattr <<= 30;
+		chattr += stat->ctime.tv_nsec;
+		chattr += inode_query_iversion(inode);
+	} else {
+		chattr = stat->ctime.tv_sec;
+		chattr <<= 32;
+		chattr += stat->ctime.tv_nsec;
+	}
 	return chattr;
 }
 
-- 
2.43.0



