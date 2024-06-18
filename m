Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10EF158DB3;
	Tue, 18 Jun 2024 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716405; cv=none; b=IcQY+LvfQBstJFKrr3gvQnKL6oEbS6iBM5FtSS5UkCVKDERrJkZnJ2ikbSYImV25RwC1zp8HBzFXi9C0Srz9qJoFDiUFwizaukyhlYk0gGXvylCKIF3/plwYXC62vyiYPecabntp+bpgof7G1WIuMraSsTOc+gqhIKn/tZXgvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716405; c=relaxed/simple;
	bh=XWMznKTwyxKexJlKp+RLXuAYla6Ey6XwV3T6gmE8Oqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWTcd2ylMlM3egvg4EedaSzTE+OfiwUqYYuZFN+UCJE/ZAKXwOjYqQ0raIEWvTCjsFTkYO1ry6lcYnrGDc7yUAXr0NwmcUfo42OKBtCHTgPEfQGf9gZFiJpoBjQDHsYFFZ62LwsKOS3WGxfXufqsWO0ySKHLg/mYSE3fgYoDiyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxXUe9GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxXUe9GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1235CC3277B;
	Tue, 18 Jun 2024 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716405;
	bh=XWMznKTwyxKexJlKp+RLXuAYla6Ey6XwV3T6gmE8Oqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxXUe9GZNce+t6ZhVqnBUsQEQqZ5+nYTxncdxR2Iqy98+FcJLutXPjCSC5HlkkO0e
	 1tMwYAZygFLB6JJwdQod2h3BaXrmIiKTMqaOH7HLEqgfKZi2jH6s2tpiuNwwi1Hyir
	 /CV+HW8ovtr+OFR1hJsINzR1912/VyFihloqmJLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 635/770] NFSD: Protect against send buffer overflow in NFSv2 READ
Date: Tue, 18 Jun 2024 14:38:08 +0200
Message-ID: <20240618123431.795928043@linuxfoundation.org>
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

[ Upstream commit 401bc1f90874280a80b93f23be33a0e7e2d1f912 ]

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
 fs/nfsd/nfsproc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 559603a0a5358..749c3354304c2 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -185,6 +185,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 		argp->count, argp->offset);
 
 	argp->count = min_t(u32, argp->count, NFSSVC_MAXBLKSIZE_V2);
+	argp->count = min_t(u32, argp->count, rqstp->rq_res.buflen);
 
 	v = 0;
 	len = argp->count;
-- 
2.43.0



