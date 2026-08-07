Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B21354AE3;
	Fri,  7 Aug 2026 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117670; cv=none; b=t5CVPxJcL8RRLUqWBBtI37Stf2tnuSE+QJF4QnrG3ZdRo5LSQpBqL2EvDz2JCT1KSTzZo+/439UAhhIX287sIkmzqG95gSvdEw4oN6Rl157iA5/7AzUglCIz328Ene2HmCRr1o4p7X+nR2L7MQzXrWk1aH4bIqOaRIF7UGzzqH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117670; c=relaxed/simple;
	bh=ELYIlXPOshoKePHlKvCkzWMJ5qXaGvHsxfrKRSfNzQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQjCgUzYm3TIDYgDlpnzQBLIpC3jaZkyyGiMt4iK1VAv+3IVTTobTvxcZqjCr9JXiEyi63aI2TW3aYU1FXZmL2jmeFI9ERUcgDOH57JMBZ4HEoMLtQxm9rQRuxknNDjxbZIrFYKAg9P5TJ006MVnmD5yEsHklC1psuPqRIA3TdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL84AeXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL84AeXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6E41F000E9;
	Fri,  7 Aug 2026 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117669;
	bh=oP/+2TthC/XQRGSD+8VeSnWjIUbRmCd4Pu8BFD8egPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aL84AeXjBbJxT2ivFJiHheVOeUsT8BLCp4xaiuM+FVgCbuURQILYQ+fZm8VGBKxiD
	 Wgx82KhhhTfnwIWzNTpFeafiLasMuL5z8rSWeOC76C2M5ioV6eIqCc86CikwvVOMa0
	 y7FTJWyk6cgojjMAu0j6AW7dCbPvdTJkpeK3PnDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 398/438] drm/amd/display: Fix divide-by-zero in calculate_mcache_setting on zero viewport
Date: Fri,  7 Aug 2026 16:39:54 +0200
Message-ID: <20260807143436.446695771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Zhang <george.zhang@amd.com>

commit f327e389c07cfc3a2f6ff54f6214e1a52d457edc upstream.

If a plane reaches calculate_mcache_setting with a zero-area viewport,
calculate_mcache_setting exits early with num_mcaches == 0 and
mvmpg_width/height == 0. This will cause a divide-by-zero panic and can
also cause an underflow on num_mcaches.

Fix this by changing calculate_mcache_setting to bool and adding guards
after each calculate_mcache_row_bytes call. If num_mcaches or
mvmpg_width/height is zero, return a false. Callers will propagate the
failure as a rejected mode, which prevents the panic.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5302
Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 29c0f7c655f47bcbd575ff75e58480df6ec3c9da)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c |   31 ++++++++--
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -2425,7 +2425,7 @@ static void calculate_mcache_row_bytes(
 	DML_ASSERT(*p->num_mcaches > 0);
 }
 
-static void calculate_mcache_setting(
+static bool calculate_mcache_setting(
 	struct dml2_core_internal_scratch *scratch,
 	struct dml2_core_calcs_calculate_mcache_setting_params *p)
 {
@@ -2451,7 +2451,7 @@ static void calculate_mcache_setting(
 	*p->lc_comb_mcache = 0;
 
 	if (!p->dcc_enable)
-		return;
+		return true;
 
 	l->is_dual_plane = dml_is_420(p->source_format) || p->source_format == dml2_rgbe_alpha;
 
@@ -2488,7 +2488,14 @@ static void calculate_mcache_setting(
 	l->l_p.mvmpg_per_mcache_lb = &l->mvmpg_per_mcache_lb_l;
 
 	calculate_mcache_row_bytes(scratch, &l->l_p);
-	DML_ASSERT(*p->num_mcaches_l > 0);
+	if (*p->num_mcaches_l == 0 ||
+	    (p->surf_vert ? l->mvmpg_height_l : l->mvmpg_width_l) == 0) {
+		DML_LOG_VERBOSE("DML::%s: degenerate luma viewport (num_mcaches_l=%u mvmpg_%s_l=%u) — mode not supported\n",
+			__func__, *p->num_mcaches_l,
+			p->surf_vert ? "height" : "width",
+			p->surf_vert ? l->mvmpg_height_l : l->mvmpg_width_l);
+		return false;
+	}
 
 	if (l->is_dual_plane) {
 		l->c_p.num_chans = p->num_chans;
@@ -2524,7 +2531,14 @@ static void calculate_mcache_setting(
 		l->c_p.mvmpg_per_mcache_lb = &l->mvmpg_per_mcache_lb_c;
 
 		calculate_mcache_row_bytes(scratch, &l->c_p);
-		DML_ASSERT(*p->num_mcaches_c > 0);
+		if (*p->num_mcaches_c == 0 ||
+		    (p->surf_vert ? l->mvmpg_height_c : l->mvmpg_width_c) == 0) {
+			DML_LOG_VERBOSE("DML::%s: degenerate chroma viewport (num_mcaches_c=%u mvmpg_%s_c=%u) — mode not supported\n",
+				__func__, *p->num_mcaches_c,
+				p->surf_vert ? "height" : "width",
+				p->surf_vert ? l->mvmpg_height_c : l->mvmpg_width_c);
+			return false;
+		}
 	}
 
 	// Sharing for iMALL access
@@ -2634,6 +2648,7 @@ static void calculate_mcache_setting(
 
 	*p->mcache_shift_granularity_l = l->mvmpg_access_width_l;
 	*p->mcache_shift_granularity_c = l->mvmpg_access_width_c;
+	return true;
 }
 
 static void calculate_mall_bw_overhead_factor(
@@ -9430,7 +9445,10 @@ static bool dml_core_mode_support(struct
 			calculate_mcache_setting_params->mall_comb_mcache_c = &mode_lib->ms.mall_comb_mcache_c[k];
 			calculate_mcache_setting_params->lc_comb_mcache = &mode_lib->ms.lc_comb_mcache[k];
 
-			calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params);
+			if (!calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params)) {
+				mode_lib->ms.support.ModeSupport = false;
+				return false;
+			}
 		}
 
 		calculate_mall_bw_overhead_factor(
@@ -10906,7 +10924,8 @@ static bool dml_core_mode_programming(st
 			calculate_mcache_setting_params->mall_comb_mcache_l = &mode_lib->mp.mall_comb_mcache_l[k];
 			calculate_mcache_setting_params->mall_comb_mcache_c = &mode_lib->mp.mall_comb_mcache_c[k];
 			calculate_mcache_setting_params->lc_comb_mcache = &mode_lib->mp.lc_comb_mcache[k];
-			calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params);
+			if (!calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params))
+				return false;
 		}
 
 		calculate_mall_bw_overhead_factor(


