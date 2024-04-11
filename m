Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E71422C4;
	Thu, 11 Apr 2024 10:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829870; cv=none; b=tBgzwimqy1zYqdCOV3ZhBk3sgTe+A4fWwGSzUEYZ3CEPiQhGKuGnfxRtmk/dPYBgZzIlOXq3gBn1Qa++sKUsnJHZnLUjKI5BskQwjblikjfJ2/8INqtdvofCzfSnKKF+YFLl1Qj+YTEdnSM5ht2+urPcdLJ0cQLAT0V2W/laBhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829870; c=relaxed/simple;
	bh=cIop02llaJHd4nq3ow+FjntSCmlphyqKRmhHt3sYaDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UA0ssvDSo6bshcfLW84RNER+Ch75L/BHnvTBYE7HaH92HDG+yNWnME0+aWzSykSLAepUsrwYOrHyx+wOh1CaYOSNnSgHnCauYR6rR8BTxrPzsXDxGWZ1Fjz3NXmZEdzxeduLR5LcXtKVBeGiWLqivgUdxUa01LG59VQN8fHy/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0TRxaQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0TRxaQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A140C433C7;
	Thu, 11 Apr 2024 10:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829870;
	bh=cIop02llaJHd4nq3ow+FjntSCmlphyqKRmhHt3sYaDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0TRxaQdzz5JQw3wkJr+552cdJL4VpSP6FKxbjyj1isKkHavh9PMbJGKw05DhqYTi
	 QBwBXhCBbuVPgBZ/3wxflMDefTOaZZn/BXbjxL6l1yROsx5B2wShJj6ll+13fGFKcx
	 F8T2bq+4QPd9JfAneZuWAAIAk1L0WHkls9dIg8HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/175] fs: add a vfs_fchown helper
Date: Thu, 11 Apr 2024 11:55:57 +0200
Message-ID: <20240411095423.598671313@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c04011fe8cbd80af1be6e12b53193bf3846750d7 ]

Add a helper for struct file based chown operations.  To be used by
the initramfs code soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4624b346cf67 ("init: open /initrd.image with O_LARGEFILE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c          | 29 +++++++++++++++++------------
 include/linux/fs.h |  2 ++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 76996f920ebf5..e072e86003f56 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -707,23 +707,28 @@ SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group
 			   AT_SYMLINK_NOFOLLOW);
 }
 
+int vfs_fchown(struct file *file, uid_t user, gid_t group)
+{
+	int error;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	audit_file(file);
+	error = chown_common(&file->f_path, user, group);
+	mnt_drop_write_file(file);
+	return error;
+}
+
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
 {
 	struct fd f = fdget(fd);
 	int error = -EBADF;
 
-	if (!f.file)
-		goto out;
-
-	error = mnt_want_write_file(f.file);
-	if (error)
-		goto out_fput;
-	audit_file(f.file);
-	error = chown_common(&f.file->f_path, user, group);
-	mnt_drop_write_file(f.file);
-out_fput:
-	fdput(f);
-out:
+	if (f.file) {
+		error = vfs_fchown(f.file, user, group);
+		fdput(f);
+	}
 	return error;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e2c87c056742c..7d93d22ad1062 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1660,6 +1660,8 @@ int vfs_mkobj(struct dentry *, umode_t,
 		int (*f)(struct dentry *, umode_t, void *),
 		void *);
 
+int vfs_fchown(struct file *file, uid_t user, gid_t group);
+
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /*
-- 
2.43.0



