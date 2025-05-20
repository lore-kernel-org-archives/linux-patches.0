Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0102472AE;
	Tue, 20 May 2025 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750436; cv=none; b=K2tCRnduOxIcTgqhrZ9pRjls3lot7P5lBSaQYeQJ6IOx3GTyAvq2cug5qAlN122Tkv+9Pd3nHVhCyRRllXwauJ5jjDb2P5dkzMll1/OPUAT3owvT1XrlIgiwXUsPKhhELOIRg41eTqFucM86aexCo69FH5wEsn4kruRV5UsA2zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750436; c=relaxed/simple;
	bh=2ysceANjiXDDwni/D09KKLSKmgJITSyynl2eWalLQ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjgxSyMEQS9WJSH9CPQ45B6vWan5gGeH5KH7R9cvS0zFckoAdlHnLno1ufQltAZTHaBfT2OJlvf+37L+48fm+rxZqPNn4sZVSr6sRANZ8G8cn2xJIA5FtTGN2OnZIbf3vjbvgOIqQZMNDkKSXrnbwuNEKo8v6ieUllRECNtVX7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFJsbY15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFJsbY15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD354C4CEEA;
	Tue, 20 May 2025 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750436;
	bh=2ysceANjiXDDwni/D09KKLSKmgJITSyynl2eWalLQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFJsbY152Do4wHfR4oHiCLd6kGJV8y1WvK7d8l4Q35+cpXX0ZHxQw2THNnCfs83I9
	 Mnb7vloBpQRZdX6HwyZESAN/WQgg7BEv1K9CitCf0RvpU/hGdVwYtPodY6HoUjHRhd
	 Z9BQbVAo/j1bikLjYtjneh+tBpfo22gH5qYrpvOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 135/143] accel/ivpu: Fix fw log printing
Date: Tue, 20 May 2025 15:51:30 +0200
Message-ID: <20250520125815.326961719@linuxfoundation.org>
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

commit 4bc988b47019536b3b1f7d9c5b83893c712d94d6 upstream.

  - Fix empty log detection that couldn't work without read_wrap_count
  - Start printing wrapped log from correct position (log_start)
  - Properly handle logs that are wrapped multiple times in reference
    to reader position
  - Don't add a newline when log buffer is wrapped
  - Always add a newline after printing a log buffer in case log does
    not end with one

Reviewed-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-6-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |   49 +++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -87,7 +87,7 @@ static void fw_log_print_lines(char *buf
 	}
 	line[index] = 0;
 	if (index != 0)
-		drm_printf(p, "%s\n", line);
+		drm_printf(p, "%s", line);
 }
 
 static void fw_log_print_buffer(struct vpu_tracing_buffer_header *log, const char *prefix,
@@ -95,23 +95,29 @@ static void fw_log_print_buffer(struct v
 {
 	char *log_data = (void *)log + log->header_size;
 	u32 data_size = log->size - log->header_size;
-	u32 log_start = log->read_index;
-	u32 log_end = log->write_index;
+	u32 log_start = only_new_msgs ? READ_ONCE(log->read_index) : 0;
+	u32 log_end = READ_ONCE(log->write_index);
 
-	if (!(log->write_index || log->wrap_count) ||
-	    (log->write_index == log->read_index && only_new_msgs)) {
-		drm_printf(p, "==== %s \"%s\" log empty ====\n", prefix, log->name);
-		return;
+	if (log->wrap_count == log->read_wrap_count) {
+		if (log_end <= log_start) {
+			drm_printf(p, "==== %s \"%s\" log empty ====\n", prefix, log->name);
+			return;
+		}
+	} else if (log->wrap_count == log->read_wrap_count + 1) {
+		if (log_end > log_start)
+			log_start = log_end;
+	} else {
+		log_start = log_end;
 	}
 
 	drm_printf(p, "==== %s \"%s\" log start ====\n", prefix, log->name);
-	if (log->write_index > log->read_index) {
+	if (log_end > log_start) {
 		fw_log_print_lines(log_data + log_start, log_end - log_start, p);
 	} else {
-		fw_log_print_lines(log_data + log_end, data_size - log_end, p);
+		fw_log_print_lines(log_data + log_start, data_size - log_start, p);
 		fw_log_print_lines(log_data, log_end, p);
 	}
-	drm_printf(p, "\x1b[0m");
+	drm_printf(p, "\n\x1b[0m"); /* add new line and clear formatting */
 	drm_printf(p, "==== %s \"%s\" log end   ====\n", prefix, log->name);
 }
 
@@ -135,14 +141,19 @@ void ivpu_fw_log_print(struct ivpu_devic
 void ivpu_fw_log_mark_read(struct ivpu_device *vdev)
 {
 	struct vpu_tracing_buffer_header *log;
-	u32 next = 0;
+	u32 next;
 
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0)
-		log->read_index = log->write_index;
+	next = 0;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0) {
+		log->read_index = READ_ONCE(log->write_index);
+		log->read_wrap_count = READ_ONCE(log->wrap_count);
+	}
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0)
-		log->read_index = log->write_index;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0) {
+		log->read_index = READ_ONCE(log->write_index);
+		log->read_wrap_count = READ_ONCE(log->wrap_count);
+	}
 }
 
 void ivpu_fw_log_reset(struct ivpu_device *vdev)
@@ -151,10 +162,14 @@ void ivpu_fw_log_reset(struct ivpu_devic
 	u32 next;
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0)
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0) {
 		log->read_index = 0;
+		log->read_wrap_count = 0;
+	}
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0)
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0) {
 		log->read_index = 0;
+		log->read_wrap_count = 0;
+	}
 }


