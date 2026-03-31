Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1533B6FB;
	Tue, 31 Mar 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976996; cv=none; b=dgazi981TKnF2Jk4AlIz1n5DHM9WcUkhMK8x1EfFSUNqTbXkFudTC2Lq6J1mG2/N3rnnSQ22H++VwDQJLLdyYe+Z/qnHjgy5pL6WGDNsoY4kZ9NZXozFtKrylSc2EIkifFnDdTM4eWqDgqVUP+KkkeJRZrwEsFKDTzWtzSNHFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976996; c=relaxed/simple;
	bh=iTkpUO8ZqWvnECWpSUNwcI32onOnVA6jWY4rFzb7OMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1S/fPyo4YGpPNzSokerl1wYUIry3gh7Gmk+PCS2YhIATFDj3kgjmigxp9vThopF64zoWHK/hgn14cfOx0MUBytUEzYPPNFoSe8gPw9kiNLyvgWWBaee3pOpWQkAZqPoz5ReS6pjz0YBeQiaHjUGnHwhcjU9koe3v3zKmsFBUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1tdCj3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1tdCj3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE5C19423;
	Tue, 31 Mar 2026 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976996;
	bh=iTkpUO8ZqWvnECWpSUNwcI32onOnVA6jWY4rFzb7OMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1tdCj3TshTeS40fYMUzjnaWBOuHwNX6nUJDwseNYgSLTcCuBpM8RoOXD3BWP8W3y
	 fCnEbMahlTCjzCGA2JRF1+7TlAb7YVWiuH9OAPEWWbUR4Dy+KFYeQuPGqwfHVSZ68J
	 28nUcQ1Vb/i299wG0nHnS2zaBlxP8Qus/m75ZheY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>
Subject: [PATCH 6.18 276/309] drm/amd/pm: fix amdgpu_irq enabled counter unbalanced on smu v11.0
Date: Tue, 31 Mar 2026 18:22:59 +0200
Message-ID: <20260331161803.721235896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit e12603bf2c3d571476a21debfeab80bb70d8c0cc upstream.

v1:
- fix amdgpu_irq enabled counter unbalanced issue on smu_v11_0_disable_thermal_alert.

v2:
- re-enable smu thermal alert to make amdgpu irq counter balance for smu v11.0 if in runpm state

