Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908B1DE88F;
	Tue,  8 Oct 2024 13:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392810; cv=none; b=V+AANtnAuTmlGCO2o8j85eWa/yI83crbApJQkYeEHYwgw5H4vZdafHccvBoMWKi+E40bvZUO9pEC6hQl7yCABf+7YptsmwMLsUC0i6wbTfr2qcAu1fK2IXMXesljpBR8+SvMm6kKLhRtjemiEvVptelItEvuafW46EaU9TLm9c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392810; c=relaxed/simple;
	bh=9FzyiAPmfy21hB91tHMPTtgeLRaHd0R468nB5CwsoLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1Um65Ik4iH1c/l2uEhypFZ+3uoXxerShkcO+WY0oh+jfBj+K4/xNoqxFm9EgzGWn70ytST0ptLsN3TFHRDtPaBUAmeT/mw+eKyWHo067nakQewX0YmGIuDlORzhI37T2wvPT/hcrG8b+NEYhaIK/LsxCgYLLbbe7OBOBCjUH4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZg2XIrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZg2XIrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46D1C4CEC7;
	Tue,  8 Oct 2024 13:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392810;
	bh=9FzyiAPmfy21hB91tHMPTtgeLRaHd0R468nB5CwsoLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZg2XIrLcP8koxyZ/PZTH29GemgnNRIRwiIsPanynZfE43c62lU0HRISlFNH3go2X
	 u4JkXM2VO6OTUnARbxrMdhwV9FZlZtzQl6RBT4pLCImFuhALYI+k6Glp0fZTs5fWO0
	 MJnSQU35iJODv5G6xSv3LpkgPc8udMDHrwN/UZ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 526/558] drm/amd/display: Enable idle workqueue for more IPS modes
Date: Tue,  8 Oct 2024 14:09:16 +0200
Message-ID: <20241008115722.928620306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit ef785ca7f7c80891580cafd36c8dd86375684310 upstream.

[Why]

There are more IPS modes other than DMUB_IPS_ENABLE that enables IPS. We
need to enable the hotplug detect idle workqueue for those modes as
well.

[How]

Modify the if condition to initialize the workqueue in all IPS modes
except for DMUB_IPS_DISABLE_ALL.

Fixes: 65444581a4ae ("drm/amd/display: Determine IPS mode by ASIC and PMFW versions")
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 181db30bcfed097ecc680539b1eabe935c11f57f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2005,7 +2005,8 @@ static int amdgpu_dm_init(struct amdgpu_
 			DRM_ERROR("amdgpu: failed to initialize vblank_workqueue.\n");
 	}
 
-	if (adev->dm.dc->caps.ips_support && adev->dm.dc->config.disable_ips == DMUB_IPS_ENABLE)
+	if (adev->dm.dc->caps.ips_support &&
+	    adev->dm.dc->config.disable_ips != DMUB_IPS_DISABLE_ALL)
 		adev->dm.idle_workqueue = idle_create_workqueue(adev);
 
 	if (adev->dm.dc->caps.max_links > 0 && adev->family >= AMDGPU_FAMILY_RV) {


