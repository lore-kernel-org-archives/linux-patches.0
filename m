Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3118E757;
	Tue, 18 Jun 2024 13:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715758; cv=none; b=BLP8I5pZ6NDMTWTrHeCTWD8taC8mHBHqBfgyYe+CoZRoLEfoScN4NtN1JX53znpdvWYlRTOLDAh8mwLlm2XI6ccFXcJ8LjABp1lHXMmxqGLZp4mnYWP0VuRuzHYiwCOXcFtWwPzFOQmsMETJbRLQ2/w9NKJkR8D5kpTJ/id9Kno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715758; c=relaxed/simple;
	bh=DnVFFX1flWmqiaGtuGc950dDbpfi6JB8U6UGVOmnbWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDXw4LxXW0RdMlyY6ucxv76I5cksaeIxDc2YxEW4f1Y1bDPcxIQFKhwgcFCj891euDl19ujclzz+wbZlQEPuB1tgrE+/OGTPid9yoz2Y3iCXWLeFH7crltby9BKkCEniH8PwWaFpj6X6p+CDAt9G75Q7pWybpT9Na+z+XC9JLeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgtnMkts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgtnMkts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F14DC3277B;
	Tue, 18 Jun 2024 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715758;
	bh=DnVFFX1flWmqiaGtuGc950dDbpfi6JB8U6UGVOmnbWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgtnMktsMaQZBFf+t9CE2vkDtMdK2Tidi1AiKc7XCee1wtljb46EMo2aCY8e+v8Dv
	 CgL4n13sNKaktxqpVMl4kHUHA6K17RzD6cvwcEVqXP++RHIf6WwrYh4/FYNJXZF3qo
	 aYdrt8x8AfAtfVvqV1fyqiTgQxmNIh2FIbsPsb/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/770] fanotify: Report fid info for file related file system errors
Date: Tue, 18 Jun 2024 14:33:58 +0200
Message-ID: <20240618123422.137254665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 34ed30be0e4d4..0d36ac3ed7e99 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -334,9 +334,6 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 	pr_debug("%s: fh_len=%zu name_len=%zu, info_len=%zu, count=%zu\n",
 		 __func__, fh_len, name_len, info_len, count);
 
-	if (!fh_len)
-		return 0;
-
 	if (WARN_ON_ONCE(len < sizeof(info) || len > count))
 		return -EFAULT;
 
@@ -371,6 +368,11 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 
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



