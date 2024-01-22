Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18515BAD4;
	Tue, 23 Jan 2024 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974354; cv=none; b=d601IkT6FmF3d8nmRu1EwRsHcjIlapvqbw2JzkQfWDpL5P2ag2ObpUqu5J7FH4ZyyUwfC8bHiTxgsJ6eutrdbGStROzFcCvDckM7wEqClSewUbdwXGG34vSL5i/5x4aY6hihtODDXuyqtFhyEm1olqy40z5W3pIVWiIGtSyVxf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974354; c=relaxed/simple;
	bh=48fK7Isn32jsFUWHkVOxxaPqAyi7JG/SdbLpXKMyagI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLxDojyPwefmCxDd2pxI/LmgNJrLDkOnVMNT40JXgFV8Ghaz8vaiVmwEoaooq0BNDa1pUNxTFPyHi+AvC/G3+GhIaM8S6K6qg37dvn99Ials47I6be+boem4QN0RwxTjd/abr99/GZfvfPNl7yAVudYo7r08RB7R9Pml6DbApME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eloXQoSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eloXQoSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94692C43390;
	Tue, 23 Jan 2024 01:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974354;
	bh=48fK7Isn32jsFUWHkVOxxaPqAyi7JG/SdbLpXKMyagI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eloXQoSKeOEbOuvFLBvGB++IXx0nS60ZCy6qg+xSN9K8DHPe+/Peok6E0mCpz3xVz
	 hn5YBWyXWvFeo9HA2laTZ5I0queTwMuPvpIu6LYrvj/utKvxDXmC5F3UuXcDw7yEav
	 1rd0wl8EHJN09Vh9CC8WaHXkxkVX4xKsvlsHK4O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/374] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235751.192997850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 71225e1c930942cb1e042fc08c5cc0c4ef30e95e ]

In the unlikely event of radeon_ring_lock() failing, its errno return
value should be processed. This patch checks said return value and
prints a debug message in case of an error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 48c0c902e2e6 ("drm/radeon/kms: add support for CP setup on SI")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/si.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 4679b798a038..e4481e5a15e1 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3611,6 +3611,10 @@ static int si_cp_start(struct radeon_device *rdev)
 	for (i = RADEON_RING_TYPE_GFX_INDEX; i <= CAYMAN_RING_TYPE_CP2_INDEX; ++i) {
 		ring = &rdev->ring[i];
 		r = radeon_ring_lock(rdev, ring, 2);
+		if (r) {
+			DRM_ERROR("radeon: cp failed to lock ring (%d).\n", r);
+			return r;
+		}
 
 		/* clear the compute context state */
 		radeon_ring_write(ring, PACKET3_COMPUTE(PACKET3_CLEAR_STATE, 0));
-- 
2.43.0



