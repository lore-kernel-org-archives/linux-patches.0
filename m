Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720D155300;
	Tue, 23 Jan 2024 00:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969506; cv=none; b=TmyhCkEQd9zo5oG4f8OGD3+oTv7aiJnsYh3bnOudzzi6qFmxAiOypItBP3bpwl4AZZFEGgyyohZpwrJsSanufNLM3Rwq8/tAyxo3QyvWQwoeNCovJ7At7sPQax5uvpYNz+nXzju5QzP8go/jEEb8R94XAPmd9svG05YXVKxzhPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969506; c=relaxed/simple;
	bh=4KJTbmjCXpw50K6oc0vwgOqS+MXlexCRnOJjteYyneY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MI1Ikx/MGQN+067K6UGJ0Kt3N6odu/HLoaJld3+kJz9YYCvPzGnap5+tPMx/ZJXMPaIwphl6l/NLkb30m5aMeoAgFvqOUgmDZbba7+0LPJ76o7qAX2znXGohKD79t3IQj/Gevfkl04JidHOVi6IptKZd8TqhYxch6c4ikrU3xfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wcb9aBXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wcb9aBXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D9CC433A6;
	Tue, 23 Jan 2024 00:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969505;
	bh=4KJTbmjCXpw50K6oc0vwgOqS+MXlexCRnOJjteYyneY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wcb9aBXzs0i7ERGXIIML0XjPTw9emZxCNtu9FNCp+mXEs14wob3+4uNYGtamYaGh+
	 3C90t1MxIo3TkkJpFYjaUx+8UeH6b8RdF1d7WzGORQqWcl38P8u9mRNxBytDCoB+IU
	 UnA/gfpkL+iOmVJKZJL9AKEzYIKUGTPi0mzImgnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 267/641] drm/radeon/r600_cs: Fix possible int overflows in r600_cs_check_reg()
Date: Mon, 22 Jan 2024 15:52:51 -0800
Message-ID: <20240122235826.274610978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



