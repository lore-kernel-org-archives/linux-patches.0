Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920682BDC13;
	Thu, 15 Jan 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499260; cv=none; b=Bnyuf2WITfUgEuCXqduE4Fr0f7ihNa8wGHbZnN4bSE6RUtpm5A/PMmSGLmKnAafw5LddR1uwHPeQ8chHf2TFdGzCB11u7En9eHwR6GfGfKqZsgpC8ZYDgey3+augNs8JL4zXc/31jpTcjMePCNImr7QJjQ52QhZsdcQm/fWmfok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499260; c=relaxed/simple;
	bh=6VxYK9fH/c4UmTiV4kMbpBhFOKyT6jhHDUu4PT6ehCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4YcpEtbIgvI5RdsLxWQQLFt0iDC7GlPJDpJsiviT2iZtce6yNJ/tSK/8NDaARVWhQpbhC01cppLZrc0BnWnZjT4STH1vjWbEcCtyTTTdbYHrsv+jQTnRjbnhQY5za2E/Rk6UVvcPPjlJScw9PqRWvSqS33sNQjjNiQ/PK3XlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytjlbAJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytjlbAJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C964BC116D0;
	Thu, 15 Jan 2026 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499260;
	bh=6VxYK9fH/c4UmTiV4kMbpBhFOKyT6jhHDUu4PT6ehCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytjlbAJNNaxXq+acu1+rsSzeq05iamqw18SCGQaSGlpKL38KVBh2+WhF7qcV/XfFA
	 OBa2se4Jgk+Q6uh9Jwjqq8PU3houiWxvUdMLOgWNoJA7dvFxBbhYMSCtdnuJFk55Be
	 897gA+96SnQbO2YDww+bo7qZRKsy5+o5VIsL+FKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/451] NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags
Date: Thu, 15 Jan 2026 17:45:32 +0100
Message-ID: <20260115164235.660931720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1f03445b5cb43..d205598cdc457 100644
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
 	memcpy(&ctx->nfs_server.address, &client->cl_addr, client->cl_addrlen);
 	ctx->nfs_server.addrlen	= client->cl_addrlen;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 45b4240fdc081..b99f40e6b951b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1255,10 +1255,6 @@ int nfs_get_tree_common(struct fs_context *fc)
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



