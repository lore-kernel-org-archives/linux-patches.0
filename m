Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE3F13E022;
	Tue, 18 Jun 2024 12:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714660; cv=none; b=Bg6gfQs+Lu5ge3mqNw7HvdTAb29UoPqpA4ITfkSOARIU74kryg7V5M7IzkXJNViEBsX09oFBH9x7dJceHYWGR6Fa9iYZjJw6ZLfobYmR+5MzTNXsYG5A/oZIBq5tCi3DOC9LZ/wX5mmRofHMfjGnM6IDx12utvnGeldhLU6KHiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714660; c=relaxed/simple;
	bh=gehQ77NIwD1ab2Otwm4nCco7RuDNNL6+V32qFrBHJQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM8jSy95yb2Eo4wGxDh7yzQaqRE+pQ9qoxVa8dXwx0NuOrYGVNq3Q+F91PlfEhpwiugeLiK3YXY3qsD4SQ3Qgc5lWXhXlKOx0gJYsnUtnVLZUEP4JgLsAcSGc9qzEJMkuw7Ob0cisUBPjN9VjBL57LqV53ScbkGzNx05XaKSiC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APLRTYnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APLRTYnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33063C3277B;
	Tue, 18 Jun 2024 12:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714660;
	bh=gehQ77NIwD1ab2Otwm4nCco7RuDNNL6+V32qFrBHJQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APLRTYnpFUX/6PmizyajDOR++jIUGU9pzBpHdiyBTYZkbh+RNsZ02QqNnfG3HI+yD
	 yMEKb9X/1z9YlxdJyHxAwO6wZ7HYDEm+VfZ746QnSauykUxmNVQtLyV17XZSqVheSE
	 VDQYx0W3GjT17GeUJHds1WOVVN29k4mdbXYiGb2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/770] NFSD: Replace READ* macros in nfsd4_decode_open_confirm()
Date: Tue, 18 Jun 2024 14:28:19 +0200
Message-ID: <20240618123409.071170340@linuxfoundation.org>
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

[ Upstream commit 06bee693a1f1cb774b91000f05a6e183c257d8e9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2de54e84a3ab0..7b6fb11cdc809 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1155,18 +1155,18 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 static __be32
 nfsd4_decode_open_confirm(struct nfsd4_compoundargs *argp, struct nfsd4_open_confirm *open_conf)
 {
-	DECODE_HEAD;
+	__be32 status;
 
 	if (argp->minorversion >= 1)
 		return nfserr_notsupp;
 
-	status = nfsd4_decode_stateid(argp, &open_conf->oc_req_stateid);
+	status = nfsd4_decode_stateid4(argp, &open_conf->oc_req_stateid);
 	if (status)
 		return status;
-	READ_BUF(4);
-	open_conf->oc_seqid = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &open_conf->oc_seqid) < 0)
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



