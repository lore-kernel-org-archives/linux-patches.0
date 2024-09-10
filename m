Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC00E18B48A;
	Tue, 10 Sep 2024 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962436; cv=none; b=pg6/0smNotLONo/4WvVu/L8/yu+EPAIOIgB63cu9PGxTq1dd5lTeKOA0EHMOxR2r2b+qNH9eZgNHSoQ7xmou1T49BX1+uinYAIn4b7XnqpBZeaAA8xvzYq32QcPQ+LC/zlCX1cyced4G376QxieDOArxNmByIOwFNKjkIAsHyWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962436; c=relaxed/simple;
	bh=QZu1EJEoN1Xdn7OrOnXrqst8q6YEAFq7XQckc/dUl1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDrskpfdQtdZPKN/Gf1xsrZLXX1whNf11dP89MnKnsyMUUxvlzKPEPTnY30gwlo1GjazM/lx3PHNveDuGXqN9VNtw40uPGRi7Mk96RDHLM+F+vz03DVatF3U8oBsnemZS1Xv3G3aziHjtjm81bhZXgZj24WRAaF4UsnIB0UojjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1fuZEa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1fuZEa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D7CC4CEC3;
	Tue, 10 Sep 2024 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962436;
	bh=QZu1EJEoN1Xdn7OrOnXrqst8q6YEAFq7XQckc/dUl1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1fuZEa1HRRIFnaEhHiAkg779YYVHQoyBHhoXfwV48pdNJNUSuxnJozIEJwrqqvyG
	 9726HSyFn9CJkHoayo3YtdIvjZzynlfDq2PeCbqrXAzZVJxN8o1UViAiu3ab4ThoHt
	 vyFjRwmTGnCKgjqIn44Frna2I/pUBSP8vSPJo8/M=
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
Subject: [PATCH 5.4 008/121] drm/amd/display: Check num_valid_sets before accessing reader_wm_sets[]
Date: Tue, 10 Sep 2024 11:31:23 +0200
Message-ID: <20240910092546.139244852@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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
index 9f301f8575a5..fec3ca955b26 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -453,7 +453,8 @@ void build_watermark_ranges(struct clk_bw_params *bw_params, struct pp_smu_wm_ra
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



