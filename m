Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E535C1B6D08;
	Mon, 29 Dec 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025583; cv=none; b=m5OpQKzFPD4+5gDrGypMRS8DtITpcRX4LV31JKBZvwxVUnGf7OAanou8A+IID6e7BhyBd5LLLbRmw6gH8A2uzJG1jmuTHGTjoa3GZsKQNk1cw3IjElg+FbBbn+wK35lFd+HgGM1x9uuK5uAuRiwAX+Sx4fvAh0NHvZgXUW6v5mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025583; c=relaxed/simple;
	bh=yRZB7GRIyrN49VA4xRezWwtkiFbTqUwso8NU4rPju30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tO3BKA2WeQ4np8bL9i6Xn/E7sGiAjQDyb3HKCQ9g8Zu4Q9yBj0STZsyB4zRtanB3tSaydbpyLE6e1DxRUA9T8p2aCPT3WLilsJozro8PnMpsi239C2rMLGBrFY6mD1JMJMNqUUZBxgJyVVTHV81IiF7wuVDWaSHEp6Tf5XZSo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAR8t4l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAR8t4l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F37C4CEF7;
	Mon, 29 Dec 2025 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025582;
	bh=yRZB7GRIyrN49VA4xRezWwtkiFbTqUwso8NU4rPju30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAR8t4l2rSMi6OHKRGxvaoN+on70znzK+pycbPoJta7HRZYjGStpA9BBoxuIfyTWZ
	 OnTSl15HINTkhP31SYHdzsLL/V8vxXPf9hgXdwmBmvROXDc8aEDeOqO4ik2Y8OUJZ1
	 b5euOXt1nwi3JGmEORZ8tewQEOr7sUBgmsXlesNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 264/430] ext4: align max orphan file size with e2fsprogs limit
Date: Mon, 29 Dec 2025 17:11:06 +0100
Message-ID: <20251229160734.068290203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 7c11c56eb32eae96893eebafdbe3decadefe88ad upstream.

Kernel commit 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
limits the maximum supported orphan file size to 8 << 20.

However, in e2fsprogs, the orphan file size is set to 32–512 filesystem
blocks when creating a filesystem.

With 64k block size, formatting an ext4 fs >32G gives an orphan file bigger
than the kernel allows, so mount prints an error and fails:

    EXT4-fs (vdb): orphan file too big: 8650752
    EXT4-fs (vdb): mount failed

To prevent this issue and allow previously created 64KB filesystems to
mount, we updates the maximum allowed orphan file size in the kernel to
512 filesystem blocks.

Fixes: 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251120134233.2994147-1-libaokun@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -8,6 +8,8 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
+#define EXT4_MAX_ORPHAN_FILE_BLOCKS 512
+
 static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
 {
 	int i, j, start;
@@ -588,7 +590,7 @@ int ext4_init_orphan_info(struct super_b
 	 * consuming absurd amounts of memory when pinning blocks of orphan
 	 * file in memory.
 	 */
-	if (inode->i_size > 8 << 20) {
+	if (inode->i_size > (EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits)) {
 		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
 			 (unsigned long long)inode->i_size);
 		ret = -EFSCORRUPTED;


