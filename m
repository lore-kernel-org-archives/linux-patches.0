Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58615D5DA;
	Tue, 18 Jun 2024 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714958; cv=none; b=FmpQJUaK9OP7hlq2mXrGWXeYGAv12xZJGWXdgoBl87+9D4+QqsDCxr5zW5AX/8/tWBMzDVpIXSb3XuGuc+ZqyzlVuBnRUGR/bZcSQvpt5Ndd94I+02kY7eVplnYxXlXok6qvhKZ/aGjidZPi63yYtO86jjHCH0aFmMqh3odYAVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714958; c=relaxed/simple;
	bh=VGhsWWNfFKWuVHsfh0fW6AYkuzZddQUu7xtIcXy6FTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k63vAEC3bgEgk1xtsVFeBC/A5TW4M4F/Tj6Pew9FwLSEKcqNiu8pfYGz/rMVpZ8X2KNv/BeTDmMcbEa1zKb06ExDkFFi3/z95kXzpnLSRRnJcp+CDOeIviHgex+ePBTTCB/nCuzIneyJ+l7r6An+CIxZsUuKcbphkXU2flApDCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oC060DT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oC060DT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF34C3277B;
	Tue, 18 Jun 2024 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714958;
	bh=VGhsWWNfFKWuVHsfh0fW6AYkuzZddQUu7xtIcXy6FTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oC060DTxu3eBbTdJ2/wWad6ckpWkih+Va10F99npq4szrgAM55GcIAlvyZHrYHjc
	 E97L4ZJMsaW7qdLXEsJS/irgflTxUYnEmDvPyHb5iqT4i0z30wR9vb9KUtkyDurOU0
	 74pNcdta3DQOWctGj+nux9O2JEBPDZNtLzXrDlcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/770] NFSD: Update the LINK3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:00 +0200
Message-ID: <20240618123412.948611975@linuxfoundation.org>
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

[ Upstream commit efaa1e7c2c7475f0a9bbeb904d9aba09b73dd52a ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index f870a068aad85..9437dda2646f2 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -574,14 +574,12 @@ nfs3svc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_linkargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_fh(p, &args->tfh))
-	 || !(p = decode_filename(p, &args->tname, &args->tlen)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_nfs_fh3(xdr, &args->ffh) &&
+		svcxdr_decode_diropargs3(xdr, &args->tfh,
+					 &args->tname, &args->tlen);
 }
 
 int
-- 
2.43.0



