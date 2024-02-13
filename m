Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D268457885;
	Tue, 13 Feb 2024 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845985; cv=none; b=oOlOCTRuU0d193YVttoTNOnJzWM808n7cJmEhwlWNMH5GtW8CgzOz67xWaKDmkzZ+mDWCHyWtlI+EWLJOGEJe4ZuY/+kudQkS3fvpAJuRL5vnmXkT3lZDQ9LrUWV4k7KPNxo4+syqIQtukCEyZev5tYX1598xod0GKUyY/wjlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845985; c=relaxed/simple;
	bh=2Tdpp9wvSMaOhcIlaE/vRHkZEcxUfZq0fCW7/lY0uNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYA2OUmErTW/0+7fi9oVuMUBShMz2GBm7dI4a50Ld62P7aP0DlIGZ2wQD9HyNwpnOmhNm1pb4DXpTC2YUzG+Fk2YcZU4R6BloT1wF6IqWAJpGh2XjygKbyldAklJdK8kamwQs6jKxC+9AcdHZT7yf2dLlLVVfVZBnkUWYq+k+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obhh2ZxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obhh2ZxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433E5C433C7;
	Tue, 13 Feb 2024 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845985;
	bh=2Tdpp9wvSMaOhcIlaE/vRHkZEcxUfZq0fCW7/lY0uNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obhh2ZxB4wmYChARLTHY7ZYt+WnLfn9nFyuqPPC3bbyDVisTovAEwiQnmfEq0UL4q
	 x1EMB3pZ1VaxJ/sffgUo+mUZpQnnVLh1xWa7XqTvMM0Fmb5I3wAAjFx3d2MNS68Jvi
	 sLIJu6qatpFskbCP6FsFhzFNtOk859hmzMIM4/7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.7 111/124] bch2_ioctl_subvolume_destroy(): fix locking
Date: Tue, 13 Feb 2024 18:22:13 +0100
Message-ID: <20240213171856.974094755@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit bbe6a7c899e7f265c5a6d01a178336a405e98ed6 upstream.

make it use user_path_locked_at() to get the normal directory protection
for modifications, as well as stable ->d_parent and ->d_name in victim

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-ioctl.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -451,33 +451,36 @@ static long bch2_ioctl_subvolume_create(
 static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
 				struct bch_ioctl_subvolume arg)
 {
+	const char __user *name = (void __user *)(unsigned long)arg.dst_ptr;
 	struct path path;
 	struct inode *dir;
+	struct dentry *victim;
 	int ret = 0;
 
 	if (arg.flags)
 		return -EINVAL;
 
-	ret = user_path_at(arg.dirfd,
-			(const char __user *)(unsigned long)arg.dst_ptr,
-			LOOKUP_FOLLOW, &path);
-	if (ret)
-		return ret;
+	victim = user_path_locked_at(arg.dirfd, name, &path);
+	if (IS_ERR(victim))
+		return PTR_ERR(victim);
 
-	if (path.dentry->d_sb->s_fs_info != c) {
+	if (victim->d_sb->s_fs_info != c) {
 		ret = -EXDEV;
 		goto err;
 	}
-
-	dir = path.dentry->d_parent->d_inode;
-
-	ret = __bch2_unlink(dir, path.dentry, true);
-	if (ret)
+	if (!d_is_positive(victim)) {
+		ret = -ENOENT;
 		goto err;
-
-	fsnotify_rmdir(dir, path.dentry);
-	d_delete(path.dentry);
+	}
+	dir = d_inode(path.dentry);
+	ret = __bch2_unlink(dir, victim, true);
+	if (!ret) {
+		fsnotify_rmdir(dir, victim);
+		d_delete(victim);
+	}
+	inode_unlock(dir);
 err:
+	dput(victim);
 	path_put(&path);
 	return ret;
 }


