Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B25194A45;
	Tue, 27 May 2025 16:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364649; cv=none; b=BTUixVfLyPvwI9Lpp8AqN1f3uF/C1O7lrVq6O6MfMBdDLvviDQHb+JQz5ByA6Ri8dMmm1+MXuKj3V+rCvI84IcjTSld9wuHkc8v9NVRkWDGtoyk1zaswKEnZ2cSr7OFcH/QYdDaTYxZLqDmZuPemKKEAnBbYD9hPVzcvrGou/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364649; c=relaxed/simple;
	bh=v/GAPrP6XzEKZBb1KRYDXoxY7V1xVF7SZgCVXAV2BVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfuQvqOL8AgTRkgf3++hbEPmo/ilzNT76m2xnoyRfJKt0P62hC5X4+S+VBQVXIw7kjMFiBFvfzUBFCM7wpbNwYGM054qcDPbzwtc9cYfKAlvRm5km3kvj0gEuWkYYFLQD3LAyYzZ5+R5sD/OshCOWNHoiThwaScl49oGs1c2HUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIwsIx2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIwsIx2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389F1C4CEE9;
	Tue, 27 May 2025 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364648;
	bh=v/GAPrP6XzEKZBb1KRYDXoxY7V1xVF7SZgCVXAV2BVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIwsIx2zHIGRjD6GFb7AJV+4Dlk12+Ugrems0tydhpiPuJq5RqOkxLHx7Mj01CQuG
	 duhWamJrxFFjXz8ZL1WdKqPuvNzu1C39nGFwCSgTlR5qZxdbYJyo25+o/wYFBvhvmB
	 bZJ7R0bMvpElLLZQjeSR2ZeFDvZ8KJEvvZc8b2Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/626] drm/amdgpu: adjust drm_firmware_drivers_only() handling
Date: Tue, 27 May 2025 18:20:16 +0200
Message-ID: <20250527162450.028643200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e00e5c223878a60e391e5422d173c3382d378f87 ]

Move to probe so we can check the PCI device type and
only apply the drm_firmware_drivers_only() check for
PCI DISPLAY classes.  Also add a module parameter to
override the nomodeset kernel parameter as a workaround
for platforms that have this hardcoded on their kernel
command lines.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 1b479bd851354..93c3de2d27d3a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -172,6 +172,7 @@ uint amdgpu_sdma_phase_quantum = 32;
 char *amdgpu_disable_cu;
 char *amdgpu_virtual_display;
 bool enforce_isolation;
+int amdgpu_modeset = -1;
 
 /* Specifies the default granularity for SVM, used in buffer
  * migration and restoration of backing memory when handling
@@ -1037,6 +1038,13 @@ module_param_named(user_partt_mode, amdgpu_user_partt_mode, uint, 0444);
 module_param(enforce_isolation, bool, 0444);
 MODULE_PARM_DESC(enforce_isolation, "enforce process isolation between graphics and compute . enforce_isolation = on");
 
+/**
+ * DOC: modeset (int)
+ * Override nomodeset (1 = override, -1 = auto). The default is -1 (auto).
+ */
+MODULE_PARM_DESC(modeset, "Override nomodeset (1 = enable, -1 = auto)");
+module_param_named(modeset, amdgpu_modeset, int, 0444);
+
 /**
  * DOC: seamless (int)
  * Seamless boot will keep the image on the screen during the boot process.
@@ -2248,6 +2256,12 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	int ret, retry = 0, i;
 	bool supports_atomic = false;
 
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA ||
+	    (pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER) {
+		if (drm_firmware_drivers_only() && amdgpu_modeset == -1)
+			return -EINVAL;
+	}
+
 	/* skip devices which are owned by radeon */
 	for (i = 0; i < ARRAY_SIZE(amdgpu_unsupported_pciidlist); i++) {
 		if (amdgpu_unsupported_pciidlist[i] == pdev->device)
-- 
2.39.5



