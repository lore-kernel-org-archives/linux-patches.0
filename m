Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B4116A945;
	Tue, 18 Jun 2024 12:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715239; cv=none; b=uEthe/ctg8mLqNUvVJFm3E3pfRODfrjuLLF39HGPUsvE/3NKfULVDkr9SAAc6KZGBa48u18G9TVlNF90ivgv10ujPT6H5q5phzT8aBsD+fi9wVKtr/MXSzLaRyFwcBLyY7PGbp+ZXxKv/b6bdSEiMPO2ZBlx+vZttKtibjaPKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715239; c=relaxed/simple;
	bh=Jc0rGx6QIr8b5K08rBYASYTVpotBj1oVjINzAvI1fuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLj8AUymEDKd+kLG7rHvagITn14oeF0aXAdXJfMBGk3ahtPqsJLl8DepYtJeYXwN7Bsc6qHfCqrpoPYyQvrhIhvzUEpBIEP0V7NSa58eExXJmXik70hhHpiJblUiEebrQf9T62f4zl4KypJMJNf3QMGmhlDXi1JEFJLT+zgY21A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2G/QrK/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2G/QrK/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FCBC3277B;
	Tue, 18 Jun 2024 12:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715238;
	bh=Jc0rGx6QIr8b5K08rBYASYTVpotBj1oVjINzAvI1fuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2G/QrK/Od0jNHo0oj41hltDNKGOni+2Z8B8/uv9gFeSpWI7inzF9BbEYHig7W8BmU
	 aYXYOslDZolodgYFOF05+uvdnn2gOtJaw+lOk8powJHN78TwEANplu1zprn1E/CZdj
	 tTDsXjnGII7WHx9kKGWBxRKqsbndbttgeOfpVW8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/770] NFSD: Update the NFSv3 PATHCONF3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:03 +0200
Message-ID: <20240618123415.381394508@linuxfoundation.org>
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

[ Upstream commit ded04a587f6ceaaba3caefad4021f2212b46c9ff ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c          | 44 ++++++++++++++++++++++++++++----------
 include/linux/sunrpc/xdr.h | 18 ++++++++++++++--
 2 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 514f53ad73020..1467bba02e180 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1501,25 +1501,47 @@ nfs3svc_encode_fsinfores(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+static bool
+svcxdr_encode_pathconf3resok(struct xdr_stream *xdr,
+			     const struct nfsd3_pathconfres *resp)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 6);
+	if (!p)
+		return false;
+	*p++ = cpu_to_be32(resp->p_link_max);
+	*p++ = cpu_to_be32(resp->p_name_max);
+	p = xdr_encode_bool(p, resp->p_no_trunc);
+	p = xdr_encode_bool(p, resp->p_chown_restricted);
+	p = xdr_encode_bool(p, resp->p_case_insensitive);
+	xdr_encode_bool(p, resp->p_case_preserving);
+
+	return true;
+}
+
 /* PATHCONF */
 int
 nfs3svc_encode_pathconfres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_pathconfres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	*p++ = xdr_zero;	/* no post_op_attr */
-
-	if (resp->status == 0) {
-		*p++ = htonl(resp->p_link_max);
-		*p++ = htonl(resp->p_name_max);
-		*p++ = htonl(resp->p_no_trunc);
-		*p++ = htonl(resp->p_chown_restricted);
-		*p++ = htonl(resp->p_case_insensitive);
-		*p++ = htonl(resp->p_case_preserving);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
+		if (!svcxdr_encode_pathconf3resok(xdr, resp))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
 	}
 
-	return xdr_ressize_check(rqstp, p);
+	return 1;
 }
 
 /* COMMIT */
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 237b78146c7d6..927f1458bcab9 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -395,7 +395,21 @@ static inline int xdr_stream_encode_item_absent(struct xdr_stream *xdr)
 }
 
 /**
- * xdr_stream_encode_bool - Encode a "not present" list item
+ * xdr_encode_bool - Encode a boolean item
+ * @p: address in a buffer into which to encode
+ * @n: boolean value to encode
+ *
+ * Return value:
+ *   Address of item following the encoded boolean
+ */
+static inline __be32 *xdr_encode_bool(__be32 *p, u32 n)
+{
+	*p = n ? xdr_one : xdr_zero;
+	return p++;
+}
+
+/**
+ * xdr_stream_encode_bool - Encode a boolean item
  * @xdr: pointer to xdr_stream
  * @n: boolean value to encode
  *
@@ -410,7 +424,7 @@ static inline int xdr_stream_encode_bool(struct xdr_stream *xdr, __u32 n)
 
 	if (unlikely(!p))
 		return -EMSGSIZE;
-	*p = n ? xdr_one : xdr_zero;
+	xdr_encode_bool(p, n);
 	return len;
 }
 
-- 
2.43.0



