Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F9C43172
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 06:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743401591; cv=none; b=K/g5o19kYr7PnXa12x0BZRV3WEOQvzaAUkpbuZRodgwm3irRiiBzMUyVQX+KNakG2SqgmUET5Lp6GH/H0ent5n5wdUOtxIToT68nUoOTF/oTJcK6l9HIZJUNe1L9firtsQW8mNAu1Aax474oLNhTbBP9mlxbqqZ2PF72vBts+k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743401591; c=relaxed/simple;
	bh=OyAQRyMNWt8hIHAyljFifoVdSI1Sa2oW3sXeMopsezI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PMfi/fUbDxwZl5sEw99OddR7/MfmtbMhVhdssXPmk/pBXke5Yy+YeLR4OgeyRdtsFoJKiFyfJk//AB+2yibuGez42Y4l3h8Ft1y8J32KkXp0Ks502xMu2vic3hRLuAELOcauImC3V7Fhf1C6nSt7H5UiyCVljM0ArGypPzgrCHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xub6UUz8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xub6UUz8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=N8VeelrSMh3qcS68gyJ8o2wn8csgXDD4Us8+jFXdVnA=; b=Xub6UUz8YpxCnlXsRJaxvhZSv8
	/kmYRP+8ouSlFVkSepCGRhRCngRToU3JaJPvbtnIl+cuRyYD8IVcAhOOHZILFpvEOH8aJKfrfMr3v
	Lx7ChSATrXPcRWDPTAxucc0F7HGSoGnmi1SWH29As3w1IPCf/7kwbTQiXj4j2W9DlKtw9TLrFrUiR
	FocPmiG025SxQ1V/Fx2wp8zAP+1nPv3eAFCPBdxG4pmaUFBKmeZetNOAU3aWatbjYS+rnmbj4kflE
	mD7LkeTb9KTJvSL5RAzf8Hpcv3vnghNjNUkrvmzT4QIyEh0i/L2VZqB/LZBVDyQrQzyYJYVMks40K
	WE0JmTqg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1tz8OS-0000000H5fL-1t5b;
	Mon, 31 Mar 2025 06:13:08 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: patches@lists.linux.dev
Cc: mcgrof@kernel.org
Subject: [PATCH] mm: add migration buffer-head debugfs interface
Date: Sun, 30 Mar 2025 23:13:06 -0700
Message-ID: <20250331061306.4073352-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This will help us debug buffer-head use of migrate_folio() callbacks.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/migrate.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 174 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f3ee6d8d5e2e..723cb3ca10eb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -44,6 +44,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
+#include <linux/debugfs.h>
 
 #include <asm/tlbflush.h>
 
@@ -791,6 +792,125 @@ int migrate_folio(struct address_space *mapping, struct folio *dst,
 EXPORT_SYMBOL(migrate_folio);
 
 #ifdef CONFIG_BUFFER_HEAD
+
+static const char * const bh_routine_names[] = {
+	"buffer_migrate_folio",
+	"buffer_migrate_folio_norefs",
+};
+
+#define BH_STATS(X)							       \
+	X(bh_migrate_folio, 0, "calls")					       \
+	X(bh_migrate_folio_success, 0, "success")			       \
+	X(bh_migrate_folio_fails, 0, "fails")				       \
+	X(bh_migrate_folio_norefs, 1, "calls")				       \
+	X(bh_migrate_folio_norefs_success, 1, "success")		       \
+	X(bh_migrate_folio_norefs_fails, 1, "fails")			       \
+	X(bh_migrate_folio_norefs_nohead_success, 1, "no-head-success")	       \
+	X(bh_migrate_folio_norefs_nohead_fails, 1, "no-head-fails")	       \
+	X(bh_migrate_folio_norefs_invalid, 1, "invalid")		       \
+	X(bh_migrate_folio_norefs_valid, 1, "valid")			       \
+	X(bh_migrate_folio_norefs_valid_success, 1, "valid-success")	       \
+	X(bh_migrate_folio_norefs_valid_fails, 1, "valid-fails")
+
+
+#define DECLARE_STAT(name, routine_idx, meaning) static atomic_long_t name;
+BH_STATS(DECLARE_STAT)
+
+#define BH_STAT_PTR(name, routine_idx, meaning) &name,
+static atomic_long_t * const bh_stat_array[] = {
+	BH_STATS(BH_STAT_PTR)
+};
+
+#define BH_STAT_ROUTINE_IDX(name, routine_idx, meaning) routine_idx,
+static const int bh_stat_routine_index[] = {
+	BH_STATS(BH_STAT_ROUTINE_IDX)
+};
+
+#define BH_STAT_MEANING(name, routine_idx, meaning) meaning,
+static const char * const bh_stat_meanings[] = {
+	BH_STATS(BH_STAT_MEANING)
+};
+
+#define NUM_BH_STATS ARRAY_SIZE(bh_stat_array)
+
+static ssize_t read_file_bh_migrate_stats(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	char *buf;
+	unsigned int i, len = 0, size = NUM_BH_STATS * 128;
+	int ret, last_routine = -1;
+	unsigned long total, success, rate;
+
+	BUILD_BUG_ON(ARRAY_SIZE(bh_stat_array) != ARRAY_SIZE(bh_stat_meanings));
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < NUM_BH_STATS; i++) {
+		int routine_idx = bh_stat_routine_index[i];
+
+		if (routine_idx != last_routine) {
+			len += scnprintf(buf + len, size - len, "\n[%s]\n",
+					 bh_routine_names[routine_idx]);
+			last_routine = routine_idx;
+		}
+
+		len += scnprintf(buf + len, size - len, "%25s\t%lu\n",
+				 bh_stat_meanings[i],
+				 atomic_long_read(bh_stat_array[i]));
+
+	}
+
+	len += scnprintf(buf + len, size - len, "\nSuccess ratios:\n");
+
+	total = atomic_long_read(&bh_migrate_folio);
+	success = atomic_long_read(&bh_migrate_folio_success);
+	rate = total ? (success * 100) / total : 0;
+	len += scnprintf(buf + len, size - len,
+		"%s: %lu%% success (%lu/%lu)\n",
+		"buffer_migrate_folio", rate, success, total);
+
+	total = atomic_long_read(&bh_migrate_folio_norefs);
+	success = atomic_long_read(&bh_migrate_folio_norefs_success);
+	rate = total ? (success * 100) / total : 0;
+	len += scnprintf(buf + len, size - len,
+		"%s: %lu%% success (%lu/%lu)\n",
+		"buffer_migrate_folio_norefs", rate, success, total);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations fops_bh_migrate_stats = {
+	.read = read_file_bh_migrate_stats,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static void mm_migrate_bh_init(struct dentry *migrate_debug_root)
+{
+	struct dentry *parent_dirs[ARRAY_SIZE(bh_routine_names)] = { NULL };
+	struct dentry *root = debugfs_create_dir("bh", migrate_debug_root);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bh_routine_names); i++)
+		parent_dirs[i] = debugfs_create_dir(bh_routine_names[i], root);
+
+	for (i = 0; i < NUM_BH_STATS; i++) {
+		int routine = bh_stat_routine_index[i];
+		debugfs_create_ulong(bh_stat_meanings[i], 0400,
+		                     parent_dirs[routine],
+		                     (unsigned long *)
+				     &bh_stat_array[i]->counter);
+	}
+
+	debugfs_create_file("stats", 0400, root, root, &fops_bh_migrate_stats);
+}
+
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 							enum migrate_mode mode)
@@ -833,8 +953,16 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 	int expected_count;
 
 	head = folio_buffers(src);
