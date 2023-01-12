Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316F8749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A840FC433EF;
	Thu, 12 Jan 2023 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532519;
	bh=X8TZl+MSqW3rq6Ccs9eufKaIkImcXi+ynf1ZnQYJOWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRiUuZnREnG9arbytDgIZmYaDoFA0/k98EyBKGmmQocdbS9udqjiiI8eVO7xxlH6n
	 PakeAWKMauJT+f4TtHyZl03HpaWue9W6jnk5R87DbMGmH3JemHd+RxMEyKK5NnEyNI
	 Hxa9Ej/OcGv59NO9OjAaf0URpfoiXf+e/01bMj+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/783] NFS: Fix an Oops in nfs_d_automount()
Date: Thu, 12 Jan 2023 14:48:24 +0100
Message-Id: <20230112135533.043507472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 2bcbe38afe2e..1f03445b5cb4 100644
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



