Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1B582B9E;
	Wed,  9 Sep 2026 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963056; cv=none; b=LxEBx8jNGc9IXLGjnhu2a62vIX9Sm06dKdDyFLcclPYGRpiWnJYsrqfzpaaJX9DpFZCdwGbpIDcPB6H7o7v5+9JoCNX4s/JGfm37pDDXL9LLuQJUpjOeOAlnkkLucfMmDVYOYOLrYK6xvt+D2TSXcQ2QdGNoB++DzcF6ustBO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963056; c=relaxed/simple;
	bh=O4r2ZLiornoQpw5Vho4PIpOitASHhlJUXo20lj5oVqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT6pa4nuxsEUr+ZLYBd3qL72GIMIdRNfS+XDOPL0MHskM87n1XBgLcnu3Rp3tEzrkLQIR5lR2Po4C9+2J24j14IJi5Yx3UB3VVEZNar05nPh6EuKJ70tkbZHEU1J6afi6E96RXj60v5A/HunhFbm8YqnMiIngRKjX0pAt3tAlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtbjGvah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtbjGvah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949011F00A3A;
	Wed,  9 Sep 2026 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963055;
	bh=nyfsu3+xdlg5T2nOey3+ZUvRV4kauDOObUSRk4m/1cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtbjGvah5syg5auKNbRQu3V88a299WvC+Ja6hP8lHiGkra/Z697Gv1aQmU+GQy9nh
	 Un9j2EOkL4sMxVipC4oubUVm5NwJ7sVGbOWrSLpdzF0UjcbjCdEaBa+bWtZIFw+AEb
	 1NZKi8y0Q6gBYe8riMjSnlEAlZg0glDEK1iJWAAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 504/556] drm/amdgpu: Disable runtime PM for externally attached dGPUs
Date: Wed,  9 Sep 2026 15:43:04 +0200
Message-ID: <20260909134248.197567218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -607,6 +607,13 @@ void amdgpu_device_detect_runtime_pm_mod
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


