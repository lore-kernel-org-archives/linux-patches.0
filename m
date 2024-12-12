Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D68748A;
	Thu, 12 Dec 2024 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017279; cv=none; b=bxSVNliv1omMeTxl6gI06RGoibq5kZRHC6dp6IMrOyBZ/vHFVPRCIMFl9vRN1i20OrEpqEh29UFHWUZxlza/+Mncv6UR3BDKlHGZo/ndYpeU89xS3A24K3ORW8T4I2UAzpomYgNdRLaz3PG1wjvIf2iiriRyjuQxAKdH63wdffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017279; c=relaxed/simple;
	bh=/kdOtRmtiqu2b0aNUb4VSVBk/eXjbyfADCUbkcKFhoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvBuEpQ92Empcia3JQgczVq8WfJLDnj23XJ5wXHnBVdly6jjh0uvtW2bAh/3HgeEcUxEfXcGcsECi+WtIAyUc+7je5EgBTzHZrj7kmckMxtOJn6+CxBkyjy2rjIJsoaU/12DGcfZB8sMyXaMm6u3C6+oZYgo3Wtnu/TE8RCKawU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTjlNfP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTjlNfP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D3FC4CECE;
	Thu, 12 Dec 2024 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017278;
	bh=/kdOtRmtiqu2b0aNUb4VSVBk/eXjbyfADCUbkcKFhoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTjlNfP4KBjHxEB9yNyUwRM5WRdAJA6UbJFqSWrWhWuVsRWIr8zjQgd/4D+TMMHN3
	 NsqT/OmJDFrPRxulnGN5JpuJKR7rxnHXhTmxWLFtJg8cirWgopMlp3cfVYwB5pRtWT
	 OikldVxXWtXBir4pClBNJY/Jvu63PUcfR4FtSF/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/466] drm/xe/guc: Copy GuC log prior to dumping
Date: Thu, 12 Dec 2024 16:00:03 +0100
Message-ID: <20241212144324.016328779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit a59a403419aa03d5e44c8cf014e415490395b17f ]

Add an extra stage to the GuC log print to copy the log buffer into
regular host memory first, rather than printing the live GPU buffer
object directly. Doing so helps prevent inconsistencies due to the log
being updated as it is being dumped. It also allows the use of the
ASCII85 helper function for printing the log in a more compact form
than a straight hex dump.

v2: Use %zx instead of %lx for size_t prints.
v3: Replace hexdump code with ascii85 call (review feedback from
Matthew B). Move chunking code into next patch as that reduces the
deltas of both.
v4: Add a prefix to the ASCII85 output to aid tool parsing.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003004611.2323493-6-John.C.Harrison@Intel.com
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_log.c | 40 +++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_log.c b/drivers/gpu/drm/xe/xe_guc_log.c
index a37ee34194284..be47780ec2a7e 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -6,9 +6,12 @@
 #include "xe_guc_log.h"
 
 #include <drm/drm_managed.h>
+#include <linux/vmalloc.h>
 
 #include "xe_bo.h"
+#include "xe_devcoredump.h"
 #include "xe_gt.h"
+#include "xe_gt_printk.h"
 #include "xe_map.h"
 #include "xe_module.h"
 
@@ -49,32 +52,35 @@ static size_t guc_log_size(void)
 		CAPTURE_BUFFER_SIZE;
 }
 
+/**
+ * xe_guc_log_print - dump a copy of the GuC log to some useful location
+ * @log: GuC log structure
+ * @p: the printer object to output to
+ */
 void xe_guc_log_print(struct xe_guc_log *log, struct drm_printer *p)
 {
 	struct xe_device *xe = log_to_xe(log);
 	size_t size;
-	int i, j;
+	void *copy;
 
-	xe_assert(xe, log->bo);
+	if (!log->bo) {
+		drm_puts(p, "GuC log buffer not allocated");
+		return;
+	}
 
 	size = log->bo->size;
 
-#define DW_PER_READ		128
-	xe_assert(xe, !(size % (DW_PER_READ * sizeof(u32))));
-	for (i = 0; i < size / sizeof(u32); i += DW_PER_READ) {
-		u32 read[DW_PER_READ];
-
-		xe_map_memcpy_from(xe, read, &log->bo->vmap, i * sizeof(u32),
-				   DW_PER_READ * sizeof(u32));
-#define DW_PER_PRINT		4
-		for (j = 0; j < DW_PER_READ / DW_PER_PRINT; ++j) {
-			u32 *print = read + j * DW_PER_PRINT;
-
-			drm_printf(p, "0x%08x 0x%08x 0x%08x 0x%08x\n",
-				   *(print + 0), *(print + 1),
-				   *(print + 2), *(print + 3));
-		}
+	copy = vmalloc(size);
+	if (!copy) {
+		drm_printf(p, "Failed to allocate %zu", size);
+		return;
 	}
+
+	xe_map_memcpy_from(xe, copy, &log->bo->vmap, 0, size);
+
+	xe_print_blob_ascii85(p, "Log data", copy, 0, size);
+
+	vfree(copy);
 }
 
 int xe_guc_log_init(struct xe_guc_log *log)
-- 
2.43.0



