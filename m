Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52AC36B93B;
	Sat, 17 Oct 2026 16:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254120; cv=none; b=FJWOyio+mFbXkWMFQefOOaWHZZuuGdE7bxrfJWLRASapaHKmwf+WpMyUEOZDBDbOIGSI9oQnSztMepw0RzZzy0U9rozfidpQi2tz9HZDK1oTkTaKnqHPMBg7Npya+1qdoPMwV4K6cM3WTKG+7iWvtxXkr/C/9EAnLGtlYNvgx0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254120; c=relaxed/simple;
	bh=OWofSyPFGE9v+urcFUEFChEAH2mXwjiCT70OWhz+dFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQryokXMxPdcX3svgV7Ij1crEUQJRX3+ZO745PiVZk715oQ6IkVJN6mbmX7OKWCHSJORY9K1hdq3KhVBVIUAoZIEenfnOkuqtnMoarjzTx2ppu3Xmk9NLKwvO+C7w0P7Zo8fLLMjsj25mGCYTbA0un/fdwV1iupfS9JP3LmwtkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDM5LFzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDM5LFzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB61F000C5;
	Sat, 17 Oct 2026 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254119;
	bh=aNxOqYS6RkYFKMO8lyZSh693v7D2RHxDeyHAiufjlIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDM5LFzApNeaaqV7BYnZmkb7m3ry/wN73+lyYZKcZIqQ+F6dH5cjTr8frDzbQx54S
	 DK5GzkyT976ENtT0NDts72SmM9dByynUzj25Ci9jO+EP3R6Q5eRUOMAHuc9TVRGdn/
	 KXLy6cm/MUxBEmBG6qVGaWjna0FBuJax5nvkr7ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/869] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Sat, 17 Oct 2026 17:52:56 +0200
Message-ID: <20261017160045.669239437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit e8b4d37eba05141ee01794fc6b7f2da808cee83b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 223c3d55544b2..b128f1da98c91 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -1112,7 +1112,7 @@ struct dc_lttpr_caps {
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
 	union dp_alpm_lttpr_cap alpm;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 };
 
 struct dc_dongle_dfp_cap_ext {
-- 
2.53.0



