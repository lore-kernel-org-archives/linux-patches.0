Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5FA2FC893;
	Thu,  2 Jul 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011760; cv=none; b=pjK/OYVnSzbA+lrBac9KIuyoXiw6HtblWv7qqxsF+mbRrmgrHlxWLcJmvULIWA4ORVwpeTpRXTbARQ+/7Zl+bc+LgHDEa5atWbOsHQ0zHAFCowgWXfzdf6EHl9BULKF/c1eFRDk7mCRm7G8CIUYr+onr+PepngiLscnHXCrlQTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011760; c=relaxed/simple;
	bh=BTgny7b/a9GuaOXa0fVGdD5sgMOtom67Rh5A/khwkv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd6wJDa8zwB5yUdqvvYXXZFoGRf8i9PA4gsqDyz4vOJcaUplGMZIEc34IeWtiCBR7ZMqZ381GoKSs1aZAH9Wlv0W4KzoCb5om/7pGj2kwRsQutIplqzDil2lYUF0gVPB1Jz1xifGWrTyT1rhm+y0TYdqCPk1Wel3WVf/7M77BdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12pjpGEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12pjpGEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27A71F000E9;
	Thu,  2 Jul 2026 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011759;
	bh=RrITQLsZOfakoKUf71LsPShQ+o8mGloiMtfkhvWlAfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12pjpGELAiTeltOBYtsh9PNGzmffnm9ijB9ExhZS6w/uzgQJ9lZKS3N/GXaifFrcc
	 lpeIqzW7JHkTWXSKO3pFYfAvNHXaCuVMMsBejNyYBLSbaZCxMInfmorqHhyd9jMqEO
	 OGeMwRWUuFOjpylT11DkcPM0Az772LNh4p1C4Js4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 098/120] ntfs: serialize volume label accesses
Date: Thu,  2 Jul 2026 18:21:34 +0200
Message-ID: <20260702155114.986373191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

commit e9e50ce4f13dc721014af622613409455c734942 upstream.

Protect vol->volume_label with a mutex and snaphost the label before
copy_to_user. This prevent a use-after-free when FS_IOC_SETFSLABEL
replaces the vol->volume_label and FS_IOC_GETTSLABEL reads it
concurrently.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/file.c   |   17 +++++++++++++----
 fs/ntfs/super.c  |   19 +++++++++++++------
 fs/ntfs/volume.h |    2 ++
 3 files changed, 28 insertions(+), 10 deletions(-)

--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -707,12 +707,21 @@ static int ntfs_ioctl_get_volume_label(s
 {
 	struct ntfs_volume *vol = NTFS_SB(file_inode(filp)->i_sb);
 	char __user *buf = (char __user *)arg;
+	char label[FSLABEL_MAX];
+	ssize_t len;
 
+	mutex_lock(&vol->volume_label_lock);
 	if (!vol->volume_label) {
-		if (copy_to_user(buf, "", 1))
-			return -EFAULT;
-	} else if (copy_to_user(buf, vol->volume_label,
-				MIN(FSLABEL_MAX, strlen(vol->volume_label) + 1)))
+		label[0] = '\0';
+		len = 0;
+	} else {
+		len = strscpy(label, vol->volume_label, sizeof(label));
+		if (len == -E2BIG)
+			len = FSLABEL_MAX - 1;
+	}
+	mutex_unlock(&vol->volume_label_lock);
+
+	if (copy_to_user(buf, label, len + 1))
 		return -EFAULT;
 	return 0;
 }
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -460,17 +460,23 @@ int ntfs_write_volume_label(struct ntfs_
 	ret = ntfs_resident_attr_record_add(vol_ni, AT_VOLUME_NAME, AT_UNNAMED, 0,
 					    (u8 *)uname, uname_len * sizeof(__le16), 0);
 out:
-	mutex_unlock(&vol_ni->mrec_lock);
-	kvfree(uname);
-
 	if (ret >= 0) {
-		kfree(vol->volume_label);
+		char *old_label;
+
+		mutex_lock(&vol->volume_label_lock);
+		old_label = vol->volume_label;
 		vol->volume_label = new_label;
+		mutex_unlock(&vol->volume_label_lock);
+
+		kfree(old_label);
 		mark_inode_dirty_sync(vol->vol_ino);
 		ret = 0;
-	} else {
-		kfree(new_label);
 	}
+	mutex_unlock(&vol_ni->mrec_lock);
+	kvfree(uname);
+
+	if (ret < 0)
+		kfree(new_label);
 	return ret;
 }
 
@@ -2631,6 +2637,7 @@ static int ntfs_init_fs_context(struct f
 	NVolSetCaseSensitive(vol);
 	init_rwsem(&vol->mftbmp_lock);
 	init_rwsem(&vol->lcnbmp_lock);
+	mutex_init(&vol->volume_label_lock);
 
 	fc->s_fs_info = vol;
 	fc->ops = &ntfs_context_ops;
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -72,6 +72,7 @@
  * @vol_flags: Volume flags.
  * @major_ver: Ntfs major version of volume.
  * @minor_ver: Ntfs minor version of volume.
+ * @volume_label_lock: protects @volume_label.
  * @volume_label: volume label.
  * @root_ino: The VFS inode of the root directory.
  * @secure_ino: The VFS inode of $Secure (NTFS3.0+ only, otherwise NULL).
@@ -133,6 +134,7 @@ struct ntfs_volume {
 	struct inode *logfile_ino;
 	struct inode *lcnbmp_ino;
 	struct rw_semaphore lcnbmp_lock;
+	struct mutex volume_label_lock;
 	struct inode *vol_ino;
 	__le16 vol_flags;
 	u8 major_ver;


