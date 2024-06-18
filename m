Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BDE73461;
	Tue, 18 Jun 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715194; cv=none; b=BTRq1t0h8ZsyeS4rckd8uzkNSetRS/fXeE5SDZB/w0e8Pyr9UG0IHtvn0gj6lqe+tPicYQDOePCMh+aW9Haf7T3NPYOrxnKOW+2LODBE8eWt50eOYajJB9OQwMTmx//UWEq66/4kvkad+zfbjTAUUQ2UVfG4RGYzpXC+DvigXYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715194; c=relaxed/simple;
	bh=RGn5cOs7zeokAcy3K0qv1xgBh8sNNTZmjakrvTn+9IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuAV4Rlr4fcrnJBy3+hCPaWfcNs3RaTiuzsgfPPbqmuJfY75mAvXna55irF2my2dzY6CoRC6QCZvxgQ7idbWgq71JVsya/QF87Q9h9viNT7SIV54vIYWm1eJbstYII33pbDk/Z6VcsVsp3rIQYhO956d3B1WCQlYzLBdN73tgRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9lWmvdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9lWmvdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CB4C3277B;
	Tue, 18 Jun 2024 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715194;
	bh=RGn5cOs7zeokAcy3K0qv1xgBh8sNNTZmjakrvTn+9IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9lWmvdcbo0zMx3I03UtD5E5x/yoTCGUSXruMjC3xe9Oy0WaAJ284WlXbdwwfSRxJ
	 sV2P6D0W5nPrpkID199UD6fhZzp32KXe68TaowEJI+E4xR4AWXvLb+MXKKUmZ6g7dr
	 Ud7ONrQP9MW/fvYHjweWUWVhmdx8cRVg+IjtCkkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/770] NFSD: Update the NFSv2 READDIR result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:19 +0200
Message-ID: <20240618123416.005246994@linuxfoundation.org>
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

[ Upstream commit 94c8f8c682a6497af7ea71351b18f637c6337d42 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 22 +++++++++++++---------
 fs/nfsd/xdr.h    |  1 +
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 8ae23ed6dc5db..9522e5c5f49db 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -574,17 +574,21 @@ nfssvc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_encode_readdirres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_readdirres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		return xdr_ressize_check(rqstp, p);
-
-	xdr_ressize_check(rqstp, p);
-	p = resp->buffer;
-	*p++ = 0;			/* no more entries */
-	*p++ = htonl((resp->common.err == nfserr_eof));
-	rqstp->rq_res.page_len = resp->count << 2;
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		xdr_write_pages(xdr, &resp->page, 0, resp->count << 2);
+		/* no more entries */
+		if (xdr_stream_encode_item_absent(xdr) < 0)
+			return 0;
+		if (xdr_stream_encode_bool(xdr, resp->common.err == nfserr_eof) < 0)
+			return 0;
+		break;
+	}
 
 	return 1;
 }
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 75b3b31445340..d7beef2c2ed5b 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -114,6 +114,7 @@ struct nfsd_readdirres {
 	__be32 *		buffer;
 	int			buflen;
 	__be32 *		offset;
+	struct page		*page;
 };
 
 struct nfsd_statfsres {
-- 
2.43.0



