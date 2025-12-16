Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51300355020;
	Tue, 16 Dec 2025 11:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885814; cv=none; b=bYDfPGp6gIxTn9iAMvtcnGOYfe7mT4k/WhBxglg2rBI8FI3sWZNh/A+kQz8laT6B9xoGCWvYj6OWGxqqME2RYx/jGl3GC6P64FOUV9Sl2IX06YLQYc9V1MNftikKXEhc9ygzlsXcKK7xHFdIiloNREjYQIpaPejGk3Qh6eZk8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885814; c=relaxed/simple;
	bh=i/bhMN3c2YAWcI8oXCJNGWZra2IShMthmG4YiWSBT7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAyA8+xAbfcyRMzLKrNslevx72OWez07vzhySPCxZZ7Gshr7/+m0TpihKdcLHsYWpavH/G77+rtih9izzQ8fBxDIdsnOeioi0WyXe3Znv5wWMFKDW+WivIGW+bLXaAkoJ20FKmSiHxa9kwe+2LxU1/AarZlXzhVT+oNg1MuSi0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBiYSUOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBiYSUOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B15EC4CEF1;
	Tue, 16 Dec 2025 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885814;
	bh=i/bhMN3c2YAWcI8oXCJNGWZra2IShMthmG4YiWSBT7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBiYSUOykKAczFDEK0U53oy/nLs57haHKh+OknfKH2Unhm4hjk4QudRlWW79PL+4m
	 bTO1hnIaNUjnI47YOhhI0bi8c4OOL19qYKl99+SscMGHG3dKIcFZr1tNcy0sdmosgX
	 Fcb/CLxaLU+vINbF9Ip/f2ZWeAYMOBTSHyW5Jtcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 253/507] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
Date: Tue, 16 Dec 2025 12:11:34 +0100
Message-ID: <20251216111354.657895061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



