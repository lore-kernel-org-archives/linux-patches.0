Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AF55038E9;
	Thu, 17 Sep 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666306; cv=none; b=rx7Pm91Y0BBRud6W2CwRwHNYOavFjFJuhpfKenyObj3jmS4sQfyce3XpiaurPDKtOIJm00P8dQmBcu3pa6DkdhwcgmoMo3/xNx/gcIx4aJBJmERVwetM149nrxfyFVb5YiymiDjOtIxlP4Wbau1/7nnV58b5jq2xuWWiqQsi508=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666306; c=relaxed/simple;
	bh=2ZIWH03z5RerZ/Zp5TrCW5vi4KMoQ1HcAds9kVut4ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCBQf5CdTXL3CldYosNNvmKWzFUexhKKqpoH1zFYcPULHUp74fzttUTaed4EaTUb8LcrIak0v4hIXfCdufozjS6b2f/fAKgW1A1aIW3eXntPzEm2UXSpnao7y9KFAhsL8AT8HWhhrdrWJcm86p6l1LIyObzW8ol/UWxh0zuGA1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7S8sbmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7S8sbmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE571F000FF;
	Thu, 17 Sep 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666305;
	bh=3BnoLkfPJTRLc35AQmRZDoyjIE2qrR9vdohiWG/pIsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7S8sbmfXkZcDkZ+l3EaJknYsNPBm/C1L2iidqIBvAwGgLJkL4++WWtg8kifE805W
	 lTTUPDhXplSVfCUUbEAAFoBuRXahFaRyzl0Cj9vC8v0sanUQMiXOG6JrnpZWSCmOq2
	 +aNjXi0++dRJn1I4tsqOeMBbXMvPCpnzyOSfwSDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magdalena Schulfer <magdalena.schulfer@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 0994/1250] accel/ivpu: Validate firmware log buffer metadata
Date: Thu, 17 Sep 2026 16:13:09 +0100
Message-ID: <20260917151618.972619844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Magdalena Schulfer <magdalena.schulfer@intel.com>

commit 0724afc55c77c36c7feb9a7264b02aa7593c5c2d upstream.

The tracing log headers parsed by fw_log_print_buffer() reside in
DMA-shared BOs that the NPU firmware can write to.

fw_log_from_bo() validated log->header_size and log->size, but
fw_log_print_buffer() re-read those same fields from shared memory
afterwards, allowing a TOCTOU where firmware changes them between the
check and the use, and making the host dereference out-of-bounds
addresses while printing logs.

Snapshot the validated values once with READ_ONCE() and pass them down
explicitly in a new struct ivpu_fw_log_desc instead of re-reading them
from the shared struct.

Cc: stable@vger.kernel.org
Fixes: d4e4257afa6e ("accel/ivpu: Add firmware tracing support")
Signed-off-by: Magdalena Schulfer <magdalena.schulfer@intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260901125749.404338-3-dawid.osuchowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |   76 +++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 31 deletions(-)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -26,10 +26,17 @@ MODULE_PARM_DESC(fw_log_level,
 		 " error=" __stringify(IVPU_FW_LOG_ERROR)
 		 " fatal=" __stringify(IVPU_FW_LOG_FATAL));
 
+struct ivpu_fw_log_desc {
+	struct vpu_tracing_buffer_header *log;
+	u32 header_size;
+	u32 size;
+};
+
 static int fw_log_from_bo(struct ivpu_device *vdev, struct ivpu_bo *bo, u32 *offset,
-			  struct vpu_tracing_buffer_header **out_log)
+			  struct ivpu_fw_log_desc *desc)
 {
 	struct vpu_tracing_buffer_header *log;
+	u32 header_size, size;
 
 	if ((*offset + sizeof(*log)) > ivpu_bo_size(bo))
 		return -EINVAL;
@@ -39,26 +46,32 @@ static int fw_log_from_bo(struct ivpu_de
 	if (log->vpu_canary_start != VPU_TRACING_BUFFER_CANARY)
 		return -EINVAL;
 
-	if (log->header_size < sizeof(*log) || log->header_size > 1024) {
-		ivpu_dbg(vdev, FW_BOOT, "Invalid header size 0x%x\n", log->header_size);
+	header_size = READ_ONCE(log->header_size);
+	size = READ_ONCE(log->size);
+
+	if (header_size < sizeof(*log) || header_size > 1024) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid header size 0x%x\n", header_size);
 		return -EINVAL;
 	}
-	if (log->size < log->header_size) {
-		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
+	if ((char *)log + size > (char *)ivpu_bo_vaddr(bo) + ivpu_bo_size(bo)) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", size);
 		return -EINVAL;
 	}
-	if ((char *)log + log->size > (char *)ivpu_bo_vaddr(bo) + ivpu_bo_size(bo)) {
-		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
+	if (size < header_size) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x < header size 0x%x\n",
+			 size, header_size);
 		return -EINVAL;
 	}
 
-	*out_log = log;
-	*offset += log->size;
+	desc->log = log;
+	desc->header_size = header_size;
+	desc->size = size;
+	*offset += size;
 
 	ivpu_dbg(vdev, FW_BOOT,
 		 "FW log name \"%s\", write offset 0x%x size 0x%x, wrap count %d, hdr version %d size %d format %d, alignment %d",
-		 log->name, log->write_index, log->size, log->wrap_count, log->header_version,
-		 log->header_size, log->format, log->alignment);
+		 log->name, log->write_index, size, log->wrap_count, log->header_version,
+		 header_size, log->format, log->alignment);
 
 	return 0;
 }
