Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CE83C09EE;
	Sat, 17 Oct 2026 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258248; cv=none; b=UjVxSYpsVg4BQpt5Hl8mBx9ywi2StFKK/nzXr9S3TNRbDlU09Ba41ZOZP/tWJr2cAcIPeGNmg5xeyrpfubD0sHmlBYVjY7rMb/wKzPYBmktmRPw7Jg7kNP3r1piogZzMH6klRckmvp4ETilhNr9lqhaaYPnUpeHLAz0ORomX5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258248; c=relaxed/simple;
	bh=S3MNIhflKLLDiZTUzm9QLUo8J7NFazMpqoqD+bz/me0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIQ0oIPKL+9YHby8ysruV+ldJM6zQGCa4YodHx+935XdQAmXozTzVt8IuN2va4L6d7R6SSawROfeQDWAJX4UEq0/kOumfM9yrCj6rvl4g+18+i3dWfcf7N4i5ZFF2QecGLFDOprczu9NTedYLj4pPpF37rQC4r7+0sUnXDpkXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6J92U7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6J92U7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DFF1F000C4;
	Sat, 17 Oct 2026 17:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258247;
	bh=LKpywQi/xm3GO4IgUYbtBTrulXCyG4sKud4Bv6Hu/0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6J92U7n7Np52NtumkdMT9+WPsWWElQ9kvX2i6wHewM2XVPwa94CaWPPznywbOxoj
	 uAtGKLEZQLNTVee/Ps3EWaKnAbFZCUjpk6d9DrSACbS3dHQZ5mp4nshhFEoeEdgr7L
	 kYk5CWDv857AWqO8Zi4diHy0DE914/81hKScH8l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Zhang <guoqing.zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0821/1674] drm/amdgpu: fix gpu page fault after hibernation on PF passthrough
Date: Sat, 17 Oct 2026 17:51:33 +0200
Message-ID: <20261017160452.201881744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index 7fb6350b125b1..5989264913e51 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -513,7 +513,8 @@ static int aqua_vanjaram_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
 		return -EINVAL;
 	}
 
-	if (adev->kfd.init_complete && !amdgpu_in_reset(adev))
+	if (adev->kfd.init_complete && !amdgpu_in_reset(adev) &&
+		!adev->in_suspend)
 		flags |= AMDGPU_XCP_OPS_KFD;
 
 	if (flags & AMDGPU_XCP_OPS_KFD) {
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 1164937e8d20b..c7b868c8fa172 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -1948,9 +1948,11 @@ static int gfx_v9_4_3_cp_resume(struct amdgpu_device *adev)
 {
 	int r = 0, i, num_xcc;
 
-	if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
-					    AMDGPU_XCP_FL_NONE) ==
-	    AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE)
+	if (adev->in_suspend)
+		amdgpu_xcp_restore_partition_mode(adev->xcp_mgr);
+	else if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
+						 AMDGPU_XCP_FL_NONE) ==
+		 AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE)
 		r = amdgpu_xcp_switch_partition_mode(adev->xcp_mgr,
 						     amdgpu_user_partt_mode);
 
-- 
2.53.0



