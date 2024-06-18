Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6DB13B780;
	Tue, 18 Jun 2024 12:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715268; cv=none; b=g6t/KsbzJOCuZ8dtP8O8488B3+v06AhPpGXCvJDmC9u2q92GSiCs3v3PVOmS1a0GkrAlW1NanMY1U+TKSp30l/LW40/owHsBzyCT/q1qRHAvbUN1vJDHLwN5RMQIbWK4aax6o7SIqoRxqHcY7pS7PTfEemAnhEtG8p3HjzbPLtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715268; c=relaxed/simple;
	bh=9LzsyUQKfIQ4Etd4yu4Odf6+w8+QqGtRp7tR8dbEU2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r51xuNf30evs8hjl6u+wjE2y1a4WCK3BKjFzLQIUltOqnyD3o4V5BOXZ91XiTW/Krgcbv2YWH4doGU+6bEVQ+zKhQGHMyjZoCVH820cN/LHb4SWIbdMlqa+ZxmF3egH1Nt06+6us8hem/q0fTdRP28G8mQoaa+IosbuRbY+UQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUXqOYPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUXqOYPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D2EC3277B;
	Tue, 18 Jun 2024 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715268;
	bh=9LzsyUQKfIQ4Etd4yu4Odf6+w8+QqGtRp7tR8dbEU2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUXqOYPGYtdtR5QaGFil5M+NBcVckggitKzkwkkrFdRucwA2opXClEIVy7gKhsBxT
	 g/4KiMfwLFRHcdMHamciW6X3eotubMxLlYRtAxKJMbUfdDlhpQRBn8KA6jImnE6ePw
	 ABQ0n4f5ekuo5rhA3KLiJhkaROCj7/gPWt+w6CBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/770] fanotify: mix event info and pid into merge key hash
Date: Tue, 18 Jun 2024 14:31:45 +0200
Message-ID: <20240618123417.004140521@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 7e3e5c6943994943eb76cab2d3a1806bc10b9045 ]

Improve the merge key hash by mixing more values relevant for merge.

For example, all FAN_CREATE name events in the same dir used to have the
same merge key based on the dir inode.  With this change the created
file name is mixed into the merge key.

The object id that was used as merge key is redundant to the event info
so it is no longer mixed into the hash.

Permission events are not hashed, so no need to hash their info.

Link: https://lore.kernel.org/r/20210304104826.3993892-4-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 87 ++++++++++++++++++++++++-----------
 fs/notify/fanotify/fanotify.h |  5 ++
 2 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 8a2bb6954e02c..43a606f153702 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -14,6 +14,7 @@
 #include <linux/audit.h>
 #include <linux/sched/mm.h>
 #include <linux/statfs.h>
+#include <linux/stringhash.h>
 
 #include "fanotify.h"
 
@@ -22,12 +23,24 @@ static bool fanotify_path_equal(struct path *p1, struct path *p2)
 	return p1->mnt == p2->mnt && p1->dentry == p2->dentry;
 }
 
+static unsigned int fanotify_hash_path(const struct path *path)
+{
+	return hash_ptr(path->dentry, FANOTIFY_EVENT_HASH_BITS) ^
+		hash_ptr(path->mnt, FANOTIFY_EVENT_HASH_BITS);
+}
+
 static inline bool fanotify_fsid_equal(__kernel_fsid_t *fsid1,
 				       __kernel_fsid_t *fsid2)
 {
 	return fsid1->val[0] == fsid2->val[0] && fsid1->val[1] == fsid2->val[1];
 }
 
