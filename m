Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300C250C1C;
	Tue, 20 May 2025 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750388; cv=none; b=sVk2VpVlCKGXrJaKZQY+tl2QU8fVDjiO8ja2+gsU2wtiZVa4myTtr4C/7JtZ3seMd+b5hUXn4G6hmSNHigtrfS0EpjHi7+xRwgYfgZIyz8R/blNB8Hdu0ihqQXtb5S2QZ/+M/fenkQv59yvBp558HjHdd5Txkqocf7l/YCsnzBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750388; c=relaxed/simple;
	bh=moT/lU+7E0eQI+kzg0kKJnf+9qioy8yGGbppPAZJTg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paFgsurbqOhrYpwzfKkW70szrcuvpgxqoop4xai3gB+l+Oae2FrXvGHdm/5KdIjP1rmzc07dRP2PvJc5B7WGGpx+c41dVj4Hf+URUXHx2c8WFcxJW90VFlU2VO+KWtZM+CvQF0h51Sn1H9tuOUdiHgLlzYBHLnddZUlGG32Ut2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3wgMO7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3wgMO7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3011C4CEEA;
	Tue, 20 May 2025 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750387;
	bh=moT/lU+7E0eQI+kzg0kKJnf+9qioy8yGGbppPAZJTg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3wgMO7Vw9vXS31RuhuXvjl2H17FfLkrIIxiDWnp4/MQ4o/1UGLD01oCK9taIdOqQ
	 LgUWn7t5Y1/6rRYGebpHV+eJTNFrc8u8Py9UxPjtxHfGwdv+GTcB6S6EFbcWDhu+ur
	 KdXJEW9YDSgGSU4PB4lS8Y+K6lzdO/rAMz60fDFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 134/143] accel/ivpu: Refactor functions in ivpu_fw_log.c
Date: Tue, 20 May 2025 15:51:29 +0200
Message-ID: <20250520125815.288876970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 1fc1251149a76d3b75d7f4c94d9c4e081b7df6b4 upstream.

Make function names more consistent and (arguably) readable in
fw log code. Add fw_log_print_all_in_bo() that remove duplicated code in
ivpu_fw_log_print().

Reviewed-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-5-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c |    2 -
 drivers/accel/ivpu/ivpu_fw_log.c  |   62 ++++++++++++++++++++------------------
 drivers/accel/ivpu/ivpu_fw_log.h  |    2 -
 3 files changed, 35 insertions(+), 31 deletions(-)

--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -201,7 +201,7 @@ fw_log_fops_write(struct file *file, con
 	if (!size)
 		return -EINVAL;
 
-	ivpu_fw_log_clear(vdev);
+	ivpu_fw_log_mark_read(vdev);
 	return size;
 }
 
--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -26,8 +26,8 @@ MODULE_PARM_DESC(fw_log_level,
 		 " error=" __stringify(IVPU_FW_LOG_ERROR)
 		 " fatal=" __stringify(IVPU_FW_LOG_FATAL));
 
