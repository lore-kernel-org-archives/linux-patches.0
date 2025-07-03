Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299C515442C;
	Thu,  3 Jul 2025 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555370; cv=none; b=dgLj/wF9fq/UGLjUCv4Yy5YMPoi5l87JHIvuS3ErMgoaPhr1ubpkkFKKUQqzGc2mnXwtgvH3SH4JCSil6dlrszBThUufqooDDO3KKfFqRHiaa5eZuMsYpTWTHhfBLLKH1BtgNO6zqmEPoMj7gvvO60Ed7BfVVpFGAmJx/chc6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555370; c=relaxed/simple;
	bh=QWzDrCyIAY4pIaPXTyLHXx0TUIGD6Mk5r0eeGPTus0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT0+XGZjOoSLbzqC/rTDU5wyddFpty5HWuB6sA/PGaUAIehg+swbaZKjyfSm9EQwG05Hh3r9oloH35y79AgIuVOuBrV4sb8de6Dh/ThdKi3TmzSKQXB3ObjJ+0j+tnDg4QqGjJW+Enf0rmRvvRkA6fFW0x8HPzPCkFICAV2xGTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDyr+GGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDyr+GGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A599DC4CEE3;
	Thu,  3 Jul 2025 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555370;
	bh=QWzDrCyIAY4pIaPXTyLHXx0TUIGD6Mk5r0eeGPTus0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDyr+GGr8daVdFI9XKMK+UyeOH7wVRkMiZXmr1Ds6hIauHwee7b3VSvcH8zleT2Xl
	 UcnX+bXXYuc3I8yWUW3jMNU6wR5r+BmheJ/mG8L0BVXul+FA3NUKdcXr9SgUFGHNK5
	 /koqaR/bUthricHRAJVca8gyLMw0FawzU+7VFdRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 228/263] drm/amdgpu: Add kicker device detection
Date: Thu,  3 Jul 2025 16:42:28 +0200
Message-ID: <20250703144013.531309192@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -30,6 +30,10 @@
 
 #define AMDGPU_UCODE_NAME_MAX		(128)
 
+static const struct kicker_device kicker_device_list[] = {
+	{0x744B, 0x00},
+};
+
 static void amdgpu_ucode_print_common_hdr(const struct common_firmware_header *hdr)
 {
 	DRM_DEBUG("size_bytes: %u\n", le32_to_cpu(hdr->size_bytes));
@@ -1384,6 +1388,19 @@ static const char *amdgpu_ucode_legacy_n
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
@@ -602,6 +602,11 @@ struct amdgpu_firmware {
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
@@ -629,5 +634,6 @@ amdgpu_ucode_get_load_type(struct amdgpu
 const char *amdgpu_ucode_name(enum AMDGPU_UCODE_ID ucode_id);
 
 void amdgpu_ucode_ip_version_decode(struct amdgpu_device *adev, int block_type, char *ucode_prefix, int len);
+bool amdgpu_is_kicker_fw(struct amdgpu_device *adev);
 
 #endif


