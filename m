Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674037CF34;
	Mon,  8 Apr 2024 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584010; cv=none; b=nfDcIkWLOEW4GaGIW+TYjZx0mLXu9AODZBeHXNxPiw/ww67DZeKXC+/L36qs38wk+31Rnzb0YF0haNM9QTQVRU77vvKZAkYfuWY86a+U84uKLb+FxPlCJVvI+wpmmQlulZk4IpWxBDX1BQTrXaRiT1q7Cg31g9JdWUVr5YzwGnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584010; c=relaxed/simple;
	bh=jrClTXj2LdREau1vVBdevwG/xtUeifzonVO28MPtDAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHT4yKqGxNFDuQdq/kNyqjXudY4bAsUGGDAWVTy2k94+96FMV3chvOUmb0YyE3LpB7+6rn6qjp7bS/bZj1Tajj2IF8DJ3te87n3wE6KN/GoAUh3k9LFLeg6gyNIOAi6wmj+QmJ16X2a63jmsYJCfZTSCXtT+DDym9EJO0xZWb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATiHWxph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATiHWxph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E221EC433F1;
	Mon,  8 Apr 2024 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584010;
	bh=jrClTXj2LdREau1vVBdevwG/xtUeifzonVO28MPtDAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATiHWxphCRnofnbZoJJin1vEiYWi3KGlAGRaIrB6SGvrcgLEBwh3fMHaDokpzi896
	 x5ed/DMzsFg3tbL/cV21FRdNjiwNqWQTOQNo7s5tslkQnKRpx/rZTzdpbZnRcy2mDl
	 stn/5/OM2fno/EhxjYLZutXPl8tn8PJU+4yCN1Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 314/690] NFSD: Clean up nfsd3_proc_create()
Date: Mon,  8 Apr 2024 14:53:00 +0200
Message-ID: <20240408125410.979954471@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e61568599c9ad638fdaba150fee07d7065e31851 ]

As near as I can tell, mode bit masking and setting S_IFREG is
already done by do_nfsd_create() and vfs_create(). The NFSv4 path
(do_open_lookup), for example, does not bother with this special
processing.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3proc.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index eaf785aec0708..86163ecbb015d 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -229,8 +229,7 @@ nfsd3_proc_create(struct svc_rqst *rqstp)
 {
 	struct nfsd3_createargs *argp = rqstp->rq_argp;
 	struct nfsd3_diropres *resp = rqstp->rq_resp;
-	svc_fh		*dirfhp, *newfhp = NULL;
-	struct iattr	*attr;
+	svc_fh *dirfhp, *newfhp;
 
 	dprintk("nfsd: CREATE(3)   %s %.*s\n",
 				SVCFH_fmt(&argp->fh),
@@ -239,20 +238,9 @@ nfsd3_proc_create(struct svc_rqst *rqstp)
 
 	dirfhp = fh_copy(&resp->dirfh, &argp->fh);
 	newfhp = fh_init(&resp->fh, NFS3_FHSIZE);
-	attr   = &argp->attrs;
-
-	/* Unfudge the mode bits */
-	attr->ia_mode &= ~S_IFMT;
-	if (!(attr->ia_valid & ATTR_MODE)) { 
-		attr->ia_valid |= ATTR_MODE;
-		attr->ia_mode = S_IFREG;
-	} else {
-		attr->ia_mode = (attr->ia_mode & ~S_IFMT) | S_IFREG;
-	}
 
-	/* Now create the file and set attributes */
 	resp->status = do_nfsd_create(rqstp, dirfhp, argp->name, argp->len,
-				      attr, newfhp, argp->createmode,
+				      &argp->attrs, newfhp, argp->createmode,
 				      (u32 *)argp->verf, NULL, NULL);
 	return rpc_success;
 }
-- 
2.43.0



