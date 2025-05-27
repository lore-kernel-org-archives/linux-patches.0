Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831CF28031C;
	Tue, 27 May 2025 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367427; cv=none; b=HncDr3BPURzT4kIbX1aZ+50n9NlfyW1Wpe1ehbUbfsFqZmImNR+z3TxnSJkN27wOSiYZykSVogCNXvCmrtTgrlqM52L6bt9DLTpN8PU9S6K1ffz+aTmaif03fGqjkf7GwLYL//uUHAzl6chIEE1UvzXZA5Cpjq5rQ5IxpnZtXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367427; c=relaxed/simple;
	bh=JRHGkeNF1//2w6QaglG4aT/31sR7eX2bUo2exR2tSqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfZtDi/VdKQqqm4OuxcXMNi1j2clVXhNPXyl+qKi7gXuAVo8NQClaZg2aYIREtHh0ESSs9b347gpNfR6+HBwQwL6c5RLGEzRdKolDC81BC5VUzMfUVw3elWxI91X7qziHPUtJCJV5g+sa1GCYXrLr1DXJBDTAjQg4ybsXY3eD7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI3tMKVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI3tMKVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5552C4CEE9;
	Tue, 27 May 2025 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367427;
	bh=JRHGkeNF1//2w6QaglG4aT/31sR7eX2bUo2exR2tSqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI3tMKVYI0n+1tYhcnqGT2Z74WFHlMBXAZQoF+jqPNU0l2YhavlIrTPzRftht15bz
	 PjLB2/R3lFClMyFUgpTVJX2HMCM+IFNXo9Md5aB3cON1F0IuaX4uLPyZZtId8P//7D
	 MJVodKAwawu/fQT2NLiXURrH09Rw9Kxlgr4o2L24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navid Assadian <Navid.Assadian@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 354/783] drm/amd/display: Add opp recout adjustment
Date: Tue, 27 May 2025 18:22:31 +0200
Message-ID: <20250527162527.485384623@linuxfoundation.org>
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

From: Navid Assadian <Navid.Assadian@amd.com>

[ Upstream commit fba4d19f3731483ee8565f9e9bb7ed9fc89479e8 ]

[Why]
For subsampled YUV output formats, more pixels can get fetched and be
used for scaling.

[How]
Add the adjustment to the calculated recout, so the viewport covers the
corresponding pixels on the source plane.

Signed-off-by: Navid Assadian <Navid.Assadian@amd.com>
Reviewed-by: Samson Tam <Samson.Tam@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/spl/dc_spl.c   | 31 +++++++++++++++----
 .../gpu/drm/amd/display/dc/spl/dc_spl_types.h | 10 ++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
index 22602f088553d..153b7a8904e1e 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
@@ -76,6 +76,21 @@ static struct spl_rect shift_rec(const struct spl_rect *rec_in, int x, int y)
 	return rec_out;
 }
 
+static void spl_opp_adjust_rect(struct spl_rect *rec, const struct spl_opp_adjust *adjust)
+{
+	if ((rec->x + adjust->x) >= 0)
+		rec->x += adjust->x;
+
+	if ((rec->y + adjust->y) >= 0)
+		rec->y += adjust->y;
+
+	if ((rec->width + adjust->width) >= 1)
+		rec->width += adjust->width;
+
+	if ((rec->height + adjust->height) >= 1)
+		rec->height += adjust->height;
+}
+
 static struct spl_rect calculate_plane_rec_in_timing_active(
 		struct spl_in *spl_in,
 		const struct spl_rect *rec_in)
@@ -723,13 +738,15 @@ static void spl_handle_3d_recout(struct spl_in *spl_in, struct spl_rect *recout)
 	}
 }
 
-static void spl_clamp_viewport(struct spl_rect *viewport)
+static void spl_clamp_viewport(struct spl_rect *viewport, int min_viewport_size)
 {
+	if (min_viewport_size == 0)
+		min_viewport_size = MIN_VIEWPORT_SIZE;
 	/* Clamp minimum viewport size */
-	if (viewport->height < MIN_VIEWPORT_SIZE)
-		viewport->height = MIN_VIEWPORT_SIZE;
-	if (viewport->width < MIN_VIEWPORT_SIZE)
-		viewport->width = MIN_VIEWPORT_SIZE;
+	if (viewport->height < min_viewport_size)
+		viewport->height = min_viewport_size;
+	if (viewport->width < min_viewport_size)
+		viewport->width = min_viewport_size;
 }
 
 static enum scl_mode spl_get_dscl_mode(const struct spl_in *spl_in,
@@ -1800,6 +1817,8 @@ static bool spl_calculate_number_of_taps(struct spl_in *spl_in, struct spl_scrat
 	spl_calculate_recout(spl_in, spl_scratch, spl_out);
 	/* depends on pixel format */
 	spl_calculate_scaling_ratios(spl_in, spl_scratch, spl_out);
+	/* Adjust recout for opp if needed */
+	spl_opp_adjust_rect(&spl_scratch->scl_data.recout, &spl_in->basic_in.opp_recout_adjust);
 	/* depends on scaling ratios and recout, does not calculate offset yet */
 	spl_calculate_viewport_size(spl_in, spl_scratch);
 
@@ -1836,7 +1855,7 @@ bool spl_calculate_scaler_params(struct spl_in *spl_in, struct spl_out *spl_out)
 	// Handle 3d recout
 	spl_handle_3d_recout(spl_in, &spl_scratch.scl_data.recout);
 	// Clamp
-	spl_clamp_viewport(&spl_scratch.scl_data.viewport);
+	spl_clamp_viewport(&spl_scratch.scl_data.viewport, spl_in->min_viewport_size);
 
 	// Save all calculated parameters in dscl_prog_data structure to program hw registers
 	spl_set_dscl_prog_data(spl_in, &spl_scratch, spl_out, enable_easf_v, enable_easf_h, enable_isharp);
diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h b/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
index 5d139cf51e89b..1c3949b24611f 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
@@ -427,6 +427,14 @@ struct spl_out	{
 
 // SPL inputs
 
+// opp extra adjustment for rect
+struct spl_opp_adjust {
+	int x;
+	int y;
+	int width;
+	int height;
+};
+
 // Basic input information
 struct basic_in	{
 	enum spl_pixel_format format; // Pixel Format
@@ -444,6 +452,7 @@ struct basic_in	{
 		} num_slices_recout_width;
 	} num_h_slices_recout_width_align;
 	int mpc_h_slice_index; // previous mpc_combine_v - split_idx
+	struct spl_opp_adjust opp_recout_adjust;
 	// Inputs for adaptive scaler - TODO
 	enum spl_transfer_func_type tf_type; /* Transfer function type */
 	enum spl_transfer_func_predefined tf_predefined_type; /* Transfer function predefined type */
@@ -535,6 +544,7 @@ struct spl_in	{
 	bool is_hdr_on;
 	int h_active;
 	int v_active;
+	int min_viewport_size;
 	int sdr_white_level_nits;
 	enum sharpen_policy sharpen_policy;
 };
-- 
2.39.5



