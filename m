Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6833C44D022;
	Tue, 16 Jun 2026 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624484; cv=none; b=jGtr8orFGMlyiqB+0w4tuHpbBZvn3TNiLW9mLcaxk4EHdendv0o+hC+vehxTMdafg3Pxo4ZJnSu3K6K8j6pXogFS/XpBOoIf2ULW98h7GEEb++SRSp3jyHBffE3mLx19lhxrbElNDXVVoiS2m8WajEmT1zuR8b5rUg7DtQJLpSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624484; c=relaxed/simple;
	bh=xxp4Z7wIBCrS0msQ+YxPSXXpLd7w/HMYtk97y7AO1Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhKwPVdVegMd2WMi3e6n8PsQLAE0ds7phmn7OII1gu9Baj5vjC+dRIZs/znKczrj1ctwz5ISmi/hp2pB1okE7PygjhJ3f+0YYGKUFP+FbXfGa23aMuNnX+kAz/ovCr3WwBuEeoj6wf3cmwgp0z4rl2JD8I7yzqxm4MkUpJzDKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZhMH/EN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZhMH/EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F0A1F00A3D;
	Tue, 16 Jun 2026 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624483;
	bh=B8qRh7Dx5deTshV2SnL7b/E+mkn9W2BUSM38lUC8se0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZhMH/ENjC2xKc/jHYI5odcmFn2KkoazX1Cgxp9aGEPwfHdOpZECUpC/Yjs74NGCY
	 s/gQrAtc0MmCk0bv2sLQRHIMSx/VHKg1xLRqAHws9+la6cZ3yCBOtZO88VBi5JrYmG
	 2H1repAxglBlBPi+wAD9VUUeLhPwBMXQO8H364Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>
Subject: [PATCH 7.0 346/378] drm/amdgpu: set noretry=1 as default for GFX 10.1.x (Navi10/12/14)
Date: Tue, 16 Jun 2026 20:29:37 +0530
Message-ID: <20260616145128.387079976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

commit e47b0056a08dc70430ffc44bbf62197e7d1ff8ea upstream.

Problem:
While developing the amd_close_race IGT test (which intentionally triggers
execute permission faults by removing VM_PAGE_EXECUTABLE from GPU page table
entries), we discovered that on Navi10 (GFX 10.1.x) these faults produce
zero diagnostic output. The GPU simply hangs silently for ~10s until the
scheduler timeout fires. There is no way to distinguish an execute
permission fault from any other type of GPU hang.

Root cause:
GFX 10.1.x defaults to noretry=0, which sets
RETRY_PERMISSION_OR_INVALID_PAGE_FAULT=1 in the GFXHUB UTCL2 registers
(gfxhub_v2_0.c line 313). With this bit set, permission faults (valid PTE,
wrong R/W/X bits) are handled entirely within the UTCL1/UTCL2 hardware
loop: UTCL2 returns an XNACK to UTCL1, and UTCL1 re-requests the
translation indefinitely, expecting software to eventually fix the
permission bits (as happens in SVM/HMM recovery). No interrupt of any kind
reaches the IH ring.

This is different from invalid-page faults (V=0) which DO generate a retry
fault interrupt that the driver can escalate to a no-retry fault. Permission
faults with valid PTEs loop silently forever in hardware.

GFX 10.3+ already defaults to noretry=1, which makes permission faults
generate immediate L2 protection fault interrupts. GFX 10.1.x was
inadvertently left out of this default.

Fix:
Change the noretry=1 threshold from IP_VERSION(10, 3, 0) to
IP_VERSION(10, 1, 0) in amdgpu_gmc_noretry_set(). This is a one-line
change that aligns GFX 10.1.x behavior with GFX 10.3+ and all newer
generations.

With noretry=1, the existing non-retry fault handler
(gmc_v10_0_process_interrupt) already decodes and prints the full
GCVM_L2_PROTECTION_FAULT_STATUS register including PERMISSION_FAULTS,
faulting address, VMID, PASID, and process name. No additional logging
code is needed — the fix is purely routing permission faults to the
existing, fully-capable non-retry interrupt handler.

v2: Dropped GFX10-specific logging from gmc_v10_0.c and
kfd_int_process_v10.c (Felix Kuehling). v1 added logging in the retry
fault handler, but with noretry=1 permission faults take the non-retry
path — the v1 retry handler code was dead and would never execute.

Tested on Navi10 (GFX 10.1.10):
- Execute permission faults now produce immediate, clear output:
    [gfxhub] page fault (src_id:0 ring:64 vmid:4 pasid:592)
     Process amd_close_race pid 13380 thread amd_close_race pid 13384
      in page at address 0x40001000 from client 0x1b (UTCL2)
    GCVM_L2_PROTECTION_FAULT_STATUS:0x00700881
         PERMISSION_FAULTS: 0x8
- No regressions with properly-mapped GPU workloads

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eb21edd24c40d81066753f8ac6f23bce15745395)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1002,7 +1002,7 @@ void amdgpu_gmc_noretry_set(struct amdgp
 				gc_ver == IP_VERSION(9, 4, 3) ||
 				gc_ver == IP_VERSION(9, 4, 4) ||
 				gc_ver == IP_VERSION(9, 5, 0) ||
-				gc_ver >= IP_VERSION(10, 3, 0));
+				gc_ver >= IP_VERSION(10, 1, 0));
 
 	if (!amdgpu_sriov_xnack_support(adev))
 		gmc->noretry = 1;


