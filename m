Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704907;
	b=nKb20O7JcdvqGWJdV1D48bl1WcmaZivXgAgFau2VNZ/m+oPLbyGCFRwmtSruI2RHqLjJ
	 5Kn6V48XvBQbzCmRUWphkC653wPsvjdOEdeozuKb1i5nXisY8FohlsQCgov/AH6ZSZWyR
	 /LZRDjhul9HHm/rj+TVtWgJbjmUpONSgzLFD3XRgYoTeL3wTffj63mdagXdJ+brAGIugq
	 pgtqkno/+pvqrmADkgMbHRXG//iWmBv73wxJIqdoJbSMQ5g9O5PWgDhq5MD1hDzNMtRci
	 +EE/zI5ltW3A1ypMLIpUcdghqqQ3AC8Vfy0n3FIKewSbpIG9Z1rKVhJ/iUH92A+dkZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FE95prvSEeuA2NpYhwNp5Ox+8CV3zZYbqL4BY5ozhYk=;
	b=CSPp6/VyHPbfDkHIW4YrlWWgsl9BnonhjTBIyl6C5zpyFLgE+tXRLj/HX1Za8PFjZ+G2
	 4u2Te0v+U9dFo7F2om8lAP9ilKjoeFb8vCHP/ZKvQBC2ECWLy0B7sqWd7oanBjp6SB7cU
	 KFyY6SzhWIBHT9Do9BbaIWomoRqTzeoF+WnqHxc/qZed5Ytr89Wwxk9NXQNDkR24dR+gg
	 y/gl1EGMz+KjkaxlEWx6V9ikJvvAtCmqTjCEm5ufjyZzxPXlOjD6yiSq+ySVsCK+k/Eyv
	 CszVepu3fdYAdP4+frK2YUZcQxRPZRaZ/zfr4G2OJuSEmdb0SwG1FOgPPFteqYJ/NAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JvM6//zp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B740606A31E;
	Thu, 26 Nov 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvM6//zp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A041F000D2;
	Thu, 26 Nov 2026 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704906;
	bh=FE95prvSEeuA2NpYhwNp5Ox+8CV3zZYbqL4BY5ozhYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvM6//zpOl46QbGZynGOYIU+Z83S85VcGHoMN6z+33PrtpTiKAYbUqX7zsW3asOvu
	 +4257HN5r/Chobi8bzk2J9AqaWuaFnyPjHye+Xw9Cf1BHU0GyXzH1vmA2NMyChm1tk
	 LV8gubYUqE45jYdwbqi3A+wum2FXu+nSruXELKzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/319] fs/9p: switch vfsmount to use v9fs_get_new_inode
Date: Thu, 26 Nov 2026 15:36:25 +0100
Message-ID: <20261126144007.129632176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit fe1371d0f8c6a9aa4441ddd09ea6d4f31b975a81 ]

In the process of cleaning up inode number allocation, I noticed several functions which didn't use the standard helper
allocators.  This patch fixes the allocation in the mount entrypoint.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Stable-dep-of: 8bb0279930cc ("9p: skip intermediate directory entry name copy in p9dirent_read()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_super.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 51ac2653984a7..118fe8069bf75 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -113,7 +113,6 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
-	umode_t mode = 0777 | S_ISVTX;
 	struct p9_fid *fid;
 	int retval = 0;
 
@@ -143,7 +142,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	else
 		sb->s_d_op = &v9fs_dentry_operations;
 
-	inode = v9fs_get_inode(sb, S_IFDIR | mode, 0);
+	inode = v9fs_get_new_inode_from_fid(v9ses, fid, sb);
 	if (IS_ERR(inode)) {
 		retval = PTR_ERR(inode);
 		goto release_sb;
@@ -155,32 +154,6 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		goto release_sb;
 	}
 	sb->s_root = root;
-	if (v9fs_proto_dotl(v9ses)) {
-		struct p9_stat_dotl *st = NULL;
-
-		st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
-		if (IS_ERR(st)) {
-			retval = PTR_ERR(st);
-			goto release_sb;
-		}
-		d_inode(root)->i_ino = v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode_dotl(st, d_inode(root), 0);
-		kfree(st);
-	} else {
-		struct p9_wstat *st = NULL;
-
-		st = p9_client_stat(fid);
-		if (IS_ERR(st)) {
-			retval = PTR_ERR(st);
-			goto release_sb;
-		}
-
-		d_inode(root)->i_ino = v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode(st, d_inode(root), sb, 0);
-
-		p9stat_free(st);
-		kfree(st);
-	}
 	retval = v9fs_get_acl(inode, fid);
 	if (retval)
 		goto release_sb;
-- 
2.53.0



