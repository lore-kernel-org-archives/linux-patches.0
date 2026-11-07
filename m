Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062217;
	b=HUg2o+PnsxdjzkmwQqu3+HqSl6qHgml8fqIMzmnzZtpDfuWBQZuGFt4de+B2+Gdu+/of
	 /H4w/AJnX3aWYBp/uB837++57GCW2z7/MnIRa3ULuiR0HPysC4X+3P/AX/+E3MirwYvsg
	 IJqxu874ajHR/5vz1v7EH2fufxrXz6f5xXV7k5kQilEDu05Whsj6DiP5wd8WCrDqMKv57
	 tzN8mgpfXFcT/1PdmNvos+Q3YRddUj4LhBUWie1nSPLD6nQWIBLbJvjKLC0EG9Qv0bVnj
	 KspbFIC6QYbKKA9pLpy2IZyNoEwremJiYqMn0aV7ojATIfeNYkJZVHjfsf9j5gulO0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zv0GZf4Ad/iZ8qi6c/Ru8/qpaSf7/YU97G0HROIAHMk=;
	b=nl6tT9cecVcZ4NGzvD+c3X/mpA63fKjAk61MKkqqOWBEFIyqXo1wht0UzQcdNpJxLncF
	 GBSEGbRS9cT9nVxR6wKmVeA1IP4+YtmJqn3ku6uDX6oJx4GjCsV/2/aOxKcfTBqIgNojC
	 a1C8tAZcWnPGYhWN9lXXUO44Rqnlr59M2atd1CbAHc+kfdLpy3bDp9aGpcobhLgWY9uNV
	 zx3KqiH0uuZmrzatlrMO+s54FOPLqkcKvfdR8UIw3XB6k20ivmuAjlysPOUYtb21tYlTJ
	 FLZ5pPTvtm6ZfXFkntvp/MiS1qUo8rGIiQ4Xhryw1DUcmZwHwHuU+jH0MzgENtyztkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8IKDvQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E4B608361C;
	Sat,  7 Nov 2026 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8IKDvQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99151F008A1;
	Sat,  7 Nov 2026 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062217;
	bh=zv0GZf4Ad/iZ8qi6c/Ru8/qpaSf7/YU97G0HROIAHMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8IKDvQWZ9sTpKOc5RQOF937toTRcitzcvE+s3Cuqf3Trj3CKv8oZPLOh8OhUiXT5
	 E0Om7f0vArwlFhvj5fGQRX3h3hoVWF2w8BEh/mO3taNy1CWw9/hqMZai7y7IDwQ6nC
	 7g19YtDufb4NpUlWOy7IEFubbq2AAuqY7FD4h25o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Liang <mliang@purestorage.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Akinbou Mita <akinobu.mita@gmail.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1171/1536] fault-inject: fix dentry leak
Date: Sat,  7 Nov 2026 08:53:07 -0500
Message-ID: <20261107135030.626327583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Liang <mliang@purestorage.com>

[ Upstream commit ceb43516a9aae0d969a4ec5ab40d45bd09e64229 ]

fault_create_debugfs_attr() has always taken an extra dentry reference on
the created directory (attr->dname = dget(dir)) so that fail_dump() could
print the name via %pd from any context.  Nothing anywhere in the tree
ever calls dput() on attr->dname.

For callers with a matching teardown, that unmatched reference causes one
dentry plus its attached inode to leak per fault_create_debugfs_attr /
debugfs_remove_recursive cycle.  simple_recursive_removal() drops
debugfs's own +1 ref on the child dentry, but the dget()'d ref keeps its
refcount at 1: the dentry ends up unhashed but pinned, and its inode is
never freed.

Boot-once callers (mm/failslab, block/blk-core, etc.) leak exactly once at
init and never destroy the tree, so the impact there is bounded.  But
per-lifecycle callers (drivers/nvme, drivers/infiniband/hw/hfi1,
drivers/mmc, drivers/iommu/iommufd, drivers/media, drivers/misc,
drivers/gpu/drm/msm, drivers/crypto, net/sunrpc) leak on every
create/destroy cycle.

