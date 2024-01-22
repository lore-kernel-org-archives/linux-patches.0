Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33C1468FF;
	Tue, 23 Jan 2024 00:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968378; cv=none; b=o8FrwTICzR+mfSnsORhB1BcuIiJMLvkjevd9ha4Zn8l84jh8BT+MUiOg4Ja6WK7MOahtGlyQPtJQxmTJ+RfKg8LROdH220tm7AFGxbfk698QQCz5ESy7B2Sq3UjI0zCJ+Zvr0FiAo1Tg1TfyEKe87exFzHch1PrW3QSO89GfWHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968378; c=relaxed/simple;
	bh=T817w6BBqwZpSU7+/CkAzPribvRUi8WB7b0heVm2yFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIongt7KQvlJcNucI4dCaWEvKq0gyP5/JRzAnqprHQb0UMJclgJRa3ou1lGaRCk0njjDcLFxgw5MjDEZ506UTaCc/YaMsuxf9eqagCZsHeu9BwvWzPhGAlKQKg58Pk6PjQj/4OUPiJdjzK+EnqTzkKjcXPbMamTZCIT0tI5Kw/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2R1gsvRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2R1gsvRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A409AC43394;
	Tue, 23 Jan 2024 00:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968378;
	bh=T817w6BBqwZpSU7+/CkAzPribvRUi8WB7b0heVm2yFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2R1gsvRHojePVevigVRLsuQ3nPX4zarzDb+OIXN0WNBQuMZWpjJ9V/D0VnJNhB3OI
	 roPiTH7VIkvZqRHZ2Qpy0xikGPP1w4DKvb7BtDLGXw9m2pn6FFFdTsUpEgKS+JyiCc
	 IrpwIkYYoej1JuFGVoiSebVYbgQ0ZhJHXhNnrXcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/148] drm/radeon/r600_cs: Fix possible int overflows in r600_cs_check_reg()
Date: Mon, 22 Jan 2024 15:57:26 -0800
Message-ID: <20240122235716.024464637@linuxfoundation.org>
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
index c96b31950ca7..b6bdfb3f4a7f 100644
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



