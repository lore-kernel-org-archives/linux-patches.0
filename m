Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F53D14F9E2;
	Tue, 18 Jun 2024 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715129; cv=none; b=nKIAnjghd2gr2aZcRzl8xulPIkyg4Lyepjvm91kioWKMNP+lVH+qounAK4dBNvbVZGwc0P0ldJ1gr7CooGe9zX7KF4D83QTKpg2aTJSrflVyqaMGzl9s7ohv4yuU6vzW8XJ+tfRt9Ei8Tci6aX0dXPyQZ9M7FX2QtfdBIemD0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715129; c=relaxed/simple;
	bh=h5DiY32GF4BMg0F5XFD5A0gRABeNm52/bymnjIW5Rx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6Auuc0cVjQU3DHfbMvfuk9vtQBKhWjBUIzWtfD1EXBX8y0eMU6l61Vyi/nV8FEBUFUeoyb/uljEGbsFfDdDlIWCEsS/5FwGsAiM/72etw8oU2/xeCkP5YWrFK079baaInnYtCrGJDJNDtluij8agUSjUR9vQj74xFO6QEm6Sng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDA6uYwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDA6uYwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067F8C3277B;
	Tue, 18 Jun 2024 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715129;
	bh=h5DiY32GF4BMg0F5XFD5A0gRABeNm52/bymnjIW5Rx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDA6uYwAH3+5lM+RsoWHb4G55clyCP4Dh0vOZnWLf/nEh3RInCQzzs9q4WdU/ZpvA
	 7UyjSJWt6X0OJzC/ALocgAERnXbwtkiJ2MzmTCz4hGKkp6vOlUVnUMBCY3JR7Mm5VD
	 7HzcUUGwZtdMgzaHADW+uHEF4RQ2T44VzT3PY8ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/770] NFSD: Update the NFSv3 READ3res encode to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:56 +0200
Message-ID: <20240618123415.113237192@linuxfoundation.org>
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

[ Upstream commit cc9bcdad7773c295375e66c892c7ac00524706f2 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c         |  1 +
 fs/nfsd/nfs3xdr.c          | 43 ++++++++++++++++++++------------------
 fs/nfsd/xdr3.h             |  1 +
 include/linux/sunrpc/xdr.h | 20 ++++++++++++++++++
 4 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index e8d772f2c7769..201f2009b540b 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -159,6 +159,7 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 
 	v = 0;
 	len = argp->count;
+	resp->pages = rqstp->rq_next_page;
 	while (len > 0) {
 		struct page *page = *(rqstp->rq_next_page++);
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 352691c3e246a..859cc6c51c1a5 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1005,30 +1005,33 @@ nfs3svc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_readres *resp = rqstp->rq_resp;
 	struct kvec *head = rqstp->rq_res.head;
 
-	*p++ = resp->status;
-	p = encode_post_op_attr(rqstp, p, &resp->fh);
-	if (resp->status == 0) {
-		*p++ = htonl(resp->count);
-		*p++ = htonl(resp->eof);
-		*p++ = htonl(resp->count);	/* xdr opaque count */
-		xdr_ressize_check(rqstp, p);
-		/* now update rqstp->rq_res to reflect data as well */
-		rqstp->rq_res.page_len = resp->count;
-		if (resp->count & 3) {
-			/* need to pad the tail */
-			rqstp->rq_res.tail[0].iov_base = p;
-			*p = 0;
-			rqstp->rq_res.tail[0].iov_len = 4 - (resp->count & 3);
-		}
-		if (svc_encode_result_payload(rqstp, head->iov_len,
-					      resp->count))
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
-		return 1;
-	} else
-		return xdr_ressize_check(rqstp, p);
+		if (xdr_stream_encode_u32(xdr, resp->count) < 0)
+			return 0;
+		if (xdr_stream_encode_bool(xdr, resp->eof) < 0)
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->count) < 0)
+			return 0;
+		xdr_write_pages(xdr, resp->pages, rqstp->rq_res.page_base,
+				resp->count);
+		if (svc_encode_result_payload(rqstp, head->iov_len, resp->count) < 0)
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+	}
+
+	return 1;
 }
 
 /* WRITE */
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 1d633c5d5fa28..8073350418ae0 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -145,6 +145,7 @@ struct nfsd3_readres {
 	struct svc_fh		fh;
 	unsigned long		count;
 	__u32			eof;
+	struct page		**pages;
 };
 
 struct nfsd3_writeres {
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index eba6204330b3c..237b78146c7d6 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -394,6 +394,26 @@ static inline int xdr_stream_encode_item_absent(struct xdr_stream *xdr)
 	return len;
 }
 
+/**
+ * xdr_stream_encode_bool - Encode a "not present" list item
+ * @xdr: pointer to xdr_stream
+ * @n: boolean value to encode
+ *
+ * Return values:
+ *   On success, returns length in bytes of XDR buffer consumed
+ *   %-EMSGSIZE on XDR buffer overflow
+ */
+static inline int xdr_stream_encode_bool(struct xdr_stream *xdr, __u32 n)
+{
+	const size_t len = XDR_UNIT;
+	__be32 *p = xdr_reserve_space(xdr, len);
+
+	if (unlikely(!p))
+		return -EMSGSIZE;
+	*p = n ? xdr_one : xdr_zero;
+	return len;
+}
+
 /**
  * xdr_stream_encode_u32 - Encode a 32-bit integer
  * @xdr: pointer to xdr_stream
-- 
2.43.0



