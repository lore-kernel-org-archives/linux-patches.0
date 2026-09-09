Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B98930C161;
	Wed,  9 Sep 2026 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963320; cv=none; b=XaorlL2EvpZP0ioQkHFH6TqKpT6+wtO/Ti+SlwBQJisJVlE0Y9QHc8j29AFRT/WyW6Knsu6YnXBHiNbrcrdiFxn1JsoAci7JzVfVIOA0/+CGw/whuXthS2iu54z2FWgFYJ3bGNV86xgyEnOnz9rer0bpy3scf87sVFVlpuiY3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963320; c=relaxed/simple;
	bh=7Xes/GoIcqW8vxQ6oFZ3QxsrUCke0uFKqfTD9f9CYak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU/YVeHQ1p/jtT9yDbPMPk14zclhxT2f900YLjcx6q8OLOW8km5Asdc9h2AdETwiGIgd+ki4VRvHcJ8Z5zNfh8uR+AccLyYbkS2bREhHGNpmovLwQt06Jecw5E5EG3X/0Fn+zF9N60SLqGomuZ22zhlKjUIZPl+F8jrwKBygKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN3U6YUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN3U6YUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966AF1F00A3A;
	Wed,  9 Sep 2026 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963319;
	bh=kfovSTbVQTLuT7qVHfqickOvRv7QC2X75GaAz1zgtec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cN3U6YUIZVqLDomFWdPi63hYa1cQnbpepVAa1z5QD5k/4A4w4nriSBbabdWfL4mfb
	 e7jGsFdT2KUYnNFSGjXSWkfl1DusubYq0r8mceTF4FCj1aE9d33VpwAYk1CRn9NzDQ
	 8cg1NhnJFslFqOFGxeS4BQKZaflfuEwaPWnV+NPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <Lijo.Lazar@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/583] drm/amd: Drop calls to restore power limit and clock from smu_resume()
Date: Wed,  9 Sep 2026 15:34:53 +0200
Message-ID: <20260909134238.087352340@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4b6ec94fdae2407d9b8e69e3ec5f879e72ad667e ]

User requested power limits and clock settings are already restored as
part of smu_restore_dpm_user_profile(). It's unnecessary to call the
same restore as part of smu_resume().

Revert the following commits to drop that extra restore:
commit ed4efe426a49 ("drm/amd: Restore cached power limit during resume")
commit 796ff8a7e01b ("drm/amd: Restore cached manual clock settings during resume")
commit f9b80514a722 ("drm/amd: Only restore cached manual clock settings in restore if OD enabled")

Suggested-by: Lijo Lazar <Lijo.Lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 53d071eddbf44..8473eaac1e7fc 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2234,7 +2234,6 @@ static int smu_resume(struct amdgpu_ip_block *ip_block)
 	int ret;
 	struct amdgpu_device *adev = ip_block->adev;
 	struct smu_context *smu = adev->powerplay.pp_handle;
-	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 
 	if (amdgpu_sriov_multi_vf_mode(adev))
 		return 0;
@@ -2266,18 +2265,6 @@ static int smu_resume(struct amdgpu_ip_block *ip_block)
 
 	adev->pm.dpm_enabled = true;
 
-	if (smu->current_power_limit) {
-		ret = smu_set_power_limit(smu, smu->current_power_limit);
-		if (ret && ret != -EOPNOTSUPP)
-			return ret;
-	}
-
-	if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL && smu->od_enabled) {
-		ret = smu_od_edit_dpm_table(smu, PP_OD_COMMIT_DPM_TABLE, NULL, 0);
-		if (ret)
-			return ret;
-	}
-
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;
-- 
2.53.0



