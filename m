Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC5B28A1F7;
	Wed, 23 Apr 2025 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420978; cv=none; b=jxczlQeqj2L37YMuxgHeR3eUfChlJ6HsnFF5IGJvAxSTQVmV1zakUJ4zGRhlToK/r1OZ2AcbGI7TOmDPAgg89cA+yPdtXJ4tkHH8vSrt2Jg9LA+jOuUy34IHtxoo11c0yKFZ4XGgpY6WYyuw+k2FevaM7a/lSR1hNMnFuYasMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420978; c=relaxed/simple;
	bh=sDB0TOIqimMhu8cyn3EAEbeWn+rRjBAQT6UGgeNcw2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VREuKZVxFCkiXtjwoDU0Nr29puKuEe0iH3KOldxVd9xw4ffGK2dzA6nzttOa6vW+PhBckyXzNdAv+k7v39go9l8HureW7mSOkOH3VvSKogsQcZQ9bRmJgrnUsLmZc2gpCuzOQCY6frjaxtw9HGBfKJBtp5FS8Ydrwv1zLmB/St4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjk+zNiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjk+zNiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7C7C4CEE2;
	Wed, 23 Apr 2025 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420978;
	bh=sDB0TOIqimMhu8cyn3EAEbeWn+rRjBAQT6UGgeNcw2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjk+zNiCFNSwGuncwALysvs3T9y9TsirzWAr4A3lp6DZNCP9zwAzq6haQK1mgZ9zh
	 G6XD9hlea60nXrrKaAb7FQmZtS6U1tB5p7UjYVzANO9nBShqH6fCEEvSUHl0P2Lsyy
	 gL5tK4bD1Y+Qck2PLnXAvwHH43vvZbFtXZngfvnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 179/223] drm/amd/display: Protect FPU in dml2_init()/dml21_init()
Date: Wed, 23 Apr 2025 16:44:11 +0200
Message-ID: <20250423142624.461725223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit afcdf51d97cd58dd7a2e0aa8acbaea5108fa6826 upstream.

