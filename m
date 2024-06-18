Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AF515CD7A;
	Tue, 18 Jun 2024 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714779; cv=none; b=bzRo6bpSMSRlF4wUn/5kdD3H6KJP+MJKZAjzXgC9SOInTjkCQlm+iLv3t8xBpdpz86lYtUzRVJDZqJGCYOGQF8J6PlzbL3vIqluZ4hdXny6kEBS9VCmtTiUp+RGJ4bDWwpkN+0gYRWu6WR7rHNDrVO76brJUyIcZfCvO+yMDZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714779; c=relaxed/simple;
	bh=bu0VZr861poIVWHJCUMW9h0kQP3Cfzfhbfz8We+HQtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l194kKE8NovtBcXdzXR8+oEXa+DcVi3JwqTRVB0WODEdPXhnQdAdvF9ZU5TgStXDqSJBpE1g1BswvwknwaGATcSir/nujPPQQvLTdFuQ+KNxnd0kRvdW312zwVkXfgfYL0JJLE4QZrKopf2ANZBX/0TjGgJiBfwpt1pTj4g4+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv6iWg9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv6iWg9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96318C3277B;
	Tue, 18 Jun 2024 12:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714779;
	bh=bu0VZr861poIVWHJCUMW9h0kQP3Cfzfhbfz8We+HQtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv6iWg9jK2rUFWz8QzOFPAsR2lQG+hBOITBxAF+JLDW+hECyrxwqpDgbIKVKTarnP
	 ohoNh27++ILlTrxGEnM626TQhqUG6amGMCh468wOBtbdFJp9gJfZCitghM/y7KxwhZ
	 rBiPQq5Fy8T7cHzM9RD/eBbBXkFFN32rMNhjU7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/770] NFSD: Replace READ* macros in nfsd4_decode_seek()
Date: Tue, 18 Jun 2024 14:28:59 +0200
Message-ID: <20240618123410.598458630@linuxfoundation.org>
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

[ Upstream commit 9d32b412fe0a6186cc57789d218e8f8299454ae2 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 101beb315d963..2e2fae7e38db2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2054,17 +2054,17 @@ nfsd4_decode_offload_status(struct nfsd4_compoundargs *argp,
 static __be32
 nfsd4_decode_seek(struct nfsd4_compoundargs *argp, struct nfsd4_seek *seek)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &seek->seek_stateid);
+	status = nfsd4_decode_stateid4(argp, &seek->seek_stateid);
 	if (status)
 		return status;
+	if (xdr_stream_decode_u64(argp->xdr, &seek->seek_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &seek->seek_whence) < 0)
+		return nfserr_bad_xdr;
 
-	READ_BUF(8 + 4);
-	p = xdr_decode_hyper(p, &seek->seek_offset);
-	seek->seek_whence = be32_to_cpup(p);
-
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 /*
-- 
2.43.0



