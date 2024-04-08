Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184808173C;
	Mon,  8 Apr 2024 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582962; cv=none; b=q+6dzQPEFNxwmxmyL+kcXK+GohDivOR5wEjgkq2cqD+YhqxPttqkNmLhDGomCjzIyCbCDZ50kMl1gY2f29MuEuPVZcBHMfd+fpqUDmgJnhB4yxIbn6iEDRatLMYzA2ffzAEsRmabux3OzxgLZ7rPf5uiU/NIlpgeIPa3hxQQ1/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582962; c=relaxed/simple;
	bh=lA8xeBMAxTQyVVspu0mLW1jOJphSq89uu0BJ8Cp4Duw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKL3SrrE0PjmoiH1HSjwf/h/aUxIU9V3jpVVI9E/igdR6EILl5b8NyyjL1QPAYW1x4WAtkLCewg76lCEcbJfZq341mm+qjQL6DSrBdgs8LjDEiJnh26smw3e9UCQNEWxJEuOejbjRUEPdD4WIw0PnmnJ4+tpEnwcSkglZjcuIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt2LYL7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt2LYL7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E160C433C7;
	Mon,  8 Apr 2024 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582961;
	bh=lA8xeBMAxTQyVVspu0mLW1jOJphSq89uu0BJ8Cp4Duw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt2LYL7ImwBcD/iuQqCoXAbEe5/ERJuXXb2XfgG0W5B1HpkMoBRLy0r+h+1I/aKKy
	 yLiRtAK6PoAnnivPFbowAq7fMDqmYOpsXkbborN0aC3NsHy+9Rdz2v9WWZa+OdX9UF
	 gYM8zh8F+V361Vx6lrHqrjMksuI71GVMBEskykgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Theodore Tso <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 193/690] ext4: Send notifications on error
Date: Mon,  8 Apr 2024 14:50:59 +0200
Message-ID: <20240408125406.549986317@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 9a089b21f79b47eed240d4da7ea0d049de7c9b4d ]

Send a FS_ERROR message via fsnotify to a userspace monitoring tool
whenever a ext4 error condition is triggered.  This follows the existing
error conditions in ext4, so it is hooked to the ext4_error* functions.

Link: https://lore.kernel.org/r/20211025192746.66445-30-krisman@collabora.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/ext4/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 65716a17059d0..f69e7bf52c578 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,6 +46,7 @@
 #include <linux/part_stat.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/fsnotify.h>
 
 #include "ext4.h"
 #include "ext4_extents.h"	/* Needed for trace points definition */
@@ -753,6 +754,8 @@ void __ext4_error(struct super_block *sb, const char *function,
 		       sb->s_id, function, line, current->comm, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(sb, NULL, error ? error : EFSCORRUPTED);
+
 	ext4_handle_error(sb, force_ro, error, 0, block, function, line);
 }
 
@@ -783,6 +786,8 @@ void __ext4_error_inode(struct inode *inode, const char *function,
 			       current->comm, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(inode->i_sb, inode, error ? error : EFSCORRUPTED);
+
 	ext4_handle_error(inode->i_sb, false, error, inode->i_ino, block,
 			  function, line);
 }
@@ -821,6 +826,8 @@ void __ext4_error_file(struct file *file, const char *function,
 			       current->comm, path, &vaf);
 		va_end(args);
 	}
+	fsnotify_sb_error(inode->i_sb, inode, EFSCORRUPTED);
+
 	ext4_handle_error(inode->i_sb, false, EFSCORRUPTED, inode->i_ino, block,
 			  function, line);
 }
@@ -888,6 +895,7 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 		printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
 		       sb->s_id, function, line, errstr);
 	}
+	fsnotify_sb_error(sb, NULL, errno ? errno : EFSCORRUPTED);
 
 	ext4_handle_error(sb, false, -errno, 0, 0, function, line);
 }
-- 
2.43.0



