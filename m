Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A367194085;
	Mon, 21 Oct 2024 10:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507520; cv=none; b=CY+AwgjAycz2PMlnB6NZ4yXrVM9P09mDlfTQvX2HDAWxW3rwsMhtMYHRp7/HG4WYklWdO+69/mqwIfM3I06tJVc7l0BfDRiyzb05LK9/Zp0cEqMDnROE5bgJXp6uI0LzqUod3satKvkBenVWJAWLLbJu3ttwyEnD56ovk9N9WUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507520; c=relaxed/simple;
	bh=jEht6G4Nj5uJWr0GkswdfC6fu3VG67MblecGNiHZecU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5dytj2jjbVsjhBFHVDdvGC6S4syiECbixnVBkFYGA2VMRjY71xLlDXThRf16is1BcNnWZ5y1qfEgV3MkSOxn/y/o3FZG8C5H2k8VkTzlaJa/O5o7kDq6pKWIDpoEQ/kYKo8w5eQjxXKdhDq2QKZlbCA61nQJ0r00Una5rijQR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj3ie8SF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj3ie8SF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0BCC4CEC3;
	Mon, 21 Oct 2024 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507519;
	bh=jEht6G4Nj5uJWr0GkswdfC6fu3VG67MblecGNiHZecU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj3ie8SFo8nk7JP4WPzCMIwS2fvFdD5WLS5FnjzIpWiDJzlJX7n/nPGM/EaixNG+a
	 m253+1rB4ImGqIvNvHKf8DsSLBF7AmGApFGgavEYIC6eAlH2iyg5iXbQnUl+e8nau2
	 k9McadbqE8zl0GzyH14XfTUxv/yPRigVYR7AJl6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+69c9fdccc6dd08961d34@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 05/82] udf: Implement searching for directory entry using new iteration code
Date: Mon, 21 Oct 2024 12:24:46 +0200
Message-ID: <20241021102247.428735020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 1c80afa04db39c98aebea9aabfafa37a208cdfee ]

Implement searching for directory entry - udf_fiiter_find_entry() -
using new directory iteration code.

Reported-by: syzbot+69c9fdccc6dd08961d34@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -141,6 +141,73 @@ int udf_write_fi(struct inode *inode, st
 }
 
 /**
+ * udf_fiiter_find_entry - find entry in given directory.
+ *
+ * @dir:	directory inode to search in
+ * @child:	qstr of the name
+ * @iter:	iter to use for searching
+ *
+ * This function searches in the directory @dir for a file name @child. When
+ * found, @iter points to the position in the directory with given entry.
+ *
+ * Returns 0 on success, < 0 on error (including -ENOENT).
+ */
+static int udf_fiiter_find_entry(struct inode *dir, const struct qstr *child,
+				 struct udf_fileident_iter *iter)
+{
+	int flen;
+	unsigned char *fname = NULL;
+	struct super_block *sb = dir->i_sb;
+	int isdotdot = child->len == 2 &&
+		child->name[0] == '.' && child->name[1] == '.';
+	int ret;
+
+	fname = kmalloc(UDF_NAME_LEN, GFP_NOFS);
+	if (!fname)
+		return -ENOMEM;
+
+	for (ret = udf_fiiter_init(iter, dir, 0);
+	     !ret && iter->pos < dir->i_size;
+	     ret = udf_fiiter_advance(iter)) {
+		if (iter->fi.fileCharacteristics & FID_FILE_CHAR_DELETED) {
+			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_UNDELETE))
+				continue;
+		}
+
+		if (iter->fi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) {
+			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
+				continue;
+		}
+
+		if ((iter->fi.fileCharacteristics & FID_FILE_CHAR_PARENT) &&
+		    isdotdot)
+			goto out_ok;
+
+		if (!iter->fi.lengthFileIdent)
+			continue;
+
+		flen = udf_get_filename(sb, iter->name,
+				iter->fi.lengthFileIdent, fname, UDF_NAME_LEN);
+		if (flen < 0) {
+			ret = flen;
+			goto out_err;
+		}
+
+		if (udf_match(flen, fname, child->len, child->name))
+			goto out_ok;
+	}
+	if (!ret)
+		ret = -ENOENT;
+
+out_err:
+	udf_fiiter_release(iter);
+out_ok:
+	kfree(fname);
+
+	return ret;
+}
+
+/**
  * udf_find_entry - find entry in given directory.
  *
  * @dir:	directory inode to search in


