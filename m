Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A180022;
	Mon,  8 Apr 2024 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582906; cv=none; b=OWkiRbCrBOC3N1QdIwTknujsidfyWu8yJxI5QlrncbNj3DDQnxeC1/sdz4tCA1j+6TjlsGr1Y+M+lurRDnwazf6uZem+tbzR4Zzutdf1EV37bRbdHHQD23zY5BLqIUu4O1EVldghWXR1LlGK4dtgXMaaKraK0asFb5OjbIu9OIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582906; c=relaxed/simple;
	bh=vLeB5i8DcxG13OfYaUZPkdb+EOPiDRemO13doRJcO9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6J0EAnXXYH53h7XCQ+EMWPdlXMQYBBoowsz8Z8CQYgY0lufItLnDiD+WuwFn3LdGLS1wXCepJ4iEvhvO3WLO3BSN9423gtHcVB0v4uhGWj4WWXiR6wS364rxS0SYRKMksLcibqQH6/F2oixMu/Rpl/N+8FwQ1uMV5r5gMxxRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6wEfR1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6wEfR1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43546C433F1;
	Mon,  8 Apr 2024 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582906;
	bh=vLeB5i8DcxG13OfYaUZPkdb+EOPiDRemO13doRJcO9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6wEfR1GjYk5eHDA7BBDOwgEwkvs2/GiF/JIF/1Ii2igvMIFMFSu/ob2nZ9/XFOb7
	 eWA67UksPzO5YJHK8uG+MriWW7CQdkkXe9/WIURH7mDV119QdeHR/54gmnoLa1R1jc
	 ftP4pkvhoWPGwzGjOyhX2N5+FQeJVgq14SZjDw9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 186/690] fanotify: Support merging of error events
Date: Mon,  8 Apr 2024 14:50:52 +0200
Message-ID: <20240408125406.293496259@linuxfoundation.org>
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

[ Upstream commit 8a6ae64132fd27a944faed7bc38484827609eb76 ]

Error events (FAN_FS_ERROR) against the same file system can be merged
by simply iterating the error count.  The hash is taken from the fsid,
without considering the FH.  This means that only the first error object
is reported.

Link: https://lore.kernel.org/r/20211025192746.66445-22-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 26 ++++++++++++++++++++++++--
 fs/notify/fanotify/fanotify.h |  4 +++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 1f195c95dfcd0..cedcb15468043 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -111,6 +111,16 @@ static bool fanotify_name_event_equal(struct fanotify_name_event *fne1,
 	return fanotify_info_equal(info1, info2);
 }
 
+static bool fanotify_error_event_equal(struct fanotify_error_event *fee1,
+				       struct fanotify_error_event *fee2)
+{
+	/* Error events against the same file system are always merged. */
+	if (!fanotify_fsid_equal(&fee1->fsid, &fee2->fsid))
+		return false;
+
+	return true;
+}
+
 static bool fanotify_should_merge(struct fanotify_event *old,
 				  struct fanotify_event *new)
 {
@@ -141,6 +151,9 @@ static bool fanotify_should_merge(struct fanotify_event *old,
 	case FANOTIFY_EVENT_TYPE_FID_NAME:
 		return fanotify_name_event_equal(FANOTIFY_NE(old),
 						 FANOTIFY_NE(new));
+	case FANOTIFY_EVENT_TYPE_FS_ERROR:
+		return fanotify_error_event_equal(FANOTIFY_EE(old),
+						  FANOTIFY_EE(new));
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -176,6 +189,10 @@ static int fanotify_merge(struct fsnotify_group *group,
 			break;
 		if (fanotify_should_merge(old, new)) {
 			old->mask |= new->mask;
+
+			if (fanotify_is_error_event(old->mask))
+				FANOTIFY_EE(old)->err_count++;
+
 			return 1;
 		}
 	}
@@ -577,7 +594,8 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 static struct fanotify_event *fanotify_alloc_error_event(
 						struct fsnotify_group *group,
 						__kernel_fsid_t *fsid,
-						const void *data, int data_type)
+						const void *data, int data_type,
+						unsigned int *hash)
 {
 	struct fs_error_report *report =
 			fsnotify_data_error_report(data, data_type);
@@ -591,6 +609,10 @@ static struct fanotify_event *fanotify_alloc_error_event(
 		return NULL;
 
 	fee->fae.type = FANOTIFY_EVENT_TYPE_FS_ERROR;
+	fee->err_count = 1;
+	fee->fsid = *fsid;
+
+	*hash ^= fanotify_hash_fsid(fsid);
 
 	return &fee->fae;
 }
@@ -664,7 +686,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		event = fanotify_alloc_perm_event(path, gfp);
 	} else if (fanotify_is_error_event(mask)) {
 		event = fanotify_alloc_error_event(group, fsid, data,
-						   data_type);
+						   data_type, &hash);
 	} else if (name_event && (file_name || child)) {
 		event = fanotify_alloc_name_event(id, fsid, file_name, child,
 						  &hash, gfp);
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index ebef952481fa0..2b032b79d5b06 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -199,6 +199,9 @@ FANOTIFY_NE(struct fanotify_event *event)
 
 struct fanotify_error_event {
 	struct fanotify_event fae;
+	u32 err_count; /* Suppressed errors count */
+
+	__kernel_fsid_t fsid; /* FSID this error refers to. */
 };
 
 static inline struct fanotify_error_event *
@@ -332,7 +335,6 @@ static inline struct path *fanotify_event_path(struct fanotify_event *event)
 static inline bool fanotify_is_hashed_event(u32 mask)
 {
 	return !(fanotify_is_perm_event(mask) ||
-		 fanotify_is_error_event(mask) ||
 		 fsnotify_is_overflow_event(mask));
 }
 
-- 
2.43.0