@@ -94,11 +107,12 @@ static void fw_log_print_lines(char *buf
 		drm_printf(p, "%s", line);
 }
 
-static void fw_log_print_buffer(struct vpu_tracing_buffer_header *log, const char *prefix,
+static void fw_log_print_buffer(struct ivpu_fw_log_desc *desc, const char *prefix,
 				bool only_new_msgs, struct drm_printer *p)
 {
-	char *log_data = (void *)log + log->header_size;
-	u32 data_size = log->size - log->header_size;
+	struct vpu_tracing_buffer_header *log = desc->log;
+	char *log_data = (void *)log + desc->header_size;
+	u32 data_size = desc->size - desc->header_size;
 	u32 log_start = only_new_msgs ? READ_ONCE(log->read_index) : 0;
 	u32 log_end = READ_ONCE(log->write_index);
 
@@ -134,11 +148,11 @@ static void
 fw_log_print_all_in_bo(struct ivpu_device *vdev, const char *name,
 		       struct ivpu_bo *bo, bool only_new_msgs, struct drm_printer *p)
 {
-	struct vpu_tracing_buffer_header *log;
+	struct ivpu_fw_log_desc desc;
 	u32 next = 0;
 
-	while (fw_log_from_bo(vdev, bo, &next, &log) == 0)
-		fw_log_print_buffer(log, name, only_new_msgs, p);
+	while (fw_log_from_bo(vdev, bo, &next, &desc) == 0)
+		fw_log_print_buffer(&desc, name, only_new_msgs, p);
 }
 
 void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p)
@@ -149,36 +163,36 @@ void ivpu_fw_log_print(struct ivpu_devic
 
 void ivpu_fw_log_mark_read(struct ivpu_device *vdev)
 {
-	struct vpu_tracing_buffer_header *log;
+	struct ivpu_fw_log_desc desc;
 	u32 next;
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0) {
-		log->read_index = READ_ONCE(log->write_index);
-		log->read_wrap_count = READ_ONCE(log->wrap_count);
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &desc) == 0) {
+		desc.log->read_index = READ_ONCE(desc.log->write_index);
+		desc.log->read_wrap_count = READ_ONCE(desc.log->wrap_count);
 	}
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0) {
-		log->read_index = READ_ONCE(log->write_index);
-		log->read_wrap_count = READ_ONCE(log->wrap_count);
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &desc) == 0) {
+		desc.log->read_index = READ_ONCE(desc.log->write_index);
+		desc.log->read_wrap_count = READ_ONCE(desc.log->wrap_count);
 	}
 }
 
 void ivpu_fw_log_reset(struct ivpu_device *vdev)
 {
-	struct vpu_tracing_buffer_header *log;
+	struct ivpu_fw_log_desc desc;
 	u32 next;
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &log) == 0) {
-		log->read_index = 0;
-		log->read_wrap_count = 0;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_crit, &next, &desc) == 0) {
+		desc.log->read_index = 0;
+		desc.log->read_wrap_count = 0;
 	}
 
 	next = 0;
-	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &log) == 0) {
-		log->read_index = 0;
-		log->read_wrap_count = 0;
+	while (fw_log_from_bo(vdev, vdev->fw->mem_log_verb, &next, &desc) == 0) {
+		desc.log->read_index = 0;
+		desc.log->read_wrap_count = 0;
 	}
 }


