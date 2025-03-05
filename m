Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3562561D9;
	Wed,  5 Mar 2025 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198722; cv=none; b=U4MD5lTvIjdiApco1KIPTu/RZxkRxUp0KOsFPM09ViSlOKkPYFcuEbCCl5m11iVZ83pIxPtIB+q3LBsjEIpZ6UQ/1MjwEP3eZ/ANtixYPBltPGqXuKxP4wwDAiWJR6J8IfLKy3AZVvvmXeKM2JWFi6I0kGRPeY6ASEHvYGZJMtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198722; c=relaxed/simple;
	bh=s8CtKQBLpd6zaTNhrPdVr048Hd2Vm69caznVdJG362w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr4dL45+Q7V3lGgAJv2ozs0rBObXIWj7mZ06tIfyjeNsWffeQWi8BFwXPHATI84mKKEeWI/ofzdOkEui5kE2rkNHjY+RxVFqLwXq1Xq5AcZ08JpXtEjrmVyGKwTVsshVn0nXW33G2L6sggIWDqkBP/OrwzDW4br6lWUNoBbch18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvLa9xft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvLa9xft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11093C4CED1;
	Wed,  5 Mar 2025 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198722;
	bh=s8CtKQBLpd6zaTNhrPdVr048Hd2Vm69caznVdJG362w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvLa9xft91fxqVecWhkvaxj8aSKJ+fP1QZWPAxBGWTcLENGz1GlyBBji4ZI5j9kGk
	 XMEjEv0fzeAb6bbsaMbEma+IjGQC0B3hR6F4UOmFPeQBONjAdqIfzLjmd4uZZsWxuI
	 X6lPYowRQU18ff4V8IV4sTqfugItHUeXatjePwB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 094/157] drm/amdgpu: disable BAR resize on Dell G5 SE
Date: Wed,  5 Mar 2025 18:48:50 +0100
Message-ID: <20250305174509.091869766@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 099bffc7cadff40bfab1517c3461c53a7a38a0d7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1635,6 +1635,13 @@ int amdgpu_device_resize_fb_bar(struct a
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
 		DRM_WARN("System can't access extended configuration space, please check!!\n");