+static unsigned int fanotify_hash_fsid(__kernel_fsid_t *fsid)
+{
+	return hash_32(fsid->val[0], FANOTIFY_EVENT_HASH_BITS) ^
+		hash_32(fsid->val[1], FANOTIFY_EVENT_HASH_BITS);
+}
+
 static bool fanotify_fh_equal(struct fanotify_fh *fh1,
 			      struct fanotify_fh *fh2)
 {
@@ -38,6 +51,16 @@ static bool fanotify_fh_equal(struct fanotify_fh *fh1,
 		!memcmp(fanotify_fh_buf(fh1), fanotify_fh_buf(fh2), fh1->len);
 }
 
+static unsigned int fanotify_hash_fh(struct fanotify_fh *fh)
+{
+	long salt = (long)fh->type | (long)fh->len << 8;
+
+	/*
+	 * full_name_hash() works long by long, so it handles fh buf optimally.
+	 */
+	return full_name_hash((void *)salt, fanotify_fh_buf(fh), fh->len);
+}
+
 static bool fanotify_fid_event_equal(struct fanotify_fid_event *ffe1,
 				     struct fanotify_fid_event *ffe2)
 {
@@ -325,7 +348,8 @@ static int fanotify_encode_fh_len(struct inode *inode)
  * Return 0 on failure to encode.
  */
 static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
-			      unsigned int fh_len, gfp_t gfp)
+			      unsigned int fh_len, unsigned int *hash,
+			      gfp_t gfp)
 {
 	int dwords, type = 0;
 	char *ext_buf = NULL;
@@ -368,6 +392,9 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	fh->type = type;
 	fh->len = fh_len;
 
+	/* Mix fh into event merge key */
+	*hash ^= fanotify_hash_fh(fh);
+
 	return FANOTIFY_FH_HDR_LEN + fh_len;
 
 out_err:
@@ -421,6 +448,7 @@ static struct inode *fanotify_dfid_inode(u32 event_mask, const void *data,
 }
 
 static struct fanotify_event *fanotify_alloc_path_event(const struct path *path,
+							unsigned int *hash,
 							gfp_t gfp)
 {
 	struct fanotify_path_event *pevent;
@@ -431,6 +459,7 @@ static struct fanotify_event *fanotify_alloc_path_event(const struct path *path,
 
 	pevent->fae.type = FANOTIFY_EVENT_TYPE_PATH;
 	pevent->path = *path;
+	*hash ^= fanotify_hash_path(path);
 	path_get(path);
 
 	return &pevent->fae;
@@ -456,6 +485,7 @@ static struct fanotify_event *fanotify_alloc_perm_event(const struct path *path,
 
 static struct fanotify_event *fanotify_alloc_fid_event(struct inode *id,
 						       __kernel_fsid_t *fsid,
+						       unsigned int *hash,
 						       gfp_t gfp)
 {
 	struct fanotify_fid_event *ffe;
@@ -466,16 +496,18 @@ static struct fanotify_event *fanotify_alloc_fid_event(struct inode *id,
 
 	ffe->fae.type = FANOTIFY_EVENT_TYPE_FID;
 	ffe->fsid = *fsid;
+	*hash ^= fanotify_hash_fsid(fsid);
 	fanotify_encode_fh(&ffe->object_fh, id, fanotify_encode_fh_len(id),
-			   gfp);
+			   hash, gfp);
 
 	return &ffe->fae;
 }
 
 static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 							__kernel_fsid_t *fsid,
-							const struct qstr *file_name,
+							const struct qstr *name,
 							struct inode *child,
+							unsigned int *hash,
 							gfp_t gfp)
 {
 	struct fanotify_name_event *fne;
@@ -488,24 +520,30 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 	size = sizeof(*fne) + FANOTIFY_FH_HDR_LEN + dir_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
-	if (file_name)
-		size += file_name->len + 1;
+	if (name)
+		size += name->len + 1;
 	fne = kmalloc(size, gfp);
 	if (!fne)
 		return NULL;
 
 	fne->fae.type = FANOTIFY_EVENT_TYPE_FID_NAME;
 	fne->fsid = *fsid;
+	*hash ^= fanotify_hash_fsid(fsid);
 	info = &fne->info;
 	fanotify_info_init(info);
 	dfh = fanotify_info_dir_fh(info);
-	info->dir_fh_totlen = fanotify_encode_fh(dfh, id, dir_fh_len, 0);
+	info->dir_fh_totlen = fanotify_encode_fh(dfh, id, dir_fh_len, hash, 0);
 	if (child_fh_len) {
 		ffh = fanotify_info_file_fh(info);
-		info->file_fh_totlen = fanotify_encode_fh(ffh, child, child_fh_len, 0);
+		info->file_fh_totlen = fanotify_encode_fh(ffh, child,
+							child_fh_len, hash, 0);
+	}
+	if (name) {
+		long salt = name->len;
+
+		fanotify_info_copy_name(info, name);
+		*hash ^= full_name_hash((void *)salt, name->name, name->len);
 	}
-	if (file_name)
-		fanotify_info_copy_name(info, file_name);
 
 	pr_debug("%s: ino=%lu size=%u dir_fh_len=%u child_fh_len=%u name_len=%u name='%.*s'\n",
 		 __func__, id->i_ino, size, dir_fh_len, child_fh_len,
@@ -530,6 +568,8 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	struct inode *child = NULL;
 	bool name_event = false;
 	unsigned int hash = 0;
+	bool ondir = mask & FAN_ONDIR;
+	struct pid *pid;
 
 	if ((fid_mode & FAN_REPORT_DIR_FID) && dirid) {
 		/*
@@ -537,8 +577,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		 * report the child fid for events reported on a non-dir child
 		 * in addition to reporting the parent fid and maybe child name.
 		 */
-		if ((fid_mode & FAN_REPORT_FID) &&
-		    id != dirid && !(mask & FAN_ONDIR))
+		if ((fid_mode & FAN_REPORT_FID) && id != dirid && !ondir)
 			child = id;
 
 		id = dirid;
@@ -559,8 +598,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		if (!(fid_mode & FAN_REPORT_NAME)) {
 			name_event = !!child;
 			file_name = NULL;
-		} else if ((mask & ALL_FSNOTIFY_DIRENT_EVENTS) ||
-			   !(mask & FAN_ONDIR)) {
+		} else if ((mask & ALL_FSNOTIFY_DIRENT_EVENTS) || !ondir) {
 			name_event = true;
 		}
 	}
@@ -583,28 +621,25 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		event = fanotify_alloc_perm_event(path, gfp);
 	} else if (name_event && (file_name || child)) {
 		event = fanotify_alloc_name_event(id, fsid, file_name, child,
-						  gfp);
+						  &hash, gfp);
 	} else if (fid_mode) {
-		event = fanotify_alloc_fid_event(id, fsid, gfp);
+		event = fanotify_alloc_fid_event(id, fsid, &hash, gfp);
 	} else {
-		event = fanotify_alloc_path_event(path, gfp);
+		event = fanotify_alloc_path_event(path, &hash, gfp);
 	}
 
 	if (!event)
 		goto out;
 
-	/*
-	 * Use the victim inode instead of the watching inode as the id for
-	 * event queue, so event reported on parent is merged with event
-	 * reported on child when both directory and child watches exist.
-	 * Hash object id for queue merge.
-	 */
-	hash = hash_ptr(id, FANOTIFY_EVENT_HASH_BITS);
-	fanotify_init_event(event, hash, mask);
 	if (FAN_GROUP_FLAG(group, FAN_REPORT_TID))
-		event->pid = get_pid(task_pid(current));
+		pid = get_pid(task_pid(current));
 	else
-		event->pid = get_pid(task_tgid(current));
+		pid = get_pid(task_tgid(current));
+
+	/* Mix event info, FAN_ONDIR flag and pid into event merge key */
+	hash ^= hash_long((unsigned long)pid | ondir, FANOTIFY_EVENT_HASH_BITS);
+	fanotify_init_event(event, hash, mask);
+	event->pid = pid;
 
 out:
 	set_active_memcg(old_memcg);
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index d531f0cfa46f2..9871f76cd9c2c 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -115,6 +115,11 @@ static inline void fanotify_info_init(struct fanotify_info *info)
 	info->name_len = 0;
 }
 
+static inline unsigned int fanotify_info_len(struct fanotify_info *info)
+{
+	return info->dir_fh_totlen + info->file_fh_totlen + info->name_len;
+}
+
 static inline void fanotify_info_copy_name(struct fanotify_info *info,
 					   const struct qstr *name)
 {
-- 
2.43.0



