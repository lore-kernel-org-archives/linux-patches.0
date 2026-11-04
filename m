Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828872;
	b=bOFvsXdEXCBUQ5H487I3nFhyKDVXZigBmJlqFZfBvbRQDR4nt95s2tDF7ZQDZpqTodFx
	 IiDohdANrEGiYAwf7prJs5/5FKCox8ZJjCzwP1arq8PkyIQTkOUoTmLSULQax7e3OjIwA
	 +xkHDgUUYX6sfxK7bTOgYgDw9aqZ4Dr6KN8l4+fty8NPvjKUiOOeS2yo9vU6sfhXZTEbJ
	 9zyUyArIn5svmi0fB+0RY53e3wFMpT5Kuv4qXDlAu6btujy2NcRjxyfEgpV9Lb28spsLM
	 4W1tPzmtmHhsao6l3o2YPA7edynX/vpQTTn04A1q00wRlLXspqoPH4FgTC8MRYpYP0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HRhSnRD0JBn0vGpivJUaT0Htgfgu4+IX+ANUKcNGOZQ=;
	b=Tlb4k6Gb56LuHZktlOP2b7ADHNLvIj/XQ+S6ylPmx25dutevQp4dZkt3mgvxGrd95Cc5
	 ZngWdnMRN/xoB2E++Ugm69hPAxjFjq9WZtkEt7hVwUOs21wmftYf78b+P+81qnvrZEFDf
	 cAknoat/H58dzHoMYaWTGOdSxzFmSjpOByUL4NEEZhRRTwidEwjskcTjqb/JUXXotzheO
	 7LHmaFF0cK1GgYVFpv/KT9yTZOkUyaL6KatOT9doknPme7MVrOUdkTNjK44bv08vlgEGK
	 Wu45rgWhFM0gK3NLGnQEMXuFTNJ3kfs7YHVeIKL0uJ+s9RaWZCfue7SZ2vCyzuJHJgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASrKR6Lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F5B6070F39;
	Wed,  4 Nov 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASrKR6Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D131F00919;
	Wed,  4 Nov 2026 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828872;
	bh=HRhSnRD0JBn0vGpivJUaT0Htgfgu4+IX+ANUKcNGOZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASrKR6Lk6EhcKdZ4BsqIrXN2R5ioqTLrVvlcp8aT8dO+tJ5HBL2zP8d+x2Uwkn67z
	 fUYMEtrGHDoftlif6URCGdcEwJVGemfis9Tn4djgYJRN4kRzEIVxLv9RpCtOdME8Hy
	 ZT7BvTWz0u6Msvkbp3ZaW+vJvl7buYAplz7kk5us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 293/547] ovl: fortify ovl_copy_xattr() against underlying layer modifications
Date: Wed,  4 Nov 2026 16:07:57 -0500
Message-ID: <20261104211046.528525391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit e6b9117076fb4c0ff4a670efa9c876d9a50d79ab upstream.

Adapt ovl_getxattr_value() to be used from ovl_copy_xattr(), by
allowing to pass it a pre-allocated buffer, which can be resized
and by handling the ENODATA/EOPNOTSUPP return codes in the caller.

This replaces the retry loop in ovl_copy_xattr() with a single retry
after resizing the buffer. If the value changed again by then, the
underlying layer was modified, so return -EIO instead of retrying.

As a side effect, ovl_copy_up_meta_inode_data() now returns -EIO instead
of -ERANGE in this case of underlying xattr size changes.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Tested-by: Fahad Alharbi <fahad@codepure.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-fsdevel/CAJfpegsVoUyqy0dYkTvBGRZvgdv_nmzmCw_uF+LP-Vq3EhEkSg@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   68 +++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -72,6 +72,9 @@ static int ovl_copy_acl(struct ovl_fs *o
 	return err;
 }
 
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size);
+
 int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct dentry *new)
 {
 	struct dentry *old = oldpath->dentry;
@@ -129,34 +132,12 @@ int ovl_copy_xattr(struct super_block *s
 			break;
 		}
 
-retry:
-		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE) {
-			size = ovl_do_getxattr(oldpath, name, NULL, 0);
-			/* Nothing was read into value, so it must not be used */
-			if (size >= 0 && size <= value_size)
-				size = -EIO;
-		}
-
+		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
 			error = size;
 			break;
 		}
 
-		if (size > value_size) {
-			void *new;
-
-			new = kvmalloc(size, GFP_KERNEL);
-			if (!new) {
-				error = -ENOMEM;
-				break;
-			}
-			kvfree(value);
-			value = new;
-			value_size = size;
-			goto retry;
-		}
-
 		error = ovl_do_setxattr(OVL_FS(sb), new, name, value, size, 0);
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
@@ -1070,26 +1051,39 @@ static bool ovl_need_meta_copy_up(struct
 	return true;
 }
 
-static ssize_t ovl_getxattr_value(const struct path *path, char *name, char **value)
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size)
 {
 	ssize_t res;
 	char *buf;
 
-	res = ovl_do_getxattr(path, name, NULL, 0);
-	if (res == -ENODATA || res == -EOPNOTSUPP)
-		res = 0;
+	res = ovl_do_getxattr(path, name, *value, *value_size);
+	if (res == -ERANGE) {
+		res = ovl_do_getxattr(path, name, NULL, 0);
+		/* Xattr changed underneath us? */
+		if (res >= 0 && res <= *value_size)
+			return -EIO;
+	}
 
-	if (res > 0) {
-		buf = kzalloc(res, GFP_KERNEL);
+	if (res > *value_size) {
+		buf = kvmalloc(res, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 
 		res = ovl_do_getxattr(path, name, buf, res);
-		if (res < 0)
-			kfree(buf);
-		else
-			*value = buf;
+		if (res < 0) {
+			kvfree(buf);
+			/* Xattr changed underneath us? */
+			if (res == -ERANGE)
+				return -EIO;
+			return res;
+		}
+
+		kvfree(*value);
+		*value = buf;
+		*value_size = res;
 	}
+
 	return res;
 }
 
@@ -1100,7 +1094,7 @@ static int ovl_copy_up_meta_inode_data(s
 	struct path upperpath;
 	int err;
 	char *capability = NULL;
-	ssize_t cap_size;
+	ssize_t cap_size = 0;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
@@ -1108,7 +1102,9 @@ static int ovl_copy_up_meta_inode_data(s
 
 	if (c->stat.size) {
 		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
-						    &capability);
+						    &capability, &cap_size);
+		if (cap_size == -ENODATA || cap_size == -EOPNOTSUPP)
+			cap_size = 0;
 		if (cap_size < 0)
 			goto out;
 	}
@@ -1138,7 +1134,7 @@ static int ovl_copy_up_meta_inode_data(s
 	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
 out_free:
-	kfree(capability);
+	kvfree(capability);
 out:
 	return err;
 }


