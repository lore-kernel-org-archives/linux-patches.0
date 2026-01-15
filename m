Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A012D239B;
	Thu, 15 Jan 2026 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497722; cv=none; b=WYpjGhWci7VbdYxdQYyYdMnPYYsILYdoCKjC+1E/cABQyYpZ78A9p09GrJrixrtpg/RptES78IcQFehmetSLQq3Eq+JBaSlE4IfYGdPk+VwHLXTVtDHW4naIzkncU+c/7QSu7MGjcFo+gDwvXXTV1i0Eh6vwNhQ2u6Q6QgYp9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497722; c=relaxed/simple;
	bh=A9Tzzd4gPneeTjd8S3L6Aje1WBkvrjwg/1DE5oM+S0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6R3CnNJVSQOIf4W74cIK4cihdy65oPqIRiPESj0ADEiV8J4lArrXPP+SNh2Vke+KEeAwFho9T2+ynj5Pob+Mjk7DiaPV739GnQRTz7n+xHWB8q1O3P80cske3gFl+xXqs/6heP6nUG6w4U979HQuYvgoXucXVX9K1fv3N33jew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA68PbLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA68PbLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2ECC116D0;
	Thu, 15 Jan 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497721;
	bh=A9Tzzd4gPneeTjd8S3L6Aje1WBkvrjwg/1DE5oM+S0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA68PbLCNVl0bHGnD/ojeSqqLgf0aBzDLcSwVRcNKFI94cIfx0u0olPjKJecM3TsW
	 DX1mpyVd6imlUXvFtJifYCBnAQrZhm9J9qdDyf2C2djJHVBL1SLNRfIETZ4aJ58/Nt
	 p5hFC8UZqt9Eoi/DLMMBkLYJsd4JkbnKIxDETikI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/554] NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags
Date: Thu, 15 Jan 2026 17:44:07 +0100
Message-ID: <20260115164252.816365652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 565421c6682ed..8fb570fd376a1 100644
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
index 0faed67d61bde..d9d6f055771a9 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1276,10 +1276,6 @@ int nfs_get_tree_common(struct fs_context *fc)
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



