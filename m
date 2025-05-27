Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B863C01;
	Tue, 27 May 2025 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367421; cv=none; b=mr56gzFgv8X9rSsXmZXZUEYndc0O0H5Ns9IQ6CCkIaIKZ6Hdhtpw64JhHKoIH/jSjPpYvQ78iWRmpdCVACnk9ti7laXRHJtazweZ22zTXiNziM82fcyS743CqEsCnXO2K5+Qs3yyfbre7kPgbqvLLE0AgTTPuGpAAO4GBiyinL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367421; c=relaxed/simple;
	bh=AjBa7y91hjeRfW9we/9qqc+Xg0HmB0nEMfcri2Qui2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro08RL5wbxylzD+csuizMBwBRbsYOwU+lybD2n+CSpQSVIpPiXQZLIKiT63EOx3F5Mgf2V4RPO0eInUifotAfeOrYzSFY3aHd30r4C6CkJUhqm5P9U4Qw24qq+u+caU6DqkccYh9B+nzfdNeUqkjV4jLeKGTSpw1Z8pE9Qbbsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjhNu2bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjhNu2bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD308C4CEE9;
	Tue, 27 May 2025 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367421;
	bh=AjBa7y91hjeRfW9we/9qqc+Xg0HmB0nEMfcri2Qui2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjhNu2bpUQky6paQ+yhgof3SHshhXTj92erMySgzI66MMdhxOxt01y82ulV5om75S
	 Y6zH9aBxX3f0FcLIlAvI+sDrU5rKrfNG2voZlL0z9bALcggcBnexDG471LxJdi/zfL
	 p/AnBjkiNYejyx3H4KSE3sOflWONoIV/95mrdBIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <Samson.Tam@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 352/783] drm/amd/display: fix check for identity ratio
Date: Tue, 27 May 2025 18:22:29 +0200
Message-ID: <20250527162527.405057500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit 0d3004647631aedb713251525a99784661574767 ]

[Why]
IDENTITY_RATIO check uses 2 bits for integer, which only allows
 checking downscale ratios up to 3.  But we support up to 6x
 downscale

[How]
Update IDENTITY_RATIO to check 3 bits for integer
Add ASSERT to catch if we downscale more than 6x

Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Jun Lei <jun.lei@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/spl/dc_spl.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
index 38a9a0d680581..18b423bd302a7 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
@@ -8,7 +8,7 @@
 #include "dc_spl_isharp_filters.h"
 #include "spl_debug.h"
 
-#define IDENTITY_RATIO(ratio) (spl_fixpt_u2d19(ratio) == (1 << 19))
+#define IDENTITY_RATIO(ratio) (spl_fixpt_u3d19(ratio) == (1 << 19))
 #define MIN_VIEWPORT_SIZE 12
 
 static bool spl_is_yuv420(enum spl_pixel_format format)
@@ -887,6 +887,8 @@ static bool spl_get_isharp_en(struct spl_in *spl_in,
 static void spl_get_taps_non_adaptive_scaler(
 	  struct spl_scratch *spl_scratch, const struct spl_taps *in_taps)
 {
+	bool check_max_downscale = false;
+
 	if (in_taps->h_taps == 0) {
 		if (spl_fixpt_ceil(spl_scratch->scl_data.ratios.horz) > 1)
 			spl_scratch->scl_data.taps.h_taps = spl_min(2 * spl_fixpt_ceil(
@@ -926,6 +928,23 @@ static void spl_get_taps_non_adaptive_scaler(
 	else
 		spl_scratch->scl_data.taps.h_taps_c = in_taps->h_taps_c;
 
+
+	/*
+	 * Max downscale supported is 6.0x.  Add ASSERT to catch if go beyond that
+	 */
+	check_max_downscale = spl_fixpt_le(spl_scratch->scl_data.ratios.horz,
+		spl_fixpt_from_fraction(6, 1));
+	SPL_ASSERT(check_max_downscale);
+	check_max_downscale = spl_fixpt_le(spl_scratch->scl_data.ratios.vert,
+		spl_fixpt_from_fraction(6, 1));
+	SPL_ASSERT(check_max_downscale);
+	check_max_downscale = spl_fixpt_le(spl_scratch->scl_data.ratios.horz_c,
+		spl_fixpt_from_fraction(6, 1));
+	SPL_ASSERT(check_max_downscale);
+	check_max_downscale = spl_fixpt_le(spl_scratch->scl_data.ratios.vert_c,
+		spl_fixpt_from_fraction(6, 1));
+	SPL_ASSERT(check_max_downscale);
+
 	if (IDENTITY_RATIO(spl_scratch->scl_data.ratios.horz))
 		spl_scratch->scl_data.taps.h_taps = 1;
 	if (IDENTITY_RATIO(spl_scratch->scl_data.ratios.vert))
-- 
2.39.5