-	if (!head)
-		return migrate_folio(mapping, dst, src, mode);
+	if (!head) {
+		rc = migrate_folio(mapping, dst, src, mode);
+		if (check_refs) {
+			if (rc == 0)
+				atomic_long_inc(&bh_migrate_folio_norefs_nohead_success);
+			else
+				atomic_long_inc(&bh_migrate_folio_norefs_nohead_fails);
+		}
+		return rc;
+	}
 
 	/* Check whether page does not have extra refs before we do more work */
 	expected_count = folio_expected_refs(mapping, src);
@@ -862,6 +990,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 		if (busy) {
 			if (invalidated) {
 				rc = -EAGAIN;
+				atomic_long_inc(&bh_migrate_folio_norefs_invalid);
 				goto unlock_buffers;
 			}
 			spin_unlock(&mapping->i_private_lock);
@@ -869,11 +998,16 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 			invalidated = true;
 			goto recheck_buffers;
 		}
+		atomic_long_inc(&bh_migrate_folio_norefs_valid);
 	}
 
 	rc = filemap_migrate_folio(mapping, dst, src, mode);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc != MIGRATEPAGE_SUCCESS) {
+		if (check_refs)
+			atomic_long_inc(&bh_migrate_folio_norefs_valid_fails);
 		goto unlock_buffers;
+	} else if (check_refs)
+		atomic_long_inc(&bh_migrate_folio_norefs_valid_success);
 
 	bh = head;
 	do {
@@ -911,7 +1045,16 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 int buffer_migrate_folio(struct address_space *mapping,
 		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	return __buffer_migrate_folio(mapping, dst, src, mode, false);
+	int ret;
+	atomic_long_inc(&bh_migrate_folio);
+
+	ret = __buffer_migrate_folio(mapping, dst, src, mode, false);
+	if (ret == 0)
+		atomic_long_inc(&bh_migrate_folio_success);
+	else
+		atomic_long_inc(&bh_migrate_folio_fails);
+
+	return ret;
 }
 EXPORT_SYMBOL(buffer_migrate_folio);
 
@@ -932,9 +1075,21 @@ EXPORT_SYMBOL(buffer_migrate_folio);
 int buffer_migrate_folio_norefs(struct address_space *mapping,
 		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	return __buffer_migrate_folio(mapping, dst, src, mode, true);
+	int ret;
+
+	atomic_long_inc(&bh_migrate_folio_norefs);
+
+	ret = __buffer_migrate_folio(mapping, dst, src, mode, true);
+	if (ret == 0)
+		atomic_long_inc(&bh_migrate_folio_norefs_success);
+	else
+		atomic_long_inc(&bh_migrate_folio_norefs_fails);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(buffer_migrate_folio_norefs);
+#else
+static inline void mm_migrate_bh_init(struct dentry *migrate_debug_root) { }
 #endif /* CONFIG_BUFFER_HEAD */
 
 int filemap_migrate_folio(struct address_space *mapping,
@@ -2733,3 +2888,17 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
+
+static __init int mm_migrate_debugfs_init(void)
+{
+	struct dentry *mm_debug_root;
+	struct dentry *migrate_debug_root;
+
+	mm_debug_root = debugfs_create_dir("mm", NULL);
+	migrate_debug_root = debugfs_create_dir("migrate", mm_debug_root);
+
+	mm_migrate_bh_init(migrate_debug_root);
+
+	return 0;
+}
+fs_initcall(mm_migrate_debugfs_init);
-- 
2.47.2

