Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7C014831F;
	Tue, 30 Jul 2024 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358135; cv=none; b=dTGLVlRp+3Fi0IiLMhkv3AfFBEd/5yQAYqEfQz4TjuoY6gXZt9zhBIOaSOPogNWfSjP5Tr7CMzBV5ylvhssJA4N3qgX9vd7bpfU1d6ogn23BlEaWYMsnSy0gp5N1GCP1GspFi7gbmgTGXXFK48wla2OfNUaZQIEAryQWZXOq0rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358135; c=relaxed/simple;
	bh=Ue++hnAzbXuS+/GXxeMAdcWFlPMfD/PcO+liEdccaT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTewY3O4eSi4H3loXLe5AqgnN+1Jd4xJlPuhgDHAS/EAhpdQHMPYurNA35NqGxUPyKN225c4jumZWEHxDttbUONT+Jnh5LN5efVLJGJaQ4vfiGmsT2LX03gEw5vZevaYAhPKVjf9ZTIH0JEsP38NskNixVzzYQ36dwPwu59nH4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3gxKn/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3gxKn/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17275C4AF0C;
	Tue, 30 Jul 2024 16:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358135;
	bh=Ue++hnAzbXuS+/GXxeMAdcWFlPMfD/PcO+liEdccaT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3gxKn/p1ZOVoz23rFbJ1ZMiJANfLzGmc4TexDbMDlI2fJa2LWnRmDQZK0g11uZbT
	 5MS1XqPubagsnz1lS966tRCnnmKf47pWDkhgNgkCjOAJbtvjj4Db+6osSvn3pvOZiV
	 D/ggnFDRQG3SnWsQkDQ0QvfsWCjoXpNVQx+IudFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	Sasha Levin <sashal@kernel.org>,
	George Zhang <George.zhang@amd.com>
Subject: [PATCH 6.10 308/809] drm/amd/display: use pre-allocated temp structure for bounding box
Date: Tue, 30 Jul 2024 17:43:04 +0200
Message-ID: <20240730151736.763458353@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit afe9555e79fcd0d758e3796ad00fd6292d99361b ]

This mirrors what the driver does for older DCN generations.

Should fix:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:306
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 449, name: kworker/u64:8
preempt_count: 2, expected: 0
RCU nest depth: 0, expected: 0
Preemption disabled at:
ffffffffc0ce1580>] dc_fpu_begin+0x30/0xd0 [amdgpu]
CPU: 5 PID: 449 Comm: kworker/u64:8 Tainted: G        W          6.8.0+ #35
Hardware name: System manufacturer System Product Name/ROG STRIX X570-E GAMING WIFI II, BIOS 4204 02/24/2022
Workqueue: events_unbound async_run_entry_fn

v2: drop extra memcpy

Fixes: 88c61827cedc ("drm/amd/display: dynamically allocate dml2_configuration_options structures")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: George Zhang <George.zhang@amd.com> (v1)
Suggested-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: George Zhang <george.zhang@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: harry.wentland@amd.com
Cc: sunpeng.li@amd.com
Cc: Rodrigo.Siqueira@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                       | 1 +
 .../drm/amd/display/dc/resource/dcn32/dcn32_resource.c    | 8 ++------
 .../drm/amd/display/dc/resource/dcn321/dcn321_resource.c  | 8 ++------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 3c33c3bcbe2cb..4362fca1f15ad 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1392,6 +1392,7 @@ struct dc {
 	} scratch;
 
 	struct dml2_configuration_options dml2_options;
+	struct dml2_configuration_options dml2_tmp;
 	enum dc_acpi_cm_power_state power_state;
 
 };
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index 957002967d691..d84c8e0e5c2f0 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -2006,11 +2006,9 @@ void dcn32_calculate_wm_and_dlg(struct dc *dc, struct dc_state *context,
 
 static void dcn32_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params)
 {
-	struct dml2_configuration_options *dml2_opt;
+	struct dml2_configuration_options *dml2_opt = &dc->dml2_tmp;
 
-	dml2_opt = kmemdup(&dc->dml2_options, sizeof(dc->dml2_options), GFP_KERNEL);
-	if (!dml2_opt)
-		return;
+	memcpy(dml2_opt, &dc->dml2_options, sizeof(dc->dml2_options));
 
 	DC_FP_START();
 
@@ -2025,8 +2023,6 @@ static void dcn32_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw
 		dml2_reinit(dc, dml2_opt, &dc->current_state->bw_ctx.dml2_dc_power_source);
 
 	DC_FP_END();
-
-	kfree(dml2_opt);
 }
 
 static struct resource_funcs dcn32_res_pool_funcs = {
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
index 07ca6f58447d6..9a3cc0514a36e 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1581,11 +1581,9 @@ static struct dc_cap_funcs cap_funcs = {
 
 static void dcn321_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params)
 {
-	struct dml2_configuration_options *dml2_opt;
+	struct dml2_configuration_options *dml2_opt = &dc->dml2_tmp;
 
-	dml2_opt = kmemdup(&dc->dml2_options, sizeof(dc->dml2_options), GFP_KERNEL);
-	if (!dml2_opt)
-		return;
+	memcpy(dml2_opt, &dc->dml2_options, sizeof(dc->dml2_options));
 
 	DC_FP_START();
 
@@ -1600,8 +1598,6 @@ static void dcn321_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 		dml2_reinit(dc, dml2_opt, &dc->current_state->bw_ctx.dml2_dc_power_source);
 
 	DC_FP_END();
-
-	kfree(dml2_opt);
 }
 
 static struct resource_funcs dcn321_res_pool_funcs = {
-- 
2.43.0