We observed this in production: an NVMe/RDMA host repeatedly reconnecting
to a target that rejected the CRTO Property Get went through ~50 nvme
controller create/destroy cycles per second, and dentry and inode_cache
grew by ~13k pinned objects per 240 s -- unrecoverable through
drop_caches.  Byte math matched a per-cycle 1-dentry / 1-inode leak from
the "fault_inject" directory dentry.

Fix this by not holding any external reference in fault_attr.  Embed the
directory name as a fixed-size char array (FAULT_ATTR_DNAME_LEN, 64 bytes)
inside struct fault_attr, copied by strscpy() at
fault_create_debugfs_attr() time.  fail_dump() prints it via %s.

Advantages of an embedded array over kstrdup() + kfree() paired with a new
destroy API:

  - Zero API footprint.  No new export and no caller changes required:
    callers already own their fault_attr's memory and free it when
    they are done, and now that suffices.
  - No allocation on the create path.
  - fault_create_debugfs_attr() cannot fail from the name-copy step.
  - No lifetime coupling between attr->dname and debugfs; the string
    is valid for exactly as long as the containing struct.

The 64-byte length accommodates every in-tree caller with generous
headroom (the longest current name is "fail_dma_array_full", 19 chars).

The user-visible fail_dump() format changes from "name %pd" to "name %s",
but the printed content is identical -- %pd on the created directory
renders the same string that was passed in as @name.

drivers/infiniband/hw/hfi1/fault.c drops a now-invalid "attr.dname = NULL"
statement; the surrounding kzalloc() already zero-initialises the array.

Link: https://lore.kernel.org/20260821181527.3271414-1-mliang@purestorage.com
Fixes: 6adc4a22f20b ("fault-inject: add ratelimit option")
Signed-off-by: Michael Liang <mliang@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/fault.c |  1 -
 include/linux/fault-inject.h       | 10 ++++++++--
 lib/fault-inject.c                 |  7 +++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index ec9ee59fcf0cc..a729029bc1dd1 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -225,7 +225,6 @@ int hfi1_fault_init_debugfs(struct hfi1_ibdev *ibd)
 	ibd->fault->attr.interval = 1;
 	ibd->fault->attr.require_end = ULONG_MAX;
 	ibd->fault->attr.stacktrace_depth = 32;
-	ibd->fault->attr.dname = NULL;
 	ibd->fault->attr.verbose = 0;
 	ibd->fault->enable = false;
 	ibd->fault->opcode = false;
diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 8c829d28dcf35..f55b51f333467 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -14,6 +14,13 @@ struct kmem_cache;
 #include <linux/configfs.h>
 #include <linux/ratelimit.h>
 
+/*
+ * Length of the debugfs directory name embedded in struct fault_attr.
+ * Chosen to accommodate every in-tree caller of fault_create_debugfs_attr()
+ * (the longest is "fail_dma_array_full", 19 chars) with generous headroom.
+ */
+#define FAULT_ATTR_DNAME_LEN	64
+
 /*
  * For explanation of the elements of this struct, see
  * Documentation/fault-injection/fault-injection.rst
@@ -33,7 +40,7 @@ struct fault_attr {
 
 	unsigned long count;
 	struct ratelimit_state ratelimit_state;
-	struct dentry *dname;
+	char dname[FAULT_ATTR_DNAME_LEN];
 };
 
 enum fault_flags {
@@ -47,7 +54,6 @@ enum fault_flags {
 		.stacktrace_depth = 32,					\
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
-		.dname = NULL,						\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 52eb6ba296984..6fcd255e11b94 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -5,6 +5,7 @@
 #include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/export.h>
@@ -44,7 +45,7 @@ static void fail_dump(struct fault_attr *attr)
 {
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
-		       "name %pd, interval %lu, probability %lu, "
+		       "name %s, interval %lu, probability %lu, "
 		       "space %d, times %d\n", attr->dname,
 		       attr->interval, attr->probability,
 		       atomic_read(&attr->space),
@@ -239,7 +240,9 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 	debugfs_create_xul("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-	attr->dname = dget(dir);
+	if (strscpy(attr->dname, name, sizeof(attr->dname)) == -E2BIG)
+		pr_warn("FAULT_INJECTION: name '%s' truncated to '%s'\n",
+			name, attr->dname);
 	return dir;
 }
 EXPORT_SYMBOL_GPL(fault_create_debugfs_attr);
-- 
2.53.0



