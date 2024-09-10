Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801E7190664;
	Tue, 10 Sep 2024 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963482; cv=none; b=Ggr1MRa3j7dquJliB2tKY3feO47JLaX0QOquFtcSt/SNiFxBqTcYf3+i6+YYttyo4TCg0iecG5rNpdt0IOdfZJG7ASedITDESkEx+yBLWIc2Q3Gn6hBoQHl3KnHDdIhVf/WgryEtYQ9N44p8Bw6PH+npluSNuWNvrTwznC9Nqo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963482; c=relaxed/simple;
	bh=vTl3M/eKCFdE2xx4iycU6AHeYbqykOSatZW5x/Jr7QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4TyezmWSbrN+X0FEiAjYfTF5v1YXZg8vrxTWABh9KduJBIZhhNcEM94L4wX2uxAzgIQuDm5XWMGWrhUjjchQ+elpA+WEbSeCMwI3njuw+N22AqBSEGVgHLGS4KujHlpfUGioMQg+JAtXdgPy2MxM4EEPxDqdwyGiAkp645FYU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOujIPwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOujIPwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0507AC4CEC3;
	Tue, 10 Sep 2024 10:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963482;
	bh=vTl3M/eKCFdE2xx4iycU6AHeYbqykOSatZW5x/Jr7QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOujIPwQb0z0ZAaIX8tq/CDqnK2g5eaEWKMuZ0a6TMp2i9hIAFQ1jgAGscRsMn6Ok
	 qtqiUgzG1NsVfxOAV2KjqjM6FZgR8/j5SEh4KBtP5QcAxSuMg+2DUmIncFx6i0Ddqb
	 MgzY785xhLchliTMXhEF3qLvIZ4V0AIlXR1hYMjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>
Subject: [PATCH 5.15 055/214] drm/amd/pm: Fix the null pointer dereference for vega10_hwmgr
Date: Tue, 10 Sep 2024 11:31:17 +0200
Message-ID: <20240910092601.012024452@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

commit 50151b7f1c79a09117837eb95b76c2de76841dab upstream.

Check return value and conduct null pointer handling to avoid null pointer dereference.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Mukul Sikka <mukul.sikka@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c |   30 +++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -3415,13 +3415,17 @@ static int vega10_find_dpm_states_clocks
 	const struct vega10_power_state *vega10_ps =
 			cast_const_phw_vega10_power_state(states->pnew_state);
 	struct vega10_single_dpm_table *sclk_table = &(data->dpm_table.gfx_table);
-	uint32_t sclk = vega10_ps->performance_levels
-			[vega10_ps->performance_level_count - 1].gfx_clock;
 	struct vega10_single_dpm_table *mclk_table = &(data->dpm_table.mem_table);
-	uint32_t mclk = vega10_ps->performance_levels
-			[vega10_ps->performance_level_count - 1].mem_clock;
+	uint32_t sclk, mclk;
 	uint32_t i;
 
+	if (vega10_ps == NULL)
+		return -EINVAL;
+	sclk = vega10_ps->performance_levels
+			[vega10_ps->performance_level_count - 1].gfx_clock;
+	mclk = vega10_ps->performance_levels
+			[vega10_ps->performance_level_count - 1].mem_clock;
+
 	for (i = 0; i < sclk_table->count; i++) {
 		if (sclk == sclk_table->dpm_levels[i].value)
 			break;
@@ -3728,6 +3732,9 @@ static int vega10_generate_dpm_level_ena
 			cast_const_phw_vega10_power_state(states->pnew_state);
 	int i;
 
+	if (vega10_ps == NULL)
+		return -EINVAL;
+
 	PP_ASSERT_WITH_CODE(!vega10_trim_dpm_states(hwmgr, vega10_ps),
 			"Attempt to Trim DPM States Failed!",
 			return -1);
@@ -4865,6 +4872,9 @@ static int vega10_check_states_equal(str
 
 	psa = cast_const_phw_vega10_power_state(pstate1);
 	psb = cast_const_phw_vega10_power_state(pstate2);
+	if (psa == NULL || psb == NULL)
+		return -EINVAL;
+
 	/* If the two states don't even have the same number of performance levels they cannot be the same state. */
 	if (psa->performance_level_count != psb->performance_level_count) {
 		*equal = false;
@@ -4990,6 +5000,8 @@ static int vega10_set_sclk_od(struct pp_
 		return -EINVAL;
 
 	vega10_ps = cast_phw_vega10_power_state(&ps->hardware);
+	if (vega10_ps == NULL)
+		return -EINVAL;
 
 	vega10_ps->performance_levels
 	[vega10_ps->performance_level_count - 1].gfx_clock =
@@ -5041,6 +5053,8 @@ static int vega10_set_mclk_od(struct pp_
 		return -EINVAL;
 
 	vega10_ps = cast_phw_vega10_power_state(&ps->hardware);
+	if (vega10_ps == NULL)
+		return -EINVAL;
 
 	vega10_ps->performance_levels
 	[vega10_ps->performance_level_count - 1].mem_clock =
@@ -5278,6 +5292,9 @@ static void vega10_odn_update_power_stat
 		return;
 
 	vega10_ps = cast_phw_vega10_power_state(&ps->hardware);
+	if (vega10_ps == NULL)
+		return;
+
 	max_level = vega10_ps->performance_level_count - 1;
 
 	if (vega10_ps->performance_levels[max_level].gfx_clock !=
@@ -5300,6 +5317,9 @@ static void vega10_odn_update_power_stat
 
 	ps = (struct pp_power_state *)((unsigned long)(hwmgr->ps) + hwmgr->ps_size * (hwmgr->num_ps - 1));
 	vega10_ps = cast_phw_vega10_power_state(&ps->hardware);
+	if (vega10_ps == NULL)
+		return;
+
 	max_level = vega10_ps->performance_level_count - 1;
 
 	if (vega10_ps->performance_levels[max_level].gfx_clock !=
@@ -5490,6 +5510,8 @@ static int vega10_get_performance_level(
 		return -EINVAL;
 
 	ps = cast_const_phw_vega10_power_state(state);
+	if (ps == NULL)
+		return -EINVAL;
 
 	i = index > ps->performance_level_count - 1 ?
 			ps->performance_level_count - 1 : index;


