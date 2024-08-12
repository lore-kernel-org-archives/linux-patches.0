Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE018732A;
	Mon, 12 Aug 2024 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479318; cv=none; b=X5aagz3kmz1vK2cgWLz9W/dTu7IEsxzI2vFMkgvrFEtp0fLpEl18JU6zSWFOv19RnlAQiLNi+PKnS/FzIwHtEru8rX6FHPzYkultHYyoMAt5p5i0pKqSY6fXKwnBTkH6AALI6JUtq2HaTTNKwmfQOcjw8McHa8iR6gagH/IQLPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479318; c=relaxed/simple;
	bh=gemjgLJeDMD7UQqloJypj7QwPxgMNyFIw3R2xdJwCXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oasVvkHhVyliL5+ak7SfdQk08AvW5AcCW3mVFYBr/mTEyTezy0B6i3/rRBplmTRigAuCj8EHwKnqWVBvuCLvUcL/MnBG68FOfHGU2lA4Lx/ghj65/Nos3jBbYCetSV6ErguWlzgSIdX2AbEyvBMysM3F53ofgFkqjuLel3V3ArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZqs2iAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZqs2iAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A64C32782;
	Mon, 12 Aug 2024 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479318;
	bh=gemjgLJeDMD7UQqloJypj7QwPxgMNyFIw3R2xdJwCXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZqs2iAgMf5rYb2QJu6MeZ+YWDSbPJVyGSi2zjZeA2vAxMrrX+sxFXQTRrRTNg9Mh
	 W+RWtkHiqtQDjIQ9oGhgfm8eIbAtW1g9hxCRQgwfSxvVafFHEPlC7+gtQwaivFKHG2
	 O1CUaJs0L8/E7ln+oI3Shef0AYsNuLXvb175gZAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/189] drm/amd/display: Add delay to improve LTTPR UHBR interop
Date: Mon, 12 Aug 2024 18:01:45 +0200
Message-ID: <20240812160134.032361042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 10839ee6a977ed1f7d0f4deb29f2d7e5d1f2a9dd ]

[WHY]
Avoid race condition which puts LTTPR into bad state during UHBR LT.

[HOW]
Delay 30ms between starting UHBR TPS1 PHY output and sending TPS1 via DPCD.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c      | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
index b621b97711b61..a7f5b0f6272ce 100644
--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
@@ -162,7 +162,12 @@ static void set_hpo_fixed_vs_pe_retimer_dp_link_test_pattern(struct dc_link *lin
 		link_res->hpo_dp_link_enc->funcs->set_link_test_pattern(
 				link_res->hpo_dp_link_enc, tp_params);
 	}
+
 	link->dc->link_srv->dp_trace_source_sequence(link, DPCD_SOURCE_SEQ_AFTER_SET_SOURCE_PATTERN);
+
+	// Give retimer extra time to lock before updating DP_TRAINING_PATTERN_SET to TPS1
+	if (tp_params->dp_phy_pattern == DP_TEST_PATTERN_128b_132b_TPS1_TRAINING_MODE)
+		msleep(30);
 }
 
 static void set_hpo_fixed_vs_pe_retimer_dp_lane_settings(struct dc_link *link,
-- 
2.43.0



