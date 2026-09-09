Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD0572691;
	Wed,  9 Sep 2026 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964373; cv=none; b=A1I/iSQakc/wxeC8jOre5nmfJ+xq2TD8t6eOfOPhEfAcX6/1sctxn+cz+AmuJGpw1FVafZyp0KK4udxluRGluAAKHcEtPDcEKq0T5skkfk+3HlHjAj1zXeLAvkkT90YZOLpmd1j1PvFWLsgmmMkHwkzKk7i3ewhed6U2DHGfmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964373; c=relaxed/simple;
	bh=A8Krdx/JJ+GumD8ppO7AzjyQlik1mtEnr8dj7xNNLQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7GW9qFYJyCv5Wmrhmzb+REURfEixtTEXhAZnc+E79AbvaPcozcrwu3I4yawR9kvYsb7kcrAv/xaWXGOrDgBK52cpcuCHRyyhNfyy6p/6J2EPW9GfSmN+YnVHmxd9qIO20PIxlMNS87XHCy21NN5aZNqUa1i0y5jQd/hZJUWDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wC7vqAn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wC7vqAn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A201F00A3A;
	Wed,  9 Sep 2026 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964372;
	bh=fj++CtdW61HEsKSyt00fQyoNKR5N+1PyWDvgxMz0N/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wC7vqAn9sE6F5jFvO/cKD38dGhB9V/KSgcw7fRu4ubSLZXiAh1sYYv37NxUCsVBH6
	 Pw3au8BpEieo0ozw+rQj9Ca5ExJk0rmUCQwWAhSf2MZoCUoHdCy9ElMZ++SXtDw61M
	 AyfWp6ojg0jXiJ0EmxoecbEzy3q4bOsD97KyidiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 393/583] drm/amdgpu: Disable runtime PM for externally attached dGPUs
Date: Wed,  9 Sep 2026 15:41:18 +0200
Message-ID: <20260909134251.605179350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit c52feb4365396b6a881b5e8a95540517ffabb3b7 upstream.

pci_is_thunderbolt_attached() requires an upstream PCI bridge with
is_thunderbolt set from an Intel Thunderbolt VSEC. This does not cover
the affected ASM4242 USB4 PCI hierarchy:

  00:02.2
    \- 0f:00.0 [1b21:2421]
       +- 10:01.0 [1b21:2423] -> 45:00.0 -> 46:00.0
       |  -> 47:00.0 -> 48:00.0 -> 49:00.0 [1002:7590]
       \- 10:03.0 -> 76:00.0 [1b21:2425] USB4 Host Router

The host router is outside the GPU upstream bridge chain, leaving no
ancestor with is_thunderbolt set. PCI core propagates DEVICE_REMOVABLE
below the external-facing PCIe tunnel. Disable Runtime PM when either
pci_is_thunderbolt_attached() or dev_is_removable() is true.

Cc: stable@vger.kernel.org
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Candice Li <candice.li@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -468,6 +468,13 @@ void amdgpu_device_detect_runtime_pm_mod
 	int bamaco_support;
 
 	adev->pm.rpm_mode = AMDGPU_RUNPM_NONE;
+	if (pci_is_thunderbolt_attached(adev->pdev) ||
+	    dev_is_removable(&adev->pdev->dev)) {
+		dev_info(adev->dev,
+			 "Runtime PM disabled for externally attached device\n");
+		return;
+	}
+
 	bamaco_support = amdgpu_device_supports_baco(adev);
 
 	switch (amdgpu_runtime_pm) {


