Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3A334E77A;
	Wed,  3 Dec 2025 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777875; cv=none; b=ph7MydrfvH0KhRYpBnIXyiC+gasM01OVN8UVf0OV9iQm45syOJhnlbnmnu2lXTpMlj/781dhqukEN/D+rs4i9JL129vN9ZQl/H7j37FapLIPOMdwr64+vkeSwdUKW3O+ilEdGHJr7gIVPo6NxZxvXFyW6h253tIBHBNTz3z8tCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777875; c=relaxed/simple;
	bh=uso5o8mmcQX5im/eCjkO38gvvaPBqtZQXmBf68Jd/dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/BWBA3W9gHkOp8PFgBiULxNLnjRzlkYlUyI1VJfEeG7/WdC28CMAHc5rKqwTKTUJNlUKIl+txZaNQh2UeoPZoyztoyNBhmGkN5XJTy4I0e4uJiVUIWVRJQUTqvLfqbHVDnjvgiQT/9YXGXhdUGr2zJldsO/nvZ0mTKyBgd7JRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xvzJp7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xvzJp7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D418C4CEF5;
	Wed,  3 Dec 2025 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777875;
	bh=uso5o8mmcQX5im/eCjkO38gvvaPBqtZQXmBf68Jd/dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xvzJp7dr+C0he56jRBz8sUohgIbCc+XEUN0Iu8DCFQrWvEgtJCuNS53MuXMMMXwi
	 uXdVH0SGlVqHF92hZIA0OV/0FuEIOrUvsitpbs7KtV206XgeOb9P6kNOHY14XDgJ7h
	 9NMBND9ldm4ziG4GR9VUqShJi/tYGT7ECThjTY44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/392] iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()
Date: Wed,  3 Dec 2025 16:25:17 +0100
Message-ID: <20251203152420.224052245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Seyediman Seyedarab <ImanDevel@gmail.com>

[ Upstream commit 75c02a037609f34db17e91be195cedb33b61bae0 ]

snprintf() returns the number of bytes that would have been written, not
the number actually written. Using this for offset tracking can cause
buffer overruns if truncation occurs.

Replace snprintf() with scnprintf() to ensure the offset stays within
bounds.

Since scnprintf() never returns a negative value, and zero is not possible
in this context because 'bytes' starts at 0 and 'size - bytes' is
DEBUG_BUFFER_SIZE in the first call, which is large enough to hold the
string literals used, the return value is always positive. An integer
overflow is also completely out of reach here due to the small and fixed
buffer size. The error check in latency_show_one() is therefore
unnecessary. Remove it and make dmar_latency_snapshot() return void.

Signed-off-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Link: https://lore.kernel.org/r/20250731225048.131364-1-ImanDevel@gmail.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/debugfs.c | 10 ++--------
 drivers/iommu/intel/perf.c    | 10 ++++------
 drivers/iommu/intel/perf.h    |  5 ++---
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel/debugfs.c b/drivers/iommu/intel/debugfs.c
index 62e23ff3c987e..06c3376d8feb9 100644
--- a/drivers/iommu/intel/debugfs.c
+++ b/drivers/iommu/intel/debugfs.c
@@ -545,17 +545,11 @@ DEFINE_SHOW_ATTRIBUTE(ir_translation_struct);
 static void latency_show_one(struct seq_file *m, struct intel_iommu *iommu,
 			     struct dmar_drhd_unit *drhd)
 {
-	int ret;
-
 	seq_printf(m, "IOMMU: %s Register Base Address: %llx\n",
 		   iommu->name, drhd->reg_base_addr);
 
-	ret = dmar_latency_snapshot(iommu, debug_buf, DEBUG_BUFFER_SIZE);
-	if (ret < 0)
-		seq_puts(m, "Failed to get latency snapshot");
-	else
-		seq_puts(m, debug_buf);
-	seq_puts(m, "\n");
+	dmar_latency_snapshot(iommu, debug_buf, DEBUG_BUFFER_SIZE);
+	seq_printf(m, "%s\n", debug_buf);
 }
 
 static int latency_show(struct seq_file *m, void *v)
diff --git a/drivers/iommu/intel/perf.c b/drivers/iommu/intel/perf.c
index 0e8e03252d921..700eeb07bda0a 100644
--- a/drivers/iommu/intel/perf.c
+++ b/drivers/iommu/intel/perf.c
@@ -113,7 +113,7 @@ static char *latency_type_names[] = {
 	"     svm_prq"
 };
 
-int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
+void dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 {
 	struct latency_statistic *lstat = iommu->perf_statistic;
 	unsigned long flags;
@@ -122,7 +122,7 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 	memset(str, 0, size);
 
 	for (i = 0; i < COUNTS_NUM; i++)
-		bytes += snprintf(str + bytes, size - bytes,
+		bytes += scnprintf(str + bytes, size - bytes,
 				  "%s", latency_counter_names[i]);
 
 	spin_lock_irqsave(&latency_lock, flags);
@@ -130,7 +130,7 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 		if (!dmar_latency_enabled(iommu, i))
 			continue;
 
-		bytes += snprintf(str + bytes, size - bytes,
+		bytes += scnprintf(str + bytes, size - bytes,
 				  "\n%s", latency_type_names[i]);
 
 		for (j = 0; j < COUNTS_NUM; j++) {
@@ -156,11 +156,9 @@ int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 				break;
 			}
 
-			bytes += snprintf(str + bytes, size - bytes,
+			bytes += scnprintf(str + bytes, size - bytes,
 					  "%12lld", val);
 		}
 	}
 	spin_unlock_irqrestore(&latency_lock, flags);
-
-	return bytes;
 }
diff --git a/drivers/iommu/intel/perf.h b/drivers/iommu/intel/perf.h
index fd6db8049d1a7..1e481e9e4ad04 100644
--- a/drivers/iommu/intel/perf.h
+++ b/drivers/iommu/intel/perf.h
@@ -41,7 +41,7 @@ void dmar_latency_disable(struct intel_iommu *iommu, enum latency_type type);
 bool dmar_latency_enabled(struct intel_iommu *iommu, enum latency_type type);
 void dmar_latency_update(struct intel_iommu *iommu, enum latency_type type,
 			 u64 latency);
-int dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size);
+void dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size);
 #else
 static inline int
 dmar_latency_enable(struct intel_iommu *iommu, enum latency_type type)
@@ -65,9 +65,8 @@ dmar_latency_update(struct intel_iommu *iommu, enum latency_type type, u64 laten
 {
 }
 
-static inline int
+static inline void
 dmar_latency_snapshot(struct intel_iommu *iommu, char *str, size_t size)
 {
-	return 0;
 }
 #endif /* CONFIG_DMAR_PERF */
-- 
2.51.0



