Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEC034DB64;
	Tue, 16 Dec 2025 12:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887666; cv=none; b=s2Nxc9iHF2yIpd0NJNS1rRwIIiGLhtd5yXweS8ate/nqLlnuzkq7DNRi40J0BkNHVrx1bn0LCaQvvfXsXeoeZaQvbfB/yPDJ+tGcInxIt20nQap6jQMOy5Atzp/YOOzaDgv+V/a2t30bDGNZLFiUSByL8b5E8JQ0aqPeVO4mkMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887666; c=relaxed/simple;
	bh=lqAMOTDTY4d8wx1GCP8OhMWBZheYsSAXg8mG6X9sXoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxuDcMoirIkP8jVbJ0xa1uTQaQECb45ySGGYV7XFtm7LZcsosXaSsbH1TwyX1YlTcHYZhyUwzZA2qiP62e5PYzhx4fIrJ2SBxbCnfZX1fxwhN3DQx16jlX6lCNvyA8HEEl+n2IAR8sCse40GkDYO8yofdqNH/8oZbf4nI8EgNq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQ2dvVem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQ2dvVem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27949C4CEF1;
	Tue, 16 Dec 2025 12:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887666;
	bh=lqAMOTDTY4d8wx1GCP8OhMWBZheYsSAXg8mG6X9sXoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQ2dvVemiZ5amkXSAndR4yOCvm4l6VR2x7DZtlpTSqL5XfjiW8bj6+4sb2bOjye0T
	 v5MFlT5ttc5fnXUu/6a5VjWFUki/g+mL1reEgTFeKWIa6hZA6ClMTUUHuHYDP/ti34
	 sC0RLorewlsCBfZI9mXzFvOAdij3g/fW5rTF0E7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/614] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
Date: Tue, 16 Dec 2025 12:11:08 +0100
Message-ID: <20251216111412.275760078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c460192aae197df1b4db1dca493c35ad529f1b64 ]

fuse_ctl_remove_conn() used to decrement the link count of root
manually; that got subsumed by simple_recursive_removal(), but
in case when subdirectory creation has failed the latter won't
get called.

Just move the modification of parent's link count into
fuse_ctl_add_dentry() to keep the things simple.  Allows to
get rid of the nlink argument as well...

Fixes: fcaac5b42768 "fuse_ctl: use simple_recursive_removal()"
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/control.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index bb407705603c2..5247df896c5d0 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -205,8 +205,7 @@ static const struct file_operations fuse_conn_congestion_threshold_ops = {
 
 static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 					  struct fuse_conn *fc,
-					  const char *name,
-					  int mode, int nlink,
+					  const char *name, int mode,
 					  const struct inode_operations *iop,
 					  const struct file_operations *fop)
 {
@@ -232,7 +231,10 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	if (iop)
 		inode->i_op = iop;
 	inode->i_fop = fop;
-	set_nlink(inode, nlink);
+	if (S_ISDIR(mode)) {
+		inc_nlink(d_inode(parent));
+		inc_nlink(inode);
+	}
 	inode->i_private = fc;
 	d_add(dentry, inode);
 
@@ -252,22 +254,21 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 		return 0;
 
 	parent = fuse_control_sb->s_root;
-	inc_nlink(d_inode(parent));
 	sprintf(name, "%u", fc->dev);
-	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500, 2,
+	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500,
 				     &simple_dir_inode_operations,
 				     &simple_dir_operations);
 	if (!parent)
 		goto err;
 
-	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400, 1,
+	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400,
 				 NULL, &fuse_ctl_waiting_ops) ||
-	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200, 1,
+	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200,
 				 NULL, &fuse_ctl_abort_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "max_background", S_IFREG | 0600,
-				 1, NULL, &fuse_conn_max_background_ops) ||
+				 NULL, &fuse_conn_max_background_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "congestion_threshold",
-				 S_IFREG | 0600, 1, NULL,
+				 S_IFREG | 0600, NULL,
 				 &fuse_conn_congestion_threshold_ops))
 		goto err;
 
-- 
2.51.0



