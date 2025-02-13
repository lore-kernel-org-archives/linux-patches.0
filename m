Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662241DB154;
	Thu, 13 Feb 2025 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458495; cv=none; b=L8gdNXEJuZtxsTU4X41VsaURJ1eT6K44xIdwJvMXUytzpo2bBLswAaL78iuaoVRds7Ll1uea/D7IrliOFv3KK03E8ORpqgeSszKAjm5hk7BmDKQhpHTv9C+hyYGreYzy5TSovN/GxN16eYAgP5/hSRtdfXNjFz4rAE1NQr0saGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458495; c=relaxed/simple;
	bh=jsvBAUt9pOJMIPs7dGqL3bwl9H88epeu/FPNp7oIeBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chKAMqlQ3JN85XyWxklVRRUwTXsZKX2smvQQvxGSNIKsy2y2eDk72riALDexfqqMt8DE7oUFH+WtoZo4LMDrq9GpzUE9ZkBHO4OcSOmY9rJMpPyr6I2QxEI+GeHDoebEjy92IRL99YfAdVS2gLGZr05SBU01K+GMkLoE4JKYCR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTC4Qc4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTC4Qc4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DFFC4CED1;
	Thu, 13 Feb 2025 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458495;
	bh=jsvBAUt9pOJMIPs7dGqL3bwl9H88epeu/FPNp7oIeBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTC4Qc4x6zNS3NzMB8v+VrxlDcGV0bM9X9aH170yAtwyZA9H0Ql7CsQVzUZGzscbF
	 EhS6toWEXCYg1QJgquGweJ5k9OQkqWoUliKBdgj0T4QZD2CA8XQubHv3YmC5K5C0xl
	 JOXdI1/FA6BeHj6T+8/zAr135o7wIltBrDcGURog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 417/422] drm/xe: Fix and re-enable xe_print_blob_ascii85()
Date: Thu, 13 Feb 2025 15:29:26 +0100
Message-ID: <20250213142452.656908287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit a9ab6591b45258b79af1cb66112fd9f83c8855da upstream.

Commit 70fb86a85dc9 ("drm/xe: Revert some changes that break a mesa
debug tool") partially reverted some changes to workaround breakage
caused to mesa tools. However, in doing so it also broke fetching the
GuC log via debugfs since xe_print_blob_ascii85() simply bails out.

The fix is to avoid the extra newlines: the devcoredump interface is
line-oriented and adding random newlines in the middle breaks it. If a
tool is able to parse it by looking at the data and checking for chars
that are out of the ascii85 space, it can still do so. A format change
that breaks the line-oriented output on devcoredump however needs better
coordination with existing tools.

v2: Add suffix description comment
v3: Reword explanation of xe_print_blob_ascii85() calling drm_puts()
    in a loop

Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Fixes: 70fb86a85dc9 ("drm/xe: Revert some changes that break a mesa debug tool")
Fixes: ec1455ce7e35 ("drm/xe/devcoredump: Add ASCII85 dump helper function")
Link: https://patchwork.freedesktop.org/patch/msgid/20250123202307.95103-2-jose.souza@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 2c95bbf5002776117a69caed3b31c10bf7341bec)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c |   34 +++++++++++++---------------------
 drivers/gpu/drm/xe/xe_devcoredump.h |    2 +-
 drivers/gpu/drm/xe/xe_guc_log.c     |    2 +-
 3 files changed, 15 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -333,42 +333,34 @@ int xe_devcoredump_init(struct xe_device
 /**
  * xe_print_blob_ascii85 - print a BLOB to some useful location in ASCII85
  *
- * The output is split to multiple lines because some print targets, e.g. dmesg
- * cannot handle arbitrarily long lines. Note also that printing to dmesg in
- * piece-meal fashion is not possible, each separate call to drm_puts() has a
- * line-feed automatically added! Therefore, the entire output line must be
- * constructed in a local buffer first, then printed in one atomic output call.
+ * The output is split into multiple calls to drm_puts() because some print
+ * targets, e.g. dmesg, cannot handle arbitrarily long lines. These targets may
+ * add newlines, as is the case with dmesg: each drm_puts() call creates a
+ * separate line.
  *
  * There is also a scheduler yield call to prevent the 'task has been stuck for
  * 120s' kernel hang check feature from firing when printing to a slow target
  * such as dmesg over a serial port.
  *
- * TODO: Add compression prior to the ASCII85 encoding to shrink huge buffers down.
- *
  * @p: the printer object to output to
  * @prefix: optional prefix to add to output string
+ * @suffix: optional suffix to add at the end. 0 disables it and is
+ *          not added to the output, which is useful when using multiple calls
+ *          to dump data to @p
  * @blob: the Binary Large OBject to dump out
  * @offset: offset in bytes to skip from the front of the BLOB, must be a multiple of sizeof(u32)
  * @size: the size in bytes of the BLOB, must be a multiple of sizeof(u32)
  */
-void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix,
+void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix, char suffix,
 			   const void *blob, size_t offset, size_t size)
 {
 	const u32 *blob32 = (const u32 *)blob;
 	char buff[ASCII85_BUFSZ], *line_buff;
 	size_t line_pos = 0;
 
-	/*
-	 * Splitting blobs across multiple lines is not compatible with the mesa
-	 * debug decoder tool. Note that even dropping the explicit '\n' below
-	 * doesn't help because the GuC log is so big some underlying implementation
-	 * still splits the lines at 512K characters. So just bail completely for
-	 * the moment.
-	 */
-	return;
-
 #define DMESG_MAX_LINE_LEN	800
-#define MIN_SPACE		(ASCII85_BUFSZ + 2)		/* 85 + "\n\0" */
+	/* Always leave space for the suffix char and the \0 */
+#define MIN_SPACE		(ASCII85_BUFSZ + 2)	/* 85 + "<suffix>\0" */
 
 	if (size & 3)
 		drm_printf(p, "Size not word aligned: %zu", size);
@@ -400,7 +392,6 @@ void xe_print_blob_ascii85(struct drm_pr
 		line_pos += strlen(line_buff + line_pos);
 
 		if ((line_pos + MIN_SPACE) >= DMESG_MAX_LINE_LEN) {
-			line_buff[line_pos++] = '\n';
 			line_buff[line_pos++] = 0;
 
 			drm_puts(p, line_buff);
@@ -412,10 +403,11 @@ void xe_print_blob_ascii85(struct drm_pr
 		}
 	}
 
+	if (suffix)
+		line_buff[line_pos++] = suffix;
+
 	if (line_pos) {
-		line_buff[line_pos++] = '\n';
 		line_buff[line_pos++] = 0;
-
 		drm_puts(p, line_buff);
 	}
 
--- a/drivers/gpu/drm/xe/xe_devcoredump.h
+++ b/drivers/gpu/drm/xe/xe_devcoredump.h
@@ -26,7 +26,7 @@ static inline int xe_devcoredump_init(st
 }
 #endif
 
-void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix,
+void xe_print_blob_ascii85(struct drm_printer *p, const char *prefix, char suffix,
 			   const void *blob, size_t offset, size_t size);
 
 #endif
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -78,7 +78,7 @@ void xe_guc_log_print(struct xe_guc_log
 
 	xe_map_memcpy_from(xe, copy, &log->bo->vmap, 0, size);
 
-	xe_print_blob_ascii85(p, "Log data", copy, 0, size);
+	xe_print_blob_ascii85(p, "Log data", '\n', copy, 0, size);
 
 	vfree(copy);
 }


