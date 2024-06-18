Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87701514FF;
	Tue, 18 Jun 2024 12:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715126; cv=none; b=ZSG4yH1+xUb9aaVG6HglA3er9O6CLlOCdEtZVju+pnssJwGdo+/uWNaG18mlPoPehtnkZ8eC/15PbLeaVXS30dNHdc3mQUGlX5L2g4OTlMF9xwC2uT76JCE4Kq0MTUzAlNFdyBTiignrV4LU4QLOj1NZB06Nr6ltrrizzF2+TI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715126; c=relaxed/simple;
	bh=QxKARA72AY43ROHZZyklgS82OjuwYwj4foXElY9CctM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrSYlFyY5foxI56O1EdRdwORjYYgWtNsU8JysW9ZwbYxskGalaqVsXBZ72qzWqyyMbvjHqV25yXhC48f6HtvP9nff8fatR8So3GaGJvUSD/uFfKNH4MWrae8bpnHz1nIfpwvgVFzvW2tVp6jopNE5iR1/I13qngohfZnwaeWxzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQxECIr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQxECIr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA52C3277B;
	Tue, 18 Jun 2024 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715126;
	bh=QxKARA72AY43ROHZZyklgS82OjuwYwj4foXElY9CctM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQxECIr5aa1aQrCaj4KgdPS6qXhV+QgTOZF78XWRH0paxtjmeeoQKKgDhUAq58Gj4
	 ZoiHvcJtfV/ludrN1+urj8djqNheuDb9Bx+qle+nCjov+Vx7bEFLlB9QwV67eK1LgX
	 Nz1mAu2dqsR4t5cl0J6nd/ch7Q6+eskCDVJMbnJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/770] NFSD: Update the NFSv3 READLINK3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:55 +0200
Message-ID: <20240618123415.074370032@linuxfoundation.org>
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

[ Upstream commit 9a9c8923b3efd593d0e6a405efef9d58c6e6804b ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  5 +++--
 fs/nfsd/nfs3xdr.c  | 34 ++++++++++++++++++----------------
 fs/nfsd/xdr3.h     |  1 +
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 60e8c25be7571..e8d772f2c7769 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -126,14 +126,15 @@ nfsd3_proc_readlink(struct svc_rqst *rqstp)
 {
 	struct nfsd_fhandle *argp = rqstp->rq_argp;
 	struct nfsd3_readlinkres *resp = rqstp->rq_resp;
-	char *buffer = page_address(*(rqstp->rq_next_page++));
 
 	dprintk("nfsd: READLINK(3) %s\n", SVCFH_fmt(&argp->fh));
 
 	/* Read the symlink. */
 	fh_copy(&resp->fh, &argp->fh);
 	resp->len = NFS3_MAXPATHLEN;
-	resp->status = nfsd_readlink(rqstp, &resp->fh, buffer, &resp->len);
+	resp->pages = rqstp->rq_next_page++;
+	resp->status = nfsd_readlink(rqstp, &resp->fh,
+				     page_address(*resp->pages), &resp->len);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 29b923a497f48..352691c3e246a 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -977,26 +977,28 @@ nfs3svc_encode_accessres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_readlinkres *resp = rqstp->rq_resp;
 	struct kvec *head = rqstp->rq_res.head;
 
-	*p++ = resp->status;
-	p = encode_post_op_attr(rqstp, p, &resp->fh);
-	if (resp->status == 0) {
-		*p++ = htonl(resp->len);
-		xdr_ressize_check(rqstp, p);
-		rqstp->rq_res.page_len = resp->len;
-		if (resp->len & 3) {
-			/* need to pad the tail */
-			rqstp->rq_res.tail[0].iov_base = p;
-			*p = 0;
-			rqstp->rq_res.tail[0].iov_len = 4 - (resp->len&3);
-		}
-		if (svc_encode_result_payload(rqstp, head->iov_len, resp->len))
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
-		return 1;
-	} else
-		return xdr_ressize_check(rqstp, p);
+		if (xdr_stream_encode_u32(xdr, resp->len) < 0)
+			return 0;
+		xdr_write_pages(xdr, resp->pages, 0, resp->len);
+		if (svc_encode_result_payload(rqstp, head->iov_len, resp->len) < 0)
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+	}
+
+	return 1;
 }
 
 /* READ */
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 7db4ee17aa209..1d633c5d5fa28 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -137,6 +137,7 @@ struct nfsd3_readlinkres {
 	__be32			status;
 	struct svc_fh		fh;
 	__u32			len;
+	struct page		**pages;
 };
 
 struct nfsd3_readres {
-- 
2.43.0



