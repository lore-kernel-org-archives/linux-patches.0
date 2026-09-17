Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0202C4F93DA;
	Thu, 17 Sep 2026 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664275; cv=none; b=Q6Vqhfgi+VPNuDzHJ/78WdlHguEvfz6raKY9vhzSQHDmJzQqkicqw0rWWewrewHmnUXi0K4nmWwMAa6+NTtLeeHHKFTPdj51qza8VvZ7U/WyA63C+hVGDzuzaJCWqRMeFa4ogm8+3c/j6rcS/zkMHS/mTR2ESFORmXEp5ptFD+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664275; c=relaxed/simple;
	bh=PvgkBEvPrtMitndb7zG5A/q9vgf5GmsLaiGfQEwNKl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIxNGhwwcHNLlIdLqn6H4KNKyCgJAwXKeuA3o4HpPU+35i5z+CIVXMhFt4llLV4/THFCiXWhR1uXb4k5JZTurd0T0/DuZEzJm/Xwg2RZJ1+ZDFNI/tnvNW4VB2oB+I4lu8ERf2Y+TCwxEgPKU0ONlIcVjz5Tb+8dmK5fbbX2yro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vot2i1aI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vot2i1aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B13C1F00893;
	Thu, 17 Sep 2026 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664273;
	bh=FLL8rLXAC0Jh6NeJq6d/HxduvsnuiXArYRmTrOe9UEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vot2i1aIvypYSXr5+rfkpln5ennN/oju+LrFeAL6XT50MfeYeSPzHFw+MrUYIF3jG
	 v5WlyqR6AVOuhb8VEhXfZ2J2oSTD2810mij9HC9Q95njypuMZTuXbtaOeC520rRdDV
	 365okwMVb+ysPhHn7sUsYjFyZm9BHJtjJkgcy4Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0317/1250] drm/amd/pm: bound pp_dpm_set_pp_table() memcpy
Date: Thu, 17 Sep 2026 16:01:52 +0100
Message-ID: <20260917151600.696675895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit f193e71fa9fab2e68ef85201b106e8f580d3a25b ]

The powerplay path allocates hardcode_pp_table once with kmemdup(...,
soft_pp_table_size). memcpy(..., size) used the sysfs store count (up to
PAGE_SIZE) with no upper bound, causing heap overflow. Reject
writes where size exceeds soft_pp_table_size.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index a16fcca3576c4..5e197c463ed96 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -668,6 +668,9 @@ static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 	if (!hwmgr || !hwmgr->pm_en)
 		return -EINVAL;
 
+	if (size > hwmgr->soft_pp_table_size)
+		return -EINVAL;
+
 	if (!hwmgr->hardcode_pp_table) {
 		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
 						   hwmgr->soft_pp_table_size,
-- 
2.53.0



