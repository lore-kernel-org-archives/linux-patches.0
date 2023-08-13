Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3639443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2282FC433C8;
	Sun, 13 Aug 2023 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961921;
	bh=FEZPnqaJUuyzWf2KISq5+aQEajc2o9QR98pI260W5Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVtmynDBQ8Ui1pLjFWZ95OtSLNSKnKuXfCdiGMLqCTBmNPa1NbfQF6dGAo706Vz5/
	 McFsOaYuvyaSU3KieBKGJVOoXlXMu1TsjhqaxeFMYQlgfFjSZ8dTVlnyiwUZoCLyhu
	 v2cb0NdI7MaUlltCyQ4hcLfuwSNDkKnHTz30ga3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <Hamza.Mahfooz@amd.com>,
	Roman Li <roman.li@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 046/206] drm/amd: Disable S/G for APUs when 64GB or more host memory
Date: Sun, 13 Aug 2023 23:16:56 +0200
Message-ID: <20230813211726.315438669@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 08fffa74d9772d9538338be3f304006c94dde6f0 upstream.

Users report a white flickering screen on multiple systems that
is tied to having 64GB or more memory.  When S/G is enabled pages
will get pinned to both VRAM carve out and system RAM leading to
this.

Until it can be fixed properly, disable S/G when 64GB of memory or
more is detected.  This will force pages to be pinned into VRAM.
This should fix white screen flickers but if VRAM pressure is
encountered may lead to black screens.  It's a trade-off for now.

Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
Cc: Hamza Mahfooz <Hamza.Mahfooz@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: <stable@vger.kernel.org> # 6.1.y: bf0207e172703 ("drm/amdgpu: add S/G display parameter")
Cc: <stable@vger.kernel.org> # 6.4.y
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2735
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h               |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c        |   26 ++++++++++++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 +---
 3 files changed, 29 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1246,6 +1246,7 @@ int amdgpu_device_gpu_recover(struct amd
 void amdgpu_device_pci_config_reset(struct amdgpu_device *adev);
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
+bool amdgpu_sg_display_supported(struct amdgpu_device *adev);
 bool amdgpu_device_pcie_dynamic_switching_supported(void);
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
 bool amdgpu_device_aspm_support_quirk(void);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1353,6 +1353,32 @@ bool amdgpu_device_need_post(struct amdg
 }
 
 /*
+ * On APUs with >= 64GB white flickering has been observed w/ SG enabled.
+ * Disable S/G on such systems until we have a proper fix.
+ * https://gitlab.freedesktop.org/drm/amd/-/issues/2354
+ * https://gitlab.freedesktop.org/drm/amd/-/issues/2735
+ */
+bool amdgpu_sg_display_supported(struct amdgpu_device *adev)
+{
+	switch (amdgpu_sg_display) {
+	case -1:
+		break;
+	case 0:
+		return false;
+	case 1:
+		return true;
+	default:
+		return false;
+	}
+	if ((totalram_pages() << (PAGE_SHIFT - 10)) +
+	    (adev->gmc.real_vram_size / 1024) >= 64000000) {
+		DRM_WARN("Disabling S/G due to >=64GB RAM\n");
+		return false;
+	}
+	return true;
+}
+
+/*
  * Intel hosts such as Raptor Lake and Sapphire Rapids don't support dynamic
  * speed switching. Until we have confirmation from Intel that a specific host
  * supports it, it's safer that we keep it disabled for all.
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1630,9 +1630,8 @@ static int amdgpu_dm_init(struct amdgpu_
 		}
 		break;
 	}
-	if (init_data.flags.gpu_vm_support &&
-	    (amdgpu_sg_display == 0))
-		init_data.flags.gpu_vm_support = false;
+	if (init_data.flags.gpu_vm_support)
+		init_data.flags.gpu_vm_support = amdgpu_sg_display_supported(adev);
 
 	if (init_data.flags.gpu_vm_support)
 		adev->mode_info.gpu_vm_support = true;


