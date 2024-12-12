Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C61E23A1BF;
	Thu, 12 Dec 2024 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021364; cv=none; b=sC2x8U+R4RcX4pES8wiD3LlUq5brqYO0R3t281yiQAbtqWvpsEuF/SQ+el94KIU6f0zyR77tOojcvBfs5W+WJIax3GXNIUHfLyuU+3rPWfgwYzPyntkYeXR3Ni6rzCbuK9iHRncjVfTG5zrOK889vNTeA6ubG/0Bd2lVjuWK71k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021364; c=relaxed/simple;
	bh=dQn6WBWVWMN+QZh7qLgmCCWvekiNRsCbl8vXYqxzGo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NANjGenc4WH7yyofhltQ2CGAdDhv4CuKVw9RRRPPdURzHATfS76Gl6QuAP4RjG5FqwGmaNxrKgnRA+WlzsG9L+HvNo4WgBXxU9ASvJpT3reCcQuU2Sg9xZnVLDVPs9G+GCCsJep2/cQxuy5qNCh1Ju4J5+1MD4HUdPy3oT89ENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXXLNzh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXXLNzh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1E1C4CECE;
	Thu, 12 Dec 2024 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021364;
	bh=dQn6WBWVWMN+QZh7qLgmCCWvekiNRsCbl8vXYqxzGo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXXLNzh3O70zUUIS3n7sgr3D03V/JUwy/6N1Fk1lxCIaqNKDnBPzv3xeSDmlW/6lM
	 zFeZ+Ip6o5ezvAzf7VF6rZQ4kc5+1e/SLwaWEjmL8kU+YWkW32nL5RRIRiQhOWhzN1
	 NzzNhNtCA09otli+cY4txY8D8gbpm58KgdEqEbWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 687/772] drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov
Date: Thu, 12 Dec 2024 16:00:32 +0100
Message-ID: <20241212144418.304052547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit afe260df55ac280cd56306248cb6d8a6b0db095c ]

Under sriov, host driver will save and restore vf pci cfg space during
reset. And during device init, under sriov, pci_restore_state happens after
fullaccess released, and it can have race condition with mmio protection
enable from host side leading to missing interrupts.

So skip amdgpu_device_cache_pci_state for sriov.

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 1d0f6628f1d69..aca1a4e9b7ae9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6013,6 +6013,9 @@ bool amdgpu_device_cache_pci_state(struct pci_dev *pdev)
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int r;
 
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
 	r = pci_save_state(pdev);
 	if (!r) {
 		kfree(adev->pci_state);
-- 
2.43.0



