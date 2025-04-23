Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF8E29CB50;
	Wed, 23 Apr 2025 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421477; cv=none; b=bZF2UKtmU+wIQRqT31gmZ6Kg1xbjpBjwWX0JL0jVhQeeF3Ffmd6cmV4NgR8zpBMsQkRFwjYjC0RtlOBUaFGiLaomvJsseESQIESmXqzom/Eu0r5kfTrcT+24DUXzCYCvkc8uRdPZ/MUAkEtBu8N2ICgq73Uj3Q/kg19Cqw36hHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421477; c=relaxed/simple;
	bh=J/exJj/lwB+I9lz2mV1D7ceOb0AaKbwwmcEiMlXrcaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipzPSj0pnTrDHuVZ83n6t9wGKzJrM+k/6k6IW4fyylcdnBpOM8ec9ZjTSxRrlg450FYgMCbJ/zrVAkTZWNLBfazZftuvaLLm0/AuTXNu75zgkIYDS88F3OInR6ScYmFjS5YzwQ0NDQl5g85Ol+PHe/vo1tbIoyM/p3rxSZSpqj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suxqX0J3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suxqX0J3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1368DC4CEE2;
	Wed, 23 Apr 2025 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421476;
	bh=J/exJj/lwB+I9lz2mV1D7ceOb0AaKbwwmcEiMlXrcaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suxqX0J3bV0h3M+z6NfXVF93woxlFJe0g+P+PV88iIpCoiCima2VJxI9ao40fB4q2
	 YqA/+TWSDsrQpJ6mF4zkz9aaudUkN52Ct98BWjUFtyTBqKQ1o+4d059LAG3viOlufE
	 +mwzFrZ7q0WWf3YWtjEAi3qsubUty4Mt67m+Uo/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Dongyan Qian <qiandongyan@loongson.cn>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 193/241] drm/amd/display: Protect FPU in dml2_validate()/dml21_validate()
Date: Wed, 23 Apr 2025 16:44:17 +0200
Message-ID: <20250423142628.399943771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 366e77cd4923c3aa45341e15dcaf3377af9b042f upstream.

