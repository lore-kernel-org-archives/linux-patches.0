Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC21DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9mL8Gbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F424C433C8;
	Wed,  4 Oct 2023 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444174;
	bh=hiL1y0xd6K+joZaHd5kBRlLSKDWESd+ENz1DXjhWsIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9mL8Gbmcw2eqCcgqmXfDRIjXNrEoxjanuLFXOGvQSX9A0JUxqw/lVo0MaszpGTrm
	 YyCpd1Bxm972xaQiXyC3+rAr1gjy5REqVJzJ/IRPm+n7WemI0In3zOoLYkdXNv1D8o
	 wjuoOVeVfegKPLCBjZQo5kNUlyVpVpsKsk8Uo/4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 157/321] NFSD: Fix zero NFSv4 READ results when RQ_SPLICE_OK is not set
Date: Wed,  4 Oct 2023 19:55:02 +0200
Message-ID: <20231004175236.514079407@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0d32a6bbb8e7bf503855f2990f1ccce0922db87b ]

nfsd4_encode_readv() uses xdr->buf->page_len as a starting point for
the nfsd_iter_read() sink buffer -- page_len is going to be offset
by the parts of the COMPOUND that have already been encoded into
xdr->buf->pages.

However, that value must be captured /before/
xdr_reserve_space_vec() advances page_len by the expected size of
the read payload. Otherwise, the whole front part of the first
page of the payload in the reply will be uninitialized.

Mantas hit this because sec=krb5i forces RQ_SPLICE_OK off, which
invokes the readv part of the nfsd4_encode_read() path. Also,
older Linux NFS clients appear to send shorter READ requests
for files smaller than a page, whereas newer clients just send
page-sized requests and let the server send as many bytes as
are in the file.

Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/f1d0b234-e650-0f6e-0f5d-126b3d51d1eb@gmail.com/
Fixes: 703d75215555 ("NFSD: Hoist rq_vec preparation into nfsd_read() [step two]")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index be72628b13376..d2588f4ac42be 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4105,6 +4105,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct file *file, unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
+	unsigned int base = xdr->buf->page_len & ~PAGE_MASK;
 	unsigned int starting_len = xdr->buf->len;
 	__be32 zero = xdr_zero;
 	__be32 nfserr;
@@ -4113,8 +4114,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 		return nfserr_resource;
 
 	nfserr = nfsd_iter_read(resp->rqstp, read->rd_fhp, file,
-				read->rd_offset, &maxcount,
-				xdr->buf->page_len & ~PAGE_MASK,
+				read->rd_offset, &maxcount, base,
 				&read->rd_eof);
 	read->rd_length = maxcount;
 	if (nfserr)
-- 
2.40.1



