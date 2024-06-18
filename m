Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345B158D9F;
	Tue, 18 Jun 2024 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716402; cv=none; b=MDEmfip3+I3M8SBMICUTiYaPK3G7qWaZKBun44HDYu+DLrxu1+rLFbbef1pZLQfKBYESWtuExRKW9kVcw2xDwuucZcWh33Ljd6OS0LEpM3lfB2ZRuSjDl1FzCfTOMQ4D0QI6NWxKxC3HEKsSNOlHKHFZmdIUkRZlo+6xevLgy5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716402; c=relaxed/simple;
	bh=mehLvUsV6WH454ltcxsxQOfD6TMXnLJpjb+aq8qkSXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8dWsr19OclkF9lCL9p7L857aTPi19FknkoAGdNnOaXp5CHCzQLbco17nWZNldd4A+US3P1G8+4X68Z+YeqYZ00eXmp2uA6xl9cxraLZJeOrHtNlK7z6UONwFpwxBVjlAtPXq3tMfYc/iv/mycrD4Yu7A75mZmRu8lMXCI3mIh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHt1qXsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHt1qXsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29865C3277B;
	Tue, 18 Jun 2024 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716402;
	bh=mehLvUsV6WH454ltcxsxQOfD6TMXnLJpjb+aq8qkSXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHt1qXsSWKkKm5DN9ec6pfb3qRd3B56zYykEfSHIQGRYSIrhgXK2SiTw2bsmDLf/M
	 WcW9mXwRjAiHv0TFnaZRFwNTuiO2QbyEdzCfExfoVrj/aaje2nzsN75qqzI1MyTKg1
	 m/pi9zZatShzQZnUgMiTVecgTMZSNdLzH0htH6zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Ronallo <Benjamin.Ronallo@synopsys.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 634/770] NFSD: Protect against send buffer overflow in NFSv3 READDIR
Date: Tue, 18 Jun 2024 14:38:07 +0200
Message-ID: <20240618123431.756677086@linuxfoundation.org>
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

[ Upstream commit 640f87c190e0d1b2a0fcb2ecf6d2cd53b1c41991 ]

Since before the git era, NFSD has conserved the number of pages
held by each nfsd thread by combining the RPC receive and send
buffers into a single array of pages. This works because there are
no cases where an operation needs a large RPC Call message and a
large RPC Reply message at the same time.

Once an RPC Call has been received, svc_process() updates
svc_rqst::rq_res to describe the part of rq_pages that can be
used for constructing the Reply. This means that the send buffer
(rq_res) shrinks when the received RPC record containing the RPC
Call is large.

A client can force this shrinkage on TCP by sending a correctly-
formed RPC Call header contained in an RPC record that is
excessively large. The full maximum payload size cannot be
constructed in that case.

Thanks to Aleksi Illikainen and Kari Hulkko for uncovering this
issue.

Reported-by: Ben Ronallo <Benjamin.Ronallo@synopsys.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 1a52f0b06ec32..d808779ab4538 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -563,13 +563,14 @@ static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
-
-	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
+	unsigned int sendbuf = min_t(unsigned int, rqstp->rq_res.buflen,
+				     svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
-	buf->buflen = count - XDR_UNIT * 2;
+	buf->buflen = clamp(count, (u32)(XDR_UNIT * 2), sendbuf);
+	buf->buflen -= XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page += (buf->buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-- 
2.43.0



