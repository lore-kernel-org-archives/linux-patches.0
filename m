Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CED412BF3D;
	Tue, 23 Jan 2024 00:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968941; cv=none; b=OPo+ctKLhEp1yDhUlWejGumFk6yhXTbkGDsXzTso6N1D7OrFK7r9TmPW6RJlW6CCeml8wu8fKGKITP7tpSQ2kgsnGbgfWgdUVoayebTuAzWSmNN2fGtT+u7GymkBKHsNrIqBwb92N9eyY2UOwYWr20bYXygaIR4rspNm2QSH5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968941; c=relaxed/simple;
	bh=WDFAYU8UJAOWpAEBV0IAx5fWqjyzB8ExPy2wVW8xeVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxp5au+VmMjdiX4pW5ED8cMH5oQY20pjIWHxMHgWlsx2wOFQN8k6ZuVzAXE/63w1X51wn/r4pMWFZ3OfbBkG+xVtciM8ABSlV0C1WIw64tercJ/kEgdUE+LtVA8FV2FiNLLjDgIrvufP7pBfen2YOWF7IxuBuytZiDfigA2wcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ux9viVsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ux9viVsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1F8C433C7;
	Tue, 23 Jan 2024 00:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968940;
	bh=WDFAYU8UJAOWpAEBV0IAx5fWqjyzB8ExPy2wVW8xeVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux9viVsZic5/lNsvjrHIot+02Y7ysuPbNo0lWmAXObzgu9+ra93wcfPsYMH1WCe7k
	 wssQzEniQK6lK7xzzwuyPrSMFnsWqINeA24ds10XpMBMNhFxT6pkRjU4xxFGkbr9PW
	 aJmhUz91oJyfKf8epp4tNAtHyyzObAKNjVLK+Mho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/194] drm/radeon/r600_cs: Fix possible int overflows in r600_cs_check_reg()
Date: Mon, 22 Jan 2024 15:57:23 -0800
Message-ID: <20240122235724.080891491@linuxfoundation.org>
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

[ Upstream commit 39c960bbf9d9ea862398759e75736cfb68c3446f ]

While improbable, there may be a chance of hitting integer
overflow when the result of radeon_get_ib_value() gets shifted
left.

Avoid it by casting one of the operands to larger data type (u64).

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 1729dd33d20b ("drm/radeon/kms: r600 CS parser fixes")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r600_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index d6c28a5d77ab..19c9e86b2aaf 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -1278,7 +1278,7 @@ static int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
 			return -EINVAL;
 		}
 		tmp = (reg - CB_COLOR0_BASE) / 4;
-		track->cb_color_bo_offset[tmp] = radeon_get_ib_value(p, idx) << 8;
+		track->cb_color_bo_offset[tmp] = (u64)radeon_get_ib_value(p, idx) << 8;
 		ib[idx] += (u32)((reloc->gpu_offset >> 8) & 0xffffffff);
 		track->cb_color_base_last[tmp] = ib[idx];
 		track->cb_color_bo[tmp] = reloc->robj;
@@ -1305,7 +1305,7 @@ static int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
 					"0x%04X\n", reg);
 			return -EINVAL;
 		}
-		track->htile_offset = radeon_get_ib_value(p, idx) << 8;
+		track->htile_offset = (u64)radeon_get_ib_value(p, idx) << 8;
 		ib[idx] += (u32)((reloc->gpu_offset >> 8) & 0xffffffff);
 		track->htile_bo = reloc->robj;
 		track->db_dirty = true;
-- 
2.43.0



