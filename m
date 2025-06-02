Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D1222576;
	Mon,  2 Jun 2025 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873823; cv=none; b=k75YAosCCjIhUFf52TrUn0Z8f2xi8uB8H/QMC+OreL9k+1HJDQYKyMlV19WSzHmRYBP+hr3/iBXsDxAMHvBXF3hioHp/oKZAZbkKsJuff4948OrIAN4z/FoHIhJvJN+7fYoirRqt3GsSjeSpcbivBbtIPKZLoirPRl3B/RcQjao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873823; c=relaxed/simple;
	bh=dhTu+hRuxhzcuTx1TVADUqOS5+zGYvYfkZTbUTubTk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNLd5CZEeXYWcdcCkNWRhkKQY3Pd6xITwws/Xa5b65sixQG3Lq9GAj3LC0tGkJv+TWO5YIvRcaCkGa3x01yP2Zbx1wwd069QtY7jACytBkH9g9V/xI6mN7MBSGoC/jV8pME4POejQ3ls4y+vXishi1MBxNe1YXk/KJUFqcF+vCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0wK0nA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0wK0nA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C601C4CEEB;
	Mon,  2 Jun 2025 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873823;
	bh=dhTu+hRuxhzcuTx1TVADUqOS5+zGYvYfkZTbUTubTk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0wK0nA/HnmBF9bwRnGXP96TwyGKCJgHD/94pqPp3/5zTrF8Xr6YpU+fwgFiBfE3a
	 J1H1Yoke/N48UvyPkhO+HUCwRs3r0vG8ri5nZXQEji/Q223d1LWMt29Kb+xZS6GWdO
	 k3DGib8LYSRg9FBsxu+CgA305CVHr0iE59m4Pus8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/444] pstore: Change kmsg_bytes storage size to u32
Date: Mon,  2 Jun 2025 15:45:28 +0200
Message-ID: <20250602134351.647237448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7dbbf3b6d98d3..a1c97cd2720a6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -264,7 +264,7 @@ static void parse_options(char *options)
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
index 03425928d2fb3..ef62389212b60 100644
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
 			enum kmsg_dump_reason reason)
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



