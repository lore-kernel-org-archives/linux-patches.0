Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759513BA226;
	Mon, 23 Mar 2026 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282259; cv=none; b=Xr08c113sjWDRlqhg7HCK/51wT3Qx0bEjJjjJLpPopucqH8ggRxGr+/vUHCIE6aihxGiuMMo4l6v4jlDM2sr1lk9Ck8ZRv9x0N81gm3Bak0wHi1F8HXbFY6tEA8Ay307LVWYLA2FMIiztMiX6hNsyk0uJArYSO6bBSEQukGEaD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282259; c=relaxed/simple;
	bh=NCWMqJjXGVG/nT9m+jfAHvolQnq5oF/QJsDC2hzumbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7NKFMYhKEEESNB2hBbevBEk6D2j8dbdB3l7mX95Gpc+qpv0F6mamQp1IYJOcyN8B/QGtFf4HCxQKpRJ2QL4CVCvYZHsDJ0Xz6exiMiCPC9hciRan62KcmTRHWEqWMocjrjEQ5elS/Rm+ZHBTX1cGrvsPjst+z4XW4Wb8FPxL9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r17ZtYky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r17ZtYky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C484DC4CEF7;
	Mon, 23 Mar 2026 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282259;
	bh=NCWMqJjXGVG/nT9m+jfAHvolQnq5oF/QJsDC2hzumbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r17ZtYkycsKLBYmQesBR9D1zGNWlBeU3i1EJelsMgCxLUIe9XKOVeiVEoLPr0rUw1
	 87VLW1wA8uYB9MPrDf8OxSSZ13F5HrOpcAjhneAXZPg4sbjUONkUDWqtd0a5nboPna
	 hriqTMIvpitVD9xvsqRDPG9OCqAY9htvB9Pb2zEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 088/481] scsi: target: Fix recursive locking in __configfs_open_file()
Date: Mon, 23 Mar 2026 14:41:10 +0100
Message-ID: <20260323134527.412776523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/target/target_core_configfs.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -107,8 +107,8 @@ static ssize_t target_core_item_dbroot_s
 					const char *page, size_t count)
 {
 	ssize_t read_bytes;
-	struct file *fp;
 	ssize_t r = -EINVAL;
+	struct path path = {};
 
 	mutex_lock(&target_devices_lock);
 	if (target_devices) {
@@ -130,17 +130,14 @@ static ssize_t target_core_item_dbroot_s
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
 
 	strncpy(db_root, db_root_stage, read_bytes);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);


