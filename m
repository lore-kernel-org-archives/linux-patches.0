Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DDF13D8BC;
	Tue, 18 Jun 2024 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715186; cv=none; b=N0DICMzemiviPf32B/oforHvQVBwSHBZzSZ73ZRuRFZJ2eBC4H5qyzK8AMdDwo7ODUvoEieQJydW5UFd6AsnAiE084UckxyP9pRwy2ZCz/H7/i1wHUPdMgxj82YeRwQUK0YzEo4VGgU/vEJzH2vpwhCk91AbY66SfYxBRvpL+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715186; c=relaxed/simple;
	bh=pJ5buSq0179c0YB9Wu+CS6M9kbcyyF0oQ3AiNg40M5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE+EezA+akPGN0Gq9rgrYjeoVs0IURsVHp7sE1PalWgF6xK0egvIrqhuykqWaCQq8l9mJGqfsbabzG3hETls+NHQn8qFK2UyLD31F6h5XKHomRjolDg9WsF+2UtkIlsZlfGTo98/69Ci5/YlMgmXSwQ7N1fHYAdCqCXidsd9CeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zC4xK1UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC4xK1UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659A8C3277B;
	Tue, 18 Jun 2024 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715185;
	bh=pJ5buSq0179c0YB9Wu+CS6M9kbcyyF0oQ3AiNg40M5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC4xK1UY0zabTJV1okAo7ZVKlYLaV+SGVYccwLy8pgzMh7G7L5ceAZGu09kOtR3ww
	 GuJWtZrS9J6G36IHvqX5DKbIG3uWpdz43oCfrZJ23Z6+OoQHrNm3VaL1L14P/rdgtK
	 CVwJBHPxwqnjVv/gVK+S7qCpDb3rdYaS1xyFa0Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/770] NFSD: Add a helper that encodes NFSv3 directory offset cookies, again
Date: Tue, 18 Jun 2024 14:31:17 +0200
Message-ID: <20240618123415.930199526@linuxfoundation.org>
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

[ Upstream commit d52532002ffa217ad3fa4c3ba86c95203d21dd21 ]

Refactor: Add helper function similar to nfs3svc_encode_cookie3().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  3 +--
 fs/nfsd/nfsxdr.c  | 18 ++++++++++++++++--
 fs/nfsd/xdr.h     |  1 +
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 1fd91e00b97ba..2d3d7cdffd52f 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -595,8 +595,7 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 				    &resp->common, nfssvc_encode_entry);
 
 	resp->count = resp->buffer - buffer;
-	if (resp->offset)
-		*resp->offset = htonl(offset);
+	nfssvc_encode_nfscookie(resp, offset);
 
 	fh_put(&argp->fh);
 	return rpc_success;
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 39d296aecd3e7..a87b21cfe0d03 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -614,6 +614,21 @@ nfssvc_encode_statfsres(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+/**
+ * nfssvc_encode_nfscookie - Encode a directory offset cookie
+ * @resp: readdir result context
+ * @offset: offset cookie to encode
+ *
+ */
+void nfssvc_encode_nfscookie(struct nfsd_readdirres *resp, u32 offset)
+{
+	if (!resp->offset)
+		return;
+
+	*resp->offset = cpu_to_be32(offset);
+	resp->offset = NULL;
+}
+
 int
 nfssvc_encode_entry(void *ccdv, const char *name,
 		    int namlen, loff_t offset, u64 ino, unsigned int d_type)
@@ -632,8 +647,7 @@ nfssvc_encode_entry(void *ccdv, const char *name,
 		cd->common.err = nfserr_fbig;
 		return -EINVAL;
 	}
-	if (cd->offset)
-		*cd->offset = htonl(offset);
+	nfssvc_encode_nfscookie(cd, offset);
 
 	/* truncate filename */
 	namlen = min(namlen, NFS2_MAXNAMLEN);
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 337c581e15b4c..75b3b31445340 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -157,6 +157,7 @@ int nfssvc_encode_readres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_statfsres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *);
 
+void nfssvc_encode_nfscookie(struct nfsd_readdirres *resp, u32 offset);
 int nfssvc_encode_entry(void *, const char *name,
 			int namlen, loff_t offset, u64 ino, unsigned int);
 
-- 
2.43.0