Commit 7da55c27e76749b9 ("drm/amd/display: Remove incorrect FP context
start") removes the FP context protection of dml2_create(), and it said
"All the DC_FP_START/END should be used before call anything from DML2".

However, dml2_validate()/dml21_validate() are not protected from their
callers, causing such errors:

 do_fpu invoked from kernel context![#1]:
 CPU: 10 UID: 0 PID: 331 Comm: kworker/10:1H Not tainted 6.14.0-rc6+ #4
 Workqueue: events_highpri dm_irq_work_func [amdgpu]
 pc ffff800003191eb0 ra ffff800003191e60 tp 9000000107a94000 sp 9000000107a975b0
 a0 9000000140ce4910 a1 0000000000000000 a2 9000000140ce49b0 a3 9000000140ce49a8
 a4 9000000140ce49a8 a5 0000000100000000 a6 0000000000000001 a7 9000000107a97660
 t0 ffff800003790000 t1 9000000140ce5000 t2 0000000000000001 t3 0000000000000000
 t4 0000000000000004 t5 0000000000000000 t6 0000000000000000 t7 0000000000000000
 t8 0000000100000000 u0 ffff8000031a3b9c s9 9000000130bc0000 s0 9000000132400000
 s1 9000000140ec0000 s2 9000000132400000 s3 9000000140ce0000 s4 90000000057f8b88
 s5 9000000140ec0000 s6 9000000140ce4910 s7 0000000000000001 s8 9000000130d45010
 ra: ffff800003191e60 dml21_map_dc_state_into_dml_display_cfg+0x40/0x1140 [amdgpu]
   ERA: ffff800003191eb0 dml21_map_dc_state_into_dml_display_cfg+0x90/0x1140 [amdgpu]
  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000f0000 [FPD] (IS= ECode=15 EsubCode=0)
  PRID: 0014d010 (Loongson-64bit, Loongson-3C6000/S)
 Process kworker/10:1H (pid: 331, threadinfo=000000007bf9ddb0, task=00000000cc4ab9f3)
 Stack : 0000000100000000 0000043800000780 0000000100000001 0000000100000001
         0000000000000000 0000078000000000 0000000000000438 0000078000000000
         0000000000000438 0000078000000000 0000000000000438 0000000100000000
         0000000100000000 0000000100000000 0000000100000000 0000000100000000
         0000000000000001 9000000140ec0000 9000000132400000 9000000132400000
         ffff800003408000 ffff800003408000 9000000132400000 9000000140ce0000
         9000000140ce0000 ffff800003193850 0000000000000001 9000000140ec0000
         9000000132400000 9000000140ec0860 9000000140ec0738 0000000000000001
         90000001405e8000 9000000130bc0000 9000000140ec02a8 ffff8000031b5db8
         0000000000000000 0000043800000780 0000000000000003 ffff8000031b79cc
         ...
 Call Trace:
 [<ffff800003191eb0>] dml21_map_dc_state_into_dml_display_cfg+0x90/0x1140 [amdgpu]
 [<ffff80000319384c>] dml21_validate+0xcc/0x520 [amdgpu]
 [<ffff8000031b8948>] dc_validate_global_state+0x2e8/0x460 [amdgpu]
 [<ffff800002e94034>] create_validate_stream_for_sink+0x3d4/0x420 [amdgpu]
 [<ffff800002e940e4>] amdgpu_dm_connector_mode_valid+0x64/0x240 [amdgpu]
 [<900000000441d6b8>] drm_connector_mode_valid+0x38/0x80
 [<900000000441d824>] __drm_helper_update_and_validate+0x124/0x3e0
 [<900000000441ddc0>] drm_helper_probe_single_connector_modes+0x2e0/0x620
 [<90000000044050dc>] drm_client_modeset_probe+0x23c/0x1780
 [<9000000004420384>] __drm_fb_helper_initial_config_and_unlock+0x44/0x5a0
 [<9000000004403acc>] drm_client_dev_hotplug+0xcc/0x140
 [<ffff800002e9ab50>] handle_hpd_irq_helper+0x1b0/0x1e0 [amdgpu]
 [<90000000038f5da0>] process_one_work+0x160/0x300
 [<90000000038f6718>] worker_thread+0x318/0x440
 [<9000000003901b8c>] kthread+0x12c/0x220
 [<90000000038b1484>] ret_from_kernel_thread+0x8/0xa4

Unfortunately, protecting dml2_validate()/dml21_validate() out of DML2
causes "sleeping function called from invalid context", so protect them
with DC_FP_START() and DC_FP_END() inside.

Fixes: 7da55c27e767 ("drm/amd/display: Remove incorrect FP context start")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Tested-by: Dongyan Qian <qiandongyan@loongson.cn>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c |    9 +++++++--
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c        |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -269,11 +269,16 @@ bool dml21_validate(const struct dc *in_
 {
 	bool out = false;
 
+	DC_FP_START();
+
 	/* Use dml_validate_only for fast_validate path */
-	if (fast_validate) {
+	if (fast_validate)
 		out = dml21_check_mode_support(in_dc, context, dml_ctx);
-	} else
+	else
 		out = dml21_mode_check_and_programming(in_dc, context, dml_ctx);
+
+	DC_FP_END();
+
 	return out;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -732,11 +732,16 @@ bool dml2_validate(const struct dc *in_d
 		return out;
 	}
 
+	DC_FP_START();
+
 	/* Use dml_validate_only for fast_validate path */
 	if (fast_validate)
 		out = dml2_validate_only(context);
 	else
 		out = dml2_validate_and_build_resource(in_dc, context);
+
+	DC_FP_END();
+
 	return out;
 }
 


