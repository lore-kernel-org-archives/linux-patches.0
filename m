Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332B14F13D;
	Tue, 18 Jun 2024 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715035; cv=none; b=RLSpk9DBmGA3poUXPLlS7dd3FWOpFhaRbVxPCOTtg1ZAioX+idXo0r21zBCpeb2+7EGtI9hXSROJFSUWr49naBNr27VaoMnqMOhaxKhHs7LWTzQ8oitvO/jxaLWzxddd+Ln6sBxfg+7o0I74g+FxCaDjwLPDLbkDvbSnWRDbtvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715035; c=relaxed/simple;
	bh=bfuILI0o0j416LboOui9VQb3zc+I4euB5YSXSMVwKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7XY18NLJB7/pZBx16OIfIIV3WjzPH/NNe/JxRBBGRVRnpEcsHwixwrU3XkfmryDp8iWNs3KribVQTyI0j07Fb4US8xWsxWFSR28TkmQKorp20cTpv2iqdUFDCwBCITghvk5izSxGWSON46HuSlf8uFif13F64vowY2hpZ1J0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s92NGU1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s92NGU1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16D2C3277B;
	Tue, 18 Jun 2024 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715035;
	bh=bfuILI0o0j416LboOui9VQb3zc+I4euB5YSXSMVwKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s92NGU1SY/StXjnFFqHWikbJpveLpsS8UbYVZ7HxGo8mw31InNvd4wPSEmnB4mZ4s
	 qSYVHiUfpcra7A2xzaN1VdXYsQK3wuS6WndvFRCdTkZeL3TgthGqMMSEZvN6LplrAo
	 3oJjvISCWHfLvM7mKNc6LxpSR3DTTtxDzhvMs42I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/770] NFSD: Clean up after updating NFSv2 ACL decoders
Date: Tue, 18 Jun 2024 14:30:24 +0200
Message-ID: <20240618123413.871081423@linuxfoundation.org>
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

[ Upstream commit baadce65d6ee3032b921d9c043ba808bc69d6b13 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 18 ------------------
 fs/nfsd/xdr.h    |  1 -
 2 files changed, 19 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 5ab9fc14816c2..5d79ef6a0c7fc 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -26,18 +26,6 @@ static u32	nfs_ftypes[] = {
  * Basic NFSv2 data types (RFC 1094 Section 2.3)
  */
 
-static __be32 *
-decode_fh(__be32 *p, struct svc_fh *fhp)
-{
-	fh_init(fhp, NFS_FHSIZE);
-	memcpy(&fhp->fh_handle.fh_base, p, NFS_FHSIZE);
-	fhp->fh_handle.fh_size = NFS_FHSIZE;
-
-	/* FIXME: Look up export pointer here and verify
-	 * Sun Secure RPC if requested */
-	return p + (NFS_FHSIZE >> 2);
-}
-
 /**
  * svcxdr_decode_fhandle - Decode an NFSv2 file handle
  * @xdr: XDR stream positioned at an encoded NFSv2 FH
@@ -62,12 +50,6 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp)
 	return true;
 }
 
-/* Helper function for NFSv2 ACL code */
-__be32 *nfs2svc_decode_fh(__be32 *p, struct svc_fh *fhp)
-{
-	return decode_fh(p, fhp);
-}
-
 static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 77afad72c2aa1..b92f1acec9e77 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -164,7 +164,6 @@ void nfssvc_release_readres(struct svc_rqst *rqstp);
 
 /* Helper functions for NFSv2 ACL code */
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat);
-__be32 *nfs2svc_decode_fh(__be32 *p, struct svc_fh *fhp);
 bool svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp);
 
 #endif /* LINUX_NFSD_H */
-- 
2.43.0



