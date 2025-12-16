Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BADF266B6B;
	Tue, 16 Dec 2025 12:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888492; cv=none; b=rxzuxnnNEGVu9miu5ldwhYjMnPd7HiLolD/RVBMIzYuklCQggKZkU9QOzTLbX+g1y5Xh/DHdSOv55HqGaMjOEmpLupMx4HK2CwFH3to0p3JTIoGyYPWfw1WaDNb2meiyPglH8ZI4Zs+25TlZk2OL87mopEqfn4ptff75Mxa8qNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888492; c=relaxed/simple;
	bh=qshjZCUH55V12HUtGgrdvdNa7P1rE9T7a1tcFrstiWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUbLQbkIVODqXtLJZzDHKKr9j33nQKfbWu/6xzF+pebxOHMcJsK0JnoqZcKSRGmg0aKjyab+xDOEVxbqsbz+t+x1HAviGHvQd40XQsK8e6LEsNXQIm4SkNp8ZuUcKy2z2LIeD0s9ZiFtF00K9hpqg8K2EshWN9kEyFJdsINwGlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6WjXTeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6WjXTeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB07C4CEF5;
	Tue, 16 Dec 2025 12:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888492;
	bh=qshjZCUH55V12HUtGgrdvdNa7P1rE9T7a1tcFrstiWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6WjXTeCDCIv/HnnA5SG31rgJ0VJd/FeFPU5gz2Ieyk2S1aZSEdRLoWFzkZU/Y0rC
	 lJZRmairqskCAl9Aj8AOXoTCj0GjEWhPTycV02AE8oWwH/YE+81q/xamF/5rZYqheM
	 PIB2F74wpkXMG9FMcWpKMRENWWhUT1rtnMgflLpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 550/614] NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags
Date: Tue, 16 Dec 2025 12:15:17 +0100
Message-ID: <20251216111421.307391912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a4d193da1a98..dca055676c4f3 100644
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
index 9b9464e70a7f0..66413133b43e3 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1315,10 +1315,6 @@ int nfs_get_tree_common(struct fs_context *fc)
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



