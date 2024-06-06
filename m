Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B09146D54;
	Thu,  6 Jun 2024 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683148; cv=none; b=RBdmc913kJH+yLnqdo1DfN7LM7VbBqllLr29GCHqa7PhT0BkY6uxQ+0p4fXvOJ7D5bKZIaRw+Z5g6v6sBeks/bWA0ASTgPzhvOnfvR6rIpXUjDzEHOoS3d09tWQiyBLRASwZSTkbOr64+XpWGQUcRReQvH+qEFVylK0VB7U6tLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683148; c=relaxed/simple;
	bh=5REApRBdNHO5QFJ9M8f14DEG6Y8OtlEm84KAfgsi2GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdopSyg5LjWgl3RDR3/p9RHuWB9bKanji6Vkt9D3/MLBO8ZeXbRvFshnOClgvygZnte67nH92Pq35PQipgV7OmBx1YgG3sQXGbQyiCBln/Doc8CX0TIX2nfxP/ryg74ui9w8RiU/dE4i5IgIG6jWipItYcWKQ10n4gXgojobUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeIbtGPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeIbtGPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20376C2BD10;
	Thu,  6 Jun 2024 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683148;
	bh=5REApRBdNHO5QFJ9M8f14DEG6Y8OtlEm84KAfgsi2GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeIbtGPdEg51J6lgs6L0GDdF3J2fLZBqY0Br51kvtd5U4Hc1EOlD06uw5CUHn7fH3
	 7skEHXqpcxRPLv4ikvKMQni005oGGJl4FuKSgQ5osQ7ZUy/KxnnQMDD64H90Q0NNJL
	 NK1fl4AlSuXjrUbP3yjA6A5RAWvbG3XArEtd34BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/744] openpromfs: finish conversion to the new mount API
Date: Thu,  6 Jun 2024 15:56:05 +0200
Message-ID: <20240606131735.377833533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 8f27829974b025d4df2e78894105d75e3bf349f0 ]

The original mount API conversion inexplicably left out the change
from ->remount_fs to ->reconfigure; do that now.

Fixes: 7ab2fa7693c3 ("vfs: Convert openpromfs to use the new mount API")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Link: https://lore.kernel.org/r/90b968aa-c979-420f-ba37-5acc3391b28f@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/openpromfs/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index b2457cb97fa00..e62e809a55265 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -355,10 +355,10 @@ static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
 	return inode;
 }
 
-static int openprom_remount(struct super_block *sb, int *flags, char *data)
+static int openpromfs_reconfigure(struct fs_context *fc)
 {
-	sync_filesystem(sb);
-	*flags |= SB_NOATIME;
+	sync_filesystem(fc->root->d_sb);
+	fc->sb_flags |= SB_NOATIME;
 	return 0;
 }
 
@@ -366,7 +366,6 @@ static const struct super_operations openprom_sops = {
 	.alloc_inode	= openprom_alloc_inode,
 	.free_inode	= openprom_free_inode,
 	.statfs		= simple_statfs,
-	.remount_fs	= openprom_remount,
 };
 
 static int openprom_fill_super(struct super_block *s, struct fs_context *fc)
@@ -415,6 +414,7 @@ static int openpromfs_get_tree(struct fs_context *fc)
 
 static const struct fs_context_operations openpromfs_context_ops = {
 	.get_tree	= openpromfs_get_tree,
+	.reconfigure	= openpromfs_reconfigure,
 };
 
 static int openpromfs_init_fs_context(struct fs_context *fc)
-- 
2.43.0



