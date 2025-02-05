Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C301487DC;
	Wed,  5 Feb 2025 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763636; cv=none; b=pYVR1bbzrqALsaB1oKTrV2H3jW7muyg5Fnmywq8WxxBIl7MJYF/pQCNbW8gI6cwCZaC1xGGlwqC2RWT6XXmGhHtOYqTaAth5XzRFcWIto9Rrbm7swP8PIYciB13F6lINd7OVrX10esdHajM+vEHUb89YmW57dtvF9Ua+PknnKvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763636; c=relaxed/simple;
	bh=39j5r/CFoEFxtSVTOKmu/yWtrXJDI93qvBBH7JfBvLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM4fenr7zSQOCHo1LA84xHKCNUCTfFgyQf3OHCHbAVE/qhAgRQjJfHzJzlwvkOo7qHOXy3bDOhusfs5SXP8kkKKcaoljK+gpeUZzM5fcObw7MNUOew8DxWh5y5b02dSajMVR6jglgQQFB5Wu1y3kr3ElXGAhHSyNbFQHjyjwSyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW7YO6VS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW7YO6VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25A8C4CED1;
	Wed,  5 Feb 2025 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763636;
	bh=39j5r/CFoEFxtSVTOKmu/yWtrXJDI93qvBBH7JfBvLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aW7YO6VSAeNEIm5z4qTjdm8/lEtsA+k2JwcdVO559jsijDxuDFIWqtQrkAq36RhbM
	 pkbGjWgDQsxNxIvAtakwJxBxwzF/ibxY4AtI4+eMTRq8UEeI1KGuZpo69wdoC9O9za
	 BrSocHWA/JEF3+qDTkd/k4GRXq9RD5hL7DkeDTPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/590] drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
Date: Wed,  5 Feb 2025 14:36:38 +0100
Message-ID: <20250205134456.900499377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b56298d9da98f..5c54c9fd44619 100644
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