-static int fw_log_ptr(struct ivpu_device *vdev, struct ivpu_bo *bo, u32 *offset,
-		      struct vpu_tracing_buffer_header **log_header)
+static int fw_log_from_bo(struct ivpu_device *vdev, struct ivpu_bo *bo, u32 *offset,
+			  struct vpu_tracing_buffer_header **out_log)
 {
 	struct vpu_tracing_buffer_header *log;
 
@@ -48,7 +48,7 @@ static int fw_log_ptr(struct ivpu_device
 		return -EINVAL;
 	}
 
-	*log_header = log;
+	*out_log = log;
 	*offset += log->size;
 
 	ivpu_dbg(vdev, FW_BOOT,
@@ -59,7 +59,7 @@ static int fw_log_ptr(struct ivpu_device
 	return 0;
 }
 
-static void buffer_print(char *buffer, u32 size, struct drm_printer *p)
+static void fw_log_print_lines(char *buffer, u32 size, struct drm_printer *p)
 {
 	char line[IVPU_FW_LOG_LINE_LENGTH];
 	u32 index = 0;
@@ -90,11 +90,11 @@ static void buffer_print(char *buffer, u
 		drm_printf(p, "%s\n", line);
 }
 
-static void fw_log_print_buffer(struct ivpu_device *vdev, struct vpu_tracing_buffer_header *log,
-				const char *prefix, bool only_new_msgs, struct drm_printer *p)
+static void fw_log_print_buffer(struct vpu_tracing_buffer_header *log, const char *prefix,
+				bool only_new_msgs, struct drm_printer *p)
 {
-	char *log_buffer = (void *)log + log->header_size;
-	u32 log_size = log->size - log->header_size;
+	char *log_data = (void *)log + log->header_size;
+	u32 data_size = log->size - log->header_size;
 	u32 log_start = log->read_index;
 	u32 log_end = log->write_index;
 
@@ -106,51 +106,55 @@ static void fw_log_print_buffer(struct i
 
 	drm_printf(p, "==== %s \"%s\" log start ====\n", prefix, log->name);
 	if (log->write_index > log->read_index) {
-		buffer_print(log_buffer + log_start, log_end - log_start, p);
+		fw_log_print_lines(log_data + log_start, log_end - log_start, p);
 	} else {
-		buffer_print(log_buffer + log_end, log_size - log_end, p);
-		buffer_print(log_buffer, log_end, p);
+		fw_log_print_lines(log_data + log_end, data_size - log_end, p);
+		fw_log_print_lines(log_data, log_end, p);
 	}
 	drm_printf(p, "\x1b[0m");
 	drm_printf(p, "==== %s \"%s\" log end   ====\n", prefix, log->name);
 }
 
-void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p)
+static void
+fw_log_print_all_in_bo(struct ivpu_device *vdev, const char *name,
+		       struct ivpu_bo *bo, bool only_new_msgs, struct drm_printer *p)
 {
-	struct vpu_tracing_buffer_header *log_header;
+	struct vpu_tracing_buffer_header *log;
 	u32 next = 0;
 
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_crit, &next, &log_header) == 0)
-		fw_log_print_buffer(vdev, log_header, "NPU critical", only_new_msgs, p);
+	while (fw_log_from_bo(vdev, bo, &next, &log) == 0)
+		fw_log_print_buffer(log, name, only_new_msgs, p);
+}
 
-	next = 0;
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_verb, &next, &log_header) == 0)
-		fw_log_print_buffer(vdev, log_header, "NPU verbose", only_new_msgs, p);
+void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p)
+{
+	fw_log_print_all_in_bo(vdev, "NPU critical", vdev->fw->mem_log_crit, only_new_msgs, p);
+	fw_log_print_all_in_bo(vdev, "NPU verbose", vdev->fw->mem_log_verb, only_new_msgs, p);
 }
 
-void ivpu_fw_log_clear(struct ivpu_device *vdev)
+void ivpu_fw_log_mark_read(struct ivpu_device *vdev)
 {
-	struct vpu_tracing_buffer_header *log_header;
+	struct vpu_tracing_buffer_header *log;
 	u32 next = 0;
 
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_crit, &next, &log_header) == 0)
-		log_header->read_index = log_header->write_index;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0)
+		log->read_index = log->write_index;
 
 	next = 0;
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_verb, &next, &log_header) == 0)
-		log_header->read_index = log_header->write_index;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0)
+		log->read_index = log->write_index;
 }
 
 void ivpu_fw_log_reset(struct ivpu_device *vdev)
 {
-	struct vpu_tracing_buffer_header *log_header;
+	struct vpu_tracing_buffer_header *log;
 	u32 next;
 
 	next = 0;
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_crit, &next, &log_header) == 0)
-		log_header->read_index = 0;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0)
+		log->read_index = 0;
 
 	next = 0;
-	while (fw_log_ptr(vdev, vdev->fw->mem_log_verb, &next, &log_header) == 0)
-		log_header->read_index = 0;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0)
+		log->read_index = 0;
 }
--- a/drivers/accel/ivpu/ivpu_fw_log.h
+++ b/drivers/accel/ivpu/ivpu_fw_log.h
@@ -24,7 +24,7 @@
 extern unsigned int ivpu_fw_log_level;
 
 void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p);
-void ivpu_fw_log_clear(struct ivpu_device *vdev);
+void ivpu_fw_log_mark_read(struct ivpu_device *vdev);
 void ivpu_fw_log_reset(struct ivpu_device *vdev);
 
 


