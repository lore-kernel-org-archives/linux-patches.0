Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95731372B31;
	Wed, 20 May 2026 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301347; cv=none; b=fPrZycEaFqtqsaYKoJiivylYEnP5sLjPHBW1BL8uYIbo39+WC5InNKGV4W4EaGapVAdCPaMc1dIJgK+oXCQhVAcG2l0G5yR8ICFJKy/JnvaZt6XmEYfWW7n/3bbAeKXjORIJklS+/Qp+Gellg0zudRqAT2ojZMQ95C9ESI915ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301347; c=relaxed/simple;
	bh=mEJH8QLCVF2Gn2xD3FTgsaHMX1qsB8veIuS0MWKZFYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRodQQ9eZFenF95wYUZMnGTceUulluowkIk9pIhFoKuwSu4OvjLPlj4XXmp8O5GQE0yf/LdK/7oocm2YjVLEGZZoV5T+L9/TeCCSnorQ3cbIDoQepaC39l+ojRmCB/qc6vgoWJ+MnJ+9iSQYD1xFLAZ2Vr4TNY/xK1+H1TI9jiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3mhxKBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3mhxKBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16A71F000E9;
	Wed, 20 May 2026 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301346;
	bh=OMxIy8zKKlwbni1dLSftLiWC4z3zRJ+qo127/+mpMfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3mhxKBH7u1OBz2ywBdGynxDTgnx2RiZkcihZJN+NE9lxZOiR5DiNZcM9bernxSrR
	 1pcT4006m8+HWgKvKKJKuOnpCus3j7PcJ7t2afF4Gdf2EcFSsyniZaI52XaLtOHtmz
	 1iqBc78p2gdCdgjSJ4Fa/HtM/1iLJwh4VkUGA4tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/666] drm/amdgpu/gmc: Fix AMDGPU_GART_PLACEMENT_LOW to not overlap with VRAM
Date: Wed, 20 May 2026 18:22:09 +0200
Message-ID: <20260520162122.490528698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 36d65da7570bf72ce28504fa9a81abfc728e6d96 ]

When the GART placement is set to AMDGPU_GART_PLACEMENT_LOW:
Make sure that GART does not overlap with VRAM when
VRAM is configured to be in the low address space.

Solve this according to the following logic:
- When GART fits before VRAM, use zero address for GART
- Otherwise, put GART after the end of VRAM, aligned to 4 GiB

Previously, I had assumed this was not possible
so it was OK to not handle it, but now we got a report
from a user who has a board that is configured this way.

Fixes: 917f91d8d8e8 ("drm/amdgpu/gmc: add a way to force a particular placement for GART")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3d9de5d86a1658cadb311461b001eb1df67263ad)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 564c68c9277b3..cf41ef9e3ad83 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -297,7 +297,10 @@ void amdgpu_gmc_gart_location(struct amdgpu_device *adev, struct amdgpu_gmc *mc,
 		mc->gart_start = max_mc_address - mc->gart_size + 1;
 		break;
 	case AMDGPU_GART_PLACEMENT_LOW:
-		mc->gart_start = 0;
+		if (size_bf >= mc->gart_size)
+			mc->gart_start = 0;
+		else
+			mc->gart_start = ALIGN(mc->fb_end, four_gb);
 		break;
 	case AMDGPU_GART_PLACEMENT_BEST_FIT:
 	default:
-- 
2.53.0



