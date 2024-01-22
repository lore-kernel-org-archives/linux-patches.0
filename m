Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF83C3F;
	Tue, 23 Jan 2024 00:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969551; cv=none; b=E/vk+78iJfK1SNL2yBdayrEQ4WbxOnPrxMk5AanHjIzQvd17OGX5wBmB01gySNtRn9Dyfq6uPB8uAeEcsk/cUM7jlW77mFuMXiF+fP+JPh1pHZ92fkBo1H/m3AG3qMPezMGVT1QNhpsF/L/N6StEx+9xQy/b8MwtvE2iHwqVjeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969551; c=relaxed/simple;
	bh=Qj17u9nWe8fYn4ZW2NtmDPQtdSbPWyRCUyIvmjCUBV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNgrY3RjU+DUQyOq4pqKUnMnpS0/QGj0tHUJT+gTuh7YSaHiN71SnkEO7JJfmgjwe/rCrbDzm7yz/3E7v3n5XwFQfx8y+KWD5FzaetCHNW0nRUq2SHW8v7MoURC4gtvEcOYWDsQRSPLTrR5Pbm9i8+UiEyOvRtemMQnNtiPGWEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuHkVYZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuHkVYZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED49C433F1;
	Tue, 23 Jan 2024 00:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969550;
	bh=Qj17u9nWe8fYn4ZW2NtmDPQtdSbPWyRCUyIvmjCUBV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuHkVYZmOrMop/oHfUG1KVq4lng85b2pb8wLOsEdCggnaiPWP1P2yQ9CKN+7UnZln
	 utkkJ5DTiSgpxlOtGBpb8dsHWImBM6Nqzu7faSF2sINjEcH6ZCJh5vi+b8rb0IdMOd
	 npsJZBZWxjwLBmg7RUcKO9WeEVfmxXlsYVM9SOc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 296/641] drm/radeon/trinity_dpm: fix a memleak in trinity_parse_power_table
Date: Mon, 22 Jan 2024 15:53:20 -0800
Message-ID: <20240122235827.162041236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 28c28d7f77c06ac2c0b8f9c82bc04eba22912b3b ]

The rdev->pm.dpm.ps allocated by kcalloc should be freed in every
following error-handling path. However, in the error-handling of
rdev->pm.power_state[i].clock_info the rdev->pm.dpm.ps is not freed,
resulting in a memleak in this function.

Fixes: d70229f70447 ("drm/radeon/kms: add dpm support for trinity asics")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/trinity_dpm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 08ea1c864cb2..ef1cc7bad20a 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1726,8 +1726,10 @@ static int trinity_parse_power_table(struct radeon_device *rdev)
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



