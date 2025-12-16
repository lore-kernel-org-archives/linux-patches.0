Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F96C341648;
	Tue, 16 Dec 2025 11:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884835; cv=none; b=e0nN6fmhdgQqLRx+JbAtvWtk/OExCj8IgQE3epNbJCZ7Yx67IgTtJeptTAKpfO04ee7bpQaNrQ40kG6h0XlZplRqEdfLlQzweK1pmAYBmmSWfMl32MXdAf53ls9j0xKePejAKejsWOs34/BA28kJTG/zFIbwo85P2pRstlZjJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884835; c=relaxed/simple;
	bh=wfbg7346MpM7DkZoU6xZnedzXMTnITo34wFjO6WfXGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8M9lDNj3LSWWgUdxt0ZhOSrF7FWOsRpdSY7WDB3Bu5J5K91CG46cn1t5ajeGidPdjrhojPzJn79fzgDDSxHPNyWy1WfVz6S1/TkhGGDY98/WbvXWiQGP8ziF6nEUoTKJCwyb7XrG8ANMaYFDIfx+HqbA0X7OzXEGWFY3Eo6LXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjSdN/TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjSdN/TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880BFC4CEF1;
	Tue, 16 Dec 2025 11:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884835;
	bh=wfbg7346MpM7DkZoU6xZnedzXMTnITo34wFjO6WfXGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjSdN/TLoj3TTQEgHWO1rqz2PWAc+Vcjz/mYnzDMXdbdbZ91s3Pu5jvru4jXWs87N
	 adipc88gqJuD22o5fnUyG5dCvu31nPJvHeeagPPiKXEDyGSvCzvok6A+z1/y8FCUkT
	 zvQm3iHUFTRQIqIj5LJ5KOY7hsCoNGntBbX2hF4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/354] NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags
Date: Tue, 16 Dec 2025 12:14:39 +0100
Message-ID: <20251216111332.214647493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e7494cdd957e5..40d7163bca870 100644
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
index ae5c5e39afa03..fbd5ed4639862 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1310,10 +1310,6 @@ int nfs_get_tree_common(struct fs_context *fc)
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



