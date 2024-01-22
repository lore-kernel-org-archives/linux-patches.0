Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6743514830F;
	Tue, 23 Jan 2024 00:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968388; cv=none; b=JGXde6J2J/Pa1JXqGuHWH9K8f2F4AUAdgSotVKMPCO0WsYJONozFqbgczSWiiRLPZ4bt/AkXz2kcDA7/w5XbvZHZMzIsMwlF/Jc6WaVbnTDeIi8Ed6Eid5C5MkBkHnq8lA16FpYRqFM+c8Kuh8KONF3zRpLfy4xvMx+cDFXcPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968388; c=relaxed/simple;
	bh=qvZcMztYeRBU49SU+8PldygT7O2hyYfQkepP0VF7WJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWCtdz7vzcUGAikYt5kcQ82JzR6B7Y+zHkqxhg7bd+NU8/sCCtGtHUl92leVRYfHgVioyrlgaBSOy2kQVrF7HggKbvuKNM/9NqrZTWMBPtk6QNH2/VfJdJwvN44pMLEaUDJesdEWxCjDljxVyJQ9rXZriDY97hZ+jAiOc1qNdRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt7San1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt7San1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B823BC433F1;
	Tue, 23 Jan 2024 00:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968387;
	bh=qvZcMztYeRBU49SU+8PldygT7O2hyYfQkepP0VF7WJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rt7San1epHBEvv+Rp4zerflxaK23cA2a6skyXoNMjfrzH07dIjzcYzSJnd/XUZKsY
	 arL7pccZY460T0Ojp4i2tCk6/8TVJ6h9NnB8AOihAcq+g0Vzfdb7hAhzB6cMx8hQ+C
	 4EkovA0EuyfhA+8jVqRC/+eXk2mtMJBytYxFw9Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/148] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:57:28 -0800
Message-ID: <20240122235716.109475148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 644ddd8d65ad..167dbcef0c38 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3612,6 +3612,10 @@ static int si_cp_start(struct radeon_device *rdev)
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



