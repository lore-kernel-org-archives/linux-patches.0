Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4D714F108;
	Tue, 18 Jun 2024 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715200; cv=none; b=hg8xlIAHAR3mnicWPQK+309PB+1V37bvNMh3wsFp1QeypIfelINV3Bq+ohECM1FSm1X0v7oG6GPcVPNKlZORFGV95RdgUnJd1S/AGeKHmZi6Ph2Jlwa3Ja4JTnoRhFpT9NN/66qXXYkPPlEuPqufw6d2atOt+8BOIO0GPrvo56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715200; c=relaxed/simple;
	bh=UCsYtLX3RoWMPO2iRyJVwBT22ump4dYMspFdIQteoTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoorgRTStTvs5V8yYVsnxLBTohxUmuQ03RNsBH5qN34KlrH62htuz33Sv3xkxNfUhtvUk8WEARCGbIUmorFM74e3hsI9HfLIq8GmSpq44ZptrU1KWWyjpHH8eO/2hDIc+fX6zQk8Edsn/D8kwdXKH/twntFab5jGn1y6JJBvdnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGcN3wgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGcN3wgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247E9C3277B;
	Tue, 18 Jun 2024 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715200;
	bh=UCsYtLX3RoWMPO2iRyJVwBT22ump4dYMspFdIQteoTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGcN3wgEem1znFhhD318eoXk1bHkNtDSA0MvRFhqngLc/kTqf0JM8jgWJo90ZOqEb
	 iO+z+r2Z49I0Clo9RXO6AxO2q6G0Jzz905YBKVo1ZOsLLTA8/yb56T3RSlGfBtuC4j
	 6MMnZtuqkFbWWBKLlhe1VrNtOEmJqfp/lKKPKag0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/770] NFSD: Remove unused NFSv2 directory entry encoders
Date: Tue, 18 Jun 2024 14:31:21 +0200
Message-ID: <20240618123416.082635406@linuxfoundation.org>
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

[ Upstream commit 8a2cf9f5709cc20a1114a7d22655928314fc86f8 ]

Clean up.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  2 +-
 fs/nfsd/nfsxdr.c  | 51 +++--------------------------------------------
 fs/nfsd/xdr.h     | 10 ++--------
 3 files changed, 6 insertions(+), 57 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 135c0bc468bce..72f8bc4a7ea48 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -602,7 +602,7 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 	resp->cookie_offset = 0;
 	offset = argp->cookie;
 	resp->status = nfsd_readdir(rqstp, &argp->fh, &offset,
-				    &resp->common, nfs2svc_encode_entry);
+				    &resp->common, nfssvc_encode_entry);
 	nfssvc_encode_nfscookie(resp, offset);
 
 	fh_put(&argp->fh);
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 1102d40ded03f..5df6f00d76fd5 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -663,7 +663,7 @@ svcxdr_encode_entry_common(struct nfsd_readdirres *resp, const char *name,
 }
 
 /**
- * nfs2svc_encode_entry - encode one NFSv2 READDIR entry
+ * nfssvc_encode_entry - encode one NFSv2 READDIR entry
  * @data: directory context
  * @name: name of the object to be encoded
  * @namlen: length of that name, in bytes
@@ -680,8 +680,8 @@ svcxdr_encode_entry_common(struct nfsd_readdirres *resp, const char *name,
  *   - resp->common.err
  *   - resp->cookie_offset
  */
-int nfs2svc_encode_entry(void *data, const char *name, int namlen,
-			 loff_t offset, u64 ino, unsigned int d_type)
+int nfssvc_encode_entry(void *data, const char *name, int namlen,
+			loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct readdir_cd *ccd = data;
 	struct nfsd_readdirres *resp = container_of(ccd,
@@ -706,51 +706,6 @@ int nfs2svc_encode_entry(void *data, const char *name, int namlen,
 	return -EINVAL;
 }
 
-int
-nfssvc_encode_entry(void *ccdv, const char *name,
-		    int namlen, loff_t offset, u64 ino, unsigned int d_type)
-{
-	struct readdir_cd *ccd = ccdv;
-	struct nfsd_readdirres *cd = container_of(ccd, struct nfsd_readdirres, common);
-	__be32	*p = cd->buffer;
-	int	buflen, slen;
-
-	/*
-	dprintk("nfsd: entry(%.*s off %ld ino %ld)\n",
-			namlen, name, offset, ino);
-	 */
-
-	if (offset > ~((u32) 0)) {
-		cd->common.err = nfserr_fbig;
-		return -EINVAL;
-	}
-	nfssvc_encode_nfscookie(cd, offset);
-
-	/* truncate filename */
-	namlen = min(namlen, NFS2_MAXNAMLEN);
-	slen = XDR_QUADLEN(namlen);
-
-	if ((buflen = cd->buflen - slen - 4) < 0) {
-		cd->common.err = nfserr_toosmall;
-		return -EINVAL;
-	}
-	if (ino > ~((u32) 0)) {
-		cd->common.err = nfserr_fbig;
-		return -EINVAL;
-	}
-	*p++ = xdr_one;				/* mark entry present */
-	*p++ = htonl((u32) ino);		/* file id */
-	p    = xdr_encode_array(p, name, namlen);/* name length & name */
-	cd->offset = p;			/* remember pointer */
-	*p++ = htonl(~0U);		/* offset of next entry */
-
-	cd->count += p - cd->buffer;
-	cd->buflen = buflen;
-	cd->buffer = p;
-	cd->common.err = nfs_ok;
-	return 0;
-}
-
 /*
  * XDR release functions
  */
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index a065852c9ea86..10f3bd25e8ccc 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -115,10 +115,6 @@ struct nfsd_readdirres {
 	struct xdr_stream	xdr;
 	struct xdr_buf		dirlist;
 	struct readdir_cd	common;
-	__be32 *		buffer;
-	int			buflen;
-	__be32 *		offset;
-	struct page		*page;
 	unsigned int		cookie_offset;
 };
 
@@ -164,10 +160,8 @@ int nfssvc_encode_statfsres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *);
 
 void nfssvc_encode_nfscookie(struct nfsd_readdirres *resp, u32 offset);
-int nfs2svc_encode_entry(void *data, const char *name, int namlen,
-			 loff_t offset, u64 ino, unsigned int d_type);
-int nfssvc_encode_entry(void *, const char *name,
-			int namlen, loff_t offset, u64 ino, unsigned int);
+int nfssvc_encode_entry(void *data, const char *name, int namlen,
+			loff_t offset, u64 ino, unsigned int d_type);
 
 void nfssvc_release_attrstat(struct svc_rqst *rqstp);
 void nfssvc_release_diropres(struct svc_rqst *rqstp);
-- 
2.43.0



