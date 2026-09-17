Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7DF49D5AF;
	Thu, 17 Sep 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667827; cv=none; b=YhtVEUvzmlzmMaAXaRZAtZB6pvgCD1re6l4gKWKlS9WdxApXcreTmM59hXUAs1PvhZm/UkqrOY02NFhiX18+LxebMaMnCepWamvWhXOMa1vAd+06GbY9ZzI6+tJXRoboWBwPfxA+A6uJgMM0+aVl7g6QpKg2XVJLLoxC30IWTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667827; c=relaxed/simple;
	bh=LSnB5Foa0BK944VyDvSq0sQamkro5rnmUeMWFqxXY58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2yfKwB8ujGUcb+xg7uEMvN4nP66iyy9rYcbFL5dLKL6w1ZF6c6THkrUlLGOZ06cuHxDzlTCofW79EnZamyvh2yMPp7OsxjDv9fS4YujNdFVRj60YJJIAjn1fmwpTTAwsROC/H228C/EStTELFxNH9qgyTbU93nRx7YZg/i1/gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWeLAnov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWeLAnov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3129D1F00893;
	Thu, 17 Sep 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667825;
	bh=8JgHMq71OsBdMghpPIPR1c7m3bKgF8HsgPcnVghhsTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWeLAnovPQU/+cF9LvkvaOeiPq69vfC6a/Ju9pdMn5/UJLGEuDlaZCstuUrr+ClUF
	 Q99nENjAZsm4CbjuB6o+z/IzhYA4zKLH7ic++KHvBxY331fAAq4hdKMdecuHAU2tWk
	 nHPKIxbXD8wYMnh/ndqkVHYt/+ZajBy8PFfewakQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0223/1102] drm/amd/pm: bound pp_dpm_set_pp_table() memcpy
Date: Thu, 17 Sep 2026 16:02:46 +0100
Message-ID: <20260917151545.178897085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 32839355a1845..ec4d070d49141 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -684,6 +684,9 @@ static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
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



