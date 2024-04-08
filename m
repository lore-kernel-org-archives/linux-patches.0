Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6BD7BAF4;
	Mon,  8 Apr 2024 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583169; cv=none; b=q1yq+nRAdD0nMSzLSGD3yGyxoEnrG2jeTWW/wyc798kGYheDob+lTevTdedoE9kTTXFVRpRs3bg02HkhrrKrG3TkFSB+lBAbIl7GUHFiQd7o5TtcnnwO8t5AL0B4cuLAMXXbDW1d85Ry8YbYvAYmzYkTuNJ4CH9ddeh6xnBDIXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583169; c=relaxed/simple;
	bh=bNgZzs6wNhN+imbfsKuwae8BN/0Bq4+GZnlL9XNSdCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qq5ZkfAsKspA4C3VUY+SyodOmbxx2vUW1PKJaTx5wUKC6nIhowofo3j4J7n8I2vP8nQBgmBodbY6GSqbRZt17GUDe9VmMHpftAkyEKV4C5bkGF0eL7w8SoXDm9ABm6/HndMHRHhzxvjNoij3FOdsH+up2SIK8GiQBo9UK9GH5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B85uK6oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B85uK6oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B41C433C7;
	Mon,  8 Apr 2024 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583168;
	bh=bNgZzs6wNhN+imbfsKuwae8BN/0Bq4+GZnlL9XNSdCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B85uK6oegOSIsRckO/Mq3sr7j0V4IzE/CHqr7F8qoJHmmmG2UlDQCWm/pqUDxnbaV
	 y3xcWEdpF6D2fISYLs1lpxJCwIzjqyJqgpa4f3pjPPfKOiKyvGAC3BIJrVPQ5JUK3x
	 tMhBz9zj4LBaXHLvrOQ8JNZQ0z7PjjlpAlsXH3/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 218/690] fanotify: use helpers to parcel fanotify_info buffer
Date: Mon,  8 Apr 2024 14:51:24 +0200
Message-ID: <20240408125407.447621560@linuxfoundation.org>
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

[ Upstream commit 1a9515ac9e55e68d733bab81bd408463ab1e25b1 ]

fanotify_info buffer is parceled into variable sized records, so the
records must be written in order: dir_fh, file_fh, name.

Use helpers to assert that order and make fanotify_alloc_name_event()
a bit more generic to allow empty dir_fh record and to allow expanding
to more records (i.e. name2) soon.

Link: https://lore.kernel.org/r/20211129201537.1932819-7-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 35 +++++++++++++++++++----------------
 fs/notify/fanotify/fanotify.h | 20 ++++++++++++++++++++
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index ffad224be0149..2b13c79cebc62 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -576,7 +576,7 @@ static struct fanotify_event *fanotify_alloc_fid_event(struct inode *id,
 	return &ffe->fae;
 }
 
-static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
+static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 							__kernel_fsid_t *fsid,
 							const struct qstr *name,
 							struct inode *child,
@@ -586,15 +586,17 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 	struct fanotify_name_event *fne;
 	struct fanotify_info *info;
 	struct fanotify_fh *dfh, *ffh;
-	unsigned int dir_fh_len = fanotify_encode_fh_len(id);
+	unsigned int dir_fh_len = fanotify_encode_fh_len(dir);
 	unsigned int child_fh_len = fanotify_encode_fh_len(child);
-	unsigned int size;
+	unsigned long name_len = name ? name->len : 0;
+	unsigned int len, size;
 
-	size = sizeof(*fne) + FANOTIFY_FH_HDR_LEN + dir_fh_len;
+	/* Reserve terminating null byte even for empty name */
+	size = sizeof(*fne) + name_len + 1;
+	if (dir_fh_len)
+		size += FANOTIFY_FH_HDR_LEN + dir_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
-	if (name)
-		size += name->len + 1;
 	fne = kmalloc(size, gfp);
 	if (!fne)
 		return NULL;
@@ -604,22 +606,23 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 	*hash ^= fanotify_hash_fsid(fsid);
 	info = &fne->info;
 	fanotify_info_init(info);
-	dfh = fanotify_info_dir_fh(info);
-	info->dir_fh_totlen = fanotify_encode_fh(dfh, id, dir_fh_len, hash, 0);
+	if (dir_fh_len) {
+		dfh = fanotify_info_dir_fh(info);
+		len = fanotify_encode_fh(dfh, dir, dir_fh_len, hash, 0);
+		fanotify_info_set_dir_fh(info, len);
+	}
 	if (child_fh_len) {
 		ffh = fanotify_info_file_fh(info);
-		info->file_fh_totlen = fanotify_encode_fh(ffh, child,
-							child_fh_len, hash, 0);
+		len = fanotify_encode_fh(ffh, child, child_fh_len, hash, 0);
+		fanotify_info_set_file_fh(info, len);
 	}
-	if (name) {
-		long salt = name->len;
-
+	if (name_len) {
 		fanotify_info_copy_name(info, name);
-		*hash ^= full_name_hash((void *)salt, name->name, name->len);
+		*hash ^= full_name_hash((void *)name_len, name->name, name_len);
 	}
 
-	pr_debug("%s: ino=%lu size=%u dir_fh_len=%u child_fh_len=%u name_len=%u name='%.*s'\n",
-		 __func__, id->i_ino, size, dir_fh_len, child_fh_len,
+	pr_debug("%s: size=%u dir_fh_len=%u child_fh_len=%u name_len=%u name='%.*s'\n",
+		 __func__, size, dir_fh_len, child_fh_len,
 		 info->name_len, info->name_len, fanotify_info_name(info));
 
 	return &fne->fae;
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index dd23ba659e76b..7ac6f9f1e4148 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -138,6 +138,26 @@ static inline void fanotify_info_init(struct fanotify_info *info)
 	info->name_len = 0;
 }
 
+/* These set/copy helpers MUST be called by order */
+static inline void fanotify_info_set_dir_fh(struct fanotify_info *info,
+					    unsigned int totlen)
+{
+	if (WARN_ON_ONCE(info->file_fh_totlen > 0) ||
+	    WARN_ON_ONCE(info->name_len > 0))
+		return;
+
+	info->dir_fh_totlen = totlen;
+}
+
+static inline void fanotify_info_set_file_fh(struct fanotify_info *info,
+					     unsigned int totlen)
+{
+	if (WARN_ON_ONCE(info->name_len > 0))
+		return;
+
+	info->file_fh_totlen = totlen;
+}
+
 static inline void fanotify_info_copy_name(struct fanotify_info *info,
 					   const struct qstr *name)
 {
-- 
2.43.0



