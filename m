Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282422EFD98;
	Thu,  3 Jul 2025 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555800; cv=none; b=nCTBx1jBw3pZ3Ab72n+v8jVyCv+Kt+Fr6Ign/Q4LNRcgtP6yLpimgQ5Vok3IdUNL1evE1L4HWm1TpsXKZ2hKTNwQdXzmoNSz2LXNUpsVY7e3Pbd1+wS9mYbv+/1fGXmkLhsMQQxcOrKewJojZucXYojZfrRwmpqFI75DwGV26j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555800; c=relaxed/simple;
	bh=APgbLQmO/sNQ0XJtBQ3I0igdRSGgejUItlPR9/PRINE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwrkiOcp2uKpjXq8LkJe4vSuFPFI1gvdS0iG7wC5c3FM1v3/TtAUs2Z+R9NNNZJ2iY6C0t8xYUjc+/iZC4W99kCwn4FJKbavcAUvJbP7P1pBlS0ADHx+vPI5MNkvrm5uJtdYUWfPtZ5yPRFU/n2RUf5bbV50s6zFEatwmP6Pi4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYtBq4Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYtBq4Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70366C4CEE3;
	Thu,  3 Jul 2025 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555800;
	bh=APgbLQmO/sNQ0XJtBQ3I0igdRSGgejUItlPR9/PRINE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYtBq4Tr3ehcIUdilQAAn1vcmeFlgh1iHnwV6SwJy+DrLoQo2jUAVtZ1HvcDN8RZY
	 p7Z9jxY/Y1aNwsnFgEDG/EJfMIdhIs0/xd/tUrNk8vYxoDchLX1G6GnmX5ZHqgLCu7
	 tNxU6bJmy7gCy6sr/7J8oK3NN3TqhrcB+pd4WQyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 125/139] drm/amdgpu: Add kicker device detection
Date: Thu,  3 Jul 2025 16:43:08 +0200
Message-ID: <20250703143946.070039169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Min <Frank.Min@amd.com>

commit 0bbf5fd86c585d437b75003f11365b324360a5d6 upstream.

1. add kicker device list
2. add kicker device checking helper function

Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 09aa2b408f4ab689c3541d22b0968de0392ee406)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c |   17 +++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h |    6 ++++++
 2 files changed, 23 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -28,6 +28,10 @@
 #include "amdgpu.h"
 #include "amdgpu_ucode.h"
 
+static const struct kicker_device kicker_device_list[] = {
+	{0x744B, 0x00},
+};
+
 static void amdgpu_ucode_print_common_hdr(const struct common_firmware_header *hdr)
 {
 	DRM_DEBUG("size_bytes: %u\n", le32_to_cpu(hdr->size_bytes));
@@ -1268,6 +1272,19 @@ static const char *amdgpu_ucode_legacy_n
 	return NULL;
 }
 
+bool amdgpu_is_kicker_fw(struct amdgpu_device *adev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kicker_device_list); i++) {
+		if (adev->pdev->device == kicker_device_list[i].device &&
+			adev->pdev->revision == kicker_device_list[i].revision)
+		return true;
+	}
+
+	return false;
+}
+
 void amdgpu_ucode_ip_version_decode(struct amdgpu_device *adev, int block_type, char *ucode_prefix, int len)
 {
 	int maj, min, rev;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
@@ -536,6 +536,11 @@ struct amdgpu_firmware {
 	uint64_t fw_buf_mc;
 };
 
+struct kicker_device{
+	unsigned short device;
+	u8 revision;
+};
+
 void amdgpu_ucode_print_mc_hdr(const struct common_firmware_header *hdr);
 void amdgpu_ucode_print_smc_hdr(const struct common_firmware_header *hdr);
 void amdgpu_ucode_print_imu_hdr(const struct common_firmware_header *hdr);
@@ -562,5 +567,6 @@ amdgpu_ucode_get_load_type(struct amdgpu
 const char *amdgpu_ucode_name(enum AMDGPU_UCODE_ID ucode_id);
 
 void amdgpu_ucode_ip_version_decode(struct amdgpu_device *adev, int block_type, char *ucode_prefix, int len);
+bool amdgpu_is_kicker_fw(struct amdgpu_device *adev);
 
 #endif


