Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5573BFE34;
	Sat, 17 Oct 2026 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258876; cv=none; b=FVPyY1oifgSF0Ghl1Ow2KNWH3zplV2VcqgSwdHAMwaFsfnljv064GcMA3Yr0DmN7mXXjHZG1d3RWZcXHiiWpQxvWaeDIqCaXUZpxjBfq2+b9m3IScTmW5TBiWKJdtSY1TwSG3SsBLN0y0V3g1RECdejbmg66Uc6ORV5XqfS3Qsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258876; c=relaxed/simple;
	bh=nzBFsYX5x+RbApPSrEHTGd1jEOWgLfHdBPJY5s/67fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvyjlO5n1bIcYgIbZVb+dmzorvjWq3bUbrQ236KduCJJK0PnzCPVUbH9t8wC2VlBzIMyLFCRo/ORjloJaBu95NFJu/8II8MyVAgoDSSTFHrNsxXMxGc+BDYqKoQiFf/w1gjpJDVj6I0D4mrFvIcslIzKYm8Y5+G/LcAEzst5Me0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lydQbpyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lydQbpyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A602F1F000C4;
	Sat, 17 Oct 2026 17:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258875;
	bh=9eyE3drfj3kuuCKp1vA4ouZlfQFpaCw8AgpAiGOsZaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lydQbpyreoq1wm1HQKhAw072FGB3zTHHoRVOY8SfFCj9ah3g2OrS5JbPA+5SWrYn/
	 uIEPKjre62PA4TeWDNxwQetrPNt3omD+auc1nAu+BH+27kcRfXXtj9p7PfEwJo/u4c
	 PK47FHispkxql/HtuJMCzP9X0c0hnsRSlz9TrwCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1029/1674] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Sat, 17 Oct 2026 17:55:01 +0200
Message-ID: <20261017160457.546687194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83719f5bea495..f834c0fa3b17c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -1156,7 +1156,7 @@ struct dc_lttpr_caps {
 	uint8_t max_ext_timeout;
 	union dp_main_link_channel_coding_lttpr_cap main_link_channel_coding;
 	union dp_128b_132b_supported_lttpr_link_rates supported_128b_132b_rates;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 };
 
 struct dc_dongle_dfp_cap_ext {
-- 
2.53.0



