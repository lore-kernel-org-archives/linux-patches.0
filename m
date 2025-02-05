Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD61519AA;
	Wed,  5 Feb 2025 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764289; cv=none; b=E1pq2eFwXpRBIHmQUZarZi1kg2XxuUZiv/6RaqOl+pOKD9Mv2bxt2KnsS4SceTyIUgvMDzlii9z1Bje1V2VWP06NKpSuASRnPw9b1iWKCtXV8Ocd+SAMD6llsfkDuUAYCEBeiIGHWuR9/NGahNKma0TLt1AXIWxOvRA+H1We8Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764289; c=relaxed/simple;
	bh=hg591Kj5jSWQLmAQ6fsyChr2jwI768riK3XoL9ZaRCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHfTomObKqFeBBbKrpRHXXQJOX/8176eeUJRCMCMuWs5LC7oZE8MQxEt2YGir3nPjsllu25dKvtnm8VZGWDcrR5DeSiVrhJte2OZeBb3tNrd9HyVDgD1GC5gGCxZeZF+HZBJ+7RHOhBVJaaoQfbPSpptsLbYjK+49Gj1Nf2ipN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZG7bAk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZG7bAk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0926C4CED1;
	Wed,  5 Feb 2025 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764289;
	bh=hg591Kj5jSWQLmAQ6fsyChr2jwI768riK3XoL9ZaRCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZG7bAk73CPfWoPpD0wgHJWWpzvsTBYCdMz4Iemi5O/uiA+wzqTr9zq3cvBoWeWaE
	 2F0DIUe6b9KnwhzFDnf4ocAyEG5jtVOfN3DrcVfiHd9UcIQ8+MiC7JEYManhenx5Ug
	 4yw+Lw8blG/rQTzaUw+J6IzsjJF0vdRTFuEvJSCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Przybylski <karprzy7@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 064/623] drm/amdgpu: Fix potential integer overflow in scheduler mask calculations
Date: Wed,  5 Feb 2025 14:36:46 +0100
Message-ID: <20250205134458.673613020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Przybylski <karprzy7@gmail.com>

[ Upstream commit 34c4eb7d4e0cd443399a0f114d467d2b3ff05419 ]

The use of 1 << i in scheduler mask calculations can result in an
unintentional integer overflow due to the expression being
evaluated as a 32-bit signed integer.

This patch replaces 1 << i with 1ULL << i to ensure the operation
is performed as a 64-bit unsigned integer, preventing overflow

Discovered in coverity scan, CID 1636393, 1636175, 1636007, 1635853

Fixes: c5c63d9cb5d3 ("drm/amdgpu: add amdgpu_gfx_sched_mask and amdgpu_compute_sched_mask debugfs")
Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 1d155463d044b..9a4dad3e41529 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -2058,7 +2058,7 @@ static int amdgpu_debugfs_gfx_sched_mask_set(void *data, u64 val)
 	if (!adev)
 		return -ENODEV;
 
-	mask = (1 << adev->gfx.num_gfx_rings) - 1;
+	mask = (1ULL << adev->gfx.num_gfx_rings) - 1;
 	if ((val & mask) == 0)
 		return -EINVAL;
 
@@ -2086,7 +2086,7 @@ static int amdgpu_debugfs_gfx_sched_mask_get(void *data, u64 *val)
 	for (i = 0; i < adev->gfx.num_gfx_rings; ++i) {
 		ring = &adev->gfx.gfx_ring[i];
 		if (ring->sched.ready)
-			mask |= 1 << i;
+			mask |= 1ULL << i;
 	}
 
 	*val = mask;
@@ -2128,7 +2128,7 @@ static int amdgpu_debugfs_compute_sched_mask_set(void *data, u64 val)
 	if (!adev)
 		return -ENODEV;
 
-	mask = (1 << adev->gfx.num_compute_rings) - 1;
+	mask = (1ULL << adev->gfx.num_compute_rings) - 1;
 	if ((val & mask) == 0)
 		return -EINVAL;
 
@@ -2157,7 +2157,7 @@ static int amdgpu_debugfs_compute_sched_mask_get(void *data, u64 *val)
 	for (i = 0; i < adev->gfx.num_compute_rings; ++i) {
 		ring = &adev->gfx.compute_ring[i];
 		if (ring->sched.ready)
-			mask |= 1 << i;
+			mask |= 1ULL << i;
 	}
 
 	*val = mask;
-- 
2.39.5



