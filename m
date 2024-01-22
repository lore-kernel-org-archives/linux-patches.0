Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F0112BF3D;
	Tue, 23 Jan 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968960; cv=none; b=Sus8nE0DzX3zfMe5vmrk7SjH26bawnC8XwuBqhO9s7MNJ/Ggj7AAFSC36AYUmUkSU/RKFy6PojgXYfnhYh9BRVto9ZjB5c8wl1IyFePiXLtLgyBwEovJhON1zbiJesOaACCijNV9cZXl7DpRzAmjPOv/CB4EMh860FNjDJ1Xvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968960; c=relaxed/simple;
	bh=Ayl7f9uNjTZbA9YpIKv65asgryV5eS+IgRlbD9QmDDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goVWcN+GBzVgumGixpxyr8GRafN7zAxkhpB7NxhIhGAi0mzVOgPosp4M87ydfPrCtSR4plvv+cA2BVGUvg5l9kthoE3981ytMMD33ZDA82l/g4cMPV/IDRnrcTY1emgQMjBpufi32GdY7jZDxl7iJHQvgW5O5k8phz2F/fY2hv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btSsSAz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btSsSAz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C77C433C7;
	Tue, 23 Jan 2024 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968960;
	bh=Ayl7f9uNjTZbA9YpIKv65asgryV5eS+IgRlbD9QmDDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btSsSAz/ED0VQ7OVhyGVsvZT7F9dmlIl9/DTFXsMzljb4TCM8SdyO/GZ1aefN87jN
	 Wx28Q904oNJKIIAOm7hNhy6bM8QHdphKJdQwPKvBoLRaGjdMhWuIrQWZA2HtKbRfNw
	 ighSLMNF3/uWrAKh2aB+tRTY5MVqUsHmDErLcelo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/194] drm/radeon/trinity_dpm: fix a memleak in trinity_parse_power_table
Date: Mon, 22 Jan 2024 15:57:33 -0800
Message-ID: <20240122235724.505700296@linuxfoundation.org>
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
index 65302f9d025e..fbb93d0feb71 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1771,8 +1771,10 @@ static int trinity_parse_power_table(struct radeon_device *rdev)
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



