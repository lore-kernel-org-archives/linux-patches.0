Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210518;
	b=q9GzNnYZMnjYEMdDs+qPfr7hzM1XUvBqA/FbK4sseGunqmdnk6fMos6Urio4wDmiExNo
	 QVEhSI/qvojb9GOlDbreBB/Uz0P4FGhrHopGjH0nYeDFHYxCYCPxOwcH2yoa+gmD3gK3t
	 igA5MBhOw5B6WiGETWh32hrv9BFZbQZFAUoMvvfhl1mjumAnKHqbJqoO7CW/mZLcnV195
	 eUc6xoVTC752TFj4vdjxXuArZ4hMTUxlYnYDktcfXZMMB8Dsjo80okgcOkNkG/W5q8nFb
	 pOERUerr/b4wFkCAKTFBSnMG37dlt9IK68Zjay7tQ8i2q4MV24RsMcSL4UwNm09ZTZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yX+I4c3gdTHowZI1UnKHltg+s1kesLc6QnI2pq2xbn8=;
	b=0gFz2JISTyXbR5EIgJU4XxICH00mAZdppWmkIC5U5rwNOP5LJ2kjgsFRpL7asoHAI92I
	 js5vXHX9rAnxbPljAGF60/459i+T63T/lWRVsEjvLmGa0OPO/akOzO967WYz52Di8Op52
	 zw/0R/u7TsoipoeQ4JLXShbn3I2OvxWbGECPIydt/6rTfcDgY6b64xLNZOODPRPlp/FPT
	 dsAEmm+TUb4aw2dQCIZEM/o1cfLPIcLj7PWwJn6pYR3PGREdeuX5a9HDi/gcqqgFWHV81
	 4cWlAkhd+RxQIwfXQ1lpgqatHHpZ6O3B45NNYSjPdWRsHfE3kXP1l4admnbBi028EqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nAMOICnM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCEC606A32F;
	Wed, 28 Oct 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nAMOICnM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6822D1F01829;
	Wed, 28 Oct 2026 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210517;
	bh=yX+I4c3gdTHowZI1UnKHltg+s1kesLc6QnI2pq2xbn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAMOICnM+22JClSMm6PRN+6+U9lCx73Siec/a7Yi2C1kLa3g9jio5G36NgwpKc07c
	 lNq3X3rcljXhvErvay23uFED087KMDOuz8WJMLlQzlhMRKFb/E+DAeTGSmVSnbAkCI
	 fgzbi/IG3U2M8q+xuWmNIF/15tTRN5GBc4kWiAPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/571] nfsd: gate nfs2 setacl by argp->mask
Date: Wed, 28 Oct 2026 17:53:21 +0100
Message-ID: <20261028170009.309330735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ retained the older user-namespace and inode set_posix_acl() API in place of the newer mount-idmap and dentry API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index f8b91aacd8174..cd6de7aca989f 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -115,14 +115,19 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 
 	inode_lock(inode);
 
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS,
-			      argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_DEFAULT,
-			      argp->acl_default);
-	if (error)
-		goto out_drop_lock;
+	error = 0;
+	if (argp->mask & NFS_ACL) {
+		error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS,
+				      argp->acl_access);
+		if (error)
+			goto out_drop_lock;
+	}
+	if (argp->mask & NFS_DFACL) {
+		error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_DEFAULT,
+				      argp->acl_default);
+		if (error)
+			goto out_drop_lock;
+	}
 
 	inode_unlock(inode);
 
-- 
2.53.0



