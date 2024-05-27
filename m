Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8319DDA9;
	Mon, 27 May 2024 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836416; cv=none; b=lUwwjmlwKRX0+OP1z6n/fcj/s5hyrAdc0MGGeH/UB3sRSyBD2f1+U4ae9sBfPvjcVSjxp9Rs0xGS/PPn0sIRCkxQ55Gnd+funsEgWg3LGW7PdSTitwFvggCtVf9wjh35Rsz+rxiZPsjI67K90+lWgvyJcOonv18D3yPfYb6dNhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836416; c=relaxed/simple;
	bh=/6tKymXw2m2ssGd4pq/B8BWq4Jo+9WalU4EESsvT40Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDyND8T/W1d2c5RStNWPWIapLjRfiAlkC1hAlAHs1DHgOM1S/6LGpanSqscnB4DB/gpyuzRBm0OV80NBi8E9H4KYIk+Cfx0U5T9nhgDS6FaPtnlKoVZ/RBJHTW39Y2WHpfGqIlxuIdnezxOzeBUL3OCvoF8UKeKI1Inu6ILgVnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6PlT948; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6PlT948"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19347C2BBFC;
	Mon, 27 May 2024 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836416;
	bh=/6tKymXw2m2ssGd4pq/B8BWq4Jo+9WalU4EESsvT40Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6PlT948rfbdtZCRERqjdDYvHceHlh2ChYOaRCydgtuN5JTLc7pOwwP88Gvtkq78o
	 mlOfePzCZ3ngk7OusU52hcMEY9O6EF5K99Y7Eb4lGvhIU56ZNLmoSurX9Dhi/lCEpu
	 YdekXaWJaoRlcSLkG375mPL1+So8BVZe8wLoG3dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/427] openpromfs: finish conversion to the new mount API
Date: Mon, 27 May 2024 20:51:30 +0200
Message-ID: <20240527185605.781596735@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4a0779e3ef792..a7b527ea50d3c 100644
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



