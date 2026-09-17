Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89E4F93C9;
	Thu, 17 Sep 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664266; cv=none; b=l4P0OlodSF7aDQkkiYd0cdbrbQVz/ym/dLjTBb+H4Lg1L7VNBOMA4nBvAxIRjl3jigfV9bMaRgnC4cEqCKkXCfuVan4Sw2ozeGQyosajUjyUxzhuscP97gMuyAKjqg96xGlE4UpwoEghx0nEjJS7I6V1bS/BIxRbv48EJLmVYTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664266; c=relaxed/simple;
	bh=/27/BZkfkprgco29fDSHkRyl9J/xm2RrSUESKGBaGWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lss/UmmvrjEn0Gg84HBo+NiJ7+4nPIdZZtUA1g0VPKNaYcdq/P3Co+OYHyhXR5Z7++tCs7RL2FlmbCrrF9y28Swap60gqAlHfJPM2LRqvaM6D2W2xTjOIfE7u3DoO+uAyZ2tmUtLTJzzMGoQZeBjQ3f5/zSFko2yH3G/ISzzoJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxfO4wy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxfO4wy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA41F00893;
	Thu, 17 Sep 2026 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664264;
	bh=Ec7qbSHTX9lXiiScNwSsvprn5gmZ0ric2DQwUXpFdyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxfO4wy1TbrB1XfBmayEvOsFDARPnZ/9d5q8drfI3NGtJTuFtkuuf7OnKXWw/aJ34
	 MivcFR7mgwIhynSdu1s0ot5LLIctTMjr4549l/kSr3UZj2jebxjXkbypPnsxbDZG8r
	 X1J3F+qTBNy3WC8QhOAahmnmzZrS3w8gPfy2RyRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0314/1250] drm/amd/display: Check for sharpening case when calculating max vtaps for scaler
Date: Thu, 17 Sep 2026 16:01:49 +0100
Message-ID: <20260917151600.613189577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit 4d8cfd570386eb0b6cb8aa0ca9e9db60a0404337 ]

[Why & How]
- calc_lb_num_partitions has check when scaler is not enabled to use
 larger LB in calculations for max vtaps based on viewport being 1:1
- however, scaler is forced on when sharpening is enabled, so need
 to consider this in check
- taps is predetermined in spl_get_optimal_number_of_taps prior to
 calc_lb_num_partitions.  Add check for taps not 1 to handle
 sharpening case

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
index b62bbadb0d440..029f59a58c780 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
@@ -389,9 +389,11 @@ void dscl401_spl_calc_lb_num_partitions(
 		lb_memory_size_a = 1290;
 	} else if (lb_config == LB_MEMORY_CONFIG_3) {
 		if (scl_data->viewport.width  == scl_data->h_active &&
-			scl_data->viewport.height == scl_data->v_active) {
+			scl_data->viewport.height == scl_data->v_active &&
+			scl_data->taps.h_taps == 1 && scl_data->taps.v_taps == 1) {
 			/* 420 mode: luma using all 3 mem from Y, plus 3rd mem from Cr and Cb */
 			/* use increased LB size for calculation only if Scaler not enabled */
+			/* Scaler is forced on when sharpening is on. Add check for taps = 1 */
 			lb_memory_size = 970 + 1290 + 1170 + 1170 + 1170;
 			lb_memory_size_c = 970 + 1290;
 			lb_memory_size_a = 970 + 1290 + 1170;
@@ -403,8 +405,10 @@ void dscl401_spl_calc_lb_num_partitions(
 		}
 	} else {
 		if (scl_data->viewport.width  == scl_data->h_active &&
-			scl_data->viewport.height == scl_data->v_active) {
+			scl_data->viewport.height == scl_data->v_active &&
+			scl_data->taps.h_taps == 1 && scl_data->taps.v_taps == 1) {
 			/* use increased LB size for calculation only if Scaler not enabled */
+			/* Scaler is forced on when sharpening is on. Add check for taps = 1 */
 			lb_memory_size = 970 + 1290 + 1170;
 			lb_memory_size_c = 970 + 1290 + 1170;
 			lb_memory_size_a = 970 + 1290 + 1170;
-- 
2.53.0



