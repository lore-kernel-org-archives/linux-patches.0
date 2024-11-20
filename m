Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7121C830E;
	Wed, 20 Nov 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107613; cv=none; b=etvbrIeQ4hU7Hyew0232c+F0wiXhs4FbjUhxbT+/DQoZjOQZaWp2Vv7ztGIkQydML47r29LtJ6V0IWgIYpaqsmATWxw/9z/hpFDRbmzFhsDzEIVnBp4oJf8GdNhaz+95HPOLpdFZLiWGTZSWSvlwzhJ9QoR/UQUPhIcAwwt58hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107613; c=relaxed/simple;
	bh=6peEzfFwRV3/UIL7Wj7TGwRy1UoogqihR1/MVjtPfTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcTyNMvVpMwnTxZU5ARNW6XVlGaJR8VMiC053hVUEnl/BagsJJ67xmIesv2ouaaTy6dP+H/rUdNqDsOz4uo8MrVaFlXweHyfxagbpqE6dMasSw3OqWzvvAoPX2sbyi8QPZSKqb6Fvx5h0jbDnC2Ou/CQ5bZkTn7A/ntyIWVo15M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRMrV+9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRMrV+9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B059C4CECD;
	Wed, 20 Nov 2024 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107613;
	bh=6peEzfFwRV3/UIL7Wj7TGwRy1UoogqihR1/MVjtPfTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRMrV+9Oxg287yGSYwugcxKuUpkgU1dDoIdacQBKtZiW/h1qD/KGgDLizHT3P+nyn
	 xaiuDNCU1c0OVXsTLIhnqGbCnnSE8hvtyePqRVq7yHRPj3eMwz7edEBJdgOsumNjRn
	 TPyd1kkFaIz8wiPedpGELZvC7P/MH2So/RGiQkAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 65/82] NFSD: Never decrement pending_async_copies on error
Date: Wed, 20 Nov 2024 13:57:15 +0100
Message-ID: <20241120125631.075734675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1820,10 +1820,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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


