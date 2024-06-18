Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BC14F13D;
	Tue, 18 Jun 2024 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715053; cv=none; b=ozSpgOx0EqZkEvewn8Z6ucp/A3YBJ0xsR6KiNd1RD33XIl2e2RPKr4k0shB1JE1UIhpLBckYQAFp/dEzjqRoLLfnkdgRFbIDPcTDOcHvjkza4SBVQEDkpRxBQlnoSWs4jL9WGXa9RSOwTxjMu/o2ho+MAUYK9MjjylQfgQO5DOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715053; c=relaxed/simple;
	bh=Z6zhlNWu3kpfvTTiOl0JQB6HeFpdC/756BMRz4Fsf5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3CFxBgmJgne6a5u1LNmP7qTRj+9l5vmpX8FyNERXKMaVAxwx8Fe0Uq8gg9NskNlaZmhsIpmgpeUDkyf1WlKGEaCCxEEvd/CYXLvydK+Vu9NYwcyd+egCSJQcibaTSi8zAEOiEUA2G0iqEFnNOXKOnhiXfJqvXA3nbB0gD2/gC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ4LA1RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ4LA1RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856BFC3277B;
	Tue, 18 Jun 2024 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715052;
	bh=Z6zhlNWu3kpfvTTiOl0JQB6HeFpdC/756BMRz4Fsf5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJ4LA1RPdESqWvctEFhIPtCaetdf2H8lqdWXTz7shMomvlNrWi3yiQxEYdzKRdgNO
	 w81GGpnLLAH0vDgCMpryrFgaECkeQl21l3e1ZwqZ2GaumoJ3yl+xjqVq8sAHhdKRo0
	 4/LctXUB04U3t2HeA3a1m5sfzcxobT3xaa1HnCCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/770] NFSD: Update the RENAME3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:59 +0200
Message-ID: <20240618123412.910491109@linuxfoundation.org>
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

[ Upstream commit d181e0a4bef36ee74d1338e5b5c2561d7463a5d0 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 299ea8bbd685f..f870a068aad85 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -562,15 +562,13 @@ nfs3svc_decode_mknodargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_renameargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_filename(p, &args->fname, &args->flen))
-	 || !(p = decode_fh(p, &args->tfh))
-	 || !(p = decode_filename(p, &args->tname, &args->tlen)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_diropargs3(xdr, &args->ffh,
+					&args->fname, &args->flen) &&
+		svcxdr_decode_diropargs3(xdr, &args->tfh,
+					 &args->tname, &args->tlen);
 }
 
 int
-- 
2.43.0



