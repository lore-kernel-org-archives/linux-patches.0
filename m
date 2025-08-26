Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6C0352081;
	Tue, 26 Aug 2025 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219448; cv=none; b=Wp9Ofcl+kMGp/0b+UnL9/WqCVxITpnhXSeewPMlJ1xFJBJ1M/DfhuAuzuU7HeaNrcQW3zCJrUORslCBFIzSbyAgcEyPaJvpXb2M6cZ4nEUaeahQ4n0VqFo9anXuQplS0aZBr+9hiTSng15X1M7BI+1s298q1wRbklgxg9NK1MLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219448; c=relaxed/simple;
	bh=E+DDqpL4NImO2NKgx+JNXq9Y0i2oOaCGkVzVZkgIlDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSSj3b9Vo3yxeoVSotWm2GcPklntMH9aBckl0wwupxqU0l3FTzqDLHPsfSmlbcDqYGtCxLrm5IzJTgMv+u1XsnWjtWznrMF86QGu7KBw6U//D4md+S2v1W5+0Po54vEjib7kmtBVn5iwuCmKfKKSeIbjnLnTviRx57otEATF0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eu/BH0Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eu/BH0Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD04C4CEF1;
	Tue, 26 Aug 2025 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219448;
	bh=E+DDqpL4NImO2NKgx+JNXq9Y0i2oOaCGkVzVZkgIlDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu/BH0CuVKWu/EjOz0IKshg43Oj09799u7mcqDJl5Jsmy4UOAeJW8IRbQyJnynMnO
	 aRwoUABEAvXG3Tr77ZDoPdFELiwvfdaTgyT6OKTswxSqBiwV6JPLXm5aiS8RlOW9EV
	 +LUarnYnkI+P34B25wfCVQ9zg6CJmGJHBAnNyTvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 355/403] NFSv4: Fix nfs4_bitmap_copy_adjust()
Date: Tue, 26 Aug 2025 13:11:21 +0200
Message-ID: <20250826110916.683270446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a71029b86752e8d40301af235a6bbf4896cc1402 ]

Don't remove flags from the set retrieved from the cache_validity.
We do want to retrieve all attributes that are listed as being
invalid, whether or not there is a delegation set.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -282,7 +282,7 @@ const u32 nfs4_fs_locations_bitmap[3] =
 };
 
 static void nfs4_bitmap_copy_adjust(__u32 *dst, const __u32 *src,
-		struct inode *inode)
+				    struct inode *inode, unsigned long flags)
 {
 	unsigned long cache_validity;
 
@@ -290,22 +290,19 @@ static void nfs4_bitmap_copy_adjust(__u3
 	if (!inode || !nfs4_have_delegation(inode, FMODE_READ))
 		return;
 
-	cache_validity = READ_ONCE(NFS_I(inode)->cache_validity);
-	if (!(cache_validity & NFS_INO_REVAL_FORCED))
-		cache_validity &= ~(NFS_INO_INVALID_CHANGE
-				| NFS_INO_INVALID_SIZE);
+	cache_validity = READ_ONCE(NFS_I(inode)->cache_validity) | flags;
 
+	/* Remove the attributes over which we have full control */
+	dst[1] &= ~FATTR4_WORD1_RAWDEV;
 	if (!(cache_validity & NFS_INO_INVALID_SIZE))
 		dst[0] &= ~FATTR4_WORD0_SIZE;
 
 	if (!(cache_validity & NFS_INO_INVALID_CHANGE))
 		dst[0] &= ~FATTR4_WORD0_CHANGE;
-}
 
-static void nfs4_bitmap_copy_adjust_setattr(__u32 *dst,
-		const __u32 *src, struct inode *inode)
-{
-	nfs4_bitmap_copy_adjust(dst, src, inode);
+	if (!(cache_validity & NFS_INO_INVALID_OTHER))
+		dst[1] &= ~(FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER |
+			    FATTR4_WORD1_OWNER_GROUP);
 }
 
 static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dentry,
@@ -3333,12 +3330,15 @@ static int nfs4_do_setattr(struct inode
 		.inode = inode,
 		.stateid = &arg.stateid,
 	};
+	unsigned long adjust_flags = NFS_INO_INVALID_CHANGE;
 	int err;
 
+	if (sattr->ia_valid & (ATTR_MODE|ATTR_UID|ATTR_GID))
+		adjust_flags |= NFS_INO_INVALID_OTHER;
+
 	do {
-		nfs4_bitmap_copy_adjust_setattr(bitmask,
-				nfs4_bitmask(server, olabel),
-				inode);
+		nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, olabel),
+					inode, adjust_flags);
 
 		err = _nfs4_do_setattr(inode, &arg, &res, cred, ctx);
 		switch (err) {
@@ -4143,8 +4143,7 @@ static int _nfs4_proc_getattr(struct nfs
 		.rpc_resp = &res,
 	};
 
-	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, label), inode);
-
+	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, label), inode, 0);
 	nfs_fattr_init(fattr);
 	return nfs4_call_sync(server->client, server, &msg, &args.seq_args, &res.seq_res, 0);
 }
@@ -4732,8 +4731,8 @@ static int _nfs4_proc_link(struct inode
 	}
 
 	nfs4_inode_make_writeable(inode);
-	nfs4_bitmap_copy_adjust_setattr(bitmask, nfs4_bitmask(server, res.label), inode);
-
+	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, res.label), inode,
+				NFS_INO_INVALID_CHANGE);
 	status = nfs4_call_sync(server->client, server, &msg, &arg.seq_args, &res.seq_res, 1);
 	if (!status) {
 		update_changeattr(dir, &res.cinfo, res.fattr->time_start, 0);


