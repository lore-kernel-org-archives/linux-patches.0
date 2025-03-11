Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C13B25E818;
	Tue, 11 Mar 2025 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706345; cv=none; b=FiOf0hJ8bs4YWTmSGiJs7JNGYM3nxLAlIjA2JrhAbyXdMtwcogFIFH8qA3mFcd+Uo0f0jF4Igpf1T+QKd1VArkMg18DVxAKOIRJfmXhfug4hNhxuC9xfxpyTwScckpmvZb7z1ZLM1ICH74wqu8XMbDfahDJST6I48hSNiKRBlKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706345; c=relaxed/simple;
	bh=PxIMEXPdxXbpaqg8LxpCWR3rIbqw5WjISDVkjPy+M80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIKMAdhrj9P9pblqipVYo0gSULc1/bLGwr0yM01lvg5hls7f+XZweuekX0T6VcGX+lEQl2TCYjrExrfLRDpO9D0tdxnwb4+mwY6wQq4AOwuz7iAMFhgB5aWew+QyBJ1RtTX/R2Esz5Z6MIyGComPCkWiojOn6Rfai9z2j6dINV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi4Mr4lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi4Mr4lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3041C4CEE9;
	Tue, 11 Mar 2025 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706345;
	bh=PxIMEXPdxXbpaqg8LxpCWR3rIbqw5WjISDVkjPy+M80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi4Mr4lAwa74hwWAJ5LK07fqVNyUketq3bpFcJu8ZGdPKJ/JlOm7zoowLfEasbJhc
	 7Dh1o6cS5LvUbOx1HdaFCnnKrgPOfgMGhkYezUJz0uhxLEQg04Bv6s2GcNBfxuPEFo
	 r40J8LZVo/p6M0Md1i1ZBZOECX+PaCUSt+UjrRSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/462] drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table
Date: Tue, 11 Mar 2025 15:54:35 +0100
Message-ID: <20250311145758.720145614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 165af862d0542..04dbd9f89a45d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -1370,6 +1370,8 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
 			GetIndexIntoMasterTable(DATA, SMU_Info),
 			&size, &frev, &crev);
 
+	if (!psmu_info)
+		return -EINVAL;
 
 	for (i = 0; i < psmu_info->ucSclkEntryNum; i++) {
 		table->entry[i].ucVco_setting = psmu_info->asSclkFcwRangeEntry[i].ucVco_setting;
-- 
2.39.5



