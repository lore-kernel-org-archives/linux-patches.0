Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24D7392829;
	Sat, 17 Oct 2026 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257852; cv=none; b=Zuv6UoNRUbKAAkZGTWpROF0SM7y6Xof/L9RitH7srZdiHCWC9Z3q44q+xLE2CTe/QZdnTaiXxeglBhxxMqgYQgyVEQsrgkGISxxafqc5niQ58GZZDi7nh7GVwxwHCcTzQNNSYoyXnaUUfYy0KA+QA8ShOpPcxSK1Lf75VkVH4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257852; c=relaxed/simple;
	bh=v7l/2H1cwg7uxEKVVKqe6r+wmjlHuDSS9ItZHnumECc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKWz7yAoJ5jJ5JFEu0M0HEpFBK1K2GhvaOng1EFQqW1Nq3huVl5V8rdCIsc5MkXQUSGA1AWu9Ck5UdFd15HGFYTY1XZ8q5Yav6MEpoIz97iWaLgaczweXkMlD8sgHYli82GAVJz9JpLqNORvPLJcyJO5KH1YQuC7PpMpmNwWV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAAPjMcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAAPjMcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F21F000C4;
	Sat, 17 Oct 2026 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257851;
	bh=0jafUzrtwbBMrIpARzp2qSYQ6gnSmS81fZ/9EZiFL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAAPjMcqtrj2wJ3Vf3Sdo3bLQtoI9iB8dGgLbJPW7/+dA5xB+kZuNYc6F35ACLriE
	 OZ/oc+tfVjOTa2rpsQzmpOd3WXJzzcllTWu/ZxUD4/KZuFawZE4xiofy7iVw8s3o/x
	 42p6aIK1kCzMo/MG4Bx3G5NpW/H8Ff6ZQLw/GKPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0690/1674] fs/9p: convert mkdir to use get_new_inode
Date: Sat, 17 Oct 2026 17:49:22 +0200
Message-ID: <20261017160448.818921040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 44c53ac09720e7bc62fa1663a3b0b44306e693f0 ]

mkdir had different code paths for inode creation, cache used
the get_new_inode_from_fid helper, but non-cached used
v9fs_get_inode.  Collapsed into a single implementation across
both as there should be no difference.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Stable-dep-of: 3f61ac7c65bd ("fs/9p: fix NULL pointer dereference on mkdir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode_dotl.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 96e791c2b7b44..b870e3bba940b 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -402,32 +402,17 @@ static int v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
-	if (v9ses->cache & (CACHE_META|CACHE_LOOSE)) {
-		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
-		if (IS_ERR(inode)) {
-			err = PTR_ERR(inode);
-			p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n",
-				 err);
-			goto error;
-		}
-		v9fs_fid_add(dentry, &fid);
-		v9fs_set_create_acl(inode, fid, dacl, pacl);
-		d_instantiate(dentry, inode);
-		err = 0;
-	} else {
-		/*
-		 * Not in cached mode. No need to populate
-		 * inode with stat. We need to get an inode
-		 * so that we can set the acl with dentry
-		 */
-		inode = v9fs_get_inode(dir->i_sb, mode, 0);
-		if (IS_ERR(inode)) {
-			err = PTR_ERR(inode);
-			goto error;
-		}
-		v9fs_set_create_acl(inode, fid, dacl, pacl);
-		d_instantiate(dentry, inode);
+	inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n",
+			 err);
+		goto error;
 	}
+	v9fs_fid_add(dentry, &fid);
+	v9fs_set_create_acl(inode, fid, dacl, pacl);
+	d_instantiate(dentry, inode);
+	err = 0;
 	inc_nlink(dir);
 	v9fs_invalidate_inode_attr(dir);
 error:
-- 
2.53.0



