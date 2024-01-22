Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9985F6A354;
	Tue, 23 Jan 2024 02:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975399; cv=none; b=kYRJ+UM6tVX+Bf6TOdGWyGuRMQAQxN/BsQtu78z1sSuQl9HlpT11ShRo0PjyEsHFd7q4/FwPAVuM9gHGeiw4qveTwQ8yismoxrCVZ/JH97jGLiRu+KqNQclyX31efzqhioEn9M+g0hTnu7pCrQXEtPWkdmbyipNYRDK8hwVPpQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975399; c=relaxed/simple;
	bh=UT7b9wn7RRFbh96ryjAvKe022W+FVz/NE3HbZTd1kBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZPTiAT51jxVF6dSGpUpFF1FOx+bxL0WEDmPPVzKOJvaWBDR9qkj92Eim8W2322AfhfcXV2KoVPNr2Cnr0iZa6/5EDal2J/m+jm+kmo7splw7pm4r7mvBEU777/hz5yq86UhOMGGrlUTgPRIFkxTauRomLcjIxOo5YYcA8ZM6Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8ZBuDG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8ZBuDG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D862C433A6;
	Tue, 23 Jan 2024 02:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975399;
	bh=UT7b9wn7RRFbh96ryjAvKe022W+FVz/NE3HbZTd1kBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8ZBuDG3lyZQNXlk1NFcn5vs/jCXDc++1JdSjdwZalhbLSmATMgxu+CknOGK73REw
	 qiCB+8x0BHsfBP7ikY/ZmAtMG7wIqf6mJc2k7c6HshN3OvgoPJjWKnNVyC4PHkZ4XI
	 JtUGLopXg+2wttKrX7wevHr4QXiZxVffbdswQfWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/583] drm/amd/display: avoid stringop-overflow warnings for dp_decide_lane_settings()
Date: Mon, 22 Jan 2024 15:56:24 -0800
Message-ID: <20240122235822.233179298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c966dc0e9d96dc44423c404a2628236f1200c24e ]

gcc prints a warning about a possible array overflow for a couple of
callers of dp_decide_lane_settings() after commit 1b56c90018f0 ("Makefile:
Enable -Wstringop-overflow globally"):

drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c: In function 'dp_perform_fixed_vs_pe_training_sequence_legacy':
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c:426:25: error: 'dp_decide_lane_settings' accessing 4 bytes in a region of size 1 [-Werror=stringop-overflow=]
  426 |                         dp_decide_lane_settings(lt_settings, dpcd_lane_adjust,
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  427 |                                         lt_settings->hw_lane_settings, lt_settings->dpcd_lane_settings);
      |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c:426:25: note: referencing argument 4 of type 'union dpcd_training_lane[4]'

I'm not entirely sure what caused this, but changing the prototype to expect
a pointer instead of an array avoids the warnings.

Fixes: 7727e7b60f82 ("drm/amd/display: Improve robustness of FIXED_VS link training at DP1 rates")
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c    | 2 +-
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 90339c2dfd84..5a0b04518956 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -807,7 +807,7 @@ void dp_decide_lane_settings(
 		const struct link_training_settings *lt_settings,
 		const union lane_adjust ln_adjust[LANE_COUNT_DP_MAX],
 		struct dc_lane_settings hw_lane_settings[LANE_COUNT_DP_MAX],
-		union dpcd_training_lane dpcd_lane_settings[LANE_COUNT_DP_MAX])
+		union dpcd_training_lane *dpcd_lane_settings)
 {
 	uint32_t lane;
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
index 7d027bac8255..851bd17317a0 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
@@ -111,7 +111,7 @@ void dp_decide_lane_settings(
 	const struct link_training_settings *lt_settings,
 	const union lane_adjust ln_adjust[LANE_COUNT_DP_MAX],
 	struct dc_lane_settings hw_lane_settings[LANE_COUNT_DP_MAX],
-	union dpcd_training_lane dpcd_lane_settings[LANE_COUNT_DP_MAX]);
+	union dpcd_training_lane *dpcd_lane_settings);
 
 enum dc_dp_training_pattern decide_cr_training_pattern(
 		const struct dc_link_settings *link_settings);
-- 
2.43.0



