Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0519413B;
	Thu,  5 Sep 2024 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530501; cv=none; b=iYKzITSL/VcS6OGd+2cujXMJAqM9KDGWGh5Lp+rKJjdakD4wLU5MR8mATmxftGq5nG+vVRbG8eZQRqBc+Yr+omCGjctrEGJmVfBsBJ63ma/gVqHIOqghM7TRrT8Qf09gsXhj0Dtf96yvAuyrIYvSf6t4U1r0ETPz4w1uMPAS32c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530501; c=relaxed/simple;
	bh=+dxYXN4K4y9V4V0y/xV30lKKFdLhrs3onvyHs2whnvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kovVpXxWfZ7/Pi9rKFikyUb6gDqjwENp4YChpHj2R+maOOoLMXG/vHtyUZE3rb4fEFS2QkTiVRq77lDvrt2JHHhRS5SYS6aT3oXdvh/SV+RgS6d03p1t4Sn7aytcXX4KbmHRNKDZ5emNZZNsiKkfyMCKts4aYCZOOw6BflhmuYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJjRudDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJjRudDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7558DC4CEC3;
	Thu,  5 Sep 2024 10:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530500;
	bh=+dxYXN4K4y9V4V0y/xV30lKKFdLhrs3onvyHs2whnvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJjRudDxrwXvCv2XoOP/YuvLR6U2JZ/Vaws4POyt+wojMqLC9N10mk0ODmDDyPuOb
	 CVf19e0vvm3o5KKu4j0MRvm+H9riMhm5wh+5aYUaW6uSEtXods3HqM7gFkajAj+zWu
	 17JWacf4Z1rMZiHIH0BoBTp18dqzEXK0dg17HXkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/101] drm/amd/display: Check num_valid_sets before accessing reader_wm_sets[]
Date: Thu,  5 Sep 2024 11:41:15 +0200
Message-ID: <20240905093717.821834249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b38a4815f79b87efb196cd5121579fc51e29a7fb ]

[WHY & HOW]
num_valid_sets needs to be checked to avoid a negative index when
accessing reader_wm_sets[num_valid_sets - 1].

This fixes an OVERRUN issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index ca6dfd2d7561..35386011c56c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -484,7 +484,8 @@ static void build_watermark_ranges(struct clk_bw_params *bw_params, struct pp_sm
 			ranges->reader_wm_sets[num_valid_sets].max_fill_clk_mhz = PP_SMU_WM_SET_RANGE_CLK_UNCONSTRAINED_MAX;
 
 			/* Modify previous watermark range to cover up to max */
-			ranges->reader_wm_sets[num_valid_sets - 1].max_fill_clk_mhz = PP_SMU_WM_SET_RANGE_CLK_UNCONSTRAINED_MAX;
+			if (num_valid_sets > 0)
+				ranges->reader_wm_sets[num_valid_sets - 1].max_fill_clk_mhz = PP_SMU_WM_SET_RANGE_CLK_UNCONSTRAINED_MAX;
 		}
 		num_valid_sets++;
 	}
-- 
2.43.0



