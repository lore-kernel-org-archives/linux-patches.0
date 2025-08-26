Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C8352FD9;
	Tue, 26 Aug 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218266; cv=none; b=uPZsQWmQftV69UVvQR12SbRytTy9gxxbp+Om3UTHa3KYzSZxkohSs/jHQGWnUFoz+MjiS2KZRU2+gLNSFbzxKVFNK2lsyujH7Zi8zvGRmzee0e3n7ksq0d7fR/1SWzGOpVLUrX77CiNHySzzFN/V9rNIkitXzWjd6aJWdjRYAtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218266; c=relaxed/simple;
	bh=i/BbdCfvnCfCQK+DKkJXrUcSOIfYrsVoiyAxN6t82SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW3wuCb9QVGToYvlf5apfMVreSrTcPF8B6W+A/zjUgh90QaEdPVHmrhRevByG8l+9myDB+BQ9jrI5pxAd7DjJiYtzddOBqi9+5eBZikxtBXIB9fnzz7HYpkp9m5BsvzjSxFSjmeHTeDhfmsKORQTAK6fPIb/u1/mapBPB3f9mkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmDqP13B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmDqP13B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD0AC4CEF1;
	Tue, 26 Aug 2025 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218265;
	bh=i/BbdCfvnCfCQK+DKkJXrUcSOIfYrsVoiyAxN6t82SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmDqP13Bg6ZM3LW/SIZSGprylJu/EYRPJIc465hLz2Kb9DhbkzY//4QRiiwCynfEB
	 fOPRzeOFJa/ZkJCa0W7tVd9B+yPFe71Ox8CCPrgSasHGr3QWw8RHtsuA8N7kcDZ+vp
	 RDURrEx01vzVA8bROYhWVVEdAksC0jL8cflagync=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/523] NFSv4: Fix nfs4_bitmap_copy_adjust()
Date: Tue, 26 Aug 2025 13:11:06 +0200
Message-ID: <20250826110935.696386887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -292,7 +292,7 @@ const u32 nfs4_fs_locations_bitmap[3] =
 };
 
 static void nfs4_bitmap_copy_adjust(__u32 *dst, const __u32 *src,
-		struct inode *inode)
+				    struct inode *inode, unsigned long flags)
 {
 	unsigned long cache_validity;
 
@@ -300,22 +300,19 @@ static void nfs4_bitmap_copy_adjust(__u3
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
@@ -3379,12 +3376,15 @@ static int nfs4_do_setattr(struct inode
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
@@ -4192,8 +4192,7 @@ static int _nfs4_proc_getattr(struct nfs
 	if (inode && (server->flags & NFS_MOUNT_SOFTREVAL))
 		task_flags |= RPC_TASK_TIMEOUT;
 
-	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, label), inode);
-
+	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, label), inode, 0);
 	nfs_fattr_init(fattr);
 	nfs4_init_sequence(&args.seq_args, &res.seq_res, 0, 0);
 	return nfs4_do_call_sync(server->client, server, &msg,
@@ -4795,8 +4794,8 @@ static int _nfs4_proc_link(struct inode
 	}
 
 	nfs4_inode_make_writeable(inode);
-	nfs4_bitmap_copy_adjust_setattr(bitmask, nfs4_bitmask(server, res.label), inode);
-
+	nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, res.label), inode,
+				NFS_INO_INVALID_CHANGE);
 	status = nfs4_call_sync(server->client, server, &msg, &arg.seq_args, &res.seq_res, 1);
 	if (!status) {
 		nfs4_update_changeattr(dir, &res.cinfo, res.fattr->time_start,


