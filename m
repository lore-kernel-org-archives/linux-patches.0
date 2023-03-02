Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE2ED522
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wgFqT2w/eK3dzdLgYbGtjhgywFNrzKWQTAiGgoTWdic=; b=zuz/8Msfgxa1qz/+0bvXQ8D3Dp
	E3r+AMFHIPNG69xjYkIr9FvCfgMSUDnVjlJT4SOx0FFzkxlUeu+75oiSFUOzzw/QtZi8iGr0sllE4
	/BdnnxIPUFFxPl9MpfNst/iqR18werqw5FZ2dDHaUZ1Ooj9cCZLhyJPoVn+xk8AunsF3x7UMGgb9G
	XPHI5mus6/eMOr8SqayIwWTq5KMJ3EynxiojmBY+kt8Q5rXJ3xVd54ebBq7uFJgZgjWXUwxJpzKdy
	1P4naZHSWeF6x1Q9wk9JuoR8linxmXFjFNARUmAUNpYdIIdUlr3gyM+cQT1mytSJEYpjCSRuJQWJs
	x/LSF5Pw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpXS-003FxT-Kb; Thu, 02 Mar 2023 20:28:30 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	john.johansen@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	luto@amacapital.net,
	wad@chromium.org,
	dverkamp@chromium.org,
	paulmck@kernel.org,
	baihaowen@meizu.com,
	frederic@kernel.org,
	jeffxu@google.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	guoren@kernel.org
Cc: j.granados@samsung.com,
	zhangpeng362@huawei.com,
	tangmeng@uniontech.com,
	willy@infradead.org,
	nixiaoming@huawei.com,
	sujiaxun@uniontech.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 11/11] proc_sysctl: deprecate register_sysctl_paths()
Date: Thu,  2 Mar 2023 12:28:26 -0800
Message-Id: <20230302202826.776286-12-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302202826.776286-1-mcgrof@kernel.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Now that all users are removed, drop the export for register_sysctl_paths()

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/proc/proc_sysctl.c  | 30 +++++++++---------------------
 include/linux/sysctl.h | 11 -----------
 2 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 15d5e02f1ec0..ff06434f7be1 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1486,6 +1486,7 @@ static int count_subheaders(struct ctl_table *table)
 	return nr_subheaders + has_files;
 }
 
+/* Note: this can recurse and call itself when dealing with subdirectories */
 static int register_leaf_sysctl_tables(const char *path, char *pos,
 	struct ctl_table_header ***subheader, struct ctl_table_set *set,
 	struct ctl_table *table)
@@ -1571,9 +1572,10 @@ static int register_leaf_sysctl_tables(const char *path, char *pos,
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
  *
- * See __register_sysctl_table for more details.
+ * See __register_sysctl_table for more details. This routine can
+ * recurse by having register_leaf_sysctl_tables() call itself.
  */
-struct ctl_table_header *__register_sysctl_paths(
+static struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table_set *set,
 	const struct ctl_path *path, struct ctl_table *table)
 {
@@ -1613,6 +1615,7 @@ struct ctl_table_header *__register_sysctl_paths(
 		subheader = subheaders;
 		header->ctl_table_arg = ctl_table_arg;
 
+		/* this can recurse */
 		if (register_leaf_sysctl_tables(new_path, pos, &subheader,
 						set, table))
 			goto err_register_leaves;
@@ -1635,37 +1638,22 @@ struct ctl_table_header *__register_sysctl_paths(
 }
 
 /**
- * register_sysctl_paths - register a sysctl table hierarchy
- * @path: The path to the directory the sysctl table is in.
+ * register_sysctl_table - register a sysctl table hierarchy
  * @table: the top-level table structure
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. A completely 0 filled entry terminates the table.
  *
  * See __register_sysctl_paths for more details.
- */
-struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
-						struct ctl_table *table)
-{
-	return __register_sysctl_paths(&sysctl_table_root.default_set,
-					path, table);
-}
-EXPORT_SYMBOL(register_sysctl_paths);
-
-/**
- * register_sysctl_table - register a sysctl table hierarchy
- * @table: the top-level table structure
- *
- * Register a sysctl table hierarchy. @table should be a filled in ctl_table
- * array. A completely 0 filled entry terminates the table.
  *
- * See register_sysctl_paths for more details.
+ * This is a deprecated compatibility wrapper. You should avoid adding new
+ * users of this into the kernel.
  */
 struct ctl_table_header *register_sysctl_table(struct ctl_table *table)
 {
 	static const struct ctl_path null_path[] = { {} };
 
-	return register_sysctl_paths(null_path, table);
+	return __register_sysctl_paths(&sysctl_table_root.default_set, null_path, table);
 }
 EXPORT_SYMBOL(register_sysctl_table);
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 780690dc08cd..e8459fc56b50 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -221,13 +221,8 @@ extern void retire_sysctl_set(struct ctl_table_set *set);
 struct ctl_table_header *__register_sysctl_table(
 	struct ctl_table_set *set,
 	const char *path, struct ctl_table *table);
-struct ctl_table_header *__register_sysctl_paths(
-	struct ctl_table_set *set,
-	const struct ctl_path *path, struct ctl_table *table);
 struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *table);
 struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
-struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
-						struct ctl_table *table);
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 
@@ -277,12 +272,6 @@ static inline struct ctl_table_header *register_sysctl_mount_point(const char *p
 	return NULL;
 }
 
-static inline struct ctl_table_header *register_sysctl_paths(
-			const struct ctl_path *path, struct ctl_table *table)
-{
-	return NULL;
-}
-
 static inline struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *table)
 {
 	return NULL;
-- 
2.39.1

