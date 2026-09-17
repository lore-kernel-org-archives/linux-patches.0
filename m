Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C949390230;
	Thu, 17 Sep 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660138; cv=none; b=BoG9KeknO8mqPPoaeIcLk/daUnUhOHJ+40YiAQ6y+m+BkM1/O1qzxue4dGDE+hiPcsN5MX7CeZOAdO7sCQXC5qbApRu26/P/d2fAH3TYcF9q+N5dXIns2Qio7oNiBy32iKC83HhbFZYZugZqiBqnxClB7E9/9Mvx0egOXi2h4Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660138; c=relaxed/simple;
	bh=H+opfygnnY7nfwvESR1l1xR1LkFBbKfobEIZqQvSf1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJpmM2hpXtzReLvIQkfo/v/ZxGQe1OPDptMSRCaZyCLO8LZikfOC+I0DQCjJrVyuJ6L+w2qRYLrG325Yoid5pNuwKpWg5IPAI2lu1YufdVnVAOQzNxu1VwdownHiNQ7dSSQSOmbtWDHBKuQR/rcDaKTmhH4p6YtyacUJcoGMDbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lp06UYr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lp06UYr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2961F00898;
	Thu, 17 Sep 2026 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660127;
	bh=N24C9lmSwDuIwGC5yjMXJv/c9y8SgWXvEy4F2rNYVEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lp06UYr+ZB5/lcYSEyna6W8M0N7RVr9TPFd1S/mtpE1ApzA/YAHaqCaWyXLcN/j0G
	 dQpqDw05mnUgJmSE+JsDl8WtH9+8eXSXCUIajf4prlb7qmyZouCo3b21CJfrNNChof
	 wy39JwVejCFh3PkSlemFoO8r9D1m1efTd8tmtrm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 487/733] drm/amdgpu: skip gfx switch_power_profile during GPU reset
Date: Thu, 17 Sep 2026 16:13:15 +0100
Message-ID: <20260917151404.178896635@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

commit 1f1d43418d61c8511779e0f63a954a78b9433b43 upstream.

During resume from GPU reset, the gfx idle work may invoke switch_power_profile
before the reset completes. This causes the following assert error because the
register access occurs without first releasing the GPU reset semaphore:

[ 1576.768935] CR2: 0000559ea133ead0 CR3: 00000002e6c42000 CR4: 0000000000350ef0
[ 1576.768940] Call Trace:
[ 1576.768944]  <TASK>
[ 1576.768953]  amdgpu_device_rreg+0x21/0x50 [amdgpu]
[ 1576.769158]  smu_msg_v1_send_msg+0x1a4/0x6e0 [amdgpu]
[ 1576.769437]  smu_cmn_send_smc_msg_with_params_ext+0xba/0x120 [amdgpu]
[ 1576.769721]  smu_cmn_send_smc_msg_with_param+0x33/0x40 [amdgpu]
[ 1576.769993]  smu_v13_0_0_set_power_profile_mode+0x192/0x2b0 [amdgpu]
[ 1576.770267]  smu_bump_power_profile_mode+0x5d/0x80 [amdgpu]
[ 1576.770538]  smu_switch_power_profile+0xa4/0xf0 [amdgpu]
[ 1576.770839]  amdgpu_dpm_switch_power_profile+0x6f/0x90 [amdgpu]
[ 1576.771210]  amdgpu_gfx_profile_idle_work_handler+0xe9/0x130 [amdgpu]
[ 1576.771460]  process_one_work+0x23e/0x6f0
[ 1576.771491]  worker_thread+0x1c4/0x380
[ 1576.771506]  kthread+0x10c/0x150
[ 1576.771512]  ? __pfx_worker_thread+0x10/0x10
[ 1576.771518]  ? __pfx_kthread+0x10/0x10
[ 1576.771530]  ret_from_fork+0x314/0x390
[ 1576.771537]  ? __pfx_kthread+0x10/0x10
[ 1576.771546]  ret_from_fork_asm+0x1a/0x30

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d93b1ff538ce9750c01e0dd0aa62575579c0fc08)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -348,7 +348,8 @@ int amdgpu_dpm_switch_power_profile(stru
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->switch_power_profile) {
@@ -367,7 +368,8 @@ int amdgpu_dpm_pause_power_profile(struc
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->pause_power_profile) {


