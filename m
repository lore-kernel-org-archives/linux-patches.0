Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F47186E5E;
	Mon, 12 Aug 2024 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480152; cv=none; b=S8oxqcG8BeJxxjLSat+VUyqBKdL8DiKL8k0+4+ivJAIFc2RGc1wpcApg7qRzvvAITVY5Fb9UFTrRHGs0mVdSZ4C9/hDNLlQhzNX0m1++3TpPT/7bi9fP3XwZ6HZkI/mv0Gg5xD8l6m8tLuPXEK2zAFAoe6uoDqugXfhRKLzF9MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480152; c=relaxed/simple;
	bh=HdyRECe2u+4+61fB4yOcRWrnwMmREf+/lUu9SqAWJLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1NkppTZkLVXaJULV6PhOA/b1BpWde6knc8k72fU6YE2JQG/iFmOk6b/yhurJi1Kig8AyTui0fUNIbS8LedzKu6ZcMHJKT8GuIbQGHYsoiOwhsWuXHXOrNwMc5cWD8fBsjp0L4qGoCnuCrOSzOcShjvOfXpWmbhZlrx76IHi/WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPs7KOtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPs7KOtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D488C32782;
	Mon, 12 Aug 2024 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480151;
	bh=HdyRECe2u+4+61fB4yOcRWrnwMmREf+/lUu9SqAWJLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPs7KOtwO+U0HxQNs2sdJAGErf1HJmtqHgHbfQ0Ydnr3YrCo/V8qJXt1jmzyNW715
	 oB2Xrtr6I/j3JYdbDcN6Y4I9rXTdLlSAASZE4viYII1CxldSX5/VdNmZvOvWaDbuZ5
	 6rBOskzUAu+7eb5WoHdHMpoX0UgJGyEcJ4BsXAmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/263] drm/amd/display: Fix NULL pointer dereference for DTN log in DCN401
Date: Mon, 12 Aug 2024 18:01:51 +0200
Message-ID: <20240812160150.755713683@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Rodrigo Siqueira <rodrigo.siqueira@amd.com>

[ Upstream commit 5af757124792817f8eb1bd0c80ad60fab519586b ]

When users run the command:

cat /sys/kernel/debug/dri/0/amdgpu_dm_dtn_log

The following NULL pointer dereference happens:

[  +0.000003] BUG: kernel NULL pointer dereference, address: NULL
[  +0.000005] #PF: supervisor instruction fetch in kernel mode
[  +0.000002] #PF: error_code(0x0010) - not-present page
[  +0.000002] PGD 0 P4D 0
[  +0.000004] Oops: 0010 [#1] PREEMPT SMP NOPTI
[  +0.000003] RIP: 0010:0x0
[  +0.000008] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[...]
[  +0.000002] PKRU: 55555554
[  +0.000002] Call Trace:
[  +0.000002]  <TASK>
[  +0.000003]  ? show_regs+0x65/0x70
[  +0.000006]  ? __die+0x24/0x70
[  +0.000004]  ? page_fault_oops+0x160/0x470
[  +0.000006]  ? do_user_addr_fault+0x2b5/0x690
[  +0.000003]  ? prb_read_valid+0x1c/0x30
[  +0.000005]  ? exc_page_fault+0x8c/0x1a0
[  +0.000005]  ? asm_exc_page_fault+0x27/0x30
[  +0.000012]  dcn10_log_color_state+0xf9/0x510 [amdgpu]
[  +0.000306]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000003]  ? vsnprintf+0x2fb/0x600
[  +0.000009]  dcn10_log_hw_state+0xfd0/0xfe0 [amdgpu]
[  +0.000218]  ? __mod_memcg_lruvec_state+0xe8/0x170
[  +0.000008]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000002]  ? debug_smp_processor_id+0x17/0x20
[  +0.000003]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000002]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000002]  ? set_ptes.isra.0+0x2b/0x90
[  +0.000004]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000002]  ? _raw_spin_unlock+0x19/0x40
[  +0.000004]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000002]  ? do_anonymous_page+0x337/0x700
[  +0.000004]  dtn_log_read+0x82/0x120 [amdgpu]
[  +0.000207]  full_proxy_read+0x66/0x90
[  +0.000007]  vfs_read+0xb0/0x340
[  +0.000005]  ? __count_memcg_events+0x79/0xe0
[  +0.000002]  ? srso_alias_return_thunk+0x5/0xfbef5
[  +0.000003]  ? count_memcg_events.constprop.0+0x1e/0x40
[  +0.000003]  ? handle_mm_fault+0xb2/0x370
[  +0.000003]  ksys_read+0x6b/0xf0
[  +0.000004]  __x64_sys_read+0x19/0x20
[  +0.000003]  do_syscall_64+0x60/0x130
[  +0.000004]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  +0.000003] RIP: 0033:0x7fdf32f147e2
[...]

