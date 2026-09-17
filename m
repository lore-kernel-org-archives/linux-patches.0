Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8C94ABBC7;
	Thu, 17 Sep 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660456; cv=none; b=DIpkfe2H1zbEB8cwSYlAbjHt/034LyQxGLO0Fl01/dCdiY4hVH+zKD5DsQPWrDeY5GlH3+X7u3J9yf18YQvbLf3xH1cRAsUhWQUHwyH2Jx7GS0tNwoM0zSiyBTwHhzY8jHohEwpGlEYc+qgW40AzMRGZCZHKxY+YfFv2mWhmryY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660456; c=relaxed/simple;
	bh=DmD10XPJZBQ80xOr3CyJIecNx4bWqm95h5sOSlEc34A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGgazrY1fUXYAIY5sMSWTke6X1C9Hg64NT2C/kCdxxuKvngFUR0z9O/TdMUtiNmEv5wYYS16soX3KyxcDjy1US5a6nvAVjN9lhRfFvLcmOF3hUqqnmOr9obe+4PCqjU/wXm9fx9CYdUPOFmZ28O7uuYLIOljI+ey09i0fHRjgq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctOmWVbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctOmWVbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5C71F000FF;
	Thu, 17 Sep 2026 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660455;
	bh=Soq0zBGBt0WePW21XtuKi6vAg2pATS/AFkg5vefWb2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctOmWVbzNSIKunTLOuZnNKfrkU97duW9SvuXRrHdPEuFsnNI5C4qRJJO08PAxhDwK
	 7bGRWphGRYWRi52O9iTrk7Lw8aOqvq5ORHFWkpSS7/PW2bt2wXvxUz/jHdWG8b1TIr
	 pTlC+ijjEEc3vwzWxvMtYrymLTZ8LM4Ky3SAQl+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 598/733] media: rkvdec: bound HEVC tile loops and PPS id to the array capacity
Date: Thu, 17 Sep 2026 16:15:06 +0100
Message-ID: <20260917151407.359303121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 81ad46bb33d8fd279aaa33af5296c648814c964b upstream.

compute_tiles_uniform() and compute_tiles_non_uniform() loop over
num_tile_columns_minus1 + 1 / num_tile_rows_minus1 + 1 entries, and
assemble_hw_pps() writes one COLUMN_WIDTH / ROW_HEIGHT register per tile
and indexes priv_tbl->param_set[] by pic_parameter_set_id, all taken from
the untrusted PPS. Use the bounded v4l2_hevc_pps_num_tile_columns() /
v4l2_hevc_pps_num_tile_rows() helpers for the tile loops, and bail out of
assemble_hw_pps() before indexing priv_tbl->param_set[] with an
out-of-range pic_parameter_set_id, so the writes stay within the hardware
tables.

Fixes: 3595375c2301 ("media: rkvdec: Add HEVC backend")
Fixes: c9a59dc2acc7 ("media: rkvdec: Add HEVC support for the VDPU381 variant")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c  |   14 +++++++----
 drivers/media/platform/rockchip/rkvdec/rkvdec-hevc.c         |    7 +++--
 drivers/media/platform/rockchip/rkvdec/rkvdec-vdpu381-hevc.c |    2 +
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/v4l2-common.h>
+#include <media/v4l2-hevc.h>
 #include <media/v4l2-mem2mem.h>
 
 #include "rkvdec.h"
