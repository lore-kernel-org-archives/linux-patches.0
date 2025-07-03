Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091F2EF66C;
	Thu,  3 Jul 2025 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556231; cv=none; b=ZzHown9ub/KwlmBuw/tR7CFvSEi6WL9guZpXY3u4QGDK+Ebo2RXARYqk9EtF5v6fY0cSxigijfXXbXPerlFDiaY1aGmGOS3cmSsR8vEFtb0DC8P27RmFyRO1uLAletedqHmcuPQUNBUYyOWdelmHq5ZygICEUlq7UDWfuEPIcII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556231; c=relaxed/simple;
	bh=1G5yo1g4YIdn/Sv1JtOdfq44o3NjXIC7bRyx3msXa1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke/DsSLb5jW/lVdUSuOUuSTVevT+qatUTdv4+cpb37qcQnHyW0TZSVJ/uZsN48kAQS1GYu3KofMgsDh3sNvLhpkdOLrhwTuPtLzYZQFCcEHSJ4SUlsU2bnbj1kOSYgmCAjHo/jjDhfzMxGlQMmYUTwj+7XZkmzo3/OUWXGxFKAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSMIMAUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSMIMAUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EA3C4CEE3;
	Thu,  3 Jul 2025 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556231;
	bh=1G5yo1g4YIdn/Sv1JtOdfq44o3NjXIC7bRyx3msXa1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSMIMAUOXf5aKGiWKsIWfq4wsZivgF7fISL5B/7DrnDMbDYvgVyuOl7Ctr2F7KQV/
	 ohhL4j7YfNj1Rn7XBtxToG83YV4x4+CGHJg2WZvgd6r2Es239S+GLngKrBj+h2O1bI
	 Dyx0C2ZQ9HlokiuPhYeBQR4qlBAliE8+sSMxmWeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 115/132] drm/amdgpu: Add kicker device detection
Date: Thu,  3 Jul 2025 16:43:24 +0200
Message-ID: <20250703143943.904451688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1059,6 +1063,19 @@ int amdgpu_ucode_init_bo(struct amdgpu_d
 	return 0;
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
@@ -535,6 +535,11 @@ struct amdgpu_firmware {
 	uint64_t fw_buf_mc;
 };
 
+struct kicker_device{
+	unsigned short device;
+	u8 revision;
+};
+
 void amdgpu_ucode_print_mc_hdr(const struct common_firmware_header *hdr);
 void amdgpu_ucode_print_smc_hdr(const struct common_firmware_header *hdr);
 void amdgpu_ucode_print_gfx_hdr(const struct common_firmware_header *hdr);
@@ -561,5 +566,6 @@ amdgpu_ucode_get_load_type(struct amdgpu
 const char *amdgpu_ucode_name(enum AMDGPU_UCODE_ID ucode_id);
 
 void amdgpu_ucode_ip_version_decode(struct amdgpu_device *adev, int block_type, char *ucode_prefix, int len);
+bool amdgpu_is_kicker_fw(struct amdgpu_device *adev);
 
 #endif


