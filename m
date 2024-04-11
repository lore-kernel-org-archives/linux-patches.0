Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F214535A;
	Thu, 11 Apr 2024 10:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829876; cv=none; b=FIzfY9oUkldePFsIqHnExW/qP893wBjXzJArOtU1atP7CxpgYAkjlAJ+bNDeHJEXBQBBRC7WAEAcrDzhZy0XRkF3xm4FFaM5PBNK4P5MaJj+pPLNr5cC3NVRpuUsvkymd7q/1qn6DQLnuZugOosgNFneqBpg7Y0zXhq6Ib42s2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829876; c=relaxed/simple;
	bh=gVVtfFTkA9elJkUD5++T+i/A/mShFpZegP0EdbeqxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tybxu6ige4iX9J2/YPWTA7cYJsMq5fEcODqDehidJA8Ih0QljmEPhhLVkAIZY8LFm20BuJ47S7q8+HabiY4P84pAsQQBUXQMQaykIvItrmK6OiPc5vr1UidKS+49W+dqeG5GB38PX/YbsZ8CsVr8HN1OmaTvPNmA82AS3DL5ji0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLdJE4vS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLdJE4vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59CCC433F1;
	Thu, 11 Apr 2024 10:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829876;
	bh=gVVtfFTkA9elJkUD5++T+i/A/mShFpZegP0EdbeqxIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLdJE4vS/tWxIr2777tM5FbjYFIMCTjeGXDNPvSxMxzP312YtML1jcVpF0Jy0hGko
	 Ra+yF5bqLK6ym+yt6cmJSNXAU7NoD312uijMRKi3j+ApJFpGhQsuuKd0uWXvWpuLQE
	 gxuLW/QTLQ0BVb7qn4dwa4QKlEbpUt+MvjWwu4ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/175] initramfs: switch initramfs unpacking to struct file based APIs
Date: Thu, 11 Apr 2024 11:55:59 +0200
Message-ID: <20240411095423.659342089@linuxfoundation.org>
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

[ Upstream commit bf6419e4d5440c6d414a320506c5488857a5b001 ]

There is no good reason to mess with file descriptors from in-kernel
code, switch the initramfs unpacking to struct file based write
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4624b346cf67 ("init: open /initrd.image with O_LARGEFILE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 7103edf44436c..e378d15a949e0 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -11,13 +11,14 @@
 #include <linux/utime.h>
 #include <linux/file.h>
 
-static ssize_t __init xwrite(int fd, const char *p, size_t count)
+static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
+		loff_t *pos)
 {
 	ssize_t out = 0;
 
 	/* sys_write only can write MAX_RW_COUNT aka 2G-4K bytes at most */
 	while (count) {
-		ssize_t rv = ksys_write(fd, p, count);
+		ssize_t rv = kernel_write(file, p, count, pos);
 
 		if (rv < 0) {
 			if (rv == -EINTR || rv == -EAGAIN)
@@ -315,7 +316,8 @@ static int __init maybe_link(void)
 	return 0;
 }
 
-static __initdata int wfd;
+static __initdata struct file *wfile;
+static __initdata loff_t wfile_pos;
 
 static int __init do_name(void)
 {
@@ -332,16 +334,17 @@ static int __init do_name(void)
 			int openflags = O_WRONLY|O_CREAT;
 			if (ml != 1)
 				openflags |= O_TRUNC;
-			wfd = ksys_open(collected, openflags, mode);
-
-			if (wfd >= 0) {
-				ksys_fchown(wfd, uid, gid);
-				ksys_fchmod(wfd, mode);
-				if (body_len)
-					ksys_ftruncate(wfd, body_len);
-				vcollected = kstrdup(collected, GFP_KERNEL);
-				state = CopyFile;
-			}
+			wfile = filp_open(collected, openflags, mode);
+			if (IS_ERR(wfile))
+				return 0;
+			wfile_pos = 0;
+
+			vfs_fchown(wfile, uid, gid);
+			vfs_fchmod(wfile, mode);
+			if (body_len)
+				vfs_truncate(&wfile->f_path, body_len);
+			vcollected = kstrdup(collected, GFP_KERNEL);
+			state = CopyFile;
 		}
 	} else if (S_ISDIR(mode)) {
 		ksys_mkdir(collected, mode);
@@ -363,16 +366,16 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (byte_count >= body_len) {
-		if (xwrite(wfd, victim, body_len) != body_len)
+		if (xwrite(wfile, victim, body_len, &wfile_pos) != body_len)
 			error("write error");
-		ksys_close(wfd);
+		fput(wfile);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
 	} else {
-		if (xwrite(wfd, victim, byte_count) != byte_count)
+		if (xwrite(wfile, victim, byte_count, &wfile_pos) != byte_count)
 			error("write error");
 		body_len -= byte_count;
 		eat(byte_count);
@@ -603,21 +606,23 @@ static void __init clean_rootfs(void)
 static void populate_initrd_image(char *err)
 {
 	ssize_t written;
-	int fd;
+	struct file *file;
+	loff_t pos = 0;
 
 	unpack_to_rootfs(__initramfs_start, __initramfs_size);
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	fd = ksys_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
-	if (fd < 0)
+	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	if (IS_ERR(file))
 		return;
 
-	written = xwrite(fd, (char *)initrd_start, initrd_end - initrd_start);
+	written = xwrite(file, (char *)initrd_start, initrd_end - initrd_start,
+			&pos);
 	if (written != initrd_end - initrd_start)
 		pr_err("/initrd.image: incomplete write (%zd != %ld)\n",
 		       written, initrd_end - initrd_start);
-	ksys_close(fd);
+	fput(file);
 }
 #endif /* CONFIG_BLK_DEV_RAM */
 
-- 
2.43.0



