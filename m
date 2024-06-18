Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C8D1586DB;
	Tue, 18 Jun 2024 13:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716276; cv=none; b=QPgTRVyBUfXHy+05d87fGg1zNoCF14yYGkOarGYL3iMWgBEmDA6TZ8FFmWG9MzU5Owv4Dy2W+M8QLM+3yCftMKwk6Iq8B2Z2CBQXoWwpPF7tsNurynmzF6yAr0gw5c2Iokct0mqNp6J/3ZO3gtLruH4NlViWCYm9HCEm7wCUeVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716276; c=relaxed/simple;
	bh=Ffc6ik9MsGL1FSQlw/W/IaSnLPiYkwYxlEb7if+1zx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfQqb1pfpXRfrsxsaPeukH5PGse8DWbZJvTU+aQMu3BWZyORQ9tsUuhMn/fAcyTdGireqJrQK9pa5UG+V/cfwZ7ZCWx6GoOyi0+ruZYJCunsXyeOz0T9pjxxnQuH5BT1ha/A7a/wQ9JulhhnOoUjdzQDiTA4SPyVQwDhXoS83eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnykakAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnykakAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69967C3277B;
	Tue, 18 Jun 2024 13:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716275;
	bh=Ffc6ik9MsGL1FSQlw/W/IaSnLPiYkwYxlEb7if+1zx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnykakAhgel9SF205kVNcl/CrbX2Ip0Jd2DHGmbw7Dw/gu7TdEcwQIro7ARoLwNgk
	 OWU/kr5Gu39DofiMDaNxtgGWy4cneyyv4Ste5OSGe/DZlqSP8AccpM56bv4PLodkRY
	 XduKlNNDoC7EHmBLU/Qy5s4JovE8VJRD7eKq1+pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 592/770] NFSD: Add an nfsd4_read::rd_eof field
Date: Tue, 18 Jun 2024 14:37:25 +0200
Message-ID: <20240618123430.144966682@linuxfoundation.org>
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

[ Upstream commit 24c7fb85498eda1d4c6b42cc4886328429814990 ]

Refactor: Make the EOF result available in the entire NFSv4 READ
path.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +++++------
 fs/nfsd/xdr4.h    |  5 +++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 059e920c21919..8437a390480df 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3890,7 +3890,6 @@ static __be32 nfsd4_encode_splice_read(
 	struct xdr_stream *xdr = resp->xdr;
 	struct xdr_buf *buf = xdr->buf;
 	int status, space_left;
-	u32 eof;
 	__be32 nfserr;
 	__be32 *p = xdr->p - 2;
 
@@ -3899,7 +3898,8 @@ static __be32 nfsd4_encode_splice_read(
 		return nfserr_resource;
 
 	nfserr = nfsd_splice_read(read->rd_rqstp, read->rd_fhp,
-				  file, read->rd_offset, &maxcount, &eof);
+				  file, read->rd_offset, &maxcount,
+				  &read->rd_eof);
 	read->rd_length = maxcount;
 	if (nfserr)
 		goto out_err;
@@ -3910,7 +3910,7 @@ static __be32 nfsd4_encode_splice_read(
 		goto out_err;
 	}
 
-	*(p++) = htonl(eof);
+	*(p++) = htonl(read->rd_eof);
 	*(p++) = htonl(maxcount);
 
 	buf->page_len = maxcount;
@@ -3954,7 +3954,6 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct file *file, unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
-	u32 eof;
 	int starting_len = xdr->buf->len - 8;
 	__be32 nfserr;
 	__be32 tmp;
@@ -3966,7 +3965,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 
 	nfserr = nfsd_readv(resp->rqstp, read->rd_fhp, file, read->rd_offset,
 			    resp->rqstp->rq_vec, read->rd_vlen, &maxcount,
-			    &eof);
+			    &read->rd_eof);
 	read->rd_length = maxcount;
 	if (nfserr)
 		return nfserr;
@@ -3974,7 +3973,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + 8 + xdr_align_size(maxcount));
 
-	tmp = htonl(eof);
+	tmp = htonl(read->rd_eof);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len    , &tmp, 4);
 	tmp = htonl(maxcount);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 448b687943cd3..32617639a3ece 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -302,9 +302,10 @@ struct nfsd4_read {
 	u32			rd_length;          /* request */
 	int			rd_vlen;
 	struct nfsd_file	*rd_nf;
-	
+
 	struct svc_rqst		*rd_rqstp;          /* response */
-	struct svc_fh		*rd_fhp;             /* response */
+	struct svc_fh		*rd_fhp;            /* response */
+	u32			rd_eof;             /* response */
 };
 
 struct nfsd4_readdir {
-- 
2.43.0



