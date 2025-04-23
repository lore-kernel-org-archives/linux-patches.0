Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A11F5435;
	Wed, 23 Apr 2025 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420853; cv=none; b=u0mCZJXRjB7NCBG6X9pYhQXMaWztmKNqkTQmFylmTHhNcGYV2xBJ497OaFBAVzwC1LLy27CglOf/BHkPFWTQtwB/TLUTkLHK8IpRVt9IPpbbp7fVEjqlYF/ITBfgcXhrgSsXlJWJfgsZO2rq2pQnAiZmXunRflLljK+2P5OwtXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420853; c=relaxed/simple;
	bh=2WStVK6oahWz1E0UY7F+pR7Hv34HZmX0fZ+QEobxRi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnLnHOZXODJaO/xrGBLtlE9u1Ne0jFO8Wp0ru+0RUyoKoH/52Fr1D2pH+z7OVlNzt82DzdQoc2jploZlpNIM90DLccd/Y5x4i81MzrQl+kACRgPAappI4mmCTU71DScwHoPYRxdedEzV3y4HMN5heh92PLDGKY6ZS+yPYbMdxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq0z2Z+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq0z2Z+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E78C4CEE2;
	Wed, 23 Apr 2025 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420853;
	bh=2WStVK6oahWz1E0UY7F+pR7Hv34HZmX0fZ+QEobxRi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq0z2Z+aQEnP4bllcrvOBViBA+K6b6eMAhpr8qHCIYZceNWWNXljvml8B0O4qIuvD
	 FoR03TSezfrhJDEybkMkmEHJhjhe+qJh7K+zQGVCtRF1VxCXNkug8nqOOKR/Am0wIE
	 za1f4oqQi9Yt9bGXM73fvKk4WgUP+IotgAUUo3ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 168/223] drm/amd/display: Protect FPU in dml21_copy()
Date: Wed, 23 Apr 2025 16:44:00 +0200
Message-ID: <20250423142624.009387103@linuxfoundation.org>
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

commit 4408b59eeacfea777aae397177f49748cadde5ce upstream.

Commit 7da55c27e76749b9 ("drm/amd/display: Remove incorrect FP context
start") removes the FP context protection of dml2_create(), and it said
"All the DC_FP_START/END should be used before call anything from DML2".

However, dml21_copy() are not protected from their callers, causing such
errors:

 do_fpu invoked from kernel context![#1]:
 CPU: 0 UID: 0 PID: 240 Comm: kworker/0:5 Not tainted 6.14.0-rc6+ #1
 Workqueue: events work_for_cpu_fn
 pc ffff80000318bd2c ra ffff80000315750c tp 9000000105910000 sp 9000000105913810
 a0 0000000000000000 a1 0000000000000002 a2 900000013140d728 a3 900000013140d720
 a4 0000000000000000 a5 9000000131592d98 a6 0000000000017ae8 a7 00000000001312d0
 t0 9000000130751ff0 t1 ffff800003790000 t2 ffff800003790000 t3 9000000131592e28
 t4 000000000004c6a8 t5 00000000001b7740 t6 0000000000023e38 t7 0000000000249f00
 t8 0000000000000002 u0 0000000000000000 s9 900000012b010000 s0 9000000131400000
 s1 9000000130751fd8 s2 ffff800003408000 s3 9000000130752c78 s4 9000000131592da8
 s5 9000000131592120 s6 9000000130751ff0 s7 9000000131592e28 s8 9000000131400008
    ra: ffff80000315750c dml2_top_soc15_initialize_instance+0x20c/0x300 [amdgpu]
   ERA: ffff80000318bd2c mcg_dcn4_build_min_clock_table+0x14c/0x600 [amdgpu]
  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000f0000 [FPD] (IS= ECode=15 EsubCode=0)
  PRID: 0014d010 (Loongson-64bit, Loongson-3C6000/S)
 Process kworker/0:5 (pid: 240, threadinfo=00000000f1700428, task=0000000020d2e962)
 Stack : 0000000000000000 0000000000000000 0000000000000000 9000000130751fd8
         9000000131400000 ffff8000031574e0 9000000130751ff0 0000000000000000
         9000000131592e28 0000000000000000 0000000000000000 0000000000000000
         0000000000000000 0000000000000000 0000000000000000 0000000000000000
         0000000000000000 0000000000000000 0000000000000000 0000000000000000
         0000000000000000 0000000000000000 0000000000000000 f9175936df5d7fd2
         900000012b00ff08 900000012b000000 ffff800003409000 ffff8000034a1780
         90000001019634c0 900000012b000010 90000001307beeb8 90000001306b0000
         0000000000000001 ffff8000031942b4 9000000130780000 90000001306c0000
         9000000130780000 ffff8000031c276c 900000012b044bd0 ffff800003408000
         ...
 Call Trace:
 [<ffff80000318bd2c>] mcg_dcn4_build_min_clock_table+0x14c/0x600 [amdgpu]
 [<ffff800003157508>] dml2_top_soc15_initialize_instance+0x208/0x300 [amdgpu]
 [<ffff8000031942b0>] dml21_create_copy+0x30/0x60 [amdgpu]
 [<ffff8000031c2768>] dc_state_create_copy+0x68/0xe0 [amdgpu]
 [<ffff800002e98ea0>] amdgpu_dm_init+0x8c0/0x2060 [amdgpu]
 [<ffff800002e9a658>] dm_hw_init+0x18/0x60 [amdgpu]
 [<ffff800002b0a738>] amdgpu_device_init+0x1938/0x27e0 [amdgpu]
 [<ffff800002b0ce80>] amdgpu_driver_load_kms+0x20/0xa0 [amdgpu]
 [<ffff800002b008f0>] amdgpu_pci_probe+0x1b0/0x580 [amdgpu]
 [<9000000003c7eae4>] local_pci_probe+0x44/0xc0
 [<90000000032f2b18>] work_for_cpu_fn+0x18/0x40
 [<90000000032f5da0>] process_one_work+0x160/0x300
 [<90000000032f6718>] worker_thread+0x318/0x440
 [<9000000003301b8c>] kthread+0x12c/0x220
 [<90000000032b1484>] ret_from_kernel_thread+0x8/0xa4

Unfortunately, protecting dml21_copy() out of DML2 causes "sleeping
function called from invalid context", so protect them with DC_FP_START()
and DC_FP_END() inside.

Fixes: 7da55c27e767 ("drm/amd/display: Remove incorrect FP context start")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -425,8 +425,12 @@ void dml21_copy(struct dml2_context *dst
 
 	dst_dml_ctx->v21.mode_programming.programming = dst_dml2_programming;
 
+	DC_FP_START();
+
 	/* need to initialize copied instance for internal references to be correct */
 	dml2_initialize_instance(&dst_dml_ctx->v21.dml_init);
+
+	DC_FP_END();
 }
 
 bool dml21_create_copy(struct dml2_context **dst_dml_ctx,


