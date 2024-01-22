Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F9065BB4;
	Tue, 23 Jan 2024 01:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975107; cv=none; b=et4iO8qB/77EDD5ZFW87fPZNB/thjU1o55783+q+DoFcxs5JCppJ/GNzYGTMgbDtmweHie4PPei0fO4y7OcDgMpnnKIhNSDgdY8+UnVu8mFwHqbALWMQI8xy/Btchw9ZoOiBggHvcH94DeLCigcGussrhFDJ92EEPJ8GJGStBi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975107; c=relaxed/simple;
	bh=TW8rAdJsmQYYcokg36Bl4S75gl1JAV0xA56wvbFQ0vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujsK5MImPi80hR2NJtH8LVunTxdR5lHvO6c8wb5rP3cytqWhG+7eCtEdDW+BW8aoRLxdg4fOf7fUW+bR/PvDLFQjIPzb8n32hBC5vf7gMCFNeuTG7MgdP9xN/BV5ndNDhJtGFbE39sSd0Ga3nguXVJZVsvpqL/jtFTx0OX3KpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBb9kLa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBb9kLa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9476C433A6;
	Tue, 23 Jan 2024 01:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975106;
	bh=TW8rAdJsmQYYcokg36Bl4S75gl1JAV0xA56wvbFQ0vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBb9kLa0ksxjbNh9X0iLWLZ7s/pAS/WZxw5ra70vDo2351sleuttCWVMbmUnbewC8
	 V+QjRab/+Wtgi9ebeRGzK7gdaomlcnH4cLVgx56m7vIugiL7eR4u0iwo/5qrS+MCGU
	 xMU2KqXoO2y7RUbYbmIACv/w6K6kSWfarCy2VnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/583] drm/radeon/r600_cs: Fix possible int overflows in r600_cs_check_reg()
Date: Mon, 22 Jan 2024 15:54:52 -0800
Message-ID: <20240122235819.370073877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 638f861af80f..6cf54a747749 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -1275,7 +1275,7 @@ static int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
 			return -EINVAL;
 		}
 		tmp = (reg - CB_COLOR0_BASE) / 4;
-		track->cb_color_bo_offset[tmp] = radeon_get_ib_value(p, idx) << 8;
+		track->cb_color_bo_offset[tmp] = (u64)radeon_get_ib_value(p, idx) << 8;
 		ib[idx] += (u32)((reloc->gpu_offset >> 8) & 0xffffffff);
 		track->cb_color_base_last[tmp] = ib[idx];
 		track->cb_color_bo[tmp] = reloc->robj;
@@ -1302,7 +1302,7 @@ static int r600_cs_check_reg(struct radeon_cs_parser *p, u32 reg, u32 idx)
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



