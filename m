Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D49B146A63;
	Wed,  5 Feb 2025 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763444; cv=none; b=FvwCm4dwPNSZQqURF0VvCpUkq7FjcT/k7W/+GVFuYpv6LGa8Z+Xy1VrxN+1CYOAaqzcsk+XQFQgrlb6vxcPuzyIZqjSh+3dK1JmLU2I3J71Pt1d+gPCXLVWueEx9IshIRhTvoDWGGlMiDwJ/KpbIka7PFTpMFwet2SkzW9eBoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763444; c=relaxed/simple;
	bh=RMk/oFScoXX337VGNpBgNiPlbN7v1DqoGWDyIK8qEdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcuU8XhA2KMS1jowOjqZz9FQPpjU971Phn+2ykn7Q0nb/pSw6BKmAK5EP+uS9+o0YFgmATZ0qIoErR6cqT8kbnign6X0mnEEDOlhiixCNQYbcNtckmaZNk+eSKiIsT3fIzfvIIBudKtB5MQ/LR9qyI9R3vJsBdqJGjBGM6NU8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3bxYfPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3bxYfPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA0BC4CED1;
	Wed,  5 Feb 2025 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763442;
	bh=RMk/oFScoXX337VGNpBgNiPlbN7v1DqoGWDyIK8qEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3bxYfPBozl5zTTXX5LyeXNQEWgxV/iIZzbn2qaM3je/dqKMu/CyITawXHSjtKYce
	 Ilvdca8FWZpiAMWJGGpIQeII4Bu4pWJ6rQowuAMYVaK3lbILwsUe8t2lgqzN/WD+ye
	 tXDX9EUtmQeJf+5xa3ut/4e3rO62vM5mLRnIth+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/393] drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
Date: Wed,  5 Feb 2025 14:39:05 +0100
Message-ID: <20250205134421.301643375@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 357445e28ff004d7f10967aa93ddb4bffa5c3688 ]

The function atomctrl_get_smc_sclk_range_table() does not check the return
value of smu_atom_get_data_table(). If smu_atom_get_data_table() fails to
retrieve SMU_Info table, it returns NULL which is later dereferenced.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

In practice this should never happen as this code only gets called
on polaris chips and the vbios data table will always be present on
those chips.

Fixes: a23eefa2f461 ("drm/amd/powerplay: enable dpm for baffin.")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index cc3b62f733941..1fbd23922082a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -1420,6 +1420,8 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
 			GetIndexIntoMasterTable(DATA, SMU_Info),
 			&size, &frev, &crev);
 
+	if (!psmu_info)
+		return -EINVAL;
 
 	for (i = 0; i < psmu_info->ucSclkEntryNum; i++) {
 		table->entry[i].ucVco_setting = psmu_info->asSclkFcwRangeEntry[i].ucVco_setting;
-- 
2.39.5



