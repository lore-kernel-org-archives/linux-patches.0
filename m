Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A45C297100;
	Mon, 12 May 2025 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071796; cv=none; b=T6MKZzgl2ZQHCXs9ihTktuWyVHtIYM/0wkaj3WDC8kE+FsZZEjw7BErcazQDQIoEEykSBJyg9AVgRF+Hs0dYHc812oQ29NapRRl1L3AOZ4XKR2U3tjylNMDLcVmnrUa6Isja+lZSg6DcjYjOTahnfDavf39gA+RtY6YXXazP1Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071796; c=relaxed/simple;
	bh=jMgsCah+vluXS1DDRt4sczgLdlIwigQJpH8OXmtWw5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqiN0kdUdzAswAOqtV6vMJ5SGmRplD7DRGpUc9HAZFmY8U7dwGVsKTukXnYVvOW0kfAhDQjrB0CSVQtCY6N+mcCYB3oaHObVM9LM3ivOWI9FyS47lSbdW3yFzRDxMTLnpePR6p6oeBZxGhHUw32ftp+7Qbs4Oxu5InNr7bRLsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8IEsnCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8IEsnCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5A7C4CEE7;
	Mon, 12 May 2025 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071796;
	bh=jMgsCah+vluXS1DDRt4sczgLdlIwigQJpH8OXmtWw5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8IEsnCdjUrhTEQqPB63Pjcgmz5Q+p+By/oEDthsNvcKW4bO1KrPBxiUbXztZD1vW
	 VeIE0RzDpf68RY+fyV5TQxZfknWFe+QTFgDyhMF29VcTXmF3zUmFPRPlNHstfHVEL1
	 vS5Bqqar41EkVD1CtD8blt1c+vhDNzBSie5awOmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 003/197] Revert "btrfs: canonicalize the device path before adding it"
Date: Mon, 12 May 2025 19:37:33 +0200
Message-ID: <20250512172044.479589632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -733,82 +733,6 @@ const u8 *btrfs_sb_fsid_ptr(const struct
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
@@ -1513,23 +1437,12 @@ struct btrfs_device *btrfs_scan_one_devi
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
@@ -1574,8 +1487,7 @@ struct btrfs_device *btrfs_scan_one_devi
 		goto free_disk_super;
 	}
 
-	device = device_list_add(canonical_path ? : path, disk_super,
-				 &new_device_added);
+	device = device_list_add(path, disk_super, &new_device_added);
 	if (!IS_ERR(device) && new_device_added)
 		btrfs_free_stale_devices(device->devt, device);
 
@@ -1584,7 +1496,6 @@ free_disk_super:
 
 error_bdev_put:
 	fput(bdev_file);
-	kfree(canonical_path);
 
 	return device;
 }


