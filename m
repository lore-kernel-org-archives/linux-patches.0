Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22591168C4;
	Mon, 27 May 2024 19:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837666; cv=none; b=RhXhwmfS2a6zsdZtDV3g9tiGzGwDPeMbF1feQJOUpbCQrVrv2MgTG0HoE3C/dxkfXONLtPiebh/ND/yG3yQB2YvVLxyPCSygXfDqsTBBuTMK9Yc+DfviEdJLDTVdtyiwhq1zgAq4CIqTBVQpPXfaTMYBOdW1rHyRTSvajZasHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837666; c=relaxed/simple;
	bh=QX/MKhfbuIfI0cV6/3MSkMfYriIZ6fgCX56BwlZNipM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXWGSbo9gC/xCWlgT980Tmy7VfmRFpNyvn7DqsuJAHkZ6aWsULYM3yyHXzqyvqu0/x+wTTTXOR6FpOYZIK3e96gU9MVMLp+WOJgb51z3YJwUERubeF7vD6qgTPUM3ioHCgk/N01m+ZT8XavXPldA/V7Z8I5sjlSDf5gieZepjcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROF7Irn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROF7Irn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95A0C2BBFC;
	Mon, 27 May 2024 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837666;
	bh=QX/MKhfbuIfI0cV6/3MSkMfYriIZ6fgCX56BwlZNipM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROF7Irn/6xUQAaeByAXpSL0nJGpXsyd9HwoaLw3GpgM8hSsvLAokHJGWWw1F1NzH6
	 ES8FexaRvIH/g90NkMKNw0ActHngcfbDjwvTK9f8+wn90Q8f80bxbFqUDeDfGYPJNu
	 30ddh1QY1sB9X6JslwrypU6eooiRUSExbrKmrlCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Koo <anthony.koo@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 098/493] drm/amd/display: Disable seamless boot on 128b/132b encoding
Date: Mon, 27 May 2024 20:51:40 +0200
Message-ID: <20240527185633.705274090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Joon Kim <sungjoon.kim@amd.com>

[ Upstream commit 6f0c228ed9184287031a66b46a79e5a3d2e73a86 ]

[why]
preOS will not support display mode programming and link training
for UHBR rates.

[how]
If we detect a sink that's UHBR capable, disable seamless boot

Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Sung Joon Kim <sungjoon.kim@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 3c3d613c5f00e..040b5c2a57586 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1804,6 +1804,9 @@ bool dc_validate_boot_timing(const struct dc *dc,
 		return false;
 	}
 
+	if (link->dpcd_caps.channel_coding_cap.bits.DP_128b_132b_SUPPORTED)
+		return false;
+
 	if (dc->link_srv->edp_is_ilr_optimization_required(link, crtc_timing)) {
 		DC_LOG_EVENT_LINK_TRAINING("Seamless boot disabled to optimize eDP link rate\n");
 		return false;
-- 
2.43.0



