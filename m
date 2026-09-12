Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1349519E7F7;
	Sat, 12 Sep 2026 07:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198471; cv=none; b=CqrrB0JP0M0F222C1R2y0bTo8XzwyMY9xpzsSNQMYZyxWNwm87NHrfruQVvMxmHPQI8NbV3sm2PMpJlaChHPpbzvFIdsx7gwCFbMxL9XrskJlUxakwcAeUg54Wd+6DPZR+oKaE9mjXsXEkywbrrVwrsnrOqbYUk1HIdTN0r2dvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198471; c=relaxed/simple;
	bh=WoeoXjkAw08VRZwJtbeFA4EyrljazGLqPYYytjD/X6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4NrKkM7j7xROomf1OYAkn64RPldvnS66J2OPnQRoj0+5OhmHbuHEoapA70jsPiu2eZlR0WrOt6BwILTFy6gIrSIhJ/sgLrF+xn2bg3rFAj0dWlMmXyIYGamGKYxHe6DhvA8XlieqCeJMF0QIIpiR/uWBamr+olQuSG0Hu//XMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h30QwuHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h30QwuHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185971F000FF;
	Sat, 12 Sep 2026 07:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198470;
	bh=hhHPM6u5gFgU1ycN0J1Jfle0ULpPJ2qgcFcibmUkGyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h30QwuHJNLptZzCtY6ZO/UQXy7aoMB9rAZ/fbZDvv7m2ZQZ0v3DK7yENSlPcAmq+9
	 qQWjve278HLfQqHNQM4PfdxRmqyvLOxeCOUBhNRMi6dux85fSvpivDiJCEcAQNb1bo
	 pxGCT0BL+aJgNiDpclwFIR8fey2Hni3M10vDPZdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0387/1815] hfsplus: validate thread record before delete key rebuild
Date: Sat, 12 Sep 2026 08:35:37 +0200
Message-ID: <20260912065657.978670440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 776ce36cf076b..fe11c4b6dd997 100644
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
index ec04b82ad9278..7c8667d5a49c1 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -521,6 +521,12 @@ static inline u32 hfsplus_cat_thread_size(const struct hfsplus_cat_thread *threa
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



