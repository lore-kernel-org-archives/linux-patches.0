Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C852168C4;
	Mon, 27 May 2024 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837699; cv=none; b=SuGTqpX2E705X3QB0lk53HMTJEvNb4wKY2M4E/4zull7EMBwbjFLw8w5xKvYDLIopXo4ZV9k3oS36QpGEiloWms8NY/ELj4E3rx4TtCpEufW0zfPiaMBYFAsO3O4OXe8CYFDjH476yRmRl3RVMkhadlKYNlH7hsrleeRAT4es08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837699; c=relaxed/simple;
	bh=7Mvs2jUwpIfrQr5Iy2wjPpT4d+k1j/9IeAu803HPPSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl+J13TIRLZdNQz/NIv7yNbNn3Cy2yD8aOJEogL8sSt+acUMQqVlFOLO4ZUP2f04G2yWnMo98/gZHS184ewx/tBAW/pO288b4Z19Fve8Cwq9fnSG0n0vNqt7XZ2kvjcy+oqJqttDeaHnitx6rwBc/M7t6WiQiSnQf1R2+TVZT+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2d9aNo9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2d9aNo9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C8C2BBFC;
	Mon, 27 May 2024 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837699;
	bh=7Mvs2jUwpIfrQr5Iy2wjPpT4d+k1j/9IeAu803HPPSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2d9aNo9jPRU5Z/tH83abIS8UET01Tb9nx3gIYhDLZypLY7kJbOrJWDulYToYgd7qa
	 16t+C3+N/s6n8zY9nmbVigtatxzw4AMKRnjc8KD3RfAydPpwGiR4by8DZ1quThAsMf
	 ygYQY9IQSNcfZVdYQaaI4lut7ZJY7rUTkHPtwL7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 110/493] openpromfs: finish conversion to the new mount API
Date: Mon, 27 May 2024 20:51:52 +0200
Message-ID: <20240527185634.124387257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index c4b65a6d41cc3..5cf1809d47bdb 100644
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



