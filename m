Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FF662148;
	Mon,  8 Apr 2024 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582734; cv=none; b=XcKsiRJfjJP7Oj1OmXgXplILsAAi3Yj+6Du0wr6R9eSPbKAa68UaSxUlunVv/UFkrHhMlSjJFxRl72mHpkjo0X0jC6NhD2X58j8BRAChw9As6bl3lC0tmPOfvoPsR6uUX1mI5Tp7G1bhXIUjru8sMENV6aasnjF1WaXMRLsiYiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582734; c=relaxed/simple;
	bh=JknUlGeO/WNhc3XTvzcN4oA2plFuLq89vDbZUfgieVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODc93+wr5MGsCwkNyPnlSspNcb2iR6veLqnKWeEEeZ4aH1o0NIxTZhhsSplN4bEVxEZTtU0eZqskJB7zPzf5iUK8/LXWg5XVi2omiTdBJZQuHMK9fhhi2fGOyuhc3+llLIWmdZPReGvm+rXrX8I2d/fzfaIzSwClKvFmhry1f0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiazuLEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiazuLEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4933C433F1;
	Mon,  8 Apr 2024 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582734;
	bh=JknUlGeO/WNhc3XTvzcN4oA2plFuLq89vDbZUfgieVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiazuLEh013WhcAt1vWXGlMWMRkxeczyUyqxZ9SSLXgDS/29ki9hLljgPWqGe6KOe
	 7zEF2YL7VujORmG9f9UebZYbngQTx/ZiYmMYNURmd9fbVkLlnU0Qq3plkBC4NRCmMW
	 /BjOMiKjWRgIBevuwNQIwHuWq4dIxHsnlZnBip2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 166/690] fsnotify: pass data_type to fsnotify_name()
Date: Mon,  8 Apr 2024 14:50:32 +0200
Message-ID: <20240408125405.570377973@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 9baf93d68bcc3d0a6042283b82603c076e25e4f5 ]

Align the arguments of fsnotify_name() to those of fsnotify().

Link: https://lore.kernel.org/r/20211025192746.66445-2-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/fsnotify.h | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index a9477c14fad5c..298fd2bc29e49 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -26,20 +26,21 @@
  * FS_EVENT_ON_CHILD mask on the parent inode and will not be reported if only
  * the child is interested and not the parent.
  */
-static inline void fsnotify_name(struct inode *dir, __u32 mask,
-				 struct inode *child,
-				 const struct qstr *name, u32 cookie)
+static inline int fsnotify_name(__u32 mask, const void *data, int data_type,
+				struct inode *dir, const struct qstr *name,
+				u32 cookie)
 {
 	if (atomic_long_read(&dir->i_sb->s_fsnotify_connectors) == 0)
-		return;
+		return 0;
 
-	fsnotify(mask, child, FSNOTIFY_EVENT_INODE, dir, name, NULL, cookie);
+	return fsnotify(mask, data, data_type, dir, name, NULL, cookie);
 }
 
 static inline void fsnotify_dirent(struct inode *dir, struct dentry *dentry,
 				   __u32 mask)
 {
-	fsnotify_name(dir, mask, d_inode(dentry), &dentry->d_name, 0);
+	fsnotify_name(mask, d_inode(dentry), FSNOTIFY_EVENT_INODE,
+		      dir, &dentry->d_name, 0);
 }
 
 static inline void fsnotify_inode(struct inode *inode, __u32 mask)
@@ -154,8 +155,10 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 		new_dir_mask |= FS_ISDIR;
 	}
 
-	fsnotify_name(old_dir, old_dir_mask, source, old_name, fs_cookie);
-	fsnotify_name(new_dir, new_dir_mask, source, new_name, fs_cookie);
+	fsnotify_name(old_dir_mask, source, FSNOTIFY_EVENT_INODE,
+		      old_dir, old_name, fs_cookie);
+	fsnotify_name(new_dir_mask, source, FSNOTIFY_EVENT_INODE,
+		      new_dir, new_name, fs_cookie);
 
 	if (target)
 		fsnotify_link_count(target);
@@ -209,7 +212,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode,
 	fsnotify_link_count(inode);
 	audit_inode_child(dir, new_dentry, AUDIT_TYPE_CHILD_CREATE);
 
-	fsnotify_name(dir, FS_CREATE, inode, &new_dentry->d_name, 0);
+	fsnotify_name(FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
+		      dir, &new_dentry->d_name, 0);
 }
 
 /*
-- 
2.43.0



