Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14062A1B;
	Tue, 23 Jan 2024 00:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971132; cv=none; b=CmtJ72vW0yIvaTjDj4HZI67th4+3oK42ZcOY3Z9GQ4b1gPxCJ1SDS7w3nQsA8nL3xdlbCz2hZ/HdVDDeIjZ6M7plGFfpbWTGfNNHii80OD5L4U1X8VBf0E1JRJ82C+6xV5Z9geiBXHMBpDA1sTAJ+i8mMWCBc2LCUBGx22hD3m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971132; c=relaxed/simple;
	bh=XaBA9RQxYyj8/3nLtHgvD/TbEhv+LAZD9hGcrCDkmXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da+kbOX0fwHHtkA3FAK3SSXHR1jsJJ0YWCrCG+LnqCg/ftLvUOUilRxL8boBnKQe7IA8m7Cz41ZgIqyDk9qS0vvqnOWilc1nh7GmeXOV04pOozY6yiLrROEM9aVMYvjVt0SjmfDNLT5RIysCZHjAwzDZuQHOll+Z5SqunKD02n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl1x3e1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl1x3e1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BF8C43390;
	Tue, 23 Jan 2024 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971132;
	bh=XaBA9RQxYyj8/3nLtHgvD/TbEhv+LAZD9hGcrCDkmXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl1x3e1OzlvFY0YxMqe1BtFjjK/w0wQogUi5M0j3y5PJujMm+gIGjuFw5uKu4SlT3
	 YzgS6BvrlFqnRg7+TMmb3RdcKyZOxmLvmX7hNq2av8WsY/d0/Wi9eS6B+ixR11n3XR
	 k4D8Gx+ENIAbXEWEZ5VRiJRL4uZTMgg5kGKwZh0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/417] drm/radeon/dpm: fix a memleak in sumo_parse_power_table
Date: Mon, 22 Jan 2024 15:55:55 -0800
Message-ID: <20240122235758.381190193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f74f381af05f..d49c145db437 100644
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



