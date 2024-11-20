Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44901AB6F8;
	Wed, 20 Nov 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107687; cv=none; b=YuI7jUOU0Ft9/8+FaIuiFxJFdmlfk1XAH5Zb2GO44bfkuZv6oiPSKVbgk9LayVK36Phrwlbauu2IGpOGaQ4XzX/cZEF5hebyNcPYZbQfmJ9DA1OlMmavgUQPJEUEJ81SfqWWeXg9R/X2WPiHxxxT3b4mo6rLom7UafKoxrYNKjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107687; c=relaxed/simple;
	bh=P6pjCIbuPGd0//WINip3WH1vsv7nAz4DKGQ98iUzi1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6g0R8TXROoDhyvtXx+49aRJRka2omrHQbBsIZ5EzByP4vVN3Qa/serOo0AVWYIpgxngvn6+HsC9iIAKCC02peqVACz8uhG213EKuoAIKeRTHFh6y/JGe1D7z6y7Syg5JTSLQDnf0i1PlmwPXAR1m+ivWt/6By9mo6y05fhrSqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3CGG0Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3CGG0Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB720C4CECD;
	Wed, 20 Nov 2024 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107686;
	bh=P6pjCIbuPGd0//WINip3WH1vsv7nAz4DKGQ98iUzi1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3CGG0Ik4yAecf4BHXibpLM2H8uBV0aqYqIbA1Tpw5Hzcut5iLy6ysAIjL5xHNh9z
	 46c9JZbxlS4HcpyWDO32W2W+sKIVNXTv4vndSU/cC6LA+vJ2eSSlXSbAj+YtUgAAwI
	 IriI6tTh1rR2zSc3x8L0ZN/rO7TuJ1xG9TayDIp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 45/73] NFSD: Never decrement pending_async_copies on error
Date: Wed, 20 Nov 2024 13:58:31 +0100
Message-ID: <20241120125810.693186179@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8286f8b622990194207df9ab852e0f87c60d35e9 ]

The error flow in nfsd4_copy() calls cleanup_async_copy(), which
already decrements nn->pending_async_copies.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Fixes: aadc3bbea163 ("NFSD: Limit the number of concurrent async COPY operations")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1790,10 +1790,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		refcount_set(&async_copy->refcount, 1);
 		/* Arbitrary cap on number of pending async copy operations */
 		if (atomic_inc_return(&nn->pending_async_copies) >
-				(int)rqstp->rq_pool->sp_nrthreads) {
-			atomic_dec(&nn->pending_async_copies);
+				(int)rqstp->rq_pool->sp_nrthreads)
 			goto out_err;
-		}
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;


