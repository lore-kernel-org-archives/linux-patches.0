Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C774E314B8F;
	Sat, 17 Oct 2026 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254538; cv=none; b=AR5jN7asI5kfDsXyUclCvakPc7/sdexMFOXXLEU6xHtlQDkeawrIrSTl6X0FDtOjzyo/s8uHe6gcC2We6jKHhVMhbP3N/UnLGcfk7kukkBv6CiVG2AvjkXyfuIM06NHP+wzbVt5ahR39Ht1wb/lvwdey9mRPxRfmjjdvyJ9s0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254538; c=relaxed/simple;
	bh=Vd1fomz9Vu12aSpJjjzRj4CgnAjvrumCCyDgXI9UQ0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IQtUkATRheT6Rc7n9TGFTRWjeytVO36dANiKceI8MCcq2h+AWRBzu2M7mRRBWszYxVKku+80gAnYYJr/fDBwGWWJFo+y7k/vw/fV/J3PfJ4t/IMuN4H4aiw0vZHFhjr9oWhzmnsSzBHuly05oy0wsfV8ncwAhls8Inubw7TCDnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuI0F+dI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuI0F+dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216C1F000C4;
	Sat, 17 Oct 2026 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254537;
	bh=uQ6fuxax0/Li4O3vIh69eF3BTZof/hhw/GcyThIXKnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuI0F+dIV/2eQ0UgwvIMD5NHs2O78Md92TDcAXpjKqpvmpY2PSPh0tJdVk1G3tv2N
	 2EJpA3f9zP8OD3s8xLKOg2H0a06lxyCY/Ps+4+LFC6Ryao1SCdodc6WkEzrl5RJU6T
	 d5viDQBBHiyHjoJawB8FPutJ4PGEH5i028JLk50k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/869] drm/amd/display: Fix divide-by-zero in calculate_mcache_setting on zero viewport
Date: Sat, 17 Oct 2026 17:55:22 +0200
Message-ID: <20261017160049.452667267@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Zhang <george.zhang@amd.com>

[ Upstream commit f327e389c07cfc3a2f6ff54f6214e1a52d457edc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../src/dml2_core/dml2_core_dcn4_calcs.c      | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index d18b60c9761bd..37dd05d917685 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -2449,7 +2449,7 @@ static void calculate_mcache_row_bytes(
 	DML2_ASSERT(*p->num_mcaches > 0);
 }
 
-static void calculate_mcache_setting(
+static bool calculate_mcache_setting(
 	struct dml2_core_internal_scratch *scratch,
 	struct dml2_core_calcs_calculate_mcache_setting_params *p)
 {
@@ -2473,7 +2473,7 @@ static void calculate_mcache_setting(
 	*p->lc_comb_mcache = 0;
 
 	if (!p->dcc_enable)
-		return;
+		return true;
 
 	l->is_dual_plane = dml_is_420(p->source_format) || p->source_format == dml2_rgbe_alpha;
 
@@ -2509,7 +2509,14 @@ static void calculate_mcache_setting(
 	l->l_p.mvmpg_per_mcache_lb = &l->mvmpg_per_mcache_lb_l;
 
 	calculate_mcache_row_bytes(scratch, &l->l_p);
-	dml2_assert(*p->num_mcaches_l > 0);
+	if (*p->num_mcaches_l == 0 ||
+	    (p->surf_vert ? l->mvmpg_height_l : l->mvmpg_width_l) == 0) {
+		dml2_printf("DML::%s: degenerate luma viewport (num_mcaches_l=%u mvmpg_%s_l=%u) — mode not supported\n",
+			__func__, *p->num_mcaches_l,
+			p->surf_vert ? "height" : "width",
+			p->surf_vert ? l->mvmpg_height_l : l->mvmpg_width_l);
+		return false;
+	}
 
 	if (l->is_dual_plane) {
 		l->c_p.num_chans = p->num_chans;
@@ -2544,7 +2551,14 @@ static void calculate_mcache_setting(
 		l->c_p.mvmpg_per_mcache_lb = &l->mvmpg_per_mcache_lb_c;
 
 		calculate_mcache_row_bytes(scratch, &l->c_p);
-		dml2_assert(*p->num_mcaches_c > 0);
+		if (*p->num_mcaches_c == 0 ||
+		    (p->surf_vert ? l->mvmpg_height_c : l->mvmpg_width_c) == 0) {
+			dml2_printf("DML::%s: degenerate chroma viewport (num_mcaches_c=%u mvmpg_%s_c=%u) — mode not supported\n",
+				__func__, *p->num_mcaches_c,
+				p->surf_vert ? "height" : "width",
+				p->surf_vert ? l->mvmpg_height_c : l->mvmpg_width_c);
+			return false;
+		}
 	}
 
 	// Sharing for iMALL access
@@ -2652,6 +2666,7 @@ static void calculate_mcache_setting(
 
 	*p->mcache_shift_granularity_l = l->mvmpg_access_width_l;
 	*p->mcache_shift_granularity_c = l->mvmpg_access_width_c;
+	return true;
 }
 
 static void calculate_mall_bw_overhead_factor(
@@ -8481,7 +8496,10 @@ static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out
 			calculate_mcache_setting_params->mall_comb_mcache_c = &mode_lib->ms.mall_comb_mcache_c[k];
 			calculate_mcache_setting_params->lc_comb_mcache = &mode_lib->ms.lc_comb_mcache[k];
 
-			calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params);
+			if (!calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params)) {
+				mode_lib->ms.support.ModeSupport = false;
+				return false;
+			}
 		}
 
 		calculate_mall_bw_overhead_factor(
@@ -10483,7 +10501,8 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 			calculate_mcache_setting_params->mall_comb_mcache_l = &mode_lib->mp.mall_comb_mcache_l[k];
 			calculate_mcache_setting_params->mall_comb_mcache_c = &mode_lib->mp.mall_comb_mcache_c[k];
 			calculate_mcache_setting_params->lc_comb_mcache = &mode_lib->mp.lc_comb_mcache[k];
-			calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params);
+			if (!calculate_mcache_setting(&mode_lib->scratch, calculate_mcache_setting_params))
+				return false;
 		}
 
 		calculate_mall_bw_overhead_factor(
-- 
2.53.0