@@ -37,15 +38,17 @@ void compute_tiles_uniform(struct rkvdec
 			   s32 pic_in_cts_height, u16 *column_width, u16 *row_height)
 {
 	const struct v4l2_ctrl_hevc_pps *pps = run->pps;
+	unsigned int num_cols = v4l2_hevc_pps_num_tile_columns(pps);
+	unsigned int num_rows = v4l2_hevc_pps_num_tile_rows(pps);
 	int i;
 
-	for (i = 0; i < pps->num_tile_columns_minus1 + 1; i++)
+	for (i = 0; i < num_cols; i++)
 		column_width[i] = ((i + 1) * pic_in_cts_width) /
 				  (pps->num_tile_columns_minus1 + 1) -
 				  (i * pic_in_cts_width) /
 				  (pps->num_tile_columns_minus1 + 1);
 
-	for (i = 0; i < pps->num_tile_rows_minus1 + 1; i++)
+	for (i = 0; i < num_rows; i++)
 		row_height[i] = ((i + 1) * pic_in_cts_height) /
 				(pps->num_tile_rows_minus1 + 1) -
 				(i * pic_in_cts_height) /
@@ -57,17 +60,20 @@ void compute_tiles_non_uniform(struct rk
 			       s32 pic_in_cts_height, u16 *column_width, u16 *row_height)
 {
 	const struct v4l2_ctrl_hevc_pps *pps = run->pps;
+	unsigned int num_cols = v4l2_hevc_pps_num_tile_columns(pps);
+	unsigned int num_rows = v4l2_hevc_pps_num_tile_rows(pps);
 	s32 sum = 0;
 	int i;
 
-	for (i = 0; i < pps->num_tile_columns_minus1; i++) {
+	/* The last tile entry is written after the loop, so iterate one less. */
+	for (i = 0; i < num_cols - 1; i++) {
 		column_width[i] = pps->column_width_minus1[i] + 1;
 		sum += column_width[i];
 	}
 	column_width[i] = pic_in_cts_width - sum;
 
 	sum = 0;
-	for (i = 0; i < pps->num_tile_rows_minus1; i++) {
+	for (i = 0; i < num_rows - 1; i++) {
 		row_height[i] = pps->row_height_minus1[i] + 1;
 		sum += row_height[i];
 	}
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc.c
@@ -12,6 +12,7 @@
  *	Jeffy Chen <jeffy.chen@rock-chips.com>
  */
 
+#include <media/v4l2-hevc.h>
 #include <media/v4l2-mem2mem.h>
 
 #include "rkvdec.h"
@@ -135,6 +136,8 @@ static void assemble_hw_pps(struct rkvde
 	 * packet unit). so the driver copy SPS/PPS information to the exact PPS
 	 * packet unit for HW accessing.
 	 */
+	if (pps->pic_parameter_set_id >= ARRAY_SIZE(priv_tbl->param_set))
+		return;
 	hw_ps = &priv_tbl->param_set[pps->pic_parameter_set_id];
 	memset(hw_ps, 0, sizeof(*hw_ps));
 
@@ -253,9 +256,9 @@ static void assemble_hw_pps(struct rkvde
 
 	if (pps->flags & V4L2_HEVC_PPS_FLAG_TILES_ENABLED) {
 		/* Userspace also provide column width and row height for uniform spacing */
-		for (i = 0; i <= pps->num_tile_columns_minus1; i++)
+		for (i = 0; i < v4l2_hevc_pps_num_tile_columns(pps); i++)
 			WRITE_PPS(pps->column_width_minus1[i], COLUMN_WIDTH(i));
-		for (i = 0; i <= pps->num_tile_rows_minus1; i++)
+		for (i = 0; i < v4l2_hevc_pps_num_tile_rows(pps); i++)
 			WRITE_PPS(pps->row_height_minus1[i], ROW_HEIGHT(i));
 	} else {
 		WRITE_PPS(((sps->pic_width_in_luma_samples + ctb_size_y - 1) / ctb_size_y) - 1,
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-vdpu381-hevc.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-vdpu381-hevc.c
@@ -145,6 +145,8 @@ static void assemble_hw_pps(struct rkvde
 	 * packet unit). so the driver copy SPS/PPS information to the exact PPS
 	 * packet unit for HW accessing.
 	 */
+	if (pps->pic_parameter_set_id >= ARRAY_SIZE(priv_tbl->param_set))
+		return;
 	hw_ps = &priv_tbl->param_set[pps->pic_parameter_set_id];
 	memset(hw_ps, 0, sizeof(*hw_ps));
 


