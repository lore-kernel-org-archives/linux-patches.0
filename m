Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAECC433F0;
	Wed, 28 Dec 2022 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242456;
	bh=RIXhUxirIE0+ArFSNapk95yY3FktWFx4TLh2xp8XrKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfWjrrhsyIpGers6q++dGIBb9qyia7u7j44g4dyjQJoWp0ail3alpa3s9p/vo/8tm
	 JecGRd5BtIPJX80hXU9jqIe5fIxQquxUxzKoXVNSoOgcCl9EqJOEw7/rf97yq44hQL
	 9nbPwKATOVBHPUfnQwr1TdAEXtD3g0Iw8ZtFMtIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0412/1073] NFS: Fix an Oops in nfs_d_automount()
Date: Wed, 28 Dec 2022 15:33:20 +0100
Message-Id: <20221228144339.212923909@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 35e3b6ae84935d0d7ff76cbdaa83411b0ad5e471 ]

When mounting from a NFSv4 referral, path->dentry can end up being a
negative dentry, so derive the struct nfs_server from the dentry
itself instead.

Fixes: 2b0143b5c986 ("VFS: normal filesystems (and lustre): d_inode() annotations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 3295af4110f1..c7363d9e11bf 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -147,7 +147,7 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	struct nfs_fs_context *ctx;
 	struct fs_context *fc;
 	struct vfsmount *mnt = ERR_PTR(-ENOMEM);
-	struct nfs_server *server = NFS_SERVER(d_inode(path->dentry));
+	struct nfs_server *server = NFS_SB(path->dentry->d_sb);
 	struct nfs_client *client = server->nfs_client;
 	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 	int ret;
-- 
2.35.1



