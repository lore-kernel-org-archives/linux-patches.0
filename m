Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542DD481A97;
	Wed,  9 Sep 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964472; cv=none; b=lt4M/RTFf5j2BOdEVEscj3R0ca3yRyb9UuHqx2uW5Pj7WdGIf97YDDfnV5HGUECFH1Rq2t1SBQMXDU1ZOjUGovKjodW5EUyFcGiYRhSDzapheDrj74yORWPIyp0DwbJC7jvq9MyzNzyqh89ZqW5ZY9RNl124yaNZsCP+/EwRdu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964472; c=relaxed/simple;
	bh=a8tAWa0f7T7LzGyf0yzkqaHG8EupyYc+CLPrxz4UfUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o69G6zOpYA6XORP04ACKlkskgcfuUvxIY+SDilk8h1fDB/K8mJFHn7GGq1n+xP3czVWFKZ1aPf/fGFddzH1PGLp01UNpVHjUWxiLn7fGawztq0GtFUXpGVxVCAfDRXssyAyXUKbqmxRDJ08W8onyiCNBVW1XeRgfNkDlPLYlZFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9tetiq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9tetiq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1891F00A3A;
	Wed,  9 Sep 2026 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964471;
	bh=0cjPOYDBzBoMe6PJ+bwMgcpeMzZfC5Q6MN1VpCRTO7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9tetiq7D81EyrcOYh/mKPbNh9PasI8uEN0ZYzbpYfxqPDcuuMveGhY032LMQUpT2
	 o9QTjhz5sAkoXghS9ELdNqhJtfiYQuP/jmFdO1C79hoK8Dm3tZTH6ZOrC6FA7gOaKW
	 m75fk/RxWQgA6h+qU0WzC5+s55uhwsmX6TvKYYcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 432/583] fuse: split off fuse_args and related definitions into a separate header
Date: Wed,  9 Sep 2026 15:41:57 +0200
Message-ID: <20260909134252.955472818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 229f9b9b66ab5be9e015422cf30b97740cfbdc8d ]

This is going to be used by both layers (transport and filesystem)

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: ed9c881f3b49 ("fuse: fix race between interrupt and resend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/args.h   |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h |   53 --------------------------------------------
 2 files changed, 66 insertions(+), 52 deletions(-)
 create mode 100644 fs/fuse/args.h

--- /dev/null
+++ b/fs/fuse/args.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _FS_FUSE_ARGS_H
+#define _FS_FUSE_ARGS_H
+
+#include <linux/types.h>
+
+struct fuse_mount;
+
+/** One input argument of a request */
+struct fuse_in_arg {
+	unsigned size;
+	const void *value;
+};
+
+/** One output argument of a request */
+struct fuse_arg {
+	unsigned size;
+	void *value;
+};
+
+struct fuse_args {
+	u64 nodeid;
+	u32 opcode;
+	u32 uid;
+	u32 gid;
+	u32 pid;
+	u8 in_numargs;
+	u8 out_numargs;
+	u8 ext_idx;
+	bool force:1;
+	bool noreply:1;
+	bool nocreds:1;
+	bool in_pages:1;
+	bool out_pages:1;
+	bool user_pages:1;
+	bool out_argvar:1;
+	bool page_zeroing:1;
+	bool page_replace:1;
+	bool may_block:1;
+	bool is_ext:1;
+	bool is_pinned:1;
+	bool invalidate_vmap:1;
+	bool abort_on_kill:1;
+	struct fuse_in_arg in_args[4];
+	struct fuse_arg out_args[2];
+	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
+	/* Used for kvec iter backed by vmalloc address */
+	void *vmap_base;
+};
+
+/** FUSE folio descriptor */
+struct fuse_folio_desc {
+	unsigned int length;
+	unsigned int offset;
+};
+
+struct fuse_args_pages {
+	struct fuse_args args;
+	struct folio **folios;
+	struct fuse_folio_desc *descs;
+	unsigned int num_folios;
+};
+
+#endif /* _FS_FUSE_ARGS_H */
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -13,6 +13,7 @@
 # define pr_fmt(fmt) "fuse: " fmt
 #endif
 
+#include "args.h"
 #include <linux/fuse.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -296,58 +297,6 @@ struct fuse_file {
 	bool flock:1;
 };
 
-/** One input argument of a request */
-struct fuse_in_arg {
-	unsigned size;
-	const void *value;
-};
-
-/** One output argument of a request */
-struct fuse_arg {
-	unsigned size;
-	void *value;
-};
-
-/** FUSE folio descriptor */
-struct fuse_folio_desc {
-	unsigned int length;
-	unsigned int offset;
-};
-
-struct fuse_args {
-	uint64_t nodeid;
-	uint32_t opcode;
-	uint8_t in_numargs;
-	uint8_t out_numargs;
-	uint8_t ext_idx;
-	bool force:1;
-	bool noreply:1;
-	bool nocreds:1;
-	bool in_pages:1;
-	bool out_pages:1;
-	bool user_pages:1;
-	bool out_argvar:1;
-	bool page_zeroing:1;
-	bool page_replace:1;
-	bool may_block:1;
-	bool is_ext:1;
-	bool is_pinned:1;
-	bool invalidate_vmap:1;
-	bool abort_on_kill:1;
-	struct fuse_in_arg in_args[4];
-	struct fuse_arg out_args[2];
-	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
-	/* Used for kvec iter backed by vmalloc address */
-	void *vmap_base;
-};
-
-struct fuse_args_pages {
-	struct fuse_args args;
-	struct folio **folios;
-	struct fuse_folio_desc *descs;
-	unsigned int num_folios;
-};
-
 struct fuse_release_args {
 	struct fuse_args args;
 	struct fuse_release_in inarg;


