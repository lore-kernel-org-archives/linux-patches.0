Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2C015B112;
	Tue, 18 Jun 2024 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715114; cv=none; b=Sbv67odhYxu6J/eBt3Eqsg2uJH2g4weX5Lbf7lNqbL9VfDkr6PdP46DYn/2jcHVd9kmco4Oia38CnyES2owDJNxllHjKM/1FmN2l12jX1Mf5jrICxJB013Z4E7Vzc0IOnZy+HzBfMye/SQ1YpKA9Q92rVW4mkT17vTWehOdGKQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715114; c=relaxed/simple;
	bh=08nC+NxX0vp/nvE1lPlZrIuXTLogBjvZXUrHBLsl+OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHTvFlv6mR+v0FhFfMIVoZRt4gA01v4s9e0TR496FSKUcSnUp8y4J/WTEd8QJpvaVTUfy5Wlp/b2cVDM3GUDOhQJZ69L+LlSAFO4X7YnTwFXlFyV5mg0E2ql7Up+l6RnxxNLox0mUuLGXC6O6uiP4FEnfOLAAAPmXp0cFtUNJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPLynaIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPLynaIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD49C32786;
	Tue, 18 Jun 2024 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715114;
	bh=08nC+NxX0vp/nvE1lPlZrIuXTLogBjvZXUrHBLsl+OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPLynaIBEOuqb9fQEfmrEZWzRBaCyBdNFj5Dszo0JdkDMzP64PCLRAjnBFjWsk87n
	 kX3qZZjKeyJsfPMSfJ7sJgXq2cqWnttOO8/0z4Xgk0YOnYE1yPinxLoCnd13JpveZL
	 x0fdtXLrH3iIT9TzlZxxVVDAlPJ79F+UB71bnEuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/770] NFSD: Update the NFSv3 ACCESS3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:52 +0200
Message-ID: <20240618123414.958762605@linuxfoundation.org>
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

[ Upstream commit 907c38227fb57f5c537491ca76dd0b9636029393 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 50 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/nfsd/vfs.h     |  2 +-
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 75739861d235e..9d6c989df6d8d 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -383,6 +383,35 @@ encode_saved_post_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 	return encode_fattr3(rqstp, p, fhp, &fhp->fh_post_attr);
 }
 
+static bool
+svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+			   const struct svc_fh *fhp)
+{
+	struct dentry *dentry = fhp->fh_dentry;
+	struct kstat stat;
+
+	/*
+	 * The inode may be NULL if the call failed because of a
+	 * stale file handle. In this case, no attributes are
+	 * returned.
+	 */
+	if (fhp->fh_no_wcc || !dentry || !d_really_is_positive(dentry))
+		goto no_post_op_attrs;
+	if (fh_getattr(fhp, &stat) != nfs_ok)
+		goto no_post_op_attrs;
+
+	if (xdr_stream_encode_item_present(xdr) < 0)
+		return false;
+	lease_get_mtime(d_inode(dentry), &stat.mtime);
+	if (!svcxdr_encode_fattr3(rqstp, xdr, fhp, &stat))
+		return false;
+
+	return true;
+
+no_post_op_attrs:
+	return xdr_stream_encode_item_absent(xdr) > 0;
+}
+
 /*
  * Encode post-operation attributes.
  * The inode may be NULL if the call failed because of a stale file
@@ -835,13 +864,24 @@ nfs3svc_encode_diropres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_accessres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_accessres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_post_op_attr(rqstp, p, &resp->fh);
-	if (resp->status == 0)
-		*p++ = htonl(resp->access);
-	return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->access) < 0)
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+	}
+
+	return 1;
 }
 
 /* READLINK */
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index a2442ebe5acf6..b21b76e6b9a87 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -152,7 +152,7 @@ static inline void fh_drop_write(struct svc_fh *fh)
 	}
 }
 
-static inline __be32 fh_getattr(struct svc_fh *fh, struct kstat *stat)
+static inline __be32 fh_getattr(const struct svc_fh *fh, struct kstat *stat)
 {
 	struct path p = {.mnt = fh->fh_export->ex_path.mnt,
 			 .dentry = fh->fh_dentry};
-- 
2.43.0



