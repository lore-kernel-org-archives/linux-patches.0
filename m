Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC7B1AC8AE;
	Mon, 14 Oct 2024 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918129; cv=none; b=QkSMKXID5fdpRLoMNUbAw1PGidK19vIYTXYCpyhLKNJScY+TjkcsDG2YvAAIyINPFAHCXFRU6z59Bve1B9u9d2w6mGNaQjhY0L2BB+PKp8qPSHXnB0TWSJledtL5ImW0CV2ofxXl+Tasxh7i76ae71DCVhYlqWqAGGFacieKAJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918129; c=relaxed/simple;
	bh=76hQJEJJRVMLDaNlkc6hWPLhaPhFFpiRQKMsHtqlm/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv57wKKHZd0ArjrzOYIjNQsx4TwN/B0hRb1xumScXNjK2hyg1zvbUjcvo1WAipRf3DjWcNbl3ahWFvEDn7FL3NusYjYL3bGqVsHT9PdsGcpTMMqNtNiwlpo46162gPU5cFkKvZIcRhOuimoro7fXVDBvJU0SKZuiFTJxFrJh37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxX2UfpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxX2UfpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED22C4CEC3;
	Mon, 14 Oct 2024 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918129;
	bh=76hQJEJJRVMLDaNlkc6hWPLhaPhFFpiRQKMsHtqlm/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxX2UfpNsHlqe1kOraqQVLJcKz00t8Izge2Jv945kFO/Z1bIiI310SSxJJ1PxxSI5
	 EG0/XGvbZrAkCYdeSGLlPYy1R209Z5Iem2XWZb2GrPU91HqpELA7ai6mMD54mIFaHO
	 zObBPerlWYBml1HeT8jAwsxbWnOEBfRdM8UEcumc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 232/798] nfsd: call cache_put if xdr_reserve_space returns NULL
Date: Mon, 14 Oct 2024 16:13:06 +0200
Message-ID: <20241014141227.036511082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit d078cbf5c38de83bc31f83c47dcd2184c04a50c7 ]

If not enough buffer space available, but idmap_lookup has triggered
lookup_fn which calls cache_get and returns successfully. Then we
missed to call cache_put here which pairs with cache_get.

Fixes: ddd1ea563672 ("nfsd4: use xdr_reserve_space in attribute encoding")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Reviwed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4idmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 5e9809aff37eb..717e400b16b86 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -581,6 +581,7 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		.id = id,
 		.type = type,
 	};
+	__be32 status = nfs_ok;
 	__be32 *p;
 	int ret;
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
@@ -593,12 +594,16 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		return nfserrno(ret);
 	ret = strlen(item->name);
 	WARN_ON_ONCE(ret > IDMAP_NAMESZ);
+
 	p = xdr_reserve_space(xdr, ret + 4);
-	if (!p)
-		return nfserr_resource;
-	p = xdr_encode_opaque(p, item->name, ret);
+	if (unlikely(!p)) {
+		status = nfserr_resource;
+		goto out_put;
+	}
+	xdr_encode_opaque(p, item->name, ret);
+out_put:
 	cache_put(&item->h, nn->idtoname_cache);
-	return 0;
+	return status;
 }
 
 static bool
-- 
2.43.0