[75582.361561] ------------[ cut here ]------------
[75582.361565] WARNING: CPU: 42 PID: 533 at drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:639 amdgpu_irq_put+0xd8/0xf0 [amdgpu]
...
[75582.362211] Tainted: [E]=UNSIGNED_MODULE
[75582.362214] Hardware name: GIGABYTE MZ01-CE0-00/MZ01-CE0-00, BIOS F14a 08/14/2020
[75582.362218] Workqueue: pm pm_runtime_work
[75582.362225] RIP: 0010:amdgpu_irq_put+0xd8/0xf0 [amdgpu]
[75582.362556] Code: 31 f6 31 ff e9 c9 bf cf c2 44 89 f2 4c 89 e6 4c 89 ef e8 db fc ff ff 5b 41 5c 41 5d 41 5e 5d 31 d2 31 f6 31 ff e9 a8 bf cf c2 <0f> 0b eb c3 b8 fe ff ff ff eb 97 e9 84 e8 8b 00 0f 1f 84 00 00 00
[75582.362560] RSP: 0018:ffffd50d51297b80 EFLAGS: 00010246
[75582.362564] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[75582.362568] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[75582.362570] RBP: ffffd50d51297ba0 R08: 0000000000000000 R09: 0000000000000000
[75582.362573] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8e72091d2008
[75582.362576] R13: ffff8e720af80000 R14: 0000000000000000 R15: ffff8e720af80000
[75582.362579] FS:  0000000000000000(0000) GS:ffff8e9158262000(0000) knlGS:0000000000000000
[75582.362582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[75582.362585] CR2: 000074869d040c14 CR3: 0000001e37a3e000 CR4: 00000000003506f0
[75582.362588] Call Trace:
[75582.362591]  <TASK>
[75582.362597]  smu_v11_0_disable_thermal_alert+0x17/0x30 [amdgpu]
[75582.362983]  smu_smc_hw_cleanup+0x79/0x4f0 [amdgpu]
[75582.363375]  smu_suspend+0x92/0x110 [amdgpu]
[75582.363762]  ? gfx_v10_0_hw_fini+0xd5/0x150 [amdgpu]
[75582.364098]  amdgpu_ip_block_suspend+0x27/0x80 [amdgpu]
[75582.364377]  ? timer_delete_sync+0x10/0x20
[75582.364384]  amdgpu_device_ip_suspend_phase2+0x190/0x450 [amdgpu]
[75582.364665]  amdgpu_device_suspend+0x1ae/0x2f0 [amdgpu]
[75582.364948]  amdgpu_pmops_runtime_suspend+0xf3/0x1f0 [amdgpu]
[75582.365230]  pci_pm_runtime_suspend+0x6d/0x1f0
[75582.365237]  ? __pfx_pci_pm_runtime_suspend+0x10/0x10
[75582.365242]  __rpm_callback+0x4c/0x190
[75582.365246]  ? srso_return_thunk+0x5/0x5f
[75582.365252]  ? srso_return_thunk+0x5/0x5f
[75582.365256]  ? ktime_get_mono_fast_ns+0x43/0xe0
[75582.365263]  rpm_callback+0x6e/0x80
[75582.365267]  rpm_suspend+0x124/0x5f0
[75582.365271]  ? srso_return_thunk+0x5/0x5f
[75582.365275]  ? __schedule+0x439/0x15e0
[75582.365281]  ? srso_return_thunk+0x5/0x5f
[75582.365285]  ? __queue_delayed_work+0xb8/0x180
[75582.365293]  pm_runtime_work+0xc6/0xe0
[75582.365297]  process_one_work+0x1a1/0x3f0
[75582.365303]  worker_thread+0x2ba/0x3d0
[75582.365309]  kthread+0x107/0x220
[75582.365313]  ? __pfx_worker_thread+0x10/0x10
[75582.365318]  ? __pfx_kthread+0x10/0x10
[75582.365323]  ret_from_fork+0xa2/0x120
[75582.365328]  ? __pfx_kthread+0x10/0x10
[75582.365332]  ret_from_fork_asm+0x1a/0x30
[75582.365343]  </TASK>
[75582.365345] ---[ end trace 0000000000000000 ]---
[75582.365350] amdgpu 0000:05:00.0: amdgpu: Fail to disable thermal alert!
[75582.365379] amdgpu 0000:05:00.0: amdgpu: suspend of IP block <smu> failed -22

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c      |    7 +++++--
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    7 ++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1655,9 +1655,12 @@ static int smu_smc_hw_setup(struct smu_c
 		if (adev->in_suspend && smu_is_dpm_running(smu)) {
 			dev_info(adev->dev, "dpm has been enabled\n");
 			ret = smu_system_features_control(smu, true);
-			if (ret)
+			if (ret) {
 				dev_err(adev->dev, "Failed system features control!\n");
-			return ret;
+				return ret;
+			}
+
+			return smu_enable_thermal_alert(smu);
 		}
 		break;
 	default:
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1022,7 +1022,12 @@ int smu_v11_0_enable_thermal_alert(struc
 
 int smu_v11_0_disable_thermal_alert(struct smu_context *smu)
 {
-	return amdgpu_irq_put(smu->adev, &smu->irq_source, 0);
+	int ret = 0;
+
+	if (smu->smu_table.thermal_controller_type)
+		ret = amdgpu_irq_put(smu->adev, &smu->irq_source, 0);
+
+	return ret;
 }
 
 static uint16_t convert_to_vddc(uint8_t vid)


