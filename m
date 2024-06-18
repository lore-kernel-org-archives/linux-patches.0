Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C315F401;
	Tue, 18 Jun 2024 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715000; cv=none; b=ObyWBv4rj/AHpQeRkJW7cAFwWkRy+tcOu00OgrVGK+CBg84UW8Nf79RogYKDP/HnyyskSnRzzp0SWcU8y1UlWbfFndFRQKKTt8XImn9p/jAEvXCGOzbF7Wr6s28AFXZnE5eZaZaAfylSSr7CcrEBe9MlSyQBf6R6r5avmf3PkIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715000; c=relaxed/simple;
	bh=XKeMOpo2WzwPgFzyE9N/mQXBfQIrbghkluQZH1JYBeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGCNWOpIFRr5cV3hJlLhB8GJwcwu9sCX1DTx2KMV3/DxeJcoHDQrqEPuahkxlPpQzu4jn8Pd7pKkpv6FAugR4pdZl1OjSiFDgShKVssCIgE9AJWNRtMH+Mnr4eTJbfxeB5omw+NluwmQY+rMXzRUfKKL7aVir3lUKwq5Wd8T3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHQQ8tuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHQQ8tuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A291C3277B;
	Tue, 18 Jun 2024 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715000;
	bh=XKeMOpo2WzwPgFzyE9N/mQXBfQIrbghkluQZH1JYBeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHQQ8tuA5KEXhPm02TxSoDMgLj6ZT+uNY0QcvHx7zsjioSlxD4MKMwWczH/qOUuUF
	 QSdr2aKW1tl9iwWJh4yozS+dFQ+t8/kYdc5c0vV9QWZIuBTRfwOpn3PYQd84JuZrsq
	 J69LK5Wr4YcXXHsNpus6mFBAwfP/lEJ4j2kGQl74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/770] NFSD: Update the NFSv2 RENAME argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:13 +0200
Message-ID: <20240618123413.451536920@linuxfoundation.org>
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

[ Upstream commit 62aa557efb81ea3339fabe7f5b1a343e742bbbdf ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 00a7db8548ebf..d4f4729c7b1c0 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -344,15 +344,13 @@ nfssvc_decode_createargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_renameargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_filename(p, &args->fname, &args->flen))
-	 || !(p = decode_fh(p, &args->tfh))
-	 || !(p = decode_filename(p, &args->tname, &args->tlen)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_diropargs(xdr, &args->ffh,
+				       &args->fname, &args->flen) &&
+		svcxdr_decode_diropargs(xdr, &args->tfh,
+					&args->tname, &args->tlen);
 }
 
 int
-- 
2.43.0



