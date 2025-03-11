Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95DA25DD07;
	Tue, 11 Mar 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705364; cv=none; b=BOpwA10cJW7wSe22rBrWFgHg/XfN+0VLjNGFuvLrPPe/tJDFvCmcQgjltUTCuK7RzAu/GjmZIvMVuFJNOwcL6oE9JBVDVbz+u9NxM5j/9lyIL4dLTCE9d8QPsevfSIvGk9S0ERWlscyVIlhS8NIFht6/mu4v25dCpKwhBSPO3sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705364; c=relaxed/simple;
	bh=WbM7TUsVyKV2yXyqXp0xhwbpHn3dYfAozCE6k5BMOh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0e57IbHE4Ak33CXhxnZ8TI+mejI30IuENfBm0nnn9Zeoi1Dqwd/drplB1koMLgE4Xx+4cXexVkKkJM/9+QwWPW3IfuM/kr0afSZcbQjVqkdjR3XS6XT0vPwn/4FACA/U7d3CH7Bec1td8wGQjWwA8SUmxktYLgKs5C850Rxh1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBWh+qS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBWh+qS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B673DC4CEEA;
	Tue, 11 Mar 2025 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705364;
	bh=WbM7TUsVyKV2yXyqXp0xhwbpHn3dYfAozCE6k5BMOh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBWh+qS3fAkwnFQApeRPI0GqPTmLxJyJn0Higmt5xSupGv68GF8+7D1ZX98CemY/J
	 wWzESn+0X4cyL8KzeHeBot+00V460Hjgkv8BhUHg6MBvWXCtu+R+YoiCPV5NTpu18m
	 Q77AIKmr0SjDMt+oRJr6v31z/QLD2NZQ67o6+3ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/328] drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
Date: Tue, 11 Mar 2025 15:56:20 +0100
Message-ID: <20250311145715.286988343@linuxfoundation.org>
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
 drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c
index 01dc46dc9c8a0..ec680695ed03d 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/ppatomctrl.c
@@ -1369,6 +1369,8 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
 			GetIndexIntoMasterTable(DATA, SMU_Info),
 			&size, &frev, &crev);
 
+	if (!psmu_info)
+		return -EINVAL;
 
 	for (i = 0; i < psmu_info->ucSclkEntryNum; i++) {
 		table->entry[i].ucVco_setting = psmu_info->asSclkFcwRangeEntry[i].ucVco_setting;
-- 
2.39.5



