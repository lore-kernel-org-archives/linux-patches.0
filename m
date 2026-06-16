Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E954D44E055;
	Tue, 16 Jun 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624553; cv=none; b=eaA26JnSOlz6kmNyTMeWiek2nCMhxsqk2bYWjx2BIGIJMH3jKh+6gg2ylzKVptzlXRF0XLKYnxjjLNmo5idnEGKXAfFBGcpc0EewgiGoISZK9/5q0gNuq3KDrviZsigdTSTRH5D3dH9i79jQZbxghvDQK1RV/J3bcUVFIsq4rBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624553; c=relaxed/simple;
	bh=V10z8vJZ2e1A7ESW0ZzpOa1DPHlRE9nGnixNBIg5inU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kv7x4ujP5YIFeHqWawJxXgjhiPxq+zVIis9pkXPTVW4Zh4knif6hvBaTiZl2MAhahFnWe+vLyYV72DKqn3cFHYU8Duj7JssT2Kb1qr+zL1TW7msFE3TiKc8RnLnJN49uOiwrMOAYPX8JWjxceFdOg3XIS9+pzuMxDns/YaWOMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+o1zZdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+o1zZdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501E01F00A3D;
	Tue, 16 Jun 2026 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624552;
	bh=1l+362odMZTgL+Y9F4U3xDQnCHAMxt6MH5g4/eTMqS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+o1zZdrDRMGfB6Ftr7Kx26xcua0g4WSp6yI5bf895m28tQvZm1ulzFTVnaVCSgKY
	 OgIL7Buz3q1lw/R1EiSVrNnCDNLlNv8KoTbJZ1WNZ1wko3Yl7bvnW/917RqdJa3Ghs
	 pxx9c9cMoOdxE42DQqlwGGaQf2hxjATumCo2bZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 357/378] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Tue, 16 Jun 2026 20:29:48 +0530
Message-ID: <20260616145128.938063970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit e8b4d37eba05141ee01794fc6b7f2da808cee83b upstream.

[Why & How]
The aux_rd_interval array in struct dc_lttpr_caps is declared with
MAX_REPEATER_CNT - 1 (7) elements, indexed 0..6. However, the offset
parameter passed to dp_get_eq_aux_rd_interval() can be as large as
MAX_REPEATER_CNT (8) when a sink reports 8 LTTPR repeaters via DPCD.
This leads to an out-of-bounds read of aux_rd_interval[7] when offset
is 8.

Fix this by growing aux_rd_interval to MAX_REPEATER_CNT elements to
accommodate the full range of valid repeater counts defined by the DP
spec.

Assisted-by: GitHub Copilot:Claude claude-4-opus
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a55a458a8df37a65ffda5cf721d554a8f74f6b04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -1217,7 +1217,7 @@ struct dc_lttpr_caps {
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
 	union dp_alpm_lttpr_cap alpm;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 	uint8_t lttpr_ieee_oui[3]; // Always read from closest LTTPR to host
 	uint8_t lttpr_device_id[6]; // Always read from closest LTTPR to host
 };


