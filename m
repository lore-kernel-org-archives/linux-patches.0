Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D046B78285;
	Mon,  8 Apr 2024 13:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583151; cv=none; b=ijs7TlqgDqWdZYLpDhg9EKy4oeJrCQeGmuJSIKJGtR6kQYZpIBr5JiYe/olbWNCz85qcFtVOHztrNsWetIeG9SDLSyKZxEMhnVzgLacxBuNuaR6tO0BAKHoAkH2NKkmlU/eDnl8V6dpO2J5jYD65jd+BfMEW2bqOTAvC+FHWm7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583151; c=relaxed/simple;
	bh=nTjnRkWYS18rONTKADiJ2NqOUmnuDfJEFJmHogRGBqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjLEuzF4zHPiuPojH4KEeeMiwucgL7PNIeRPPFnPFaA7isPat5SI4NfbV0WG++uGoiQEl3eI+BWYFPir+Ryl6+3W7+J18vCUBL7+3+Vda9q5q2LuldbJDzYJ68OdCrJZejAoyLB8iPQIkw5tBktBa3NWEqrJ8m0taKTRybsBjyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKD/mqx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKD/mqx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61C8C433F1;
	Mon,  8 Apr 2024 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583151;
	bh=nTjnRkWYS18rONTKADiJ2NqOUmnuDfJEFJmHogRGBqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKD/mqx7w5m0XrXJgHRWF8eerHbiBLzS5N6A4dKxgtJK68Qfwn5/NifVPn5YB2l4w
	 QRsD1DUcQ76dL+qpBhfCfCsdT/zL2q8Hd506g2OL5Qs6bVoRBiSh6IjLbUqmO6bb5W
	 e95eOV8KHSAq8noAZwKl5vtCeA9r4plbuRyKxFUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 190/690] fanotify: Report fid info for file related file system errors
Date: Mon,  8 Apr 2024 14:50:56 +0200
Message-ID: <20240408125406.445833132@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 936d6a38be39177495af38497bf8da1c6128fa1b ]

Plumb the pieces to add a FID report to error records.  Since all error
event memory must be pre-allocated, we pre-allocate the maximum file
handle size possible, such that it should always fit.

For errors that don't expose a file handle, report it with an invalid
FID. Internally we use zero-length FILEID_ROOT file handle for passing
the information (which we report as zero-length FILEID_INVALID file
handle to userspace) so we update the handle reporting code to deal with
this case correctly.

Link: https://lore.kernel.org/r/20211025192746.66445-27-krisman@collabora.com
Link: https://lore.kernel.org/r/20211025192746.66445-25-krisman@collabora.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
[Folded two patches into 2 to make series bisectable]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      | 11 +++++++++++
 fs/notify/fanotify/fanotify.h      |  9 +++++++++
 fs/notify/fanotify/fanotify_user.c |  8 +++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 45df610debbe4..465f07e70e6dc 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -609,7 +609,9 @@ static struct fanotify_event *fanotify_alloc_error_event(
 {
 	struct fs_error_report *report =
 			fsnotify_data_error_report(data, data_type);
+	struct inode *inode;
 	struct fanotify_error_event *fee;
+	int fh_len;
 
 	if (WARN_ON_ONCE(!report))
 		return NULL;
@@ -622,6 +624,15 @@ static struct fanotify_event *fanotify_alloc_error_event(
 	fee->err_count = 1;
 	fee->fsid = *fsid;
 
+	inode = report->inode;
+	fh_len = fanotify_encode_fh_len(inode);
+
+	/* Bad fh_len. Fallback to using an invalid fh. Should never happen. */
+	if (!fh_len && inode)
+		inode = NULL;
+
+	fanotify_encode_fh(&fee->object_fh, inode, fh_len, NULL, 0);
+
 	*hash ^= fanotify_hash_fsid(fsid);
 
 	return &fee->fae;
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 80af269eebb89..edd7587adcc59 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -208,6 +208,8 @@ struct fanotify_error_event {
 	u32 err_count; /* Suppressed errors count */
 
 	__kernel_fsid_t fsid; /* FSID this error refers to. */
+
+	FANOTIFY_INLINE_FH(object_fh, MAX_HANDLE_SZ);
 };
 
 static inline struct fanotify_error_event *
@@ -222,6 +224,8 @@ static inline __kernel_fsid_t *fanotify_event_fsid(struct fanotify_event *event)
 		return &FANOTIFY_FE(event)->fsid;
 	else if (event->type == FANOTIFY_EVENT_TYPE_FID_NAME)
 		return &FANOTIFY_NE(event)->fsid;
+	else if (event->type == FANOTIFY_EVENT_TYPE_FS_ERROR)
+		return &FANOTIFY_EE(event)->fsid;
 	else
 		return NULL;
 }
@@ -233,6 +237,8 @@ static inline struct fanotify_fh *fanotify_event_object_fh(
 		return &FANOTIFY_FE(event)->object_fh;
 	else if (event->type == FANOTIFY_EVENT_TYPE_FID_NAME)
 		return fanotify_info_file_fh(&FANOTIFY_NE(event)->info);
+	else if (event->type == FANOTIFY_EVENT_TYPE_FS_ERROR)
+		return &FANOTIFY_EE(event)->object_fh;
 	else
 		return NULL;
 }
@@ -266,6 +272,9 @@ static inline int fanotify_event_dir_fh_len(struct fanotify_event *event)
 
 static inline bool fanotify_event_has_object_fh(struct fanotify_event *event)
 {
+	/* For error events, even zeroed fh are reported. */
+	if (event->type == FANOTIFY_EVENT_TYPE_FS_ERROR)
+		return true;
 	return fanotify_event_object_fh_len(event) > 0;
 }
 
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c053038e1cf3c..fa3dac9c59f69 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -339,9 +339,6 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 	pr_debug("%s: fh_len=%zu name_len=%zu, info_len=%zu, count=%zu\n",
 		 __func__, fh_len, name_len, info_len, count);
 
-	if (!fh_len)
-		return 0;
-
 	if (WARN_ON_ONCE(len < sizeof(info) || len > count))
 		return -EFAULT;
 
@@ -376,6 +373,11 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 
 	handle.handle_type = fh->type;
 	handle.handle_bytes = fh_len;
+
+	/* Mangle handle_type for bad file_handle */
+	if (!fh_len)
+		handle.handle_type = FILEID_INVALID;
+
 	if (copy_to_user(buf, &handle, sizeof(handle)))
 		return -EFAULT;
 
-- 
2.43.0



