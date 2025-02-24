Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4760165F09;
	Mon, 24 Feb 2025 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408351; cv=none; b=Em3wbRFuUye7KUGCyKRf/k/mOoPLBCcF/6f6E+vbuanWBfOTAznBOCJH9vtWSSCL7+6bg4HSHVQy3OAPz3CzNgkZH/dpfUTiMqfh+F5tyqk6dJ0DXUaUroVkoPmkmKnRE9hO6fU+H87ExBLvFuep11MyV2sEYnzOCfPegEefSlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408351; c=relaxed/simple;
	bh=LEzQL5mSOsCExoQPhemnhyOFGweZOT+Eb21PBM4TJXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC6s+tfatOrYOKQ3lmOP1SP6vrT5aSYfLydpTuhnuer+9mzBPQskieyDW7LLSIBpJ9voSNi5+sCghOp6oma2SEaCqd7VxmuVimVLIM93V+9b4Wli81xBHMNaU0eU7hxBslwIIVRfk9viNd5LAUwAck9aJqvj7xTd9dtC33x3tR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B15Mn688; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B15Mn688"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7D5C4CED6;
	Mon, 24 Feb 2025 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408351;
	bh=LEzQL5mSOsCExoQPhemnhyOFGweZOT+Eb21PBM4TJXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B15Mn688LULgt1x4FAJMb9Pihs0qIl8qiqRFjdnX1Slp0ACDsl4gNIjmf9itlSXzj
	 egWb1U72LJDC8DAUQkeyekIXYNvVOC2/fCW0PMgNKQhR1AnHQ/WtyT6AGyEG4KYQYG
	 hrKNJHLChjXwveIwqknmRhbnqNh1Na4EySuHIV8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/154] accel/ivpu: Limit FW version string length
Date: Mon, 24 Feb 2025 15:33:52 +0100
Message-ID: <20250224142608.381516224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

[ Upstream commit 990b1e3d150104249115a0ad81ea77c53b28f0f8 ]

Limit FW version string, when parsing FW binary, to 256 bytes and
always add NULL-terminate it.

Reviewed-by: Karol Wachowski <karol.wachowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-7-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Stable-dep-of: 41a2d8286c90 ("accel/ivpu: Fix error handling in recovery/reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw.c | 7 ++++---
 drivers/accel/ivpu/ivpu_fw.h | 6 +++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_fw.c b/drivers/accel/ivpu/ivpu_fw.c
index ede6165e09d90..b2b6d89f06537 100644
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -25,7 +25,6 @@
 #define FW_SHAVE_NN_MAX_SIZE	SZ_2M
 #define FW_RUNTIME_MIN_ADDR	(FW_GLOBAL_MEM_START)
 #define FW_RUNTIME_MAX_ADDR	(FW_GLOBAL_MEM_END - FW_SHARED_MEM_SIZE)
-#define FW_VERSION_HEADER_SIZE	SZ_4K
 #define FW_FILE_IMAGE_OFFSET	(VPU_FW_HEADER_SIZE + FW_VERSION_HEADER_SIZE)
 
 #define WATCHDOG_MSS_REDIRECT	32
@@ -191,8 +190,10 @@ static int ivpu_fw_parse(struct ivpu_device *vdev)
 	ivpu_dbg(vdev, FW_BOOT, "Header version: 0x%x, format 0x%x\n",
 		 fw_hdr->header_version, fw_hdr->image_format);
 
-	ivpu_info(vdev, "Firmware: %s, version: %s", fw->name,
-		  (const char *)fw_hdr + VPU_FW_HEADER_SIZE);
+	if (!scnprintf(fw->version, sizeof(fw->version), "%s", fw->file->data + VPU_FW_HEADER_SIZE))
+		ivpu_warn(vdev, "Missing firmware version\n");
+
+	ivpu_info(vdev, "Firmware: %s, version: %s\n", fw->name, fw->version);
 
 	if (IVPU_FW_CHECK_API_COMPAT(vdev, fw_hdr, BOOT, 3))
 		return -EINVAL;
diff --git a/drivers/accel/ivpu/ivpu_fw.h b/drivers/accel/ivpu/ivpu_fw.h
index 40d9d17be3f52..5e8eb608b70f1 100644
--- a/drivers/accel/ivpu/ivpu_fw.h
+++ b/drivers/accel/ivpu/ivpu_fw.h
@@ -1,11 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #ifndef __IVPU_FW_H__
 #define __IVPU_FW_H__
 
+#define FW_VERSION_HEADER_SIZE	SZ_4K
+#define FW_VERSION_STR_SIZE	SZ_256
+
 struct ivpu_device;
 struct ivpu_bo;
 struct vpu_boot_params;
@@ -13,6 +16,7 @@ struct vpu_boot_params;
 struct ivpu_fw_info {
 	const struct firmware *file;
 	const char *name;
+	char version[FW_VERSION_STR_SIZE];
 	struct ivpu_bo *mem;
 	struct ivpu_bo *mem_shave_nn;
 	struct ivpu_bo *mem_log_crit;
-- 
2.39.5



