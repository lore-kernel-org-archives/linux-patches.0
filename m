Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC2158D62;
	Tue, 18 Jun 2024 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716285; cv=none; b=X3LeSLcXbVGbgI8FyMibQbUkfXkaiEfjLgMnBTaTIFlCgwpYbBUHRXD90tPbkiTUp6E2eut0mz9WkT8X4kTdmji4RwW7D+/FFAdM7esAGfyujmcAOzvdwyWB9r9j81TJzkg++ej9PQKfEPvH84c7A5CFr5eCSUyKRk9fHjVd+EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716285; c=relaxed/simple;
	bh=5Idy5YcI6dRuwo38w/AHp5eZ/qQmhyN5IaOBdRKi1Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9Wqz/aJQzygV8ugcLlVxpWGjcINadqKKvVoRidvNA2ipV21qAO0BBhpMy1MhMYgHgRK2r9gBhu27zCUSwrmruYSdf/3L+U6K/K84AHYQi0AkYgm2a4388g/s4wLY45+UxpZcMSYMeq9ZMhDrlN/zMQwtApm80F/zcSUrFsFBfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPboQu2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPboQu2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D877C3277B;
	Tue, 18 Jun 2024 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716284;
	bh=5Idy5YcI6dRuwo38w/AHp5eZ/qQmhyN5IaOBdRKi1Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPboQu2WsPSDtVHmDk1szmIkd37q8FdjuHYSJR1UIpsaT0P+um6UaZiUYV407tAjG
	 jG7emey3qcAf5EQwlWui+gG6H2lvq8/JrOuhkMW8P1fbWgFsbxaiE7PoukDKGIjX7q
	 EiRKmOxEiqLQEFfcvUZXUuEBWnDo2QmJr3TcvWZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 595/770] NFSD: Use xdr_pad_size()
Date: Tue, 18 Jun 2024 14:37:28 +0200
Message-ID: <20240618123430.260726469@linuxfoundation.org>
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

[ Upstream commit 5e64d85c7d0c59cfcd61d899720b8ccfe895d743 ]

Clean up: Use a helper instead of open-coding the calculation of
the XDR pad size.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f67a54f7eb13e..4d74eb1fee8f1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3951,9 +3951,8 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 {
 	struct xdr_stream *xdr = resp->xdr;
 	unsigned int starting_len = xdr->buf->len;
+	__be32 zero = xdr_zero;
 	__be32 nfserr;
-	__be32 tmp;
-	int pad;
 
 	read->rd_vlen = xdr_reserve_space_vec(xdr, resp->rqstp->rq_vec, maxcount);
 	if (read->rd_vlen < 0)
@@ -3969,11 +3968,9 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + xdr_align_size(maxcount));
 
-	tmp = xdr_zero;
-	pad = (maxcount&3) ? 4 - (maxcount&3) : 0;
-	write_bytes_to_xdr_buf(xdr->buf, starting_len + maxcount, &tmp, pad);
-	return 0;
-
+	write_bytes_to_xdr_buf(xdr->buf, starting_len + maxcount, &zero,
+			       xdr_pad_size(maxcount));
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



