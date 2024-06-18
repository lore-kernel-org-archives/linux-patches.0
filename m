Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E89F12CDB5;
	Tue, 18 Jun 2024 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715701; cv=none; b=iX2/Zi7IF/gYsvN+L6Zb4rlDnATcExZG6/v1wNuLpI9czeAUSqAU/5He+QBuxWVUkqKIZnoAKp13g/kxvhrfGkr+EStvQeVTviU+HYm5HEqxCXm4BTzgnlR1D4meEnW1QTI3vhhzT7UVi6+vo8SqvI50A63DchO92dzTYULMzck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715701; c=relaxed/simple;
	bh=DBqrxs80NWit93T2u05vGU1OYHjlyaBwvYX6p3khKSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYcrrbX9TiESP4fOEX2A3hMXnadewX1TdN61ocEGN+C3f8YRTzU3getqN2yt3b4BkBbLFScO/Q8jWWHJkzftciyD3jhsiZRGIOq3/sRELmbLnaeyKose2YXjV+MKSqqBhm2drZRd3lAowErQuNCKolZl9lO802XlfzeDs9uOjmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd6xriv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd6xriv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86CEC3277B;
	Tue, 18 Jun 2024 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715701;
	bh=DBqrxs80NWit93T2u05vGU1OYHjlyaBwvYX6p3khKSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qd6xriv8QMj9VBUPGIjjLeYXRrSdop01Bh7WJ7ehDFu6yuIu/Ve5S0QInXapupvDM
	 Kw5EzelUrpZ+D2MIOzRiFl/Bpw16Z4GgqPBe0mrw95A5LQvKQ0LYh7aLMIVXfYpsK5
	 27vEkwU7QY0fAhT50KMPeQ6u12o9pEQ4GASmwBuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/770] NFSD: Save location of NFSv4 COMPOUND status
Date: Tue, 18 Jun 2024 14:34:10 +0200
Message-ID: <20240618123422.604845877@linuxfoundation.org>
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

[ Upstream commit 3b0ebb255fdc49a3d340846deebf045ef58ec744 ]

Refactor: Currently nfs4svc_encode_compoundres() relies on the NFS
dispatcher to pass in the buffer location of the COMPOUND status.
Instead, save that buffer location in struct nfsd4_compoundres.

The compound tag follows immediately after.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 fs/nfsd/nfs4xdr.c  | 9 +++++++--
 fs/nfsd/xdr4.h     | 3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index d2ee1ba7ddc65..52f3f35533791 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2456,11 +2456,11 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	__be32		status;
 
 	resp->xdr = &rqstp->rq_res_stream;
+	resp->statusp = resp->xdr->p;
 
 	/* reserve space for: NFS status code */
 	xdr_reserve_space(resp->xdr, XDR_UNIT);
 
-	resp->tagp = resp->xdr->p;
 	/* reserve space for: taglen, tag, and opcnt */
 	xdr_reserve_space(resp->xdr, XDR_UNIT * 2 + args->taglen);
 	resp->taglen = args->taglen;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1b33c1c93e883..3f8d23586ea79 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5446,11 +5446,16 @@ nfs4svc_encode_compoundres(struct svc_rqst *rqstp, __be32 *p)
 	WARN_ON_ONCE(buf->len != buf->head[0].iov_len + buf->page_len +
 				 buf->tail[0].iov_len);
 
-	*p = resp->cstate.status;
+	/*
+	 * Send buffer space for the following items is reserved
+	 * at the top of nfsd4_proc_compound().
+	 */
+	p = resp->statusp;
+
+	*p++ = resp->cstate.status;
 
 	rqstp->rq_next_page = resp->xdr->page_ptr + 1;
 
-	p = resp->tagp;
 	*p++ = htonl(resp->taglen);
 	memcpy(p, resp->tag, resp->taglen);
 	p += XDR_QUADLEN(resp->taglen);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 8f349640d2e97..8e11dfdc2563a 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -702,10 +702,11 @@ struct nfsd4_compoundres {
 	struct xdr_stream		*xdr;
 	struct svc_rqst *		rqstp;
 
+	__be32				*statusp;
 	u32				taglen;
 	char *				tag;
 	u32				opcnt;
-	__be32 *			tagp; /* tag, opcount encode location */
+
 	struct nfsd4_compound_state	cstate;
 };
 
-- 
2.43.0



