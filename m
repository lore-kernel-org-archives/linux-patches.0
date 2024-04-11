Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7868E14600A;
	Thu, 11 Apr 2024 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830903; cv=none; b=JstFtJZeCYSJS1hnXVDcssRid5j++mHkS43bP7W83a2yF4JJLqbTF9HaeSZ8+H5vcFZE9PJj4rOd5wa9lO9ejbL5xGEO6rxqkSHst8SezgMeyWSFmPZnexCAIA/ABQvlt0JS4FhvCGtYJ3CVBdoP3E2b9pxBRecaxov4MwCTeG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830903; c=relaxed/simple;
	bh=3k/QQHmtyCud9/B+t8AVR+JDJ2K5UgJ+GX4zG7s9ML0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxLMvDcRlunZvOebu2cZF3od/6+17CXxvVyeAaUgoQ1VM5jU6kluD9qAm/3LG1ZZ73u3/hxL52fDOLYid8h5peGp3jMAopROgzkz4ca9IO6ME5uuVB06ZBvVMkCIyT6n5RfsppZdFZVIv7sPyEDg3Fv1XI1L6zeZ7hQtDQiw6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBBAHUn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBBAHUn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C53C433F1;
	Thu, 11 Apr 2024 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830903;
	bh=3k/QQHmtyCud9/B+t8AVR+JDJ2K5UgJ+GX4zG7s9ML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBBAHUn62EJe7l0pC3REjmwmHPWiDbK1G/BD/c77fUzeIL9pymlTcA33o2mO0m3Ps
	 Tgbq0cFY52MrWIuN+M2ipF5FLF2PKK8JRXuScpGOMjrbKUMtqwTWsz8aF7I16N+mOG
	 kY7XcK0FCeyttWKXT29Y9naX7VNC/p+p2Wx0kZyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/215] fs: add a vfs_fchown helper
Date: Thu, 11 Apr 2024 11:56:07 +0200
Message-ID: <20240411095429.628265135@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index dcbd016112375..9213c15d8a8d6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -708,23 +708,28 @@ SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group
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
index 272f261894b17..03de5c7134564 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1730,6 +1730,8 @@ int vfs_mkobj(struct dentry *, umode_t,
 		int (*f)(struct dentry *, umode_t, void *),
 		void *);
 
+int vfs_fchown(struct file *file, uid_t user, gid_t group);
+
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef CONFIG_COMPAT
-- 
2.43.0



