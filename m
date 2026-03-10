Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D42BF3E2;
	Tue, 10 Mar 2026 11:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141145; cv=none; b=gjKk+YIL5g/8hCLMHyaaW6I8VQXUKBRt5N8FRDjTVkAqfr27p0ac2GDN8AMor10Lw5lQQPCrsCIpeRLdVFQ9BdbDUfJLieCyW2HiXVHBgHPY5vFgTA9gsSBss723/rX/H1w4dg9AyvdRtQlewlbwsCSyErKk4l+kQAuW2ZqwuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141145; c=relaxed/simple;
	bh=qUCrWY8KvfO5E7YZqoTdE0Vt6l+OqLh+TvXAfea5JpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRK6qsnT3yh6UlNX1wPrvATfhhYM2N5QrcyxxJ8zmQT1okokDnWGGPTktGzawUgKthggA9DSpsV7YRWg08Ri3IzVIKgBHki/1A3VZqkfGnjSLRjCqiDBwSn26PWrgeVzN219BFfIr3VJhUIc4LmZHdmJWWjwDyIgTeFjOCfLkhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekbehUMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekbehUMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6098C19423;
	Tue, 10 Mar 2026 11:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141145;
	bh=qUCrWY8KvfO5E7YZqoTdE0Vt6l+OqLh+TvXAfea5JpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekbehUMdzQ+PXvUQgZ8hPuaRb5DMNqjO/Pd3FBkkEOWRNyI7wkHXvGfoTL88s6G36
	 e8Re+aLMufIFOjAA+OIUs9IKkyAeCCPBvpXkYaJ3/Dj0UVJ3LUTT9jAibcj1bDxtrB
	 cX4FoAJRTyGZz4pKZJVlWvOFEfqk840Y89BkX81aJ5ALH87BrTM8yRDL1zIFwY+Sdi
	 +BMOobdVzAdi2NgKe7+EMwhYVcew6h+BqsTdyx91swr94/DoPodQ5dVx7IYWrjfDv6
	 w45ybefWZ/HVQgWJ4Ej4ohBwKmuvxPy3rxUcOagqTJG/XoI0DOBIYw1WTWRUSvljDM
	 L1mkMCGSbn95w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 149/311] scsi: target: Fix recursive locking in __configfs_open_file()
Date: Tue, 10 Mar 2026 07:03:16 -0400
Message-ID: <aa421a5122526bd380c4a18dfa3b7811f97f8d51.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Prithvi Tambewagh <activprithvi@gmail.com>

commit 14d4ac19d1895397532eec407433c5d74d9da53b upstream.

In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
function is called, which, here, is target_core_item_dbroot_store().  This
function called filp_open(), following which these functions were called
(in reverse order), according to the call trace:

  down_read
  __configfs_open_file
  do_dentry_open
  vfs_open
  do_open
  path_openat
  do_filp_open
  file_open_name
  filp_open
  target_core_item_dbroot_store
  flush_write_buffer
  configfs_write_iter

target_core_item_dbroot_store() tries to validate the new file path by
trying to open the file path provided to it; however, in this case, the bug
report shows:

db_root: not a directory: /sys/kernel/config/target/dbroot

indicating that the same configfs file was tried to be opened, on which it
is currently working on. Thus, it is trying to acquire frag_sem semaphore
of the same file of which it already holds the semaphore obtained in
flush_write_buffer(), leading to acquiring the semaphore in a nested manner
and a possibility of recursive locking.

Fix this by modifying target_core_item_dbroot_store() to use kern_path()
instead of filp_open() to avoid opening the file using filesystem-specific
function __configfs_open_file(), and further modifying it to make this fix
compatible.

Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Link: https://patch.msgid.link/20260216062002.61937-1-activprithvi@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_configfs.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f7868b41c5e61..749af4a29a715 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 					const char *page, size_t count)
 {
 	ssize_t read_bytes;
-	struct file *fp;
 	ssize_t r = -EINVAL;
+	struct path path = {};
 
 	mutex_lock(&target_devices_lock);
 	if (target_devices) {
@@ -131,17 +131,14 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
-	if (IS_ERR(fp)) {
+	r = kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
+	if (r) {
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
+		if (r == -ENOTDIR)
+			pr_err("db_root: not a directory: %s\n", db_root_stage);
 		goto unlock;
 	}
-	if (!S_ISDIR(file_inode(fp)->i_mode)) {
-		filp_close(fp, NULL);
-		pr_err("db_root: not a directory: %s\n", db_root_stage);
-		goto unlock;
-	}
-	filp_close(fp, NULL);
+	path_put(&path);
 
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
-- 
2.51.0

