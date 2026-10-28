Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216066;
	b=q07DWNuHawRusOhaGRhmxUC4kHJREDQS7bMNXwnYwJmCvceQewrEddvpasH79HK060HQ
	 zOba1WiN1vex7tgSiIKhYYaMocVVk7YyfmeajM70xJPWalA258xoI8levYidqFepLUG1v
	 PwGJxjBtNRerE5Wbu5ZmXc2bWDeT9yXxoK+bcPQ+ibD2of2jI4mh7AgK2poRhSg6XvpuR
	 Ju0I77kb84260k4OSnGoa/zErSMj90PhwteJU9KtsRGCE8VPwI3i2OXE+02Tne8BFSz2L
	 uqk635+PEGqdw4k3IEv6hRICh5Huw7iIrR8EFqeXA0FQJZuagmHMWURLYISgI4/tQAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPlD36hCGEKufyWkgM1GYGevahBR+/DA+yPwnqG1fD0=;
	b=aVEjZVd95px0+GJS9aZingCNl9GBZ5gHzLe55+5nkn1rjXnHXDHG8XoCFOV3idjX2wFt
	 e9HT9MVf5nifLdJzuUZiO+J0Ru1znt8DSIjEanLfgohjvZKQrHr8BkeUaXK5X7ZdlapE5
	 ZLsCWym35PWprUdxpAyAjfE3svuHw5jttr9J7pcx61aIGjvqXP8NOjU6sTkVUtBH9T5LH
	 8eI+2S6V4FwzDmmanLK4Xali9n4uzg6mLIW8IZ/iSet4HtWP8aHrYX0FJgZJO/pbeL45H
	 NpPXdyPogTysnsm4h/sK/Y4L21hgll/4uaSEWrTP00f+DrE8HU0i4KS1UhnzwWvRkzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gcm1YhS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E87F606A31C;
	Wed, 28 Oct 2026 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gcm1YhS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D921F01825;
	Wed, 28 Oct 2026 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216066;
	bh=BPlD36hCGEKufyWkgM1GYGevahBR+/DA+yPwnqG1fD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gcm1YhStbCsfWfaoWDBbySFWAcDPXI+gcVhUw8/MsWXbHuNI0B5wq++DXZ6Gm8AD
	 Djee70B9PyTTWXp+OEe6IgewKLflKTcFHQk3whcHoCTUhHn++xLwkBnlptbAxgBwYR
	 4dbddQoKkr7NYbrAtEbT3mpiih2cDM/0W/PQze/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1430/1887] nfsd: gate nfs3 setacl by argp->mask
Date: Wed, 28 Oct 2026 17:58:46 +0100
Message-ID: <20261028170532.001271603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 453d7198a0ab07a12d46e0575861ac7b932da17e ]

nfsd3_proc_setacl() calls set_posix_acl() unconditionally for both
ACL_TYPE_ACCESS and ACL_TYPE_DEFAULT, passing argp->acl_access and
argp->acl_default verbatim. The NFSv3 ACL decoder only populates
those pointers when the corresponding mask bit is set:

    nfs3svc_decode_setaclargs()
      if (args->mask & NFS_ACL)    decode into acl_access
      if (args->mask & NFS_DFACL)  decode into acl_default
      /* otherwise the pointer stays NULL (pc_argzero) */

    nfsd3_proc_setacl()
      set_posix_acl(.., ACL_TYPE_ACCESS,  argp->acl_access)
      set_posix_acl(.., ACL_TYPE_DEFAULT, argp->acl_default)

set_posix_acl(idmap, dentry, type, NULL) is the VFS "remove this
ACL type" operation. A NULL pointer that means "the client did not
send this arm" is therefore indistinguishable from "the client
asked to remove this ACL". A SETACL with mask=NFS_ACL silently
drops the directory's default ACL; mask=0 drops both.

The sibling nfsd3_proc_getacl() already consults argp->mask before
touching each arm; mirror that in setacl.

Fix by wrapping each set_posix_acl() call in the matching mask bit
check and initializing error to 0 before inode_lock so that a
request with neither bit set leaves the on-disk ACLs untouched and
returns nfs_ok. The out_drop_lock path and the unconditional
posix_acl_release() at out: are preserved; both NULL-tolerate the
skipped arms.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-5-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index d100a8a00e08e..62435b137b9cd 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -105,12 +105,17 @@ static __be32 nfsd3_proc_setacl(struct svc_rqst *rqstp)
 
 	inode_lock(inode);
 
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS,
-			      argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_DEFAULT,
-			      argp->acl_default);
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
+	}
 
 out_drop_lock:
 	inode_unlock(inode);
-- 
2.53.0



