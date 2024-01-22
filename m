Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1999A12BF3D;
	Tue, 23 Jan 2024 00:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968945; cv=none; b=uZtaR3XhkAXTRSTwpy2TnQgubejt9nwbjrZKGXGjj7600POULrVxXr7iEXcdKwDbzQRhH9xeZtkNl4s5U3ASao1CH7Tq/8pHs8YQQjdQ/xaXYP/NlCl6EsvNw5OR3HbXatrLPYSQCgdkwmY9yZ/ciuvrTxlDbocHuptgDcPtZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968945; c=relaxed/simple;
	bh=LXjY2rlMppSROa1FDIlm/5jtj88MbOkkdAxR9vMw3sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4voec59QFAy6/WUwu4X3Zg2Vlk2oQvQRJfnKFhk0T0jATet4m+W4x4mZwpDEzH/dCxdfcbXA8zKaK6wXa924BCjvcnlZSGlHpSDLY4r5g58k2kqdrI2KxBchXFYoolfi3i727VyL6R3AAfLtua0vKAEgW7DJzvhQmcN1gM5NaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFKNQA9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFKNQA9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5760C433F1;
	Tue, 23 Jan 2024 00:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968944;
	bh=LXjY2rlMppSROa1FDIlm/5jtj88MbOkkdAxR9vMw3sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFKNQA9nn7/o4eL7SSbMluJ7fFT6ZMIIyxn/rcybjYgSfuZAGj+Kw8YY+k5zDLdNh
	 TogP3C+kKgb/id1XjAwoQUybyr7T1MqNAQelBqB7O3R4meoS6OIV2Cve5vywRetcZp
	 GM/PBkYZjuNBo+tJMLc0VGCKevkgJqNdLoqW1A6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/194] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235724.172638595@linuxfoundation.org>
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
index 74cbed9377f0..ae74e8b01ee0 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3616,6 +3616,10 @@ static int si_cp_start(struct radeon_device *rdev)
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



