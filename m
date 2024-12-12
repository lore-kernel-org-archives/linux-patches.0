Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F61487CD;
	Thu, 12 Dec 2024 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017276; cv=none; b=bNnv2TFc2rxO0PNWhqvdObr7SgeayZH9ABWp0QhIOU8vHMcBjPQDgtYyFEsZgzPZKOc4drlaoiOhE6BCaLrmXatc3A3www+hIc0wiPmro1cqMtcGZHsVkpVl1D0uuXuyMOw43kzx8U/1PF2Ev+l8AZepXxHfJrCM9UhxNMaSjXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017276; c=relaxed/simple;
	bh=HU1cuD0mksdb5LjCgmhd8JyStxGhQGj3Ez1pKgt4llA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmajfOWCOOjHMTVFY3TAM6ogwpFUFDyBj+tdfy6tt92ROqYnPeDjlktrddshplpZolMfeCDcH2t2etDYf0FOic31BweRC3qDks0FOWd8l+z4RRurvG2dCCwoAYjEBObSad3LnsflUFfIxmx0MOaChoeZVEeAeT4E+Lv42HHGHX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kh6/RC5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kh6/RC5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438B1C4CECE;
	Thu, 12 Dec 2024 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017275;
	bh=HU1cuD0mksdb5LjCgmhd8JyStxGhQGj3Ez1pKgt4llA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh6/RC5kA+sb/vbvZjfnc74Lje09IXDycLSJOZlo6hkcMmlrFfWpeYOZh8Q/LdNc3
	 4E4sfCwP05YB+0XaeWhTen9s+rUEgC9yzflJuMsftSYWj4w+HD76j5Tf6hpl2/W2Zi
	 gf98b2HjkTFpVihu1AIKqL2AZjQ7mdSs1+hAXvmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/466] drm/xe/devcoredump: Add ASCII85 dump helper function
Date: Thu, 12 Dec 2024 16:00:02 +0100
Message-ID: <20241212144323.979079474@linuxfoundation.org>
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

[ Upstream commit ec1455ce7e35a31289d2dbc1070b980538698921 ]

There is a need to include the GuC log and other large binary objects
in core dumps and via dmesg. So add a helper for dumping to a printer
function via conversion to ASCII85 encoding.

Another issue with dumping such a large buffer is that it can be slow,
especially if dumping to dmesg over a serial port. So add a yield to
prevent the 'task has been stuck for 120s' kernel hang check feature
from firing.

v2: Add a prefix to the output string. Fix memory allocation bug.
v3: Correct a string size calculation and clean up a define (review
feedback from Julia F).

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003004611.2323493-5-John.C.Harrison@Intel.com
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c | 87 +++++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_devcoredump.h |  6 ++
 2 files changed, 93 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index 2690f1d1cde4c..0884c49942fe6 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -6,6 +6,7 @@
 #include "xe_devcoredump.h"
 #include "xe_devcoredump_types.h"
 
+#include <linux/ascii85.h>
 #include <linux/devcoredump.h>
 #include <generated/utsrelease.h>
 
@@ -315,3 +316,89 @@ int xe_devcoredump_init(struct xe_device *xe)
 }
 
 #endif
+
+/**
+ * xe_print_blob_ascii85 - print a BLOB to some useful location in ASCII85
+ *
+ * The output is split to multiple lines because some print targets, e.g. dmesg
+ * cannot handle arbitrarily long lines. Note also that printing to dmesg in
+ * piece-meal fashion is not possible, each separate call to drm_puts() has a
+ * line-feed automatically added! Therefore, the entire output line must be
+ * constructed in a local buffer first, then printed in one atomic output call.
+ *
+ * There is also a scheduler yield call to prevent the 'task has been stuck for
+ * 120s' kernel hang check feature from firing when printing to a slow target
+ * such as dmesg over a serial port.
+ *
+ * TODO: Add compression prior to the ASCII85 encoding to shrink huge buffers down.
+ *
+ * @p: the printer object to output to
+ * @prefix: optional prefix to add to output string
+ * @blob: the Binary Large OBject to dump out
+ * @offset: offset in bytes to skip from the front of the BLOB, must be a multiple of sizeof(u32)
+ * @size: the size in bytes of the BLOB, must be a multiple of sizeof(u32)
+ */
+void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix,
+			   const void *blob, size_t offset, size_t size)
+{
+	const u32 *blob32 = (const u32 *)blob;
+	char buff[ASCII85_BUFSZ], *line_buff;
+	size_t line_pos = 0;
+
+#define DMESG_MAX_LINE_LEN	800
+#define MIN_SPACE		(ASCII85_BUFSZ + 2)		/* 85 + "\n\0" */
+
+	if (size & 3)
+		drm_printf(p, "Size not word aligned: %zu", size);
+	if (offset & 3)
+		drm_printf(p, "Offset not word aligned: %zu", size);
+
+	line_buff = kzalloc(DMESG_MAX_LINE_LEN, GFP_KERNEL);
+	if (IS_ERR_OR_NULL(line_buff)) {
+		drm_printf(p, "Failed to allocate line buffer: %pe", line_buff);
+		return;
+	}
+
+	blob32 += offset / sizeof(*blob32);
+	size /= sizeof(*blob32);
+
+	if (prefix) {
+		strscpy(line_buff, prefix, DMESG_MAX_LINE_LEN - MIN_SPACE - 2);
+		line_pos = strlen(line_buff);
+
+		line_buff[line_pos++] = ':';
+		line_buff[line_pos++] = ' ';
+	}
+
+	while (size--) {
+		u32 val = *(blob32++);
+
+		strscpy(line_buff + line_pos, ascii85_encode(val, buff),
+			DMESG_MAX_LINE_LEN - line_pos);
+		line_pos += strlen(line_buff + line_pos);
+
+		if ((line_pos + MIN_SPACE) >= DMESG_MAX_LINE_LEN) {
+			line_buff[line_pos++] = '\n';
+			line_buff[line_pos++] = 0;
+
+			drm_puts(p, line_buff);
+
+			line_pos = 0;
+
+			/* Prevent 'stuck thread' time out errors */
+			cond_resched();
+		}
+	}
+
+	if (line_pos) {
+		line_buff[line_pos++] = '\n';
+		line_buff[line_pos++] = 0;
+
+		drm_puts(p, line_buff);
+	}
+
+	kfree(line_buff);
+
+#undef MIN_SPACE
+#undef DMESG_MAX_LINE_LEN
+}
diff --git a/drivers/gpu/drm/xe/xe_devcoredump.h b/drivers/gpu/drm/xe/xe_devcoredump.h
index e2fa65ce09322..a4eebc285fc83 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.h
+++ b/drivers/gpu/drm/xe/xe_devcoredump.h
@@ -6,6 +6,9 @@
 #ifndef _XE_DEVCOREDUMP_H_
 #define _XE_DEVCOREDUMP_H_
 
+#include <linux/types.h>
+
+struct drm_printer;
 struct xe_device;
 struct xe_sched_job;
 
@@ -23,4 +26,7 @@ static inline int xe_devcoredump_init(struct xe_device *xe)
 }
 #endif
 
+void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix,
+			   const void *blob, size_t offset, size_t size);
+
 #endif
-- 
2.43.0



