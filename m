Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24340156F25;
	Tue, 18 Jun 2024 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715746; cv=none; b=LGXXm4PMsP892o5jqdQoFqEkWQrk547Kqsih7eYi21QaXX34mvEZF4i8/bGwpxVSWy9O0CMoSWxDdnqQwoPiJC14EFo+4VFMcO2d7zeNQ5n5UUmJ9CfnDIQ9c3GEMvs1NCFU81hgCCn0ioFjUtk+BTRrRQ4+41DnL+O6ikcF9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715746; c=relaxed/simple;
	bh=kW6RDmiLMTVoSfkWmLlaF7jNulgTh2kJExMpjVpxjNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYgU0RZusgTjRuJWVKc1NZMkd5ipFGB1085P+w5W38nQKivb+QInFZJM83d7or7BjWC17eQLMEqN6SlNGhKVXN+kYWTDBsING29eMht8jlgdVd4pjQRDd+RbMcLDWpHQxG+qBBNa+SRaNIa/VUBjXvMfO1IZj4NXifJFAe4s0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgTXfURK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgTXfURK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BACFC3277B;
	Tue, 18 Jun 2024 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715746;
	bh=kW6RDmiLMTVoSfkWmLlaF7jNulgTh2kJExMpjVpxjNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgTXfURK9orhPMC20rX3ZoYmg2+rAEpmiK+vysVWvwUeMEV6R7zhbgu16rJtyInBu
	 YbJDvoBjeO4YwGYvGPYo+qYDhY3F8rRnVh8XghUYypLivCq3L0Tj24G8hY5y84hgrX
	 rOlOtHti0pY2aaoyw5jW/pKzh8oHqkbXX/6vimz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/770] fanotify: Support merging of error events
Date: Tue, 18 Jun 2024 14:33:54 +0200
Message-ID: <20240618123421.983773411@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



