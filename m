Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FED44C6F;
	Thu, 13 Jun 2024 12:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280747; cv=none; b=Fs/dq9wbYZURR0xfFVD0ZDtQMSInDeQG+qx3HSm6FERcyLk2vQfFWso4c50lEGItapq55Q1YXTCwktawyLI5Eh9jnpSz5d75I1ttwztQ/uvzHwD9lKeVtVnUthNz+p78FbJh8glFt3+/UX95v2IVHM++lBOFNZyvfGmIA5gI+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280747; c=relaxed/simple;
	bh=A7guBJC1IxNVbM0ytyzxX7ZVrf7M6EpuvxIeOp4ByLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cigIt/e995nnz3y43872kR0ujV3+jMndBrNmGHub8xtCAZAxXm9HV+iEX9G+tFfi5vrYJLvCVcGaSwStufq3M0gATT0R3RjaRH0jGqQQnhzNJwZAB3/W6poPFKAb9LLyZ972pgIRhtC6YVvfBD/VMtPpHahE9IQIAVdYIoFBXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR1FaagU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR1FaagU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C4C2BBFC;
	Thu, 13 Jun 2024 12:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280747;
	bh=A7guBJC1IxNVbM0ytyzxX7ZVrf7M6EpuvxIeOp4ByLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR1FaagUZcJKQMo/NuvEsQFcGyKBf5nRQ+TPgay0qA+jLlnsVbKCT5UzPL7s3bjkK
	 5yKkOJ/x7bEzhvDD/hglmY0GWM14KsBwKGIZl24tvuWoOloK4sIQ7vYQqkx93u8bfR
	 LheptCDrYHiGjn30noDIraf/On4IUwtZVb1jUqwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/317] openpromfs: finish conversion to the new mount API
Date: Thu, 13 Jun 2024 13:30:38 +0200
Message-ID: <20240613113248.323771442@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 40c8c2e32fa3e..1e22344be5e54 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -362,10 +362,10 @@ static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
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
 
@@ -373,7 +373,6 @@ static const struct super_operations openprom_sops = {
 	.alloc_inode	= openprom_alloc_inode,
 	.free_inode	= openprom_free_inode,
 	.statfs		= simple_statfs,
-	.remount_fs	= openprom_remount,
 };
 
 static int openprom_fill_super(struct super_block *s, struct fs_context *fc)
@@ -417,6 +416,7 @@ static int openpromfs_get_tree(struct fs_context *fc)
 
 static const struct fs_context_operations openpromfs_context_ops = {
 	.get_tree	= openpromfs_get_tree,
+	.reconfigure	= openpromfs_reconfigure,
 };
 
 static int openpromfs_init_fs_context(struct fs_context *fc)
-- 
2.43.0



