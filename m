Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D5B336EDA;
	Fri,  9 Jan 2026 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961958; cv=none; b=tLLDHhUPKpwfCGLpzBOm/u0MZoRyIzH6OVd4R7WPcfXtHX+zIo5h47TOSM92lZ9rM7fM2rvgzRCx5gi3xrnNPCC/6hZvK5l8t6NSFgj6ozELvzPojzIHAv4a6xvkwbVo5ZlPx6IzF5h8tzYiXVa6m4vR+x5xGRYjHOh5b7CS7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961958; c=relaxed/simple;
	bh=Z9Bj5EmLXHZ5bqE35v6CJfsC7Gxr9mwm74Y7Ph0yEQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeRutJjFhqZ/i2h9irvEw5agnSm/UQe0HkIrl5wS+0Z+Haylc27wW/5B4yXQt8K8FePaOonTmak893UzRhI/BPaNLpD7qzvWAhY7LAe/rwsc/q27rvkzyw5+pp+pqNogbYvIB7p4Y3ZCGP1Q9YYW88quHu3YHiB/ZvF3S6tCZhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/PZK/Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/PZK/Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D80DC4CEF1;
	Fri,  9 Jan 2026 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961958;
	bh=Z9Bj5EmLXHZ5bqE35v6CJfsC7Gxr9mwm74Y7Ph0yEQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/PZK/Wzfr55zls3gUvLE21qgnFbbHQhSgLPoABJURweW0HoEjnM4ASm9Fzph4lsH
	 l7aXxaa17dYDETNe7D116EXgjnRmSCYw2yibCk6/CblpxpAqdfoSY1aZeLhvUrcaQq
	 Lm6NOg+LS31cWazKdYkI5b972uG9hckrG0Mau/3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/634] NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags
Date: Fri,  9 Jan 2026 12:37:54 +0100
Message-ID: <20260109112124.810329260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8675c69816e4276b979ff475ee5fac4688f80125 ]

When a filesystem is being automounted, it needs to preserve the
user-set superblock mount options, such as the "ro" flag.

Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Link: https://lore.kernel.org/all/20240604112636.236517-3-lilingfeng@huaweicloud.com/
Fixes: f2aedb713c28 ("NFS: Add fs_context support.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/namespace.c | 6 ++++++
 fs/nfs/super.c     | 4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 88a23af2bd5c9..789baa1cf768c 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -149,6 +149,7 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	struct vfsmount *mnt = ERR_PTR(-ENOMEM);
 	struct nfs_server *server = NFS_SB(path->dentry->d_sb);
 	struct nfs_client *client = server->nfs_client;
+	unsigned long s_flags = path->dentry->d_sb->s_flags;
 	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 	int ret;
 
@@ -174,6 +175,11 @@ struct vfsmount *nfs_d_automount(struct path *path)
 		fc->net_ns = get_net(client->cl_net);
 	}
 
+	/* Inherit the flags covered by NFS_SB_MASK */
+	fc->sb_flags_mask |= NFS_SB_MASK;
+	fc->sb_flags &= ~NFS_SB_MASK;
+	fc->sb_flags |= s_flags & NFS_SB_MASK;
+
 	/* for submounts we want the same server; referrals will reassign */
 	memcpy(&ctx->nfs_server._address, &client->cl_addr, client->cl_addrlen);
 	ctx->nfs_server.addrlen	= client->cl_addrlen;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index cee68f34db85c..3a002bc75d22a 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1280,10 +1280,6 @@ int nfs_get_tree_common(struct fs_context *fc)
 	if (server->flags & NFS_MOUNT_NOAC)
 		fc->sb_flags |= SB_SYNCHRONOUS;
 
-	if (ctx->clone_data.sb)
-		if (ctx->clone_data.sb->s_flags & SB_SYNCHRONOUS)
-			fc->sb_flags |= SB_SYNCHRONOUS;
-
 	/* Get a superblock - note that we may end up sharing one that already exists */
 	fc->s_fs_info = server;
 	s = sget_fc(fc, compare_super, nfs_set_super);
-- 
2.51.0



