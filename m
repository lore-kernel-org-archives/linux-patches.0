Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CCF42046;
	Mon,  8 Apr 2024 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584375; cv=none; b=YU8qNNpkneHUgTnK4ywjVhgSbBMqflvVA+yxprUQVs4gkTsH09iKcLTdRkPaJqULtX3ncVT8lMKvt9fC4oZo2KX64/FjKhnGgEM9/oqeraqEHJRHk+26aJDZTie6kkAKewIdHF0DRHAfmCcwdJ3MBVlBqS1BHAQSDESY52Jtamk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584375; c=relaxed/simple;
	bh=zKaDqJknXbGjHc30GCI4/AER8RnZvJZETv9gRhmKJ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4lkwK8/wLaFAVx+r2quftNMvZm8df+noISx5iN5W20ou2lIDgJrkv3wZLb/GbglJyjyHhRBiWwoK/3K/kpnqoBZsVGEIPEgLBtBR81Ay/a8a9N1V8KTeIGA/rZYsnQEHcE3QUrnIyLxV61X62+h+6m1yLSJj9sux5tlt05R5m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ORyJW6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ORyJW6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F77BC433C7;
	Mon,  8 Apr 2024 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584375;
	bh=zKaDqJknXbGjHc30GCI4/AER8RnZvJZETv9gRhmKJ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ORyJW6zsh1FE4PaCtQ2aLl/MgL0B6nKCSR0gPlj0JczWahAFGjJ/LQa03dyRDJDS
	 7vX9wA5b1pZCPdVwqv7qTSwQUjv9tr5xtfA0K/n+57du/Oyy7zRsCYOZ/uaLSxl74f
	 dcNQ7aplQ4YZ00WhpffI1Ba+Iq7MT+GOQhyhhPhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 385/690] NFSD: Simplify starting_len
Date: Mon,  8 Apr 2024 14:54:11 +0200
Message-ID: <20240408125413.490842095@linuxfoundation.org>
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

[ Upstream commit 071ae99feadfc55979f89287d6ad2c6a315cb46d ]

Clean-up: Now that nfsd4_encode_readv() does not have to encode the
EOF or rd_length values, it no longer needs to subtract 8 from
@starting_len.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b7a3c770d436b..310321b9b94cd 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3947,7 +3947,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct file *file, unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
-	int starting_len = xdr->buf->len - 8;
+	unsigned int starting_len = xdr->buf->len;
 	__be32 nfserr;
 	__be32 tmp;
 	int pad;
@@ -3962,14 +3962,13 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
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



