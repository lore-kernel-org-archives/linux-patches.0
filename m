Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05FE56329B;
	Wed, 30 Sep 2026 17:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790424; cv=none; b=HqwyDxcKCk7gFrZ+HnFjNjE/x7N7/LukFR52pqW9iNVNwb+kpBHwchpeUviRPEqC8+S9wqgvtw+MRTrLVeqf2PuoL/zvWoEbwcUwY11gh08IsZXXXX0+rWOXqwTfuQLh++fbY38zO7ckAWQZh99V68jjPetcnovgVgrmszyMIZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790424; c=relaxed/simple;
	bh=D99Qv/H4UE2K93/ZJh7TJXMexGLateBNGEkQ1oAy9gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoGSnsYD9AEgQ/UjMW1th6BpHHyonaD5SsB/EkP05qazN2GEKAZ2b03iq9ERWq++O8HpUwHuPex5sHm2SyHWCOboYVYy5Whry6v1+w7eUKl6qA1vknkbjhdGXK/PPm4pPCNMJRV3UiJCPoeseeK+ur+zoX+FLJZ6tpg/FLVW9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytBQxuvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytBQxuvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B691F000FF;
	Wed, 30 Sep 2026 17:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790423;
	bh=LTJ047eb9tjWCMYl+2JymgSAt7Fy/Ph2QHU2LDLkCnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytBQxuvvlGD99qACFiAGpukVzb4OPsvGGbldMMx+I+20yP/qSYWUaq4wOJR8T0Yq6
	 /Pggp9d5uqUtd+eIWJZceQofOtAlL3uA+UPN08DRQVsf3JTqhQrFhaLrdq89jKCSqK
	 +kLx9osFPc9oDOcOQrNOvuHPnLzXNsjGMF4p75XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 822/877] drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()
Date: Wed, 30 Sep 2026 17:28:53 +0200
Message-ID: <20260930152432.466672512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a997baa61179b450bd55c4810c7ccfed3b753a54 ]

amdgpu_acpi_enumerate_xcc() looks up each XCC ACPI device with
acpi_dev_get_first_match_dev(), which takes a reference to the device.
The reference is dropped with acpi_dev_put() after the XCC info is
initialized, but if the kzalloc_obj() allocation of the XCC info fails
the function returns -ENOMEM without releasing the reference, leaking
the last reference to the ACPI device.

Drop the ACPI device reference on the allocation failure path before
returning.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9211ef48b31ec66999cf55e04d0cbc60cd855fd5)
Cc: stable@vger.kernel.org
[ adapted the hunk to the existing kzalloc() failure block with braces and DRM_ERROR() logging. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1114,6 +1114,7 @@ static int amdgpu_acpi_enumerate_xcc(voi
 				   GFP_KERNEL);
 		if (!xcc_info) {
 			DRM_ERROR("Failed to allocate memory for xcc info\n");
+			acpi_dev_put(acpi_dev);
 			return -ENOMEM;
 		}
 


