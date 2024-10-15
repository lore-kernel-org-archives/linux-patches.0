Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CC31EC003;
	Tue, 15 Oct 2024 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997442; cv=none; b=CZrmJUQqCD3erWQGJfRNw9QSoU75ERSOUTgpRTg7dTmvLznkHGnSt7CJmAK16ZA1BF3g9a8QLJOGJcR3fDB15UJRQwzgFeqdkxW3hfhQz3K99/9fYXNzRUwkY8aY0Ou+i1CMNbBnr3QYXnRIZ2gLafgK+6oMR8Wlqa3gcrSlz/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997442; c=relaxed/simple;
	bh=rn/SP4WnnpWoZB5ug1oJglnlmfsk7U9xTxq8dyC6UCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faqa6RrS+ffdIE8hy3B8Hb0SwE+ilMKJk8wtEGt3Xa7JIlSnvTIN5RSjNgGTm5P+WRhNCEByFlKwzrppS8yDqYQSLods4HpZY6f83Qpuo/5RmEzGM3WrKjLksw7TRQ2+2YKNbcuIYB6KXc0O66OalB2TsCt/uyom2iKgprzeKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwcC96cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwcC96cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5DCC4CECE;
	Tue, 15 Oct 2024 13:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997441;
	bh=rn/SP4WnnpWoZB5ug1oJglnlmfsk7U9xTxq8dyC6UCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwcC96czjt4lt/AmjR00DzJHAJV2B6mVBO4BwlkBnkb9Q4944NldkqP+Z1KO6magI
	 tLlxFG74MigIkf3LOQ+Oxtp4qQRDA4kVumDuVNzP43/ZLYD9E6a3Jq1KPrSLY9GWie
	 9Ajss5H5soEMU9gOZSriVVljiDxQliluOYHFpGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.10 184/518] nfsd: call cache_put if xdr_reserve_space returns NULL
Date: Tue, 15 Oct 2024 14:41:28 +0200
Message-ID: <20241015123924.090011622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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



