Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1EB267F4F;
	Tue,  8 Apr 2025 11:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111881; cv=none; b=ddpqo73jZciWyUvcB0NmgMnM1MdwmLxxTIk+ETzfumdUtRyQ2ymg0vKdAT1FTWuCI9aZ9lTQW2TjzR6HhVrNg9YV9XYxmRsv8aNf9kxp19y30MbSLqiF+A7Ru/hKQoeJg90L0eMSjCsYJOzVjvmSa7I5MAex2JCwStUUHtPbx4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111881; c=relaxed/simple;
	bh=6KNz8It4SKT+DGSkHuemlZoHac6AnXCjlIzeN4Wo5kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8//wLnZGwibkwQaiXL30Lhy+anhMOcyD3TJ/1eNXdjiNhn2jTNhDU8SPoe7EcU+ENeSNqm4H3SxvD04oRfTX2q7neR6gqpmIjrKly8bBmZf1Bxw25S4GAdrwlGM9Ipkb3EQ0fcORsJRZNwPhkvjphTyZvDXrLqxTm0pYYeDf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDg14BQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDg14BQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B3BC4CEE5;
	Tue,  8 Apr 2025 11:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111881;
	bh=6KNz8It4SKT+DGSkHuemlZoHac6AnXCjlIzeN4Wo5kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDg14BQ2h4e+sEY1s+2nRoLfOtn1tQu1Jk3foAZ7QnWDx0vEXfEFGO5n2C3ceiJBP
	 zkH9PoYo6T+VWkKoQUBC7KLFzKkTW/rclZ8lGEuaAapIA38APLJ4jw5nruJ2+WY5II
	 ivlu2W6NxLRu1Wy3/hVQJPgfa++RR/tGgOkkLyYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 554/731] exfat: fix missing shutdown check
Date: Tue,  8 Apr 2025 12:47:31 +0200
Message-ID: <20250408104927.163340847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 47e35366bc6fa3cf189a8305bce63992495f3efa ]

xfstests generic/730 test failed because after deleting the device
that still had dirty data, the file could still be read without
returning an error. The reason is the missing shutdown check in
->read_iter.

I also noticed that shutdown checks were missing from ->write_iter,
->splice_read, and ->mmap. This commit adds shutdown checks to all
of them.

Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 807349d8ea050..841a5b18e3dfd 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -582,6 +582,9 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t pos = iocb->ki_pos;
 	loff_t valid_size;
 
+	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
 	inode_lock(inode);
 
 	valid_size = ei->valid_size;
@@ -635,6 +638,16 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
+static ssize_t exfat_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
+	return generic_file_read_iter(iocb, iter);
+}
+
 static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 {
 	int err;
@@ -672,14 +685,26 @@ static const struct vm_operations_struct exfat_file_vm_ops = {
 
 static int exfat_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	if (unlikely(exfat_forced_shutdown(file_inode(file)->i_sb)))
+		return -EIO;
+
 	file_accessed(file);
 	vma->vm_ops = &exfat_file_vm_ops;
 	return 0;
 }
 
+static ssize_t exfat_splice_read(struct file *in, loff_t *ppos,
+		struct pipe_inode_info *pipe, size_t len, unsigned int flags)
+{
+	if (unlikely(exfat_forced_shutdown(file_inode(in)->i_sb)))
+		return -EIO;
+
+	return filemap_splice_read(in, ppos, pipe, len, flags);
+}
+
 const struct file_operations exfat_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
+	.read_iter	= exfat_file_read_iter,
 	.write_iter	= exfat_file_write_iter,
 	.unlocked_ioctl = exfat_ioctl,
 #ifdef CONFIG_COMPAT
@@ -687,7 +712,7 @@ const struct file_operations exfat_file_operations = {
 #endif
 	.mmap		= exfat_file_mmap,
 	.fsync		= exfat_file_fsync,
-	.splice_read	= filemap_splice_read,
+	.splice_read	= exfat_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
 
-- 
2.39.5