This error happens when the color log tries to read the gamut remap
information from DCN401 which is not initialized in the dcn401_dpp_funcs
which leads to a null pointer dereference. This commit addresses this
issue by adding a proper guard to access the gamut_remap callback in
case the specific ASIC did not implement this function.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn10/dcn10_hwseq.c   | 49 ++++++++++---------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index 0c4aef8ffe2c5..3306684e805ac 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -288,6 +288,7 @@ static void dcn10_log_color_state(struct dc *dc,
 {
 	struct dc_context *dc_ctx = dc->ctx;
 	struct resource_pool *pool = dc->res_pool;
+	bool is_gamut_remap_available = false;
 	int i;
 
 	DTN_INFO("DPP:    IGAM format    IGAM mode    DGAM mode    RGAM mode"
@@ -300,16 +301,15 @@ static void dcn10_log_color_state(struct dc *dc,
 		struct dcn_dpp_state s = {0};
 
 		dpp->funcs->dpp_read_state(dpp, &s);
-		dpp->funcs->dpp_get_gamut_remap(dpp, &s.gamut_remap);
+		if (dpp->funcs->dpp_get_gamut_remap) {
+			dpp->funcs->dpp_get_gamut_remap(dpp, &s.gamut_remap);
+			is_gamut_remap_available = true;
+		}
 
 		if (!s.is_enabled)
 			continue;
 
-		DTN_INFO("[%2d]:  %11xh  %11s    %9s    %9s"
-			 "  %12s  "
-			 "%010lld %010lld %010lld %010lld "
-			 "%010lld %010lld %010lld %010lld "
-			 "%010lld %010lld %010lld %010lld",
+		DTN_INFO("[%2d]:  %11xh  %11s    %9s    %9s",
 				dpp->inst,
 				s.igam_input_format,
 				(s.igam_lut_mode == 0) ? "BypassFixed" :
@@ -328,22 +328,27 @@ static void dcn10_log_color_state(struct dc *dc,
 					((s.rgam_lut_mode == 2) ? "Ycc" :
 					((s.rgam_lut_mode == 3) ? "RAM" :
 					((s.rgam_lut_mode == 4) ? "RAM" :
-								 "Unknown")))),
-				(s.gamut_remap.gamut_adjust_type == 0) ? "Bypass" :
-					((s.gamut_remap.gamut_adjust_type == 1) ? "HW" :
-										  "SW"),
-				s.gamut_remap.temperature_matrix[0].value,
-				s.gamut_remap.temperature_matrix[1].value,
-				s.gamut_remap.temperature_matrix[2].value,
-				s.gamut_remap.temperature_matrix[3].value,
-				s.gamut_remap.temperature_matrix[4].value,
-				s.gamut_remap.temperature_matrix[5].value,
-				s.gamut_remap.temperature_matrix[6].value,
-				s.gamut_remap.temperature_matrix[7].value,
-				s.gamut_remap.temperature_matrix[8].value,
-				s.gamut_remap.temperature_matrix[9].value,
-				s.gamut_remap.temperature_matrix[10].value,
-				s.gamut_remap.temperature_matrix[11].value);
+								 "Unknown")))));
+		if (is_gamut_remap_available)
+			DTN_INFO("  %12s  "
+				 "%010lld %010lld %010lld %010lld "
+				 "%010lld %010lld %010lld %010lld "
+				 "%010lld %010lld %010lld %010lld",
+				 (s.gamut_remap.gamut_adjust_type == 0) ? "Bypass" :
+					((s.gamut_remap.gamut_adjust_type == 1) ? "HW" : "SW"),
+				 s.gamut_remap.temperature_matrix[0].value,
+				 s.gamut_remap.temperature_matrix[1].value,
+				 s.gamut_remap.temperature_matrix[2].value,
+				 s.gamut_remap.temperature_matrix[3].value,
+				 s.gamut_remap.temperature_matrix[4].value,
+				 s.gamut_remap.temperature_matrix[5].value,
+				 s.gamut_remap.temperature_matrix[6].value,
+				 s.gamut_remap.temperature_matrix[7].value,
+				 s.gamut_remap.temperature_matrix[8].value,
+				 s.gamut_remap.temperature_matrix[9].value,
+				 s.gamut_remap.temperature_matrix[10].value,
+				 s.gamut_remap.temperature_matrix[11].value);
+
 		DTN_INFO("\n");
 	}
 	DTN_INFO("\n");
-- 
2.43.0



