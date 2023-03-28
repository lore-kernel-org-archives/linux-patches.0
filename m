Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A798476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6864BC433EF;
	Tue, 28 Mar 2023 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015260;
	bh=yA91FB4HV4FiJRK/RU1vkyv44403zYFEYXc2y91qqsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoCj4MbmoXjtZHMrRAMKDKy0R3hjN2BFX50NOFxfipfoMDNUlIX6/qHkQXl+BgfSi
	 dpSdDFBDOK16ZF8CgQRoYA/R1B/4af7o5aQ4w0k6OrKaUHEldqyz1JnRAEQhsQBZBL
	 Gzf2p00Ff/T2+lkcl22OvxQwx1JL9k/w3VNAFQAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 224/240] drm/amdgpu: reposition the gpu reset checking for reuse
Date: Tue, 28 Mar 2023 16:43:07 +0200
Message-Id: <20230328142629.066094754@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit aaee0ce460b954e08b6e630d7e54b2abb672feb8 upstream.

Move the amdgpu_acpi_should_gpu_reset out of
CONFIG_SUSPEND to share it with hibernate case.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h      |    4 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |   41 +++++++++++++++++--------------
 2 files changed, 25 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1388,10 +1388,12 @@ int amdgpu_acpi_smart_shift_update(struc
 int amdgpu_acpi_pcie_notify_device_ready(struct amdgpu_device *adev);
 
 void amdgpu_acpi_get_backlight_caps(struct amdgpu_dm_backlight_caps *caps);
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 void amdgpu_acpi_detect(void);
 #else
 static inline int amdgpu_acpi_init(struct amdgpu_device *adev) { return 0; }
 static inline void amdgpu_acpi_fini(struct amdgpu_device *adev) { }
+static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline void amdgpu_acpi_detect(void) { }
 static inline bool amdgpu_acpi_is_power_shift_control_supported(void) { return false; }
 static inline int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
@@ -1402,11 +1404,9 @@ static inline int amdgpu_acpi_smart_shif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
-bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
-static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
 #endif
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -971,6 +971,29 @@ static bool amdgpu_atcs_pci_probe_handle
 	return true;
 }
 
+
+/**
+ * amdgpu_acpi_should_gpu_reset
+ *
+ * @adev: amdgpu_device_pointer
+ *
+ * returns true if should reset GPU, false if not
+ */
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
+{
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
+#if IS_ENABLED(CONFIG_SUSPEND)
+	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
+#else
+	return true;
+#endif
+}
+
 /*
  * amdgpu_acpi_detect - detect ACPI ATIF/ATCS methods
  *
@@ -1043,24 +1066,6 @@ bool amdgpu_acpi_is_s3_active(struct amd
 }
 
 /**
- * amdgpu_acpi_should_gpu_reset
- *
- * @adev: amdgpu_device_pointer
- *
- * returns true if should reset GPU, false if not
- */
-bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
-{
-	if (adev->flags & AMD_IS_APU)
-		return false;
-
-	if (amdgpu_sriov_vf(adev))
-		return false;
-
-	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
-}
-
-/**
  * amdgpu_acpi_is_s0ix_active
  *
  * @adev: amdgpu_device_pointer


