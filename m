Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F536EB72;
	Mon,  8 Apr 2024 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584294; cv=none; b=mLS6cu5F7XnNwKG9bUscTF6gUPCus2C7RVcsHqzTuaGUB0Egy843sm8lQZIDME1oKptfBr5K5L8zb69SuRBr0gceJZ8bnpTf7hg910ZBNt3BZfc24rFsxGtzo/y6i7GE3ptcD7039ICBGxD73R37sLcjkIWQMjJxFyIr4xYmwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584294; c=relaxed/simple;
	bh=a9U6ZEJNjrJ2GFQQaaf7JPHHCkq1bH++GUVYKAsLLAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWXFnDFbObLVoes14b5/7Es5JMn6HCxLMJrSqo2J1SRI9XmS47WP3b+oC4fThr2FaesxfUH/OPnXkqJfW7HkSMvoXrXVtMqKZQdLtqZf/K0YtIX2VzK7V5J2z5lj6NgQ9rZHV0MwaqkPDKu0g9pSZqfnWH8tcnsvA8LqvfOzHVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN4MkNIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN4MkNIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B0CC433F1;
	Mon,  8 Apr 2024 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584294;
	bh=a9U6ZEJNjrJ2GFQQaaf7JPHHCkq1bH++GUVYKAsLLAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN4MkNIOVlIzQRWg1MSVwLKSZsb1+EPJSKMwtcv25cpyrdNHDEjN3rhZcWUdQAIo8
	 Vnipa19qJ6lNIFND5DJVJALdvOnDlfNAbV5VJCi8niox7yAgn8gPXdBoxQXKCCVcqJ
	 L0Ell2g2ZEdI/yFHKcf2yE0Ph9/PKNsjNp8Wblcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 382/690] NFSD: Clean up SPLICE_OK in nfsd4_encode_read()
Date: Mon,  8 Apr 2024 14:54:08 +0200
Message-ID: <20240408125413.388350227@linuxfoundation.org>
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

[ Upstream commit c738b218a2e5a753a336b4b7fee6720b902c7ace ]

Do the test_bit() once -- this reduces the number of locked-bus
operations and makes the function a little easier to read.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d5a4aa0da32be..afc8a51cf60f1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3988,6 +3988,7 @@ static __be32
 nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 		  struct nfsd4_read *read)
 {
+	bool splice_ok = test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags);
 	unsigned long maxcount;
 	struct xdr_stream *xdr = resp->xdr;
 	struct file *file;
@@ -4000,11 +4001,10 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 
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
@@ -4013,8 +4013,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
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



