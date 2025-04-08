Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3260268FEB;
	Tue,  8 Apr 2025 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113929; cv=none; b=RgJ6xRPGgFp/R1blT/Am0q/SotQi4X0rjlbPblrDp2aQyfDfucpohj4iwoDL9dZT8AK4r3xXI3iBX+fld3zLkH1wE+VAP2mQ24EWyuhxb9zzkxpiVVN1DD2gLMXKYKbO6NbXFvMFzUYiLRfx3MhzyWuGsTZ80B/1TkrPAg+LtEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113929; c=relaxed/simple;
	bh=7VE5qF+j6Gc4JXeFQ8zSSIkO18/wjK3LlUDciSwyRi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soMjXU1+VitX+LqBdg4WDMu+ZKzA7s9qZPzU8stQCfpXYEIfEgiJ7bwjKADyML6a4rS2WQ0gYvc8ur7GChKFfEOcywLLEaAsYD2DjI2N6TLkzQe2KlIIBlyFr6xhPL+W7nSoOgm0HqDWqjUyOal2fsBcZbP2HxACqM6sJ8gZL8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXewGXGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXewGXGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DFDC4CEE5;
	Tue,  8 Apr 2025 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113929;
	bh=7VE5qF+j6Gc4JXeFQ8zSSIkO18/wjK3LlUDciSwyRi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXewGXGoNP7j7wnQM0reg8tvyfbC53hnW5ITi4xZj3m5ny2fSonUMH8nvkLYTo9wq
	 a+n+iWgNx37C1Makp0y/g9kJKqSnP07z1c5zJHTb4tt0pGYozl3mmClquJcWg/l3Dw
	 VGhuU4g5j3vkByKmcQERkJNzG53C3d1U3r7KjCnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laura Promberger <laura.promberger@cern.ch>,
	Sam Lewis <samclewis@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/154] fuse: dont truncate cached, mutated symlink
Date: Tue,  8 Apr 2025 12:49:35 +0200
Message-ID: <20250408104816.350342576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit b4c173dfbb6c78568578ff18f9e8822d7bd0e31b ]

Fuse allows the value of a symlink to change and this property is exploited
by some filesystems (e.g. CVMFS).

It has been observed, that sometimes after changing the symlink contents,
the value is truncated to the old size.

This is caused by fuse_getattr() racing with fuse_reverse_inval_inode().
fuse_reverse_inval_inode() updates the fuse_inode's attr_version, which
results in fuse_change_attributes() exiting before updating the cached
attributes

This is okay, as the cached attributes remain invalid and the next call to
fuse_change_attributes() will likely update the inode with the correct
values.

The reason this causes problems is that cached symlinks will be
returned through page_get_link(), which truncates the symlink to
inode->i_size.  This is correct for filesystems that don't mutate
symlinks, but in this case it causes bad behavior.

The solution is to just remove this truncation.  This can cause a
regression in a filesystem that relies on supplying a symlink larger than
the file size, but this is unlikely.  If that happens we'd need to make
this behavior conditional.

Reported-by: Laura Promberger <laura.promberger@cern.ch>
Tested-by: Sam Lewis <samclewis@google.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/r/20250220100258.793363-1-mszeredi@redhat.com
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c      |  2 +-
 fs/namei.c         | 24 +++++++++++++++++++-----
 include/linux/fs.h |  2 ++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b2f37809fa9bd..6b4bf30b0247e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1275,7 +1275,7 @@ static const char *fuse_get_link(struct dentry *dentry, struct inode *inode,
 		goto out_err;
 
 	if (fc->cache_symlinks)
-		return page_get_link(dentry, inode, callback);
+		return page_get_link_raw(dentry, inode, callback);
 
 	err = -ECHILD;
 	if (!dentry)
diff --git a/fs/namei.c b/fs/namei.c
index a4cba6991a4d1..038a9a4b99270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4859,10 +4859,9 @@ const char *vfs_get_link(struct dentry *dentry, struct delayed_call *done)
 EXPORT_SYMBOL(vfs_get_link);
 
 /* get the link contents into pagecache */
-const char *page_get_link(struct dentry *dentry, struct inode *inode,
-			  struct delayed_call *callback)
+static char *__page_get_link(struct dentry *dentry, struct inode *inode,
+			     struct delayed_call *callback)
 {
-	char *kaddr;
 	struct page *page;
 	struct address_space *mapping = inode->i_mapping;
 
@@ -4881,8 +4880,23 @@ const char *page_get_link(struct dentry *dentry, struct inode *inode,
 	}
 	set_delayed_call(callback, page_put_link, page);
 	BUG_ON(mapping_gfp_mask(mapping) & __GFP_HIGHMEM);
-	kaddr = page_address(page);
-	nd_terminate_link(kaddr, inode->i_size, PAGE_SIZE - 1);
+	return page_address(page);
+}
+
+const char *page_get_link_raw(struct dentry *dentry, struct inode *inode,
+			      struct delayed_call *callback)
+{
+	return __page_get_link(dentry, inode, callback);
+}
+EXPORT_SYMBOL_GPL(page_get_link_raw);
+
+const char *page_get_link(struct dentry *dentry, struct inode *inode,
+					struct delayed_call *callback)
+{
+	char *kaddr = __page_get_link(dentry, inode, callback);
+
+	if (!IS_ERR(kaddr))
+		nd_terminate_link(kaddr, inode->i_size, PAGE_SIZE - 1);
 	return kaddr;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c0967df137152..d3648a55590ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3234,6 +3234,8 @@ extern const struct file_operations generic_ro_fops;
 
 extern int readlink_copy(char __user *, int, const char *);
 extern int page_readlink(struct dentry *, char __user *, int);
+extern const char *page_get_link_raw(struct dentry *, struct inode *,
+				     struct delayed_call *);
 extern const char *page_get_link(struct dentry *, struct inode *,
 				 struct delayed_call *);
 extern void page_put_link(void *);
-- 
2.39.5



