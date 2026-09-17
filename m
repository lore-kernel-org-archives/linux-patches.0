Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293AE5187F4;
	Thu, 17 Sep 2026 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664706; cv=none; b=dnmQ5V1InDeTbGFEkvozPk/t3+GKVc42uN8DTizjYs9KwId2e80RHnFwdRmzQtI3sHQgJknppdTBYP4yP9uOmft4Xhn1c3wylGUkuaMt+E9s4WXijgwaOk3K1J+7Sgp2bvM99nPZ8voTCH3qavYb6/L4zaw60uWz5Uo+6U9Qfeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664706; c=relaxed/simple;
	bh=AOmCWJnRk1LqnvpEXV/nyeHh07tRHEgVGouag7V8m8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFXTf2SIZ3Wf78ts9zvhGDWHlxw2CXTEwyzq1v7o7e6PPx83DhcmM/XuWgGVT7VYgdhTil0oemLevZtMTDoA5xBcTPZcGliHMgWC888IcB6tUVARo1YYrrwf9btMcf8NGoMleZT0AMKGpzVZ/TltDpHoJs4Zoqqfhhza5oCqtLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8WHFQc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8WHFQc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC321F00893;
	Thu, 17 Sep 2026 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664705;
	bh=DcRYx5kNhN/aVSz4Xu3f2rdf6iUwQK2JEEOsBlbFAIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8WHFQc/+SiWoYGH2mUJExA66qJ/CbTas9cCbO+zH8+P8rG2jUn6EL+3Z9EtG73A6
	 ctP593zbVuCQ0oMMGZYI6oqlokLUTKB6jqQTwZcevNZ1QhiRdATlfBncgoCDcFg0/e
	 xMsO6Nk8jISIgqMWvp60s0wFFc/gm2A1fLmOUTNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0460/1250] ksmbd: deny renaming directory with open children
Date: Thu, 17 Sep 2026 16:04:15 +0100
Message-ID: <20260917151604.449846295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c841bd3d8dec33a000d6e31b7e7fafb22c39e4e9 ]

Windows denies renaming a directory while a file below that directory is
still open. smb2.rename.rename_dir_openfile checks this by keeping a file
handle open under the directory and then attempting to rename the directory
handle.  ksmbd did not check open children before calling vfs_rename(), so
the rename incorrectly succeeded.

For non-POSIX clients, scan the global open file table for active handles
whose dentries are below the directory being renamed.  If any child is
open, fail the rename with -EACCES so the client receives
STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c       |  6 ++++++
 fs/smb/server/vfs_cache.c | 25 +++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 32 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 216b6e427aa7e..969ece627b745 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -745,6 +745,12 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out3;
 	}
 
+	if (!work->tcon->posix_extensions && d_is_dir(old_child) &&
+	    ksmbd_has_open_files(old_child)) {
+		err = -EACCES;
+		goto out3;
+	}
+
 	parent_fp = ksmbd_lookup_fd_inode(old_child->d_parent);
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 0b654021bec07..7e76bde2263e8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/dcache.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -649,6 +650,30 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
+bool ksmbd_has_open_files(struct dentry *dentry)
+{
+	struct ksmbd_file *fp;
+	unsigned int id;
+	bool ret = false;
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		struct dentry *fp_dentry = fp->filp->f_path.dentry;
+
+		if (fp->f_state != FP_INITED)
+			continue;
+		if (fp_dentry == dentry)
+			continue;
+		if (is_subdir(fp_dentry, dentry)) {
+			ret = true;
+			break;
+		}
+	}
+	read_unlock(&global_ft.lock);
+
+	return ret;
+}
+
 #define OPEN_ID_TYPE_VOLATILE_ID	(0)
 #define OPEN_ID_TYPE_PERSISTENT_ID	(1)
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index a3a9fda6de917..0ea8cc3aaec98 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -165,6 +165,7 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
+bool ksmbd_has_open_files(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
-- 
2.53.0



