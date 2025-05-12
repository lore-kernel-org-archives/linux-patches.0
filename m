Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D82F1E505;
	Mon, 12 May 2025 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072699; cv=none; b=pxDEX9CE+kNBvkVeJ1G6pvLDwQEXgT1Cr8W4k7yXk8CJjoskg9DaxI6yA3fLP5nqx8CRqHAEqGn8PYXqNyJl5WjoaWEufYFzdiJZCkQ/rHjI2FX0wo+a6w3fTrXhUVBEONwFam3lVbnGxImFlhdqxZWPR7iL+c03XWs9kqVs0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072699; c=relaxed/simple;
	bh=VhEkZy+mH6XfucqvqU/QaK2kG0l6VpLavT6O/EzOUNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdK8ew7PRhFpD3sUiC2KThAzrvowQV8wJSDUBPWTFsiMXyqcm7bsUamCbXGe1Dc1YFjGa/3SUciojEXTcs/YwLW3pfD2dhnE6Sjlbd/d/nuiwDaEFozV6YfRJaGqsctKWCR0sIIpgaTKvep9Cw7gjH1UOTa2T1TtkhkCA2kWRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeoAdEtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeoAdEtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04F1C4CEE9;
	Mon, 12 May 2025 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072699;
	bh=VhEkZy+mH6XfucqvqU/QaK2kG0l6VpLavT6O/EzOUNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeoAdEttmuo0yOxZvLK1WaieoIdJz0h4H4gp2K/q71X8GOD/tkGI90WkUQU7Y3Zdy
	 9SCJYpgQCuQ+WsLmIJ+8ninFctVjJUfJgIoKvunajWGCoiBANqlBO3JPvf/TrSRbmk
	 Z0FvYbVRvMKw9Acybxe+lN+pcmodIvVL6pfYVI2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 003/184] Revert "btrfs: canonicalize the device path before adding it"
Date: Mon, 12 May 2025 19:43:24 +0200
Message-ID: <20250512172041.784103493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 8fb1dcbbcc1ffe6ed7cf3f0f96d2737491dd1fbf upstream.

This reverts commit 7e06de7c83a746e58d4701e013182af133395188.

Commit 7e06de7c83a7 ("btrfs: canonicalize the device path before adding
it") tries to make btrfs to use "/dev/mapper/*" name first, then any
filename inside "/dev/" as the device path.

This is mostly fine when there is only the root namespace involved, but
when multiple namespace are involved, things can easily go wrong for the
d_path() usage.

As d_path() returns a file path that is namespace dependent, the
resulted string may not make any sense in another namespace.

Furthermore, the "/dev/" prefix checks itself is not reliable, one can
still make a valid initramfs without devtmpfs, and fill all needed
device nodes manually.

Overall the userspace has all its might to pass whatever device path for
mount, and we are not going to win the war trying to cover every corner
case.

So just revert that commit, and do no extra d_path() based file path
sanity check.

CC: stable@vger.kernel.org # 6.12+
Link: https://lore.kernel.org/linux-fsdevel/20250115185608.GA2223535@zen.localdomain/
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   91 -----------------------------------------------------
 1 file changed, 1 insertion(+), 90 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -732,82 +732,6 @@ const u8 *btrfs_sb_fsid_ptr(const struct
 	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
 }
 
-/*
- * We can have very weird soft links passed in.
- * One example is "/proc/self/fd/<fd>", which can be a soft link to
- * a block device.
- *
- * But it's never a good idea to use those weird names.
- * Here we check if the path (not following symlinks) is a good one inside
- * "/dev/".
- */
-static bool is_good_dev_path(const char *dev_path)
-{
-	struct path path = { .mnt = NULL, .dentry = NULL };
-	char *path_buf = NULL;
-	char *resolved_path;
-	bool is_good = false;
-	int ret;
-
-	if (!dev_path)
-		goto out;
-
-	path_buf = kmalloc(PATH_MAX, GFP_KERNEL);
-	if (!path_buf)
-		goto out;
-
-	/*
-	 * Do not follow soft link, just check if the original path is inside
-	 * "/dev/".
-	 */
-	ret = kern_path(dev_path, 0, &path);
-	if (ret)
-		goto out;
-	resolved_path = d_path(&path, path_buf, PATH_MAX);
-	if (IS_ERR(resolved_path))
-		goto out;
-	if (strncmp(resolved_path, "/dev/", strlen("/dev/")))
-		goto out;
-	is_good = true;
-out:
-	kfree(path_buf);
-	path_put(&path);
-	return is_good;
-}
-
-static int get_canonical_dev_path(const char *dev_path, char *canonical)
-{
-	struct path path = { .mnt = NULL, .dentry = NULL };
-	char *path_buf = NULL;
-	char *resolved_path;
-	int ret;
-
-	if (!dev_path) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	path_buf = kmalloc(PATH_MAX, GFP_KERNEL);
-	if (!path_buf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = kern_path(dev_path, LOOKUP_FOLLOW, &path);
-	if (ret)
-		goto out;
-	resolved_path = d_path(&path, path_buf, PATH_MAX);
-	if (IS_ERR(resolved_path)) {
-		ret = PTR_ERR(resolved_path);
-		goto out;
-	}
-	ret = strscpy(canonical, resolved_path, PATH_MAX);
-out:
-	kfree(path_buf);
-	path_put(&path);
-	return ret;
-}
-
 static bool is_same_device(struct btrfs_device *device, const char *new_path)
 {
 	struct path old = { .mnt = NULL, .dentry = NULL };
@@ -1495,23 +1419,12 @@ struct btrfs_device *btrfs_scan_one_devi
 	bool new_device_added = false;
 	struct btrfs_device *device = NULL;
 	struct file *bdev_file;
-	char *canonical_path = NULL;
 	u64 bytenr;
 	dev_t devt;
 	int ret;
 
 	lockdep_assert_held(&uuid_mutex);
 
-	if (!is_good_dev_path(path)) {
-		canonical_path = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (canonical_path) {
-			ret = get_canonical_dev_path(path, canonical_path);
-			if (ret < 0) {
-				kfree(canonical_path);
-				canonical_path = NULL;
-			}
-		}
-	}
 	/*
 	 * Avoid an exclusive open here, as the systemd-udev may initiate the
 	 * device scan which may race with the user's mount or mkfs command,
@@ -1556,8 +1469,7 @@ struct btrfs_device *btrfs_scan_one_devi
 		goto free_disk_super;
 	}
 
-	device = device_list_add(canonical_path ? : path, disk_super,
-				 &new_device_added);
+	device = device_list_add(path, disk_super, &new_device_added);
 	if (!IS_ERR(device) && new_device_added)
 		btrfs_free_stale_devices(device->devt, device);
 
@@ -1566,7 +1478,6 @@ free_disk_super:
 
 error_bdev_put:
 	fput(bdev_file);
-	kfree(canonical_path);
 
 	return device;
 }


