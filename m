Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3C12A167;
	Tue, 23 Jan 2024 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971066; cv=none; b=s/lvsmBznn/9doHDA2Lcx9MYRtWstlSw8EAcod6CQGTrmwCUEL8/pfOmUn3lsWpon6jpcpb+H8ZKr237gzSMYfn2yLeZkLwNg4dRSZegL5CDIE3nW3BAaPM6o0nfmhv/G/umSz/Ll1EIpglXRlSgjXeWHMxvlGfVbdytI9SfvoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971066; c=relaxed/simple;
	bh=+FHn8ym5fnMJSOdXcFM/d+gVIf7Y/zxpg/Vs0epu68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcWf2ntgZ8f4djSqANqMdzqa95vBkAioA6TsZW2cp5KUXHiWJJfadrSZkkONk7qPCVnQFNJtfPlSeqZwRZbpqS7CGbWCoFmvghYW/ObUSx8xpB8gTjtVF26Ha9pLSFjI19jfuj/RDRtTQ/73qtLh6/aDKWRGH9p+ghqZG0QRgWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6s6iLxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6s6iLxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A21C43390;
	Tue, 23 Jan 2024 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971065;
	bh=+FHn8ym5fnMJSOdXcFM/d+gVIf7Y/zxpg/Vs0epu68A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6s6iLxvJVlIvn/5ansguKx8aMKMtVpPtfYiz0T0J2r+fkWcEYsx2c0R+MZ016VLF
	 vq+VRQ3ZaxypohZGFOwWFIQFR1aeMM3BEld0eB3ujaaMJLamv/i53Erz1sVSXxV2K/
	 KdqdC96fj8akMRm/tIDDjg202/cWzS1N8FDGxB2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/417] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:55:42 -0800
Message-ID: <20240122235757.888153506@linuxfoundation.org>
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
index a91012447b56..85e9cba49cec 100644
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



