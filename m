Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059031586DB;
	Tue, 18 Jun 2024 13:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716273; cv=none; b=e1eDURJv6KIKUtq6hljxMoUn4P/Py+VIsKdnjQf6uUutSeJjCLLb49ooHMDhtazfzdZebsw3O7cUwXIZomtrhe4hl7TgSD1aRpgWeiJ554XqQL6iwaz9Z9V2Y9hNz/Q4bqaDKSnT199rDS5rEJvVIkneOItPXm58h735Aschs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716273; c=relaxed/simple;
	bh=bMAmT75CtsIPfLxUo8aOR4aEptodVwblRL6zitSfk7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWNn7DXlbWK7jYRkF7ZfarGMtJmuYhlvVSfmX/eUn15qTw0KdwPLq+iPVuZQiB1TPCJJ9yMIHROTnBfTb+JdK+eBlnHtXpRQLG9i4WRjME6ugeoeNqJ1R39xp9s6nWzU7HgUA17AdwBlOGs6rnd5XToS3F/jc3Bf5YNY6GF47nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trcOC/dU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trcOC/dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BE3C3277B;
	Tue, 18 Jun 2024 13:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716272;
	bh=bMAmT75CtsIPfLxUo8aOR4aEptodVwblRL6zitSfk7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trcOC/dU8Z6qiGevFdoPb8qbohhSC68hTeiMrRgBugXzTgITU5/O3ThrnX3tykDzA
	 QRgWK+5Kh+CUB6fXoGzXY/kIB43T5cD4oiDaZaSwNZcHQsxnIA+RwLv4R960bZT7OC
	 ELWQM5IXTmWfd4vY7tEuBEDRXsFjhS242cqxQpRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 591/770] NFSD: Clean up SPLICE_OK in nfsd4_encode_read()
Date: Tue, 18 Jun 2024 14:37:24 +0200
Message-ID: <20240618123430.107561743@linuxfoundation.org>
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

[ Upstream commit c738b218a2e5a753a336b4b7fee6720b902c7ace ]

Do the test_bit() once -- this reduces the number of locked-bus
operations and makes the function a little easier to read.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1e388cdf9b005..059e920c21919 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3991,6 +3991,7 @@ static __be32
 nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 		  struct nfsd4_read *read)
 {
+	bool splice_ok = test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags);
 	unsigned long maxcount;
 	struct xdr_stream *xdr = resp->xdr;
 	struct file *file;
@@ -4003,11 +4004,10 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 
 	p = xdr_reserve_space(xdr, 8); /* eof flag and byte count */
 	if (!p) {
-		WARN_ON_ONCE(test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags));
+		WARN_ON_ONCE(splice_ok);
 		return nfserr_resource;
 	}
-	if (resp->xdr->buf->page_len &&
-	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
+	if (resp->xdr->buf->page_len && splice_ok) {
 		WARN_ON_ONCE(1);
 		return nfserr_serverfault;
 	}
@@ -4016,8 +4016,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
 
-	if (file->f_op->splice_read &&
-	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags))
+	if (file->f_op->splice_read && splice_ok)
 		nfserr = nfsd4_encode_splice_read(resp, read, file, maxcount);
 	else
 		nfserr = nfsd4_encode_readv(resp, read, file, maxcount);
-- 
2.43.0



