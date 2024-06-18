Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16B1A2FBB;
	Tue, 18 Jun 2024 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716408; cv=none; b=L8zivQMtds8nTqvZ/d5pKvfTPcCVR6ZRFfnI9EN34h3/ifMr7Q/ZAvi5NEMM7b/sb4YRNb3u9b2qMSMQQPVWWWQJw0zWg5OlmHl56R/gvJytbEwkKNKv4IA7r16TISysfq8kQnGXsaKXaixU0UgwBxs5WxxbDFgT9QBRg1j5cVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716408; c=relaxed/simple;
	bh=sh0Pr+KmjNd67m58Li3hnq30V1ARWU/ASGZ27iZl73E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9KScZR7rvJhPVFRxZm5YcIWRtFb3UIYuwC/m105cZfVNhAL1/mA3EhTolgmhTuo0htzcFqEkG8+L4dr/0/F1czCFNWUEuef1u/K8oMnP+lGuJv5GMFqC+XfzR9OH2c+FBQ3Qw8593knnyErD8g9iMcWxsJrW6LLWg2g9AOqrY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUaOt7Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUaOt7Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056E4C3277B;
	Tue, 18 Jun 2024 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716408;
	bh=sh0Pr+KmjNd67m58Li3hnq30V1ARWU/ASGZ27iZl73E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUaOt7VwCPuAEM32KdsHX60KzIX+6GKpg65Q/tXo8jhHcH3rYj4XDQHC6ug0JxUAB
	 cfm6WLBaUI8YxgQdm7x8Sne2BQ1dUjvA0Yerq8M0V4TqKVcoIqDZu0p0uroI+0Q+rq
	 i45/hk19CuyOy6kQhF8u6i7XfZ3xjoPAiXZFGfyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 636/770] NFSD: Protect against send buffer overflow in NFSv3 READ
Date: Tue, 18 Jun 2024 14:38:09 +0200
Message-ID: <20240618123431.833585121@linuxfoundation.org>
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

[ Upstream commit fa6be9cc6e80ec79892ddf08a8c10cabab9baf38 ]

Since before the git era, NFSD has conserved the number of pages
held by each nfsd thread by combining the RPC receive and send
buffers into a single array of pages. This works because there are
no cases where an operation needs a large RPC Call message and a
large RPC Reply at the same time.

Once an RPC Call has been received, svc_process() updates
svc_rqst::rq_res to describe the part of rq_pages that can be
used for constructing the Reply. This means that the send buffer
(rq_res) shrinks when the received RPC record containing the RPC
Call is large.

A client can force this shrinkage on TCP by sending a correctly-
formed RPC Call header contained in an RPC record that is
excessively large. The full maximum payload size cannot be
constructed in that case.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index d808779ab4538..8679c41746027 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -150,7 +150,6 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 {
 	struct nfsd3_readargs *argp = rqstp->rq_argp;
 	struct nfsd3_readres *resp = rqstp->rq_resp;
-	u32 max_blocksize = svc_max_payload(rqstp);
 	unsigned int len;
 	int v;
 
@@ -159,7 +158,8 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
-	argp->count = min_t(u32, argp->count, max_blocksize);
+	argp->count = min_t(u32, argp->count, svc_max_payload(rqstp));
+	argp->count = min_t(u32, argp->count, rqstp->rq_res.buflen);
 	if (argp->offset > (u64)OFFSET_MAX)
 		argp->offset = (u64)OFFSET_MAX;
 	if (argp->offset + argp->count > (u64)OFFSET_MAX)
-- 
2.43.0



