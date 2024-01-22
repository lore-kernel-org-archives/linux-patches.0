Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88A12BF3D;
	Tue, 23 Jan 2024 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968959; cv=none; b=YQakehW2Cat/f0hmkVi12fSrVX3IZ7pzlgW7CX+jRrMkpALiU/yuidS9jjOG9OC71oHAfhvwK7Uj+BclWqdF6GdGlJuCoPSyQ+Dld3QQ07rF9hCnGXLaGN3Dy5pRfYOU7Prl9cB0hzoZAVI/veEFlEcJOLH2vU/a53MDSoRZ49c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968959; c=relaxed/simple;
	bh=5288CS8tZEB5iUmcpLp/A29fZn+P5uzAMTS4h/mxITQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNJcr9o6N/VXuoKIWnBiRAMRV5A2r8wZL+B2iflFZY7lTH74776kN+YJrHmvsMyAqCpAZnpgK8BnTo6MDEimrFjYbAmD7Q3zitdG5UYyhvUHvWl2HokjiiwffzH3sRW4LCi5IGjHPzIwmjRwtr2LghecmW3RnRj7amgoCqP0tAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCxvwRiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCxvwRiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A20C433F1;
	Tue, 23 Jan 2024 00:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968959;
	bh=5288CS8tZEB5iUmcpLp/A29fZn+P5uzAMTS4h/mxITQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCxvwRiIMNHneJhsjas5o8HBZks8z+7EKS83fHu92sl/YPzpbTv1m1+RyJU2LW02Q
	 x8LJxA0/f8wgeW38iQwERzn9K5dVjGCT0tqbEi0BkNoh2sryWqnTZBo+nDPnEBua+V
	 9WO1y7OPAllzB02OAnvoe378oMphCqB5pqH0vhMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/194] drm/radeon/dpm: fix a memleak in sumo_parse_power_table
Date: Mon, 22 Jan 2024 15:57:32 -0800
Message-ID: <20240122235724.458744393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 0737df9ed0997f5b8addd6e2b9699a8c6edba2e4 ]

The rdev->pm.dpm.ps allocated by kcalloc should be freed in every
following error-handling path. However, in the error-handling of
rdev->pm.power_state[i].clock_info the rdev->pm.dpm.ps is not freed,
resulting in a memleak in this function.

Fixes: 80ea2c129c76 ("drm/radeon/kms: add dpm support for sumo asics (v2)")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/sumo_dpm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/sumo_dpm.c b/drivers/gpu/drm/radeon/sumo_dpm.c
index b95d5d390caf..45d04996adf5 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.c
+++ b/drivers/gpu/drm/radeon/sumo_dpm.c
@@ -1493,8 +1493,10 @@ static int sumo_parse_power_table(struct radeon_device *rdev)
 		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
-		if (!rdev->pm.power_state[i].clock_info)
+		if (!rdev->pm.power_state[i].clock_info) {
+			kfree(rdev->pm.dpm.ps);
 			return -EINVAL;
+		}
 		ps = kzalloc(sizeof(struct sumo_ps), GFP_KERNEL);
 		if (ps == NULL) {
 			kfree(rdev->pm.dpm.ps);
-- 
2.43.0



