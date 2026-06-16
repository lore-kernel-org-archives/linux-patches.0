Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D167E43CEC7;
	Tue, 16 Jun 2026 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634545; cv=none; b=Wildgjmi8VIBmzDxls8ZnvblqnuOetLf6/5yMUktzE1iCQaTjMSyZNK910oNJasJGpuDZGkgAp/t2mbUcKLv/vX+93SdX/lwvFxzJJXMh32asBUzf2yW61q94jvpIB4UssRfPhLSoVwPpyiN7r/EDFs5YXQcYkOYPMkIUdsJ7zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634545; c=relaxed/simple;
	bh=sDzYeqI6wGXxfmac8HkJ941LTLWBUP+1a2ZNGKi9UUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgdP/H3gkMMjYtkqTExm7OvrmeiB+2eravUTERsa5BpCLvjnByo8o9ZoiIZp7rvwGFOXE1owsimreuiYaKaYoFwCqCnti3gQQhIrJGYjQMPeXaInXoyJ7jHyH3WVnblMjz9PAfJVN0Ox4ouumuGiQ5J/6+ziHvUvAlxoe/bHMrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/WpLSQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/WpLSQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A661C1F000E9;
	Tue, 16 Jun 2026 18:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634543;
	bh=vzVBhQbdHIPJWkwwg5DM/chiteG8MWi/Gczm69PD7RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/WpLSQ+4slWAyZjy8OqCufiSoA27OhgDEsG8e4TrOVQPWUnNMxJ3klmz4yR2/qa2
	 NpzjuiNFGGCi3eFR+KZa9f7wnes8lkjwgk90s7pF3O5IQ47PDeheZD4PEw3kkpIYR9
	 V//ABNe/FkP/Ic51HIoD4fpYNLXNUIZeeLLBOz3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d80abb5b890d39261e72@syzkaller.appspotmail.com,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/411] hfsplus: fix uninit-value by validating catalog record size
Date: Tue, 16 Jun 2026 20:28:43 +0530
Message-ID: <20260616145116.308476551@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit b6b592275aeff184aa82fcf6abccd833fb71b393 ]

Syzbot reported a KMSAN uninit-value issue in hfsplus_strcasecmp(). The
root cause is that hfs_brec_read() doesn't validate that the on-disk
record size matches the expected size for the record type being read.

When mounting a corrupted filesystem, hfs_brec_read() may read less data
than expected. For example, when reading a catalog thread record, the
debug output showed:

  HFSPLUS_BREC_READ: rec_len=520, fd->entrylength=26
  HFSPLUS_BREC_READ: WARNING - entrylength (26) < rec_len (520) - PARTIAL READ!

hfs_brec_read() only validates that entrylength is not greater than the
buffer size, but doesn't check if it's less than expected. It successfully
reads 26 bytes into a 520-byte structure and returns success, leaving 494
bytes uninitialized.

This uninitialized data in tmp.thread.nodeName then gets copied by
hfsplus_cat_build_key_uni() and used by hfsplus_strcasecmp(), triggering
the KMSAN warning when the uninitialized bytes are used as array indices
in case_fold().

Fix by introducing hfsplus_brec_read_cat() wrapper that:
1. Calls hfs_brec_read() to read the data
2. Validates the record size based on the type field:
   - Fixed size for folder and file records
   - Variable size for thread records (depends on string length)
3. Returns -EIO if size doesn't match expected

For thread records, check against HFSPLUS_MIN_THREAD_SZ before reading
nodeName.length to avoid reading uninitialized data at call sites that
don't zero-initialize the entry structure.

Also initialize the tmp variable in hfsplus_find_cat() as defensive
programming to ensure no uninitialized data even if validation is
bypassed.

Reported-by: syzbot+d80abb5b890d39261e72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d80abb5b890d39261e72
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: syzbot+d80abb5b890d39261e72@syzkaller.appspotmail.com
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Suggested-by: Charalampos Mitrodimas <charmitro@posteo.net>
Link: https://lore.kernel.org/all/20260120051114.1281285-1-kartikey406@gmail.com/ [v1]
Link: https://lore.kernel.org/all/20260121063109.1830263-1-kartikey406@gmail.com/ [v2]
Link: https://lore.kernel.org/all/20260212014233.2422046-1-kartikey406@gmail.com/ [v3]
Link: https://lore.kernel.org/all/20260214002100.436125-1-kartikey406@gmail.com/T/ [v4]
Link: https://lore.kernel.org/all/20260221061626.15853-1-kartikey406@gmail.com/T/ [v5]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260307010302.41547-1-kartikey406@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Stable-dep-of: 90c500e4fd83 ("hfsplus: fix held lock freed on hfsplus_fill_super()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/bfind.c      |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/catalog.c    |    4 +--
 fs/hfsplus/dir.c        |    2 -
 fs/hfsplus/hfsplus_fs.h |    9 ++++++++
 fs/hfsplus/super.c      |    2 -
 5 files changed, 64 insertions(+), 4 deletions(-)

