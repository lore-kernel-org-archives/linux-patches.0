Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C329E1EA80;
	Tue, 11 Mar 2025 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706146; cv=none; b=A5SKiG61rEp+uvrO7Ml4tyPKKqi23QjCZzxvbSrtZG1CJQ1rGKsqHeYwsB38QEEcMh2iTIeJkEzoJP7ksxU9lIhJgI5sHNy9UliR4QEBkdav7jhgBXN2ApCiTbALFxxn6o/zn2Oj1tbTqZ2tEKcK0KYQ5hu9/7ueuYKHWcmPZMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706146; c=relaxed/simple;
	bh=1t/TFM5XFOOC5zVaHl5XXFRMna+o6Xe9KjiS3YRv+WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rW5rgAC6nQpFVUC1m7EBpmaV3zkRk5NfLJ4TkFg2YxYeuFYW1UilynlThrBk4SfMLoV2KZqKQlurW9Dxifw9lfRLE2bSzEeftBz6mRrgqaJIyBmuCaDjRj5V4lt4w3RneD1qv/ItcXYuLYWwdn0XhzS//mtDZ/Y4TR6e1Ybv03s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUHCbVkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUHCbVkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA66C4CEE9;
	Tue, 11 Mar 2025 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706146;
	bh=1t/TFM5XFOOC5zVaHl5XXFRMna+o6Xe9KjiS3YRv+WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUHCbVkUs7vRMgi4R6ChcVRxWl+8V9ixD402t0p3TcWHrS0bfvjOEtO/CeE/uuEXY
	 72ef/t1SE9/AhZDJXOm8JxkkiYqyPVQ34pMRGJSW3D0DEdHQMFvN3oGA//fC8CrmSc
	 476rGRft2ihvDNIO8nEXHXq7/v0rujm84XZsk5/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 278/328] drm/amdgpu: disable BAR resize on Dell G5 SE
Date: Tue, 11 Mar 2025 16:00:48 +0100
Message-ID: <20250311145725.966626873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 099bffc7cadff40bfab1517c3461c53a7a38a0d7 ]

There was a quirk added to add a workaround for a Sapphire
RX 5600 XT Pulse that didn't allow BAR resizing.  However,
the quirk caused a regression with runtime pm on Dell laptops
using those chips, rather than narrowing the scope of the
resizing quirk, add a quirk to prevent amdgpu from resizing
the BAR on those Dell platforms unless runtime pm is disabled.

v2: update commit message, add runpm check

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1707
Fixes: 907830b0fc9e ("PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5235053f443cef4210606e5fb71f99b915a9723d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index dc8ed896d05f0..69bfaa9a8f90b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -766,6 +766,13 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
+	/* resizing on Dell G5 SE platforms causes problems with runtime pm */
+	if ((amdgpu_runtime_pm != 0) &&
+	    adev->pdev->vendor == PCI_VENDOR_ID_ATI &&
+	    adev->pdev->device == 0x731f &&
+	    adev->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL)
+		return 0;
+
 	/* PCI_EXT_CAP_ID_VNDR extended capability is located at 0x100 */
 	if (!pci_find_ext_capability(adev->pdev, PCI_EXT_CAP_ID_VNDR))
 		DRM_WARN("System can't access extended configuration space,please check!!\n");
-- 
2.39.5



