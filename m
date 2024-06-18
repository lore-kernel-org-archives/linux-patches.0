Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078D5158D65;
	Tue, 18 Jun 2024 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716282; cv=none; b=P2i36I+6jWNdArFXjHmerFZSON5JI61uY+wyAL/93s/+JiLeeCZrE8ZmBxizIKO6bOqfKHRRZ/aC7DTA6++7HrdiH+lcRDsalN0urBif4k1Wn9TFZUZwtaMO+hXGdWg3lJooXVjEu84pXSoGyHmhEZNv/2z2/3RsZhNJjJ1CvQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716282; c=relaxed/simple;
	bh=bkwTVm7YIOVzySQPksXL2MfvNWudpbJSLSQChmmFcSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDz3J66l05O75tm8lqXj3+9MvEpyeh6ZAW4hIO2PJQdJrnMeCjuo02jIGuPV6dAf1r0LfaT4MCndIcaoBrR3+GG0Xwq0M6tyTXoDO0H1HR498sYr/CMaD6oxVN+qL2J+TZDEVzfQINv6J20BioTPzpHUh2LumV8Tsc5GrtmOzSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6hqBG9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6hqBG9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79653C32786;
	Tue, 18 Jun 2024 13:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716281;
	bh=bkwTVm7YIOVzySQPksXL2MfvNWudpbJSLSQChmmFcSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6hqBG9GgnQlhpjCNxozchmFBFKG6+lWksfUvqedeMTHJIY6kKwUNO9AQBzoGwZIB
	 aum7fDrqkbDFhID7SQRKcEYRnWWJhG+9QnMv0wYGHYxxBA+YaEjKqqCBK9+bIF8h3Q
	 UHbR9u9SR6L4JaJlPsFegTOA/w2oo5NXpyaM+mzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 594/770] NFSD: Simplify starting_len
Date: Tue, 18 Jun 2024 14:37:27 +0200
Message-ID: <20240618123430.222798512@linuxfoundation.org>
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

[ Upstream commit 071ae99feadfc55979f89287d6ad2c6a315cb46d ]

Clean-up: Now that nfsd4_encode_readv() does not have to encode the
EOF or rd_length values, it no longer needs to subtract 8 from
@starting_len.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 36f0f06714dec..f67a54f7eb13e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3950,7 +3950,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct file *file, unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
-	int starting_len = xdr->buf->len - 8;
+	unsigned int starting_len = xdr->buf->len;
 	__be32 nfserr;
 	__be32 tmp;
 	int pad;
@@ -3965,14 +3965,13 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 	read->rd_length = maxcount;
 	if (nfserr)
 		return nfserr;
-	if (svc_encode_result_payload(resp->rqstp, starting_len + 8, maxcount))
+	if (svc_encode_result_payload(resp->rqstp, starting_len, maxcount))
 		return nfserr_io;
-	xdr_truncate_encode(xdr, starting_len + 8 + xdr_align_size(maxcount));
+	xdr_truncate_encode(xdr, starting_len + xdr_align_size(maxcount));
 
 	tmp = xdr_zero;
 	pad = (maxcount&3) ? 4 - (maxcount&3) : 0;
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + 8 + maxcount,
-								&tmp, pad);
+	write_bytes_to_xdr_buf(xdr->buf, starting_len + maxcount, &tmp, pad);
 	return 0;
 
 }
-- 
2.43.0



