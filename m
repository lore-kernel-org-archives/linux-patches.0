Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2A648D880;
	Sat, 12 Sep 2026 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238716; cv=none; b=bhL7KBArrzNdKMYhZn8ugc/APQjsFnx5E4c8/G64fINDGD+oE3dN0fkFdPNzxDy82q/TFODlFJIBzz1mxcdSnYDVOcDfS2B7tgnVHkluOYphBhapsLvZ+2o5zYInWZGt7tE7MBuc/kaK4GE9zwImfwCxNlxa+H+BkE768kh4aLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238716; c=relaxed/simple;
	bh=ri9Y5A/IWz7uVsyDyZkAyLY9fXqPIDnXeCF4ODfwGt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvzSjmKGNebEzi04TBfCv+dt93Nd+YxnkV7yRtLDGJSXHAKyeoR/ffCI7HHa9vBI3BbyPUmHFPpexf6aWFTMIfKRHBbXUFhCVtPJRHwxd33jJD0M3YjNrXAb39t/mI15Vk8Ml0EVrjOwwat6Gj0i7dM+gNjdIzt9nYo10ErL1IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMpQhyuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMpQhyuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5751F000FF;
	Sat, 12 Sep 2026 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238714;
	bh=IqLBrfZ37Eri5GgUofoV+/rwXyu+1ULxd+jVcYcz0ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMpQhyuf3IgjuJVEXQ1muDIyfqL89lyyZzswfZMq4ks6WvJiUHoB6WdxxFr2vPDDM
	 OHYc7bRfllwGOqzZhir10icXJhHa2dbc7Ud5wmuJ5yn9iN+8jqVYlxJ6hoENy0XxSz
	 KL3zldJTyIovxSJBV2KOtnE1LY5+FrYmex/PDiiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/935] hfsplus: validate thread record before delete key rebuild
Date: Sat, 12 Sep 2026 08:59:08 +0200
Message-ID: <20260912065538.706988166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit e2ea5cac61acfc11dad22f1d2d4bc71d56c52a20 ]

hfsplus_delete_cat() is called with str == NULL when the last open
reference to an unlinked HFS+ hardlink backing inode is closed. In that
case, the function finds the catalog thread by CNID and rebuilds the
catalog key from thread.nodeName.

That reconstruction path reads thread.nodeName.length directly from the
catalog B-tree into fd.search_key and then copies length * 2 bytes into
fd.search_key->cat.name.unicode. It does not first check that the found
record is a thread record or that its size matches the thread name.

A corrupted image can therefore provide an oversized thread name length
and make hfs_bnode_read() write past the catalog search-key allocation.

Read the CNID record through hfsplus_brec_read_cat(), which bounds the
record read to sizeof(hfsplus_cat_entry) and verifies that a thread
record's size exactly matches nodeName.length. Together, these checks
ensure an accepted thread name fits HFSPLUS_MAX_STRLEN. Reject non-thread
records before building the delete key from the validated thread name.

Share the thread-record-type helper between hfsplus_find_cat() and
hfsplus_delete_cat().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260709010203.49664-1-kylebot@openai.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/catalog.c    | 25 ++++++++++++-------------
 fs/hfsplus/hfsplus_fs.h |  6 ++++++
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 136aa1017af2b..9a82bdf4caf24 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -204,7 +204,7 @@ int hfsplus_find_cat(struct super_block *sb, u32 cnid,
 		return err;
 
 	type = be16_to_cpu(tmp.type);
-	if (type != HFSPLUS_FOLDER_THREAD && type != HFSPLUS_FILE_THREAD) {
+	if (!is_hfs_thread_record_type(type)) {
 		pr_err("found bad thread record in catalog\n");
 		return -EIO;
 	}
@@ -350,23 +350,22 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 		goto out;
 
 	if (!str) {
-		int len;
+		hfsplus_cat_entry entry = {0};
 
 		hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
-		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
+		err = hfsplus_brec_read_cat(&fd, &entry);
 		if (err)
 			goto out;
 
-		off = fd.entryoffset +
-			offsetof(struct hfsplus_cat_thread, nodeName);
-		fd.search_key->cat.parent = cpu_to_be32(dir->i_ino);
-		hfs_bnode_read(fd.bnode,
-			&fd.search_key->cat.name.length, off, 2);
-		len = be16_to_cpu(fd.search_key->cat.name.length) * 2;
-		hfs_bnode_read(fd.bnode,
-			&fd.search_key->cat.name.unicode,
-			off + 2, len);
-		fd.search_key->key_len = cpu_to_be16(6 + len);
+		type = be16_to_cpu(entry.type);
+		if (!is_hfs_thread_record_type(type)) {
+			pr_err("found bad thread record in catalog\n");
+			err = -EIO;
+			goto out;
+		}
+
+		hfsplus_cat_build_key_uni(fd.search_key, dir->i_ino,
+					  &entry.thread.nodeName);
 	} else {
 		err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
 		if (unlikely(err))
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index ef8c087098853..1a8231dfb0353 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -540,6 +540,12 @@ static inline u32 hfsplus_cat_thread_size(const struct hfsplus_cat_thread *threa
 	       be16_to_cpu(thread->nodeName.length) * sizeof(hfsplus_unichr);
 }
 
+static inline
+bool is_hfs_thread_record_type(u16 type)
+{
+	return type == HFSPLUS_FOLDER_THREAD || type == HFSPLUS_FILE_THREAD;
+}
+
 int hfsplus_brec_read_cat(struct hfs_find_data *fd, hfsplus_cat_entry *entry);
 
 /*
-- 
2.53.0



