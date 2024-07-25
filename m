Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0FFC19;
	Thu, 25 Jul 2024 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918993; cv=none; b=kFY5utJwUDEnrzvmchfJxC2pu3fKV9MKp2CLxyHxUD51lBRip1ACDn+TgNsf0aF1F+LaYXdnBKjWI271LRp1N51BCiEpuB4u0CXRRHxEdxNNOL3uDAuIVgKBJwgKJA6RZrWTcruxG8/KeLNhFvrp04DvVDKIJxkeur2uccpOGH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918993; c=relaxed/simple;
	bh=osjaOVMSuwrztdDO3xN1c52+yJFz6MGrjjBLzio13Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSTiO5NWVWwDnyUYI+XXOyPo56KZZjT5CqWtUEZxv4hxlsSOs8xeaiSgdHRKdYgRWFh4W0p084ZdMsagXzEhpaL6cq7jP6xavwTepYy4DT6ZdXgXV6O91XeYaxx3nSAkJXvEfUj2NSGnm4jtwGOXa9Qi0PTny35o39BYIx9MQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxwenZFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxwenZFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27F6C116B1;
	Thu, 25 Jul 2024 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918993;
	bh=osjaOVMSuwrztdDO3xN1c52+yJFz6MGrjjBLzio13Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxwenZFlNKvSdLbwqMEcRDZs7u+KpWmTTmmXXYY+HNQJzMf+3D55WEJTK6mx/5hG5
	 TU3P4uBZCxeIlyGYzM/bYySoIgjuFv0f3VY7KqmeWUuoxRCh0oyEPKirmAHBG9TT9y
	 ZOutxeH7jOjDyrJavVBwy9mc8eonf1mEryk9SK4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Theodore Tso <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.10 50/59] ext4: Send notifications on error
Date: Thu, 25 Jul 2024 16:37:40 +0200
Message-ID: <20240725142735.147253543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

commit 9a089b21f79b47eed240d4da7ea0d049de7c9b4d upstream.

Send a FS_ERROR message via fsnotify to a userspace monitoring tool
whenever a ext4 error condition is triggered.  This follows the existing
error conditions in ext4, so it is hooked to the ext4_error* functions.

Link: https://lore.kernel.org/r/20211025192746.66445-30-krisman@collabora.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
[Ajay: - Modified to apply on v5.10.y
       - Added fsnotify for __ext4_abort()]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,6 +46,7 @@
 #include <linux/part_stat.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/fsnotify.h>
 
 #include "ext4.h"
 #include "ext4_extents.h"	/* Needed for trace points definition */
@@ -699,6 +700,7 @@ void __ext4_error(struct super_block *sb
 		       sb->s_id, function, line, current->comm, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(sb, NULL, error ? error : EFSCORRUPTED);
 	save_error_info(sb, error, 0, block, function, line);
 	ext4_handle_error(sb);
 }
@@ -730,6 +732,7 @@ void __ext4_error_inode(struct inode *in
 			       current->comm, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(inode->i_sb, inode, error ? error : EFSCORRUPTED);
 	save_error_info(inode->i_sb, error, inode->i_ino, block,
 			function, line);
 	ext4_handle_error(inode->i_sb);
@@ -769,6 +772,7 @@ void __ext4_error_file(struct file *file
 			       current->comm, path, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(inode->i_sb, inode, EFSCORRUPTED);
 	save_error_info(inode->i_sb, EFSCORRUPTED, inode->i_ino, block,
 			function, line);
 	ext4_handle_error(inode->i_sb);
@@ -837,7 +841,7 @@ void __ext4_std_error(struct super_block
 		printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
 		       sb->s_id, function, line, errstr);
 	}
-
+	fsnotify_sb_error(sb, NULL, errno ? errno : EFSCORRUPTED);
 	save_error_info(sb, -errno, 0, 0, function, line);
 	ext4_handle_error(sb);
 }
@@ -861,6 +865,7 @@ void __ext4_abort(struct super_block *sb
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(sb))))
 		return;
 
+	fsnotify_sb_error(sb, NULL, error ? error : EFSCORRUPTED);
 	save_error_info(sb, error, 0, 0, function, line);
 	va_start(args, fmt);
 	vaf.fmt = fmt;