Commit 7da55c27e76749b9 ("drm/amd/display: Remove incorrect FP context
start") removes the FP context protection of dml2_create(), and it said
"All the DC_FP_START/END should be used before call anything from DML2".

However, dml2_init()/dml21_init() are not protected from their callers,
causing such errors:

 do_fpu invoked from kernel context![#1]:
 CPU: 0 UID: 0 PID: 239 Comm: kworker/0:5 Not tainted 6.14.0-rc6+ #2
 Workqueue: events work_for_cpu_fn
 pc ffff80000319de80 ra ffff80000319de5c tp 900000010575c000 sp 900000010575f840
 a0 0000000000000000 a1 900000012f210130 a2 900000012f000000 a3 ffff80000357e268
 a4 ffff80000357e260 a5 900000012ea52cf0 a6 0000000400000004 a7 0000012c00001388
 t0 00001900000015e0 t1 ffff80000379d000 t2 0000000010624dd3 t3 0000006400000014
 t4 00000000000003e8 t5 0000005000000018 t6 0000000000000020 t7 0000000f00000064
 t8 000000000000002f u0 5f5e9200f8901912 s9 900000012d380010 s0 900000012ea51fd8
 s1 900000012f000000 s2 9000000109296000 s3 0000000000000001 s4 0000000000001fd8
 s5 0000000000000001 s6 ffff800003415000 s7 900000012d390000 s8 ffff800003211f80
    ra: ffff80000319de5c dml21_apply_soc_bb_overrides+0x3c/0x960 [amdgpu]
   ERA: ffff80000319de80 dml21_apply_soc_bb_overrides+0x60/0x960 [amdgpu]
  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000f0000 [FPD] (IS= ECode=15 EsubCode=0)
  PRID: 0014d010 (Loongson-64bit, Loongson-3C6000/S)
 Process kworker/0:5 (pid: 239, threadinfo=00000000927eadc6, task=000000008fd31682)
 Stack : 00040dc000003164 0000000000000001 900000012f210130 900000012eabeeb8
         900000012f000000 ffff80000319fe48 900000012f210000 900000012f210130
         900000012f000000 900000012eabeeb8 0000000000000001 ffff8000031a0064
         900000010575f9f0 900000012f210130 900000012eac0000 900000012ea80000
         900000012f000000 ffff8000031cefc4 900000010575f9f0 ffff8000035859c0
         ffff800003414000 900000010575fa78 900000012f000000 ffff8000031b4c50
         0000000000000000 9000000101c9d700 9000000109c40000 5f5e9200f8901912
         900000012d3c4bd0 900000012d3c5000 ffff8000034aed18 900000012d380010
         900000012d3c4bd0 ffff800003414000 900000012d380000 ffff800002ea49dc
         0000000000000001 900000012d3c6000 00000000ffffe423 0000000000010000
         ...
 Call Trace:
 [<ffff80000319de80>] dml21_apply_soc_bb_overrides+0x60/0x960 [amdgpu]
 [<ffff80000319fe44>] dml21_init+0xa4/0x280 [amdgpu]
 [<ffff8000031a0060>] dml21_create+0x40/0x80 [amdgpu]
 [<ffff8000031cefc0>] dc_state_create+0x100/0x160 [amdgpu]
 [<ffff8000031b4c4c>] dc_create+0x44c/0x640 [amdgpu]
 [<ffff800002ea49d8>] amdgpu_dm_init+0x3f8/0x2060 [amdgpu]
 [<ffff800002ea6658>] dm_hw_init+0x18/0x60 [amdgpu]
 [<ffff800002b16738>] amdgpu_device_init+0x1938/0x27e0 [amdgpu]
 [<ffff800002b18e80>] amdgpu_driver_load_kms+0x20/0xa0 [amdgpu]
 [<ffff800002b0c8f0>] amdgpu_pci_probe+0x1b0/0x580 [amdgpu]
 [<900000000448eae4>] local_pci_probe+0x44/0xc0
 [<9000000003b02b18>] work_for_cpu_fn+0x18/0x40
 [<9000000003b05da0>] process_one_work+0x160/0x300
 [<9000000003b06718>] worker_thread+0x318/0x440
 [<9000000003b11b8c>] kthread+0x12c/0x220
 [<9000000003ac1484>] ret_from_kernel_thread+0x8/0xa4

Unfortunately, protecting dml2_init()/dml21_init() out of DML2 causes
"sleeping function called from invalid context", so protect them with
DC_FP_START() and DC_FP_END() inside.

Fixes: 7da55c27e767 ("drm/amd/display: Remove incorrect FP context start")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c |    4 ++++
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c        |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -87,6 +87,8 @@ static void dml21_init(const struct dc *
 	/* Store configuration options */
 	(*dml_ctx)->config = *config;
 
+	DC_FP_START();
+
 	/*Initialize SOCBB and DCNIP params */
 	dml21_initialize_soc_bb_params(&(*dml_ctx)->v21.dml_init, config, in_dc);
 	dml21_initialize_ip_params(&(*dml_ctx)->v21.dml_init, config, in_dc);
@@ -97,6 +99,8 @@ static void dml21_init(const struct dc *
 
 	/*Initialize DML21 instance */
 	dml2_initialize_instance(&(*dml_ctx)->v21.dml_init);
+
+	DC_FP_END();
 }
 
 bool dml21_create(const struct dc *in_dc, struct dml2_context **dml_ctx, const struct dml2_configuration_options *config)
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -784,11 +784,15 @@ static void dml2_init(const struct dc *i
 		break;
 	}
 
+	DC_FP_START();
+
 	initialize_dml2_ip_params(*dml2, in_dc, &(*dml2)->v20.dml_core_ctx.ip);
 
 	initialize_dml2_soc_bbox(*dml2, in_dc, &(*dml2)->v20.dml_core_ctx.soc);
 
 	initialize_dml2_soc_states(*dml2, in_dc, &(*dml2)->v20.dml_core_ctx.soc, &(*dml2)->v20.dml_core_ctx.states);
+
+	DC_FP_END();
 }
 
 bool dml2_create(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)


