Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFB528003A;
	Tue, 27 May 2025 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367902; cv=none; b=A+ZLavjb6lotaItXn4JUU6UqbY9WK7PSy4Ov1XRRdSIUgw3aHhbe62t33zP93icDZtrKlmqVGpOiuC8k6oN1n4EM/3SZX4v1DNs+WMjBpwAWoIZcUGiJBMKiHCowNr2SlEfDHRXs/EWo9plpOulAYJ4FGfBBZjq7Ral9TagbYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367902; c=relaxed/simple;
	bh=8mi5zBKV4AY+mxWoVDyw6b2fxG8e2rwP2wGK5ltEh6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSi/bdyOSHPcyaP9IFPnrY+UObva5GBY8K+hjNSemSHgKyxZt92MtVc0e9PG5QCJbBYy0yI+rZ+JKR/5BenMNLu1BdAvy+tfATdxlP+CbnpfNnMjwRxoJrXnsPwRkdc0kv06WaGG102CWChFB0ZEqHL6Y9sQQ7rEaJOQgqATroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIgkaq0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIgkaq0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E106C4CEE9;
	Tue, 27 May 2025 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367902;
	bh=8mi5zBKV4AY+mxWoVDyw6b2fxG8e2rwP2wGK5ltEh6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIgkaq0cTwBVgasFrD+vsNuFHReQHGrixSUZdihZCiYVZhsR9cHk6SYfUI3Wckr4B
	 NPCDjCM9TStdUWx5TlWi4fFB9RP4JWQ5HlGPdsfQ4RCXNwwucNQtEXUe49mr/bzwTG
	 O5DJ/lMgnHk7NQwDfjgAIuv1iMJKuaA1rcq9v18o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 535/783] pstore: Change kmsg_bytes storage size to u32
Date: Tue, 27 May 2025 18:25:32 +0200
Message-ID: <20250527162534.936843516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 5674609535bafa834ab014d90d9bbe8e89223a0b ]

The types around kmsg_bytes were inconsistent. The global was unsigned
long, the argument to pstore_set_kmsg_bytes() was int, and the filesystem
option was u32. Given other internal limits, there's not much sense
in making a single pstore record larger than INT_MAX and it can't be
negative, so use u32 everywhere. Additionally, use READ/WRITE_ONCE and a
local variable in pstore_dump() to avoid kmsg_bytes changing during a
dump.

Link: https://lore.kernel.org/r/20250206191655.work.798-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/inode.c    |  2 +-
 fs/pstore/internal.h |  4 ++--
 fs/pstore/platform.c | 11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 56815799ce798..9de6b280c4f41 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -265,7 +265,7 @@ static void parse_options(char *options)
 static int pstore_show_options(struct seq_file *m, struct dentry *root)
 {
 	if (kmsg_bytes != CONFIG_PSTORE_DEFAULT_KMSG_BYTES)
-		seq_printf(m, ",kmsg_bytes=%lu", kmsg_bytes);
+		seq_printf(m, ",kmsg_bytes=%u", kmsg_bytes);
 	return 0;
 }
 
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 801d6c0b170c3..a0fc511969100 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -6,7 +6,7 @@
 #include <linux/time.h>
 #include <linux/pstore.h>
 
-extern unsigned long kmsg_bytes;
+extern unsigned int kmsg_bytes;
 
 #ifdef CONFIG_PSTORE_FTRACE
 extern void pstore_register_ftrace(void);
@@ -35,7 +35,7 @@ static inline void pstore_unregister_pmsg(void) {}
 
 extern struct pstore_info *psinfo;
 
-extern void	pstore_set_kmsg_bytes(int);
+extern void	pstore_set_kmsg_bytes(unsigned int bytes);
 extern void	pstore_get_records(int);
 extern void	pstore_get_backend_records(struct pstore_info *psi,
 					   struct dentry *root, int quiet);
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f56b066ab80ce..557cf9d40177f 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -92,8 +92,8 @@ module_param(compress, charp, 0444);
 MODULE_PARM_DESC(compress, "compression to use");
 
 /* How much of the kernel log to snapshot */
-unsigned long kmsg_bytes = CONFIG_PSTORE_DEFAULT_KMSG_BYTES;
-module_param(kmsg_bytes, ulong, 0444);
+unsigned int kmsg_bytes = CONFIG_PSTORE_DEFAULT_KMSG_BYTES;
+module_param(kmsg_bytes, uint, 0444);
 MODULE_PARM_DESC(kmsg_bytes, "amount of kernel log to snapshot (in bytes)");
 
 static void *compress_workspace;
@@ -107,9 +107,9 @@ static void *compress_workspace;
 static char *big_oops_buf;
 static size_t max_compressed_size;
 
-void pstore_set_kmsg_bytes(int bytes)
+void pstore_set_kmsg_bytes(unsigned int bytes)
 {
-	kmsg_bytes = bytes;
+	WRITE_ONCE(kmsg_bytes, bytes);
 }
 
 /* Tag each group of saved records with a sequence number */
@@ -278,6 +278,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			struct kmsg_dump_detail *detail)
 {
 	struct kmsg_dump_iter iter;
+	unsigned int	remaining = READ_ONCE(kmsg_bytes);
 	unsigned long	total = 0;
 	const char	*why;
 	unsigned int	part = 1;
@@ -300,7 +301,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	kmsg_dump_rewind(&iter);
 
 	oopscount++;
-	while (total < kmsg_bytes) {
+	while (total < remaining) {
 		char *dst;
 		size_t dst_size;
 		int header_size;
-- 
2.39.5



