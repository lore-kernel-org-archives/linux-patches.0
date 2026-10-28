Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208260;
	b=SzglT9bIeBNNyF+iQpI0cfIdX7rxEw/m/88pcMdd0DI/vSVvLNR8N9xGEm6Ovi+BsbKb
	 G2LEhOycv7SNWE1Pli8pWZlnbIkp8CRZymejBaJ3HC2/DjnL1w0yEbHoKexzL2KcVpdMG
	 y0+V+4L5zt2Fij1UE4IHtlUmmGGl9+I2OegUWuLR3r9RfCHXuTb4kNMhjvquxVl03gVu/
	 3nvHdCnZDuUsyY44/smvp2SNmIY/Dwak/roRb9zj0afPHm7aZBBOEbn3Zq32w+zi2NH6M
	 wuaAMtAjUO0G1ImX+WT/xzg6Zw3PdNKjgEF7xW1BvMax4YgcLNdkEkt4GhhxZm4CCaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FtWW/ibHOt/jN1Ii2Jotz+q/rlOSv77HoqqBrna3n+A=;
	b=ZuIGzyCbXtpvIYUXyxrzmVHXAZRtqqtjhUf4LhHxROXeW/dDwCNkcnf1/NjjE1xy5zFj
	 zLaC9KHxN58oVJBlJEpbMWBMMFQS3icO4dJRCgSWRkugR4lq85OpBbDmhsAHf4gr9ZOKQ
	 dAY4DSOvb4pSUD+4q3dbqEpVlnRI2C0XoUqQVJdSp1qAlvQIarMNndVWpus8CzzWBY42d
	 FBLlnl0IaZMf39eMSHnqrbukQQtWMWMTlrkP4HEfJhJM9VtLUUguJRjlDm/PNhv8Preq2
	 qeeu6wAQkn/OPTb6ZOYrNqh0q79FDtAQTOiKhGhGCyaOqrqVEH2GUm15XLI+lkKjQrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJE36qBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664C8606A31A;
	Wed, 28 Oct 2026 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJE36qBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67901F01825;
	Wed, 28 Oct 2026 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208260;
	bh=FtWW/ibHOt/jN1Ii2Jotz+q/rlOSv77HoqqBrna3n+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJE36qBzhwWf5wT2THLbnReOIFI4kro6Ji/ubMURBjdPRPdl6/QSGDjjbbZFKnW4w
	 5tw7Enl3KsH+BFH1eIViAuR22ZdMpqafcGJOArIlYf0erhA80u67NybdzssbwkqnuQ
	 N01snz2diB1YtpHQwnzrr7ddnm0geRVZBpaHH7xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/516] nfsd: gate nfs2 setacl by argp->mask
Date: Wed, 28 Oct 2026 17:53:22 +0100
Message-ID: <20261028170004.716928115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a3a7e20ed66d3f04d37883c398da8a113b430769 ]

The NFSACL v2 SETACL path shares the decoder convention used by its
v3 sibling: nfsaclsvc_decode_setaclargs() fills in argp->acl_access
only when NFS_ACL is set in the request mask and argp->acl_default
only when NFS_DFACL is set, leaving the other pointer NULL because
the argument buffer is zeroed up to pc_argzero before decode.

nfsacld_proc_setacl() then hands both pointers to set_posix_acl()
unconditionally. set_posix_acl(idmap, dentry, type, NULL) is the VFS
"remove this ACL type" operation, so an omitted arm is
indistinguishable from an explicit request to delete that ACL. A
SETACL carrying only NFS_ACL silently strips the directory's default
ACL; mask=0 strips both.

This is the same defect just fixed in nfsd3_proc_setacl(); apply the
same remedy. Gate each set_posix_acl() call on its mask bit and
initialize error to 0 so that a request with neither bit set leaves
the on-disk ACLs untouched and returns success. The out_drop_lock
path and the unconditional posix_acl_release() in
nfsaclsvc_release_setacl() already tolerate the skipped arms.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ adapted four-argument set_posix_acl() calls to the older three-argument inode-based API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index eb79ca463b28a..f1d4ca17cb9e7 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -115,12 +115,17 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 
 	inode_lock(inode);
 
-	error = set_posix_acl(inode, ACL_TYPE_ACCESS, argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(inode, ACL_TYPE_DEFAULT, argp->acl_default);
-	if (error)
-		goto out_drop_lock;
+	error = 0;
+	if (argp->mask & NFS_ACL) {
+		error = set_posix_acl(inode, ACL_TYPE_ACCESS, argp->acl_access);
+		if (error)
+			goto out_drop_lock;
+	}
+	if (argp->mask & NFS_DFACL) {
+		error = set_posix_acl(inode, ACL_TYPE_DEFAULT, argp->acl_default);
+		if (error)
+			goto out_drop_lock;
+	}
 
 	inode_unlock(inode);
 
-- 
2.53.0



