Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3017547041;
	Thu, 17 Sep 2026 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666409; cv=none; b=HGHdAoaNlSP8dmHCvos7ny4a3kjeU47VbpiUWKFGrycxQV6gCWj9y8Xys89mwTUFkW6etTod+UjC1Pt2omYq+Z/KM8Kw/mfq/y32cDb76lzalH0GZ4zozFekz5XuOwwo0B2+dyJqI/GbL8t6AFsdNdjqKuMddiGbS8sLCUNiQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666409; c=relaxed/simple;
	bh=KnEHye+q3CEnpEJSKejDlYTbeojLgsgDRp9IdKmqLmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR9vtCTllkJdolt/wY76LP77mGwcydj94SgnNMVVX0dw9WYW4xA12ZDPJVSk5vVzkOdBiFuqVrbUauosFteUZvxBREBugMlJ8Ao8C64UZRxo6TRLAS6lQc33hDNO0EhM+ShGxBccX8czBazMkHPi2bPbyOMAu7BG7byk3qAkfJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA51O4FI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA51O4FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FFD1F000FF;
	Thu, 17 Sep 2026 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666407;
	bh=9A1OzlDLF+puIzmZEjfR+k2wl3+LVpA8Q+oV1SmLXPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA51O4FIgxZIjkRtuzDogiqVcUqDkVac/XhE7JF0Wo6M6ScIFeksNeY+dGpH2H4Ez
	 iYz8saqeeahSSZpyf07aYkEADUZ6FspA8RLjclYCWdl49lscd1dpkZmyOqGwUZUS7f
	 JVCoYZ7NciJ1I5IUYC/D0CPoO/coIldvd0zrcJ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 0979/1250] drm/amdgpu: skip gfx switch_power_profile during GPU reset
Date: Thu, 17 Sep 2026 16:12:54 +0100
Message-ID: <20260917151618.549864396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


