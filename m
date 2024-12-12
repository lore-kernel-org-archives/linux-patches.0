Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83E222D63;
	Thu, 12 Dec 2024 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023628; cv=none; b=pMbIVGNk3kTh5CUqAkjW93Ng5q4VPv7dbZ+oU2J1bFTqCMJ2aqFRH+f9ojewy7/eJdqTFR/teGRjVp1O7j6xOyQ0wHijlLKs+CupjNXYrpsolhhPXti8/HBeo6P1Webvo+EjCSHlZy4b9yZGeeN4S3eAG5rLHB9UsNEmGq6X5kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023628; c=relaxed/simple;
	bh=+HUopQ8vIvjj34PIhTIHo0PeafA+DVRd+WkKw+pdkRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3Ych2SIj9zH3V2bjrFcdBvHc1aJzacO3VvOoK53wz7HNInClYHPHD6OR/1fAWx/aKEWjsoaZfgdQ0EaaysvgYX2ImurNOkOfQSguzDS8v7xnpspR52+EIx0D/34RcULVM8rnIKpftwmIl05YSBRow56MoZ1lA7WI1USHPgi6pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGuIOT/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGuIOT/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38991C4CED4;
	Thu, 12 Dec 2024 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023628;
	bh=+HUopQ8vIvjj34PIhTIHo0PeafA+DVRd+WkKw+pdkRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGuIOT/yjPsfeGFFZTLV9lGPYAwNuHrIa6AfNl9mXP8pYYzYGeKN5WQhVGcuTGTty
	 FkbSYHc7JPuv/Qi62WtQhUUa5iX8p2xLxm+rjzif//980YaF2RZlN9U7i0PDwrvz4d
	 XUBntpwVptT94FbNQ3XI1lJRCPhnNcNxdUkupNC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 030/459] NFSD: Never decrement pending_async_copies on error
Date: Thu, 12 Dec 2024 15:56:08 +0100
Message-ID: <20241212144254.714133338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
@@ -1791,10 +1791,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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


