Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195A530FC0B;
	Mon, 13 Oct 2025 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369723; cv=none; b=ud04+xwCeZwl4ej8jzgCWZ4w8TtaWcHasOavH7XlKP71R34RrDKcVJa31fXGyf3LnFVjSyJFtKAZtDQtSEaIcgdoC3lt4nv9gurIA5k6ZD2MMpCva4Y/7C9yafeGi6arCP/sIMuqGWgZGrK5ErwolV+9z+HM31JGgoBGcNIKbEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369723; c=relaxed/simple;
	bh=jhxGK+WlmyhnXeQCLKw+1elqplcQ55Iyd0QJNIp4zUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faSSz1CqymNPUIGK2W9sTMZIqP6pTROeeIR3UJryT3b/sRWdrsiPvUfDX9/vVVUj+YIToqJzVnuHA6HEh742Pi4uqMEWkgLZN7/o+ALQX4kiYHePeJSXhRMQY2TjIDfWoJX20bPMVFK1J9IcTr1FIcP/iW6KHB6zmHL7lK4y2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq9dyAZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq9dyAZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973E4C4CEFE;
	Mon, 13 Oct 2025 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369723;
	bh=jhxGK+WlmyhnXeQCLKw+1elqplcQ55Iyd0QJNIp4zUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq9dyAZkJr5myoVkR+jACj1t68J9+iKW3EoiJEeg/IBt1UTV68Ynz94bHQEkPkNM5
	 kADySgO1qKaF8YXGI9VNcjpsMcErdeTJg0GP6+hFG4UfJKkmF6U7vt1SZjnQvPadC2
	 ZyWINEhDvAk78bHcL8Rb74sehsTon5+hvvJvQTAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Nie <jun.nie@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 312/563] drm/msm: Do not validate SSPP when it is not ready
Date: Mon, 13 Oct 2025 16:42:53 +0200
Message-ID: <20251013144422.568047179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Nie <jun.nie@linaro.org>

[ Upstream commit 6fc616723bb5fd4289d7422fa013da062b44ae55 ]

Current code will validate current plane and previous plane to
confirm they can share a SSPP with multi-rect mode. The SSPP
is already allocated for previous plane, while current plane
is not associated with any SSPP yet. Null pointer is referenced
when validating the SSPP of current plane. Skip SSPP validation
for current plane.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000888ac3000
[0000000000000020] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 4 UID: 0 PID: 1891 Comm: modetest Tainted: G S                  6.15.0-rc2-g3ee3f6e1202e #335 PREEMPT
Tainted: [S]=CPU_OUT_OF_SPEC
Hardware name: SM8650 EV1 rev1 4slam 2et (DT)
pstate: 63400009 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : dpu_plane_is_multirect_capable+0x68/0x90
lr : dpu_assign_plane_resources+0x288/0x410
sp : ffff800093dcb770
x29: ffff800093dcb770 x28: 0000000000002000 x27: ffff000817c6c000
x26: ffff000806b46368 x25: ffff0008013f6080 x24: ffff00080cbf4800
x23: ffff000810842680 x22: ffff0008013f1080 x21: ffff00080cc86080
x20: ffff000806b463b0 x19: ffff00080cbf5a00 x18: 00000000ffffffff
x17: 707a5f657a696c61 x16: 0000000000000003 x15: 0000000000002200
x14: 00000000ffffffff x13: 00aaaaaa00aaaaaa x12: 0000000000000000
x11: ffff000817c6e2b8 x10: 0000000000000000 x9 : ffff80008106a950
x8 : ffff00080cbf48f4 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000438 x3 : 0000000000000438
x2 : ffff800082e245e0 x1 : 0000000000000008 x0 : 0000000000000000
Call trace:
 dpu_plane_is_multirect_capable+0x68/0x90 (P)
 dpu_crtc_atomic_check+0x5bc/0x650
 drm_atomic_helper_check_planes+0x13c/0x220
 drm_atomic_helper_check+0x58/0xb8
 msm_atomic_check+0xd8/0xf0
 drm_atomic_check_only+0x4a8/0x968
 drm_atomic_commit+0x50/0xd8
 drm_atomic_helper_update_plane+0x140/0x188
 __setplane_atomic+0xfc/0x148
 drm_mode_setplane+0x164/0x378
 drm_ioctl_kernel+0xc0/0x140
 drm_ioctl+0x20c/0x500
 __arm64_sys_ioctl+0xbc/0xf8
 invoke_syscall+0x50/0x120
 el0_svc_common.constprop.0+0x48/0xf8
 do_el0_svc+0x28/0x40
 el0_svc+0x30/0xd0
 el0t_64_sync_handler+0x144/0x168
 el0t_64_sync+0x198/0x1a0
Code: b9402021 370fffc1 f9401441 3707ff81 (f94010a1)
---[ end trace 0000000000000000 ]---

Fixes: 3ed12a3664b36 ("drm/msm/dpu: allow sharing SSPP between planes")
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/669224/
Link: https://lore.kernel.org/r/20250819-v6-16-rc2-quad-pipe-upstream-v15-1-2c7a85089db8@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 6859e8ef6b055..f54cf0faa1c7c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -922,6 +922,9 @@ static int dpu_plane_is_multirect_capable(struct dpu_hw_sspp *sspp,
 	if (MSM_FORMAT_IS_YUV(fmt))
 		return false;
 
+	if (!sspp)
+		return true;
+
 	if (!test_bit(DPU_SSPP_SMART_DMA_V1, &sspp->cap->features) &&
 	    !test_bit(DPU_SSPP_SMART_DMA_V2, &sspp->cap->features))
 		return false;
@@ -1028,6 +1031,7 @@ static int dpu_plane_try_multirect_shared(struct dpu_plane_state *pstate,
 	    prev_pipe->multirect_mode != DPU_SSPP_MULTIRECT_NONE)
 		return false;
 
+	/* Do not validate SSPP of current plane when it is not ready */
 	if (!dpu_plane_is_multirect_capable(pipe->sspp, pipe_cfg, fmt) ||
 	    !dpu_plane_is_multirect_capable(prev_pipe->sspp, prev_pipe_cfg, prev_fmt))
 		return false;
-- 
2.51.0



