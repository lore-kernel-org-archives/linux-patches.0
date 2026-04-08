Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4222727F3;
	Wed,  8 Apr 2026 18:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674149; cv=none; b=Epi5ykUZLt4VMgDE+XFYDycJDR5a2whU6ST2NL+E3V/4WJUXSYM+n5zOje2gmd9R8qXAzJdR/W8ECWySRMYvJQraXm5q0KldAgJXenzuYNNeDznEY22PrWAwUlzbL9ZhIF5hQQW617CZ+itIXTik5fjUJtlI2fJ0YhhTraxBJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674149; c=relaxed/simple;
	bh=UO3l4mhwD6yElOdTspIamLHOHBpDpWWOsnac6dxZyEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4RhQw7AR4tYZ85MgCuEdmVDrsMgTDhP5jsHTTwF6d6K5R+oYn7f2rza4Memmx6yWfmYG1NgQoSA99oo8aD6AvMiDA41nevitgLLeRep45Mc6mRZTzeKiKGwR631DtcSnQVnrXgf+E1V+2NgeDYfiN8wyPV7RZoO4F0KOxF0Qxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrZB9qDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrZB9qDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2026BC19421;
	Wed,  8 Apr 2026 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674149;
	bh=UO3l4mhwD6yElOdTspIamLHOHBpDpWWOsnac6dxZyEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrZB9qDEh0cDoW9zGmEbzrbUsP3rv8JLQktRhHHDqRU0b9tZdXD1yT0/M+QT4Ts0t
	 PnOITHhQFxrqOKhLW++iF1lDoFFRsxxNDKgGQhKsghjThVJ0Qr7TQcviqMD05iLnmz
	 h9HtNQohdVQR1Nl0vUyNRJAvSXGrlQz2dvttsSHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rosen Penev <rosenp@gmail.com>
Subject: [PATCH 6.12 228/242] drm/amd/amdgpu: disable ASPM in some situations
Date: Wed,  8 Apr 2026 20:04:28 +0200
Message-ID: <20260408175935.629067596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit c770ef19673fb1defcbde2ee2b91c3c89bfcf164 ]

disable ASPM with some ASICs on some specific platforms.
required from PCIe controller owner.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -84,6 +84,7 @@
 
 #if IS_ENABLED(CONFIG_X86)
 #include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #endif
 
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
@@ -1758,6 +1759,35 @@ static bool amdgpu_device_pcie_dynamic_s
 	return true;
 }
 
+static bool amdgpu_device_aspm_support_quirk(struct amdgpu_device *adev)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (!(amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(12, 0, 0) ||
+		  amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(12, 0, 1)))
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
@@ -1782,6 +1812,8 @@ bool amdgpu_device_should_use_aspm(struc
 	}
 	if (adev->flags & AMD_IS_APU)
 		return false;
+	if (amdgpu_device_aspm_support_quirk(adev))
+		return false;
 	return pcie_aspm_enabled(adev->pdev);
 }
 


