Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD088172D;
	Mon,  8 Apr 2024 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582945; cv=none; b=VATuqMrOsdsVRQBWB4qBv6gwu/w3JgsmV5xdvc9W6KIJ1UKMn8oNTOc1RCn14TOA7zBQmhTvJxR1zPQ1QxqyRg6hwlj6RqL1QnJuLR/l9HgbkuqM0+qr2iNAbEDb+wVrHlhase71wgnn5CL4q8jEwUdKGG5RgtLjwNcBKMIR30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582945; c=relaxed/simple;
	bh=H3CIYxBetTZ4DH1EiezXcrW/FanjYJoLLJk4NuGUvGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAnaci6zMCZOjHZ0RCNxSCWOUrogf2a7Z6LM9xu0HIW40SuBL9JHT2ak/d+56UGz/IxZCrhEVen6Elbp6pBQen0AA8tCH89TBpB9IS/abnTFisd5GFrlYSula+RFG8PGIk+dDG+FwXRSqambU3HOhAN0Rf8eBOtjPDYIt7pwhZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jd/3JAZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jd/3JAZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB6C433C7;
	Mon,  8 Apr 2024 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582944;
	bh=H3CIYxBetTZ4DH1EiezXcrW/FanjYJoLLJk4NuGUvGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jd/3JAZoHjEh36Yj0KlV/yOsHIUyrOs/gXm3fOkIrf/i4lUqdmfW9i5dbYZWboHG2
	 +bJzQJrNAFk6HnvcU8eSGZN4nU6jRtlTFh+D0tiwxq5gwgD/eGdhjQGmxDtCh1ai65
	 LY67O4RnIMrZaGI1aVTPywG1wIDgVzisbEy7952M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 191/690] fanotify: Emit generic error info for error event
Date: Mon,  8 Apr 2024 14:50:57 +0200
Message-ID: <20240408125406.476402741@linuxfoundation.org>
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

[ Upstream commit 130a3c742107acff985541c28360c8b40203559c ]

The error info is a record sent to users on FAN_FS_ERROR events
documenting the type of error.  It also carries an error count,
documenting how many errors were observed since the last reporting.

Link: https://lore.kernel.org/r/20211025192746.66445-28-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      |  1 +
 fs/notify/fanotify/fanotify.h      |  1 +
 fs/notify/fanotify/fanotify_user.c | 36 ++++++++++++++++++++++++++++++
 include/uapi/linux/fanotify.h      |  7 ++++++
 4 files changed, 45 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 465f07e70e6dc..af61425e6e3bf 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -621,6 +621,7 @@ static struct fanotify_event *fanotify_alloc_error_event(
 		return NULL;
 
 	fee->fae.type = FANOTIFY_EVENT_TYPE_FS_ERROR;
+	fee->error = report->error;
 	fee->err_count = 1;
 	fee->fsid = *fsid;
 
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index edd7587adcc59..d25f500bf7e79 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -205,6 +205,7 @@ FANOTIFY_NE(struct fanotify_event *event)
 
 struct fanotify_error_event {
 	struct fanotify_event fae;
+	s32 error; /* Error reported by the Filesystem. */
 	u32 err_count; /* Suppressed errors count */
 
 	__kernel_fsid_t fsid; /* FSID this error refers to. */
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index fa3dac9c59f69..133d9b5ffdb10 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -115,6 +115,8 @@ struct kmem_cache *fanotify_perm_event_cachep __read_mostly;
 	(sizeof(struct fanotify_event_info_fid) + sizeof(struct file_handle))
 #define FANOTIFY_PIDFD_INFO_HDR_LEN \
 	sizeof(struct fanotify_event_info_pidfd)
+#define FANOTIFY_ERROR_INFO_LEN \
+	(sizeof(struct fanotify_event_info_error))
 
 static int fanotify_fid_info_len(int fh_len, int name_len)
 {
@@ -139,6 +141,9 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (!info_mode)
 		return event_len;
 
+	if (fanotify_is_error_event(event->mask))
+		event_len += FANOTIFY_ERROR_INFO_LEN;
+
 	info = fanotify_event_info(event);
 
 	if (fanotify_event_has_dir_fh(event)) {
@@ -324,6 +329,28 @@ static int process_access_response(struct fsnotify_group *group,
 	return -ENOENT;
 }
 
+static size_t copy_error_info_to_user(struct fanotify_event *event,
+				      char __user *buf, int count)
+{
+	struct fanotify_event_info_error info;
+	struct fanotify_error_event *fee = FANOTIFY_EE(event);
+
+	info.hdr.info_type = FAN_EVENT_INFO_TYPE_ERROR;
+	info.hdr.pad = 0;
+	info.hdr.len = FANOTIFY_ERROR_INFO_LEN;
+
+	if (WARN_ON(count < info.hdr.len))
+		return -EFAULT;
+
+	info.error = fee->error;
+	info.error_count = fee->err_count;
+
+	if (copy_to_user(buf, &info, sizeof(info)))
+		return -EFAULT;
+
+	return info.hdr.len;
+}
+
 static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 				 int info_type, const char *name,
 				 size_t name_len,
@@ -530,6 +557,15 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
+	if (fanotify_is_error_event(event->mask)) {
+		ret = copy_error_info_to_user(event, buf, count);
+		if (ret < 0)
+			return ret;
+		buf += ret;
+		count -= ret;
+		total_bytes += ret;
+	}
+
 	return total_bytes;
 }
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 2990731ddc8bc..bd1932c2074d5 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -126,6 +126,7 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_DFID_NAME	2
 #define FAN_EVENT_INFO_TYPE_DFID	3
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
+#define FAN_EVENT_INFO_TYPE_ERROR	5
 
 /* Variable length info record following event metadata */
 struct fanotify_event_info_header {
@@ -160,6 +161,12 @@ struct fanotify_event_info_pidfd {
 	__s32 pidfd;
 };
 
+struct fanotify_event_info_error {
+	struct fanotify_event_info_header hdr;
+	__s32 error;
+	__u32 error_count;
+};
+
 struct fanotify_response {
 	__s32 fd;
 	__u32 response;
-- 
2.43.0



