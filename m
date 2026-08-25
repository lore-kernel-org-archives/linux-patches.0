Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823AC478E58;
	Tue, 25 Aug 2026 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665691; cv=none; b=tYgCQP9Bp3NMmIf02yks3yzkEiJcBaH64xPUNa0alPfwPbburboZV0HjGW2D5ZVrKYNhm6x8OiGk9hXkjBZwVEq4J6G/IYdcyBd9TGXnuELrhxZRXvQnUOap/whwal+Rwj750xH7G4Z1F0G5FFljlvZog79Z6a8j3ypZ14UVsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665691; c=relaxed/simple;
	bh=ahZNTt1IDP2Azx1UAhBf2fOgBSQEqpIZKCfVqq/VFN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9VrdLbBKdKPWNalqG1wNVhtaLuTaS1SWwybkuaxdcIc17q7mpRw4NkSiCN/NxdrxJQ9oBNvG1Hi5m13WP99yhBLogdwDezpTO3w4kNIMR9ODOz9XXgGZWB8J0JHDSM/Pi8+UqcweJBDPqX5qbYJDrRZswRUVPPcbUq+ZJRYwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkTHDdA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkTHDdA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B811F000E9;
	Tue, 25 Aug 2026 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665690;
	bh=WJ15f2DWFDpKKYzczGmc3GrHQqYKRLZ7r+Q/bn0V7w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkTHDdA90pI9tDelRdrLnzMPfLe/0QztRqxEjwYODBU8CKUl1lhu2OvfaSE1gWCb+
	 uW9PmpDlH2u4perTGIj7u72YGPkKu95stq+dJ2esOhONg+Gfqop9yvhXtMbIGzptWV
	 HAXzuVgqP7EuVOJKCflnRylmQgHN5lGnNWf7YHD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/87] drm/amd/amdgpu: disable ASPM in some situations
Date: Tue, 25 Aug 2026 15:25:57 +0200
Message-ID: <20260825132543.188077240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit c770ef19673fb1defcbde2ee2b91c3c89bfcf164 ]

disable ASPM with some ASICs on some specific platforms.
required from PCIe controller owner.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2a9c5154a565 ("drm/amdgpu: check ASPM on the dGPU host link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   54 +++++++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/nv.c            |    2 -
 3 files changed, 45 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1300,7 +1300,7 @@ int amdgpu_device_pci_reset(struct amdgp
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
 bool amdgpu_device_pcie_dynamic_switching_supported(void);
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
-bool amdgpu_device_aspm_support_quirk(void);
+bool amdgpu_device_nv_aspm_support_quirk(void);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -84,6 +84,7 @@
 
 #if IS_ENABLED(CONFIG_X86)
 #include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #endif
 
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
@@ -1283,6 +1284,46 @@ bool amdgpu_device_pcie_dynamic_switchin
 	return true;
 }
 
+bool amdgpu_device_nv_aspm_support_quirk(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
+static bool amdgpu_device_aspm_support_quirk(struct amdgpu_device *adev)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (!(adev->ip_versions[GC_HWIP][0] == IP_VERSION(12, 0, 0) ||
+		  adev->ip_versions[GC_HWIP][0] == IP_VERSION(12, 0, 1)))
+		return false;
+
+	if (c->x86 == 6 &&
+		adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN5) {
+		switch (c->x86_model) {
+		case VFM_MODEL(INTEL_ALDERLAKE):
+		case VFM_MODEL(INTEL_ALDERLAKE_L):
+		case VFM_MODEL(INTEL_RAPTORLAKE):
+		case VFM_MODEL(INTEL_RAPTORLAKE_P):
+		case VFM_MODEL(INTEL_RAPTORLAKE_S):
+			return true;
+		default:
+			return false;
+		}
+	} else {
+		return false;
+	}
+#else
+	return false;
+#endif
+}
+
 /**
  * amdgpu_device_should_use_aspm - check if the device should program ASPM
  *
@@ -1305,20 +1346,11 @@ bool amdgpu_device_should_use_aspm(struc
 	default:
 		return false;
 	}
+	if (amdgpu_device_aspm_support_quirk(adev))
+		return false;
 	return pcie_aspm_enabled(adev->pdev);
 }
 
-bool amdgpu_device_aspm_support_quirk(void)
-{
-#if IS_ENABLED(CONFIG_X86)
-	struct cpuinfo_x86 *c = &cpu_data(0);
-
-	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
-#else
-	return true;
-#endif
-}
-
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -513,7 +513,7 @@ static int nv_set_vce_clocks(struct amdg
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_nv_aspm_support_quirk())
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&


