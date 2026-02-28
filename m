Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594A2355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300992; cv=none; b=CQ89g25tVUeno/SsAQcHIOu1gEaw6kTeKluJY+thZaouPkK0m6fKWmFRla+yq2EFlwH21TSL5f9mzaBPpGSOHok3u8kna8crhV2rqY22LVBxB2ZbGJ8O9XouWQE3EwfFg4rhrJ2B2ZMVd2uYFM8/GOsuuI1taDCEAQA+NWWn50U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300992; c=relaxed/simple;
	bh=xeZh3cF455He9JeR56322hkv854L2QK5u/JbF7eXb38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1Um2UVnvCvN+37j7jwxq+7TIpzw6mDhq9TecKlWmLCR09aip4IzOZ2rKEsArUM0oSG+DSvxdjKbdoIjuQcfcyQr0xkR9y5IF7FcftYY/IIuH+iYIeliq3GDqWKrqm6E0tAAu+AnMz8Bsk6wfMmXy0mp/lihPYlpCCOahOydl5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBPaS0/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBPaS0/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80732C19424;
	Sat, 28 Feb 2026 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300992;
	bh=xeZh3cF455He9JeR56322hkv854L2QK5u/JbF7eXb38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBPaS0/jW4QJuLgt76uvP+Py+GKOQN2W7ImGWSAORGeJBzvMUWBeuhnn9C0P6OmDR
	 H7sW8hytF6nUO/L/uPNiEqYC9qL2fo6fMEa48qSZcuKqx/WRomFnroop3SX6ZmyItQ
	 5o39fYVAqZ9DguiR4CTPPxQeBnqRdF53TwwOlUV/T0NWonljBpR8zJJRmrGKkmKDR2
	 x0nlnG2kxhHVR6p7JcbYkBj0rwPba757f+9Led26/n49xtKfADG0LZBro9qd220Nbo
	 d1/zhWt1Ou0K5+ZBCPY8AI723gM384izBy9EicuWVgZOU3HPlW7rKqEFrYjD/71p9/
	 yhbtaZh62vwfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: LinCheng Ku <lincheng.ku@amd.com>,
	PeiChen Huang <peichen.huang@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/752] drm/amd/display: Add USB-C DP Alt Mode lane limitation in DCN32
Date: Sat, 28 Feb 2026 12:37:14 -0500
Message-ID: <20260228174750.1542406-123-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: LinCheng Ku <lincheng.ku@amd.com>

[ Upstream commit cea573a8e1ed83840a2173d153dd68e172849d44 ]

[Why]
USB-C DisplayPort Alt Mode with concurrent USB data needs lane count
limitation to prevent incorrect 4-lane DP configuration when only 2 lanes
are available due to hardware lane sharing between DP and USB3.

[How]
Query DMUB for Alt Mode status (is_dp_alt_disable, is_usb, is_dp4) in
dcn32_link_encoder_get_max_link_cap() and cap DP to 2 lanes when USB is
active on USB-C port. Added inline documentation explaining the USB-C
lane sharing constraint.

Reviewed-by: PeiChen Huang <peichen.huang@amd.com>
Signed-off-by: LinCheng Ku <lincheng.ku@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dio/dcn32/dcn32_dio_link_encoder.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
index 06907e8a4eda1..ddc736af776c9 100644
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
@@ -188,9 +188,18 @@ void dcn32_link_encoder_get_max_link_cap(struct link_encoder *enc,
 	if (!query_dp_alt_from_dmub(enc, &cmd))
 		return;
 
-	if (cmd.query_dp_alt.data.is_usb &&
-			cmd.query_dp_alt.data.is_dp4 == 0)
-		link_settings->lane_count = MIN(LANE_COUNT_TWO, link_settings->lane_count);
+	/*
+	 * USB-C DisplayPort Alt Mode lane count limitation logic:
+	 * When USB and DP share the same USB-C connector, hardware must allocate
+	 * some lanes for USB data, limiting DP to maximum 2 lanes instead of 4.
+	 * This ensures USB functionality remains available while DP is active.
+	 */
+	if (cmd.query_dp_alt.data.is_dp_alt_disable == 0 &&
+		cmd.query_dp_alt.data.is_usb &&
+		cmd.query_dp_alt.data.is_dp4 == 0) {
+		link_settings->lane_count =
+			MIN(LANE_COUNT_TWO, link_settings->lane_count);
+	}
 }
 
 
-- 
2.51.0

