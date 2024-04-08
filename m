Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333527F48D;
	Mon,  8 Apr 2024 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583089; cv=none; b=BqMR5FUXXlrjFMnXFu5kAZ7kXmIjW2AqMmoq3IoHF8JjE3UjCTWCBC4KyAo5J79A9fwU2MCqeKdDwExvquO5BkU8ltSRRh8n9EpIe4YwaiymIJ0OEKiCiNzds2oGtG9cLS8l5ILbNIvFDpKX0iVEfAbTEUAQa4PNAH7Q7Pui5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583089; c=relaxed/simple;
	bh=92oUQXEkZo58jEUNkiLLvWy19KhlnFRhXGZNxdoSu4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skNc1CBLKwj4vY4cCPWQVs3tvXcSEH412DrqmxQyUgxLxOBmfgwm7ePs1XSLS1HZlq9fdLrnYGCLsmiqxURfnJpVI6XYXbOqQpLtNdq7x+67G7F+5CAHm9tmrlX8iIvL5fxmRyIhSxOoBsE7Ef91GI2XOFNSP1cdNrfQ9KJCbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfmuYkI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfmuYkI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A28C433C7;
	Mon,  8 Apr 2024 13:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583089;
	bh=92oUQXEkZo58jEUNkiLLvWy19KhlnFRhXGZNxdoSu4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfmuYkI9SkyoVUajBPbRtOU2/nHadO4WYZnIjbNy5gHdWpJD1tdVRJ98kq7vCiU1x
	 f0cDC5AOkNknEDjy6apjyL8v3vBjH/O0rSyOtKvrGkW4RBCPEBywvoYfIVh+atJCwD
	 GhwUxC6yYJy1539veoB/kV4Y+Xb7sqhBM3E2PJzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.15 206/690] NFSD: Save location of NFSv4 COMPOUND status
Date: Mon,  8 Apr 2024 14:51:12 +0200
Message-ID: <20240408125406.995097266@linuxfoundation.org>
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

[ Upstream commit 3b0ebb255fdc49a3d340846deebf045ef58ec744 ]

Refactor: Currently nfs4svc_encode_compoundres() relies on the NFS
dispatcher to pass in the buffer location of the COMPOUND status.
Instead, save that buffer location in struct nfsd4_compoundres.

The compound tag follows immediately after.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 2 +-
 fs/nfsd/nfs4xdr.c  | 9 +++++++--
 fs/nfsd/xdr4.h     | 3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index bc7ae9a8604ec..002473c59fc6f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2462,11 +2462,11 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	__be32		status;
 
 	resp->xdr = &rqstp->rq_res_stream;
+	resp->statusp = resp->xdr->p;
 
 	/* reserve space for: NFS status code */
 	xdr_reserve_space(resp->xdr, XDR_UNIT);
 
-	resp->tagp = resp->xdr->p;
 	/* reserve space for: taglen, tag, and opcnt */
 	xdr_reserve_space(resp->xdr, XDR_UNIT * 2 + args->taglen);
 	resp->taglen = args->taglen;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9fcaf5f93f75d..e94f57f174f12 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5436,11 +5436,16 @@ nfs4svc_encode_compoundres(struct svc_rqst *rqstp, __be32 *p)
 	WARN_ON_ONCE(buf->len != buf->head[0].iov_len + buf->page_len +
 				 buf->tail[0].iov_len);
 
-	*p = resp->cstate.status;
+	/*
+	 * Send buffer space for the following items is reserved
+	 * at the top of nfsd4_proc_compound().
+	 */
+	p = resp->statusp;
+
+	*p++ = resp->cstate.status;
 
 	rqstp->rq_next_page = resp->xdr->page_ptr + 1;
 
-	p = resp->tagp;
 	*p++ = htonl(resp->taglen);
 	memcpy(p, resp->tag, resp->taglen);
 	p += XDR_QUADLEN(resp->taglen);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 50242d8cd09e8..f20c1ae97fec5 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -703,10 +703,11 @@ struct nfsd4_compoundres {
 	struct xdr_stream		*xdr;
 	struct svc_rqst *		rqstp;
 
+	__be32				*statusp;
 	u32				taglen;
 	char *				tag;
 	u32				opcnt;
-	__be32 *			tagp; /* tag, opcount encode location */
+
 	struct nfsd4_compound_state	cstate;
 };
 
-- 
2.43.0



