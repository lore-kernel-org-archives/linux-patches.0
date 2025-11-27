Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E63E28D8E8;
	Thu, 27 Nov 2025 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255468; cv=none; b=Fe9xPz73j2uEZTq84hDgHgP3k4Zms7/0tprjkdsIemkeGh2qOqPFU/tX+hM29kCia8iQUmFwnK/0+3S7CLCvx5AeKJ06T79vG9W1NEXGHCbMVKouq42Bxsd2jlm55MpEryK/8zko8v8nqtPGhkwMCHR1VR5xD5Q/Kp2BxIPIC70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255468; c=relaxed/simple;
	bh=1yUw7B70uPHbbewvORd5smALCXpkmjzv92JfAjkx+ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE+2xJ6eBpLlRaTBl7pUzSSHkeKjxzZvghozk9JuqfiBUvNFmsc5fPyucLcJizC1Anm9r0m/UFN7UU9VXEflsTJ0TY3XNYk+5lEy4CfMwKaED8sABC2u/fCgZmwUY61Qd6TDl61hl2E+f24nU8xa5lNmYN9OAQ83f6WraXV+PWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ie1Er+k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ie1Er+k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B16CC4CEF8;
	Thu, 27 Nov 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255467;
	bh=1yUw7B70uPHbbewvORd5smALCXpkmjzv92JfAjkx+ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ie1Er+k/UZYBirpkw/2SMdQcMXIv8Q7h+/C4ngtszneCFou6DHEU/Os6Z/cOWbWgu
	 8fCqn4/CjtkGTo0Zdz5TJOZa3PNjbaUE36ZEU3CEaWMyJJPITyUp4cxxwJEVbhT1S7
	 hgTWu0UReLqt+SULygdsIXXodJGb8VrQ1/ukm79Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Zhang <guoqing.zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/112] drm/amdgpu: fix gpu page fault after hibernation on PF passthrough
Date: Thu, 27 Nov 2025 15:46:43 +0100
Message-ID: <20251127144036.538409778@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Samuel Zhang <guoqing.zhang@amd.com>

[ Upstream commit eb6e7f520d6efa4d4ebf1671455abe4a681f7a05 ]

On PF passthrough environment, after hibernate and then resume, coralgemm
will cause gpu page fault.

Mode1 reset happens during hibernate, but partition mode is not restored
on resume, register mmCP_HYP_XCP_CTL and mmCP_PSP_XCP_CTL is not right
after resume. When CP access the MQD BO, wrong stride size is used,
this will cause out of bound access on the MQD BO, resulting page fault.

The fix is to ensure gfx_v9_4_3_switch_compute_partition() is called
when resume from a hibernation.
KFD resume is called separately during a reset recovery or resume from
suspend sequence. Hence it's not required to be called as part of
partition switch.

Signed-off-by: Samuel Zhang <guoqing.zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5d1b32cfe4a676fe552416cb5ae847b215463a1a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 3 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c    | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index ccfd2a4b4acc8..9c89e234c7869 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -555,7 +555,8 @@ static int aqua_vanjaram_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
 		return -EINVAL;
 	}
 
-	if (adev->kfd.init_complete && !amdgpu_in_reset(adev))
+	if (adev->kfd.init_complete && !amdgpu_in_reset(adev) &&
+		!adev->in_suspend)
 		flags |= AMDGPU_XCP_OPS_KFD;
 
 	if (flags & AMDGPU_XCP_OPS_KFD) {
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index f27ccb8f3c8c5..26c2d8d9e2463 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -2297,7 +2297,9 @@ static int gfx_v9_4_3_cp_resume(struct amdgpu_device *adev)
 		r = amdgpu_xcp_init(adev->xcp_mgr, num_xcp, mode);
 
 	} else {
-		if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
+		if (adev->in_suspend)
+			amdgpu_xcp_restore_partition_mode(adev->xcp_mgr);
+		else if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
 						    AMDGPU_XCP_FL_NONE) ==
 		    AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE)
 			r = amdgpu_xcp_switch_partition_mode(
-- 
2.51.0