--- a/fs/hfsplus/bfind.c
+++ b/fs/hfsplus/bfind.c
@@ -287,3 +287,54 @@ out:
 	fd->bnode = bnode;
 	return res;
 }
+
+/**
+ * hfsplus_brec_read_cat - read and validate a catalog record
+ * @fd: find data structure
+ * @entry: pointer to catalog entry to read into
+ *
+ * Reads a catalog record and validates its size matches the expected
+ * size based on the record type.
+ *
+ * Returns 0 on success, or negative error code on failure.
+ */
+int hfsplus_brec_read_cat(struct hfs_find_data *fd, hfsplus_cat_entry *entry)
+{
+	int res;
+	u32 expected_size;
+
+	res = hfs_brec_read(fd, entry, sizeof(hfsplus_cat_entry));
+	if (res)
+		return res;
+
+	/* Validate catalog record size based on type */
+	switch (be16_to_cpu(entry->type)) {
+	case HFSPLUS_FOLDER:
+		expected_size = sizeof(struct hfsplus_cat_folder);
+		break;
+	case HFSPLUS_FILE:
+		expected_size = sizeof(struct hfsplus_cat_file);
+		break;
+	case HFSPLUS_FOLDER_THREAD:
+	case HFSPLUS_FILE_THREAD:
+		/* Ensure we have at least the fixed fields before reading nodeName.length */
+		if (fd->entrylength < HFSPLUS_MIN_THREAD_SZ) {
+			pr_err("thread record too short (got %u)\n", fd->entrylength);
+			return -EIO;
+		}
+		expected_size = hfsplus_cat_thread_size(&entry->thread);
+		break;
+	default:
+		pr_err("unknown catalog record type %d\n",
+		       be16_to_cpu(entry->type));
+		return -EIO;
+	}
+
+	if (fd->entrylength != expected_size) {
+		pr_err("catalog record size mismatch (type %d, got %u, expected %u)\n",
+		       be16_to_cpu(entry->type), fd->entrylength, expected_size);
+		return -EIO;
+	}
+
+	return 0;
+}
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -194,12 +194,12 @@ static int hfsplus_fill_cat_thread(struc
 int hfsplus_find_cat(struct super_block *sb, u32 cnid,
 		     struct hfs_find_data *fd)
 {
-	hfsplus_cat_entry tmp;
+	hfsplus_cat_entry tmp = {0};
 	int err;
 	u16 type;
 
 	hfsplus_cat_build_key_with_cnid(sb, fd->search_key, cnid);
-	err = hfs_brec_read(fd, &tmp, sizeof(hfsplus_cat_entry));
+	err = hfsplus_brec_read_cat(fd, &tmp);
 	if (err)
 		return err;
 
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -49,7 +49,7 @@ static struct dentry *hfsplus_lookup(str
 	if (unlikely(err < 0))
 		goto fail;
 again:
-	err = hfs_brec_read(&fd, &entry, sizeof(entry));
+	err = hfsplus_brec_read_cat(&fd, &entry);
 	if (err) {
 		if (err == -ENOENT) {
 			hfs_find_exit(&fd);
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -533,6 +533,15 @@ int hfsplus_submit_bio(struct super_bloc
 		       void **data, int op, int op_flags);
 int hfsplus_read_wrapper(struct super_block *sb);
 
+static inline u32 hfsplus_cat_thread_size(const struct hfsplus_cat_thread *thread)
+{
+	return offsetof(struct hfsplus_cat_thread, nodeName) +
+	       offsetof(struct hfsplus_unistr, unicode) +
+	       be16_to_cpu(thread->nodeName.length) * sizeof(hfsplus_unichr);
+}
+
+int hfsplus_brec_read_cat(struct hfs_find_data *fd, hfsplus_cat_entry *entry);
+
 /*
  * time helpers: convert between 1904-base and 1970-base timestamps
  *
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -541,7 +541,7 @@ static int hfsplus_fill_super(struct sup
 	err = hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
 	if (unlikely(err < 0))
 		goto out_put_root;
-	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
+	if (!hfsplus_brec_read_cat(&fd, &entry)) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {
 			err = -EIO;


