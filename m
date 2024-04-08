Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E627867D;
	Mon,  8 Apr 2024 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584101; cv=none; b=Xa8E0Toqq9RSL9hGANIyNrDcBT0A/gtRw/5UzdoAQDd02pPHgB+FzoF7Y3v4btUBCRcv1xpYgRLhzwURdJxm7SYdWVIgPlZLB4qdxttmeI8DOUDu7FNPhcePen8YcImUb9UtFb3cnvPMcSglKKwQOXBEVcZvertZLh4f06ECVEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584101; c=relaxed/simple;
	bh=EGpmzlJvt611k9tG5RiVZ+OJ6RHmDzTY5GwaB8Nj6Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEtxlENyoO43EHJjzkgcI+dYbxN9c2jYGcGUV1+hhpmf5ITfMpSfsBhEqBUEuRw6bt0IyfmkWTXveggJEDWOct1zNr7R0ze+OAwPGQ9mGT/63tA1BiDLiha4B/f3QBYN4eaEbLpvnH3e0U0Q/y2VJGB+9Ue6CUX90kxnOMGti3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgwETn4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgwETn4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5A7C433F1;
	Mon,  8 Apr 2024 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584100;
	bh=EGpmzlJvt611k9tG5RiVZ+OJ6RHmDzTY5GwaB8Nj6Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgwETn4hS8HHyFc/tpfxDFU2rvtialxozHZhavl7nvMZZcgCVsK1/+sl4jZ3oy992
	 4UVJqkfkb2KNENM7MjO4gtMqQv2wMrBbht6y6xrfNivL3STjKOW1hq7YiJFVmilulh
	 4gyxghQMgSu7A47eUF1G1xQWgIeT/DuYvMM9zGp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 334/690] fanotify: refine the validation checks on non-dir inode mask
Date: Mon,  8 Apr 2024 14:53:20 +0200
Message-ID: <20240408125411.704847176@linuxfoundation.org>
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

[ Upstream commit 8698e3bab4dd7968666e84e111d0bfd17c040e77 ]

Commit ceaf69f8eadc ("fanotify: do not allow setting dirent events in
mask of non-dir") added restrictions about setting dirent events in the
mask of a non-dir inode mark, which does not make any sense.

For backward compatibility, these restictions were added only to new
(v5.17+) APIs.

It also does not make any sense to set the flags FAN_EVENT_ON_CHILD or
FAN_ONDIR in the mask of a non-dir inode.  Add these flags to the
dir-only restriction of the new APIs as well.

Move the check of the dir-only flags for new APIs into the helper
fanotify_events_supported(), which is only called for FAN_MARK_ADD,
because there is no need to error on an attempt to remove the dir-only
flags from non-dir inode.

Fixes: ceaf69f8eadc ("fanotify: do not allow setting dirent events in mask of non-dir")
Link: https://lore.kernel.org/linux-fsdevel/20220627113224.kr2725conevh53u4@quack3.lan/
Link: https://lore.kernel.org/r/20220627174719.2838175-1-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[ cel: adjusted to apply on v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 30 +++++++++++++++---------------
 include/linux/fanotify.h           |  4 ++++
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6db5a0b03a78d..433c89fdcf0cd 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1509,10 +1509,14 @@ static int fanotify_test_fid(struct dentry *dentry)
 	return 0;
 }
 
-static int fanotify_events_supported(struct path *path, __u64 mask,
+static int fanotify_events_supported(struct fsnotify_group *group,
+				     struct path *path, __u64 mask,
 				     unsigned int flags)
 {
 	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+	/* Strict validation of events in non-dir inode mask with v5.17+ APIs */
+	bool strict_dir_events = FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID) ||
+				 (mask & FAN_RENAME);
 
 	/*
 	 * Some filesystems such as 'proc' acquire unusual locks when opening
@@ -1540,6 +1544,15 @@ static int fanotify_events_supported(struct path *path, __u64 mask,
 	    path->mnt->mnt_sb->s_flags & SB_NOUSER)
 		return -EINVAL;
 
+	/*
+	 * We shouldn't have allowed setting dirent events and the directory
+	 * flags FAN_ONDIR and FAN_EVENT_ON_CHILD in mask of non-dir inode,
+	 * but because we always allowed it, error only when using new APIs.
+	 */
+	if (strict_dir_events && mark_type == FAN_MARK_INODE &&
+	    !d_is_dir(path->dentry) && (mask & FANOTIFY_DIRONLY_EVENT_BITS))
+		return -ENOTDIR;
+
 	return 0;
 }
 
@@ -1686,7 +1699,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		goto fput_and_out;
 
 	if (flags & FAN_MARK_ADD) {
-		ret = fanotify_events_supported(&path, mask, flags);
+		ret = fanotify_events_supported(group, &path, mask, flags);
 		if (ret)
 			goto path_put_and_out;
 	}
@@ -1709,19 +1722,6 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	else
 		mnt = path.mnt;
 
-	/*
-	 * FAN_RENAME is not allowed on non-dir (for now).
-	 * We shouldn't have allowed setting any dirent events in mask of
-	 * non-dir, but because we always allowed it, error only if group
-	 * was initialized with the new flag FAN_REPORT_TARGET_FID.
-	 */
-	ret = -ENOTDIR;
-	if (inode && !S_ISDIR(inode->i_mode) &&
-	    ((mask & FAN_RENAME) ||
-	     ((mask & FANOTIFY_DIRENT_EVENTS) &&
-	      FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID))))
-		goto path_put_and_out;
-
 	/* Mask out FAN_EVENT_ON_CHILD flag for sb/mount/non-dir marks */
 	if (mnt || !S_ISDIR(inode->i_mode)) {
 		mask &= ~FAN_EVENT_ON_CHILD;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 81f45061c1b18..4f6cbe6c6e235 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -113,6 +113,10 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 					 FANOTIFY_PERM_EVENTS | \
 					 FAN_Q_OVERFLOW | FAN_ONDIR)
 
+/* Events and flags relevant only for directories */
+#define FANOTIFY_DIRONLY_EVENT_BITS	(FANOTIFY_DIRENT_EVENTS | \
+					 FAN_EVENT_ON_CHILD | FAN_ONDIR)
+
 #define ALL_FANOTIFY_EVENT_BITS		(FANOTIFY_OUTGOING_EVENTS | \
 					 FANOTIFY_EVENT_FLAGS)
 
-- 
2.43.0



