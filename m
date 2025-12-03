Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C2034FF4E;
	Wed,  3 Dec 2025 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779393; cv=none; b=Hx8zgfCNJzhw9Yo9xX3vTkZxnd5xGKEppUB/RY0ckiYiXg7v4IyAbGlecmKLFQ7Vf1WpBhrX0lCQInderTUKdwTWT8kkMqqXrOlX2RAFOMljNrbqYXGeJH5VwMIG8SxrArXGEMB4yut47n+ygOCyZq1blhIv9C95vXmJ+1X4FKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779393; c=relaxed/simple;
	bh=bKJXMxwEDg5qqQGdE63tvq7/8LbRFZ0Wf/eQN+PivRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB5okXV5QQmypphTw0h1ZAYUWl7Xcd8fCdWRnRJOsI6XZQyPrlYnz3kzwjw8XyBWqlCLU8aF4VtXRllg/9nHqZM/xYBNBoEx5/EiQIurloppgnewMl8asqae36bbEZY+uXYHRzQBUD3gh8sProwMGx3VANSOtj2GyilvnG3bl0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1yM3ZwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1yM3ZwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9342FC16AAE;
	Wed,  3 Dec 2025 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779393;
	bh=bKJXMxwEDg5qqQGdE63tvq7/8LbRFZ0Wf/eQN+PivRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1yM3ZwNcwMLp7hEs24C8dz5jCZ6bbB958brJnObvbMBRSKR+iI0aRiIiNA0nhn1I
	 f44R/u4O/sg7oyRz+x+rxjW+wzfGuRBvsc4a4xqYCwuh8SQwgeUF91bJY8dv7LIhu3
	 MRSLc6FDmvPJS8GGfeQFHfRF5WDZuXRyY1/hknSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/568] iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()
Date: Wed,  3 Dec 2025 16:24:05 +0100
Message-ID: <20251203152449.619206162@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f925285104ee..aa9cfcb6039e2 100644
--- a/drivers/iommu/intel/debugfs.c
+++ b/drivers/iommu/intel/debugfs.c
@@ -562,17 +562,11 @@ DEFINE_SHOW_ATTRIBUTE(ir_translation_struct);
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
index 94ee70ac38e30..ae64e1123f257 100644
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



