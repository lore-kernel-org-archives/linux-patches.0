Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD0C22D7A6;
	Mon, 10 Mar 2025 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628320; cv=none; b=dPi8GtB8hinK2w8ruDkW8Lz0SNa+cSy3F1OBGN/GswPt20GaOsTJt84i3gdokOeo6Mab3zuxlWAE9wgpZxF15VJ4FQDrQy96CpXNbA6KT59GDQ9gIDvAIaIYyBWGVRkTszhvmMbxX6CKZ2nhkzbwMinxrfxFLx5S/TyD2bWnJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628320; c=relaxed/simple;
	bh=wvk1HP28FPI4U953jmyNpVI/li1OwC/KRPumEY1akfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrRPoM0eWLLixKPXh3F+o/0ixH6g9vaOYaTGW+nVWwq3ps5F8ncNszrRksf/jGaypSLom7mHsl+WGqKvJ66A4gCOWSCycqf++vvQmVVmC5DqxPYtgvtmyTAhoIMrBBHtPiRUSKn5e3fTp3upqwLnBDATTCn9Ny9dqruSY7O5HdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFEF3Ffn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFEF3Ffn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9D6C4CEE5;
	Mon, 10 Mar 2025 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628320;
	bh=wvk1HP28FPI4U953jmyNpVI/li1OwC/KRPumEY1akfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFEF3FfnxAUOKCiYHyo7I8xjm5qcafp1n57RAYaxUozNOFMYygcQ2w/J6KF+I9JQK
	 9a4+pNfoP+zlomL78uZBW8s1O/qmjkw4fzcHof1uDPIbkIGy+ofC5MOsdfewvu29ki
	 8yULip+LvmIUrqGUvuO6vdx0kTi3rP+0J1RxEInk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/109] drm/amdgpu: disable BAR resize on Dell G5 SE
Date: Mon, 10 Mar 2025 18:05:48 +0100
Message-ID: <20250310170427.719553177@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a28f7e0a27aaa..b41a97185823a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1220,6 +1220,13 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
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



