Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D72C199920;
	Tue, 21 Jul 2026 20:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665918; cv=none; b=CxI3ZhzFcgLJozGby+nO0JbbySJubqpIDwt+BBmTHTT7aqeL2eZ3A7wBLYTeGQXFHFPp1a7RvnHtHpRjLo7zCT95UDjuTpFtaow/k3rpI3Ma2dFaEr3G7wgSWJD06v/WiSGsf1ezdh4sl80EhTEHFHnKS8OVsnTWYJQuU7bBNgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665918; c=relaxed/simple;
	bh=64abZfRqB7e2heXOUJHOZIO2+rbodnsTJliDVEGlgPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAqXdvXWwcTRK53i6Dg6erBvkPZsi3oeoGDrXXkcZoVtaXwCnNWofTsVDgMxVJSiCeQOQPDPMj8b5aarE40LxAYv78jpE/1dy79L1OQ+yiwww/CvxmjrHSOD051jy6hX1vd6/dzqj92t4VFn3qzg/L/1cdOT2PGd0I5q43UjjnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izBJhI8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izBJhI8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A7C1F000E9;
	Tue, 21 Jul 2026 20:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665916;
	bh=4rqaweYWyA+I9Vk9INqNSy/gxoLRA01brXl9/+99quo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izBJhI8xiNNsFuNv7LylJsP9pXpg1fnKtmrnpVACCdkfeiVcvvwEknKWFqxuE+eOQ
	 m9WllCHQt249Qx6yxWnmGsEx+8LPRPaa6JG7O74gagSCM1YF9Lww+LS1QVpBMT2dFC
	 xFGSliiJkKlKWluwl47tD0GJrSLnSa9rhksHiZcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0485/1266] drm/amdgpu: set sub_block_index for mca ras sub-blocks
Date: Tue, 21 Jul 2026 17:15:22 +0200
Message-ID: <20260721152452.694202780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit baa286df5fb366e4aee5b747443dfc7194fdaa59 ]

The mca ras sub-blocks (mp0, mp1, mpio) all share the
AMDGPU_RAS_BLOCK__MCA block id and are distinguished only by
sub_block_index. The ras manager object for an mca block is selected
with:

	con->objs[AMDGPU_RAS_BLOCK__LAST + head->sub_block_index]

Since the rework in commit 7f544c5488cf ("drm/amdgpu: Rework mca ras
sw_init") moved the ras_comm setup into amdgpu_mca_mp*_ras_sw_init() but
left sub_block_index unset, mp0/mp1/mpio all default to index 0 and
collide on the same object slot. mp0 grabs the slot and creates its
sysfs node first; mp1 (and mpio) then find the slot already in use, so
amdgpu_ras_block_late_init() -> amdgpu_ras_sysfs_create() returns
-EINVAL:

  amdgpu: mca.mp1 failed to execute ras_block_late_init_default! ret:-22
  amdgpu: amdgpu_ras_late_init failed -22
  amdgpu: amdgpu_device_ip_late_init failed
  amdgpu: Fatal error during GPU init

The error is currently masked because amdgpu_ras_late_init() does not
check the return value of amdgpu_ras_block_late_init_default(), but it
already leaves mp1/mpio without their sysfs nodes and becomes a fatal
init failure as soon as that return value is honored.

Restore the per-sub-block sub_block_index assignment so each mca
sub-block maps to its own object slot.

Fixes: 7f544c5488cf ("drm/amdgpu: Rework mca ras sw_init")
Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
index 8d9ff9e151de1a..9a7f7d2b2767a5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
@@ -89,6 +89,7 @@ int amdgpu_mca_mp0_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mp0");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MP0;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mp0.ras_if = &ras->ras_block.ras_comm;
 
@@ -113,6 +114,7 @@ int amdgpu_mca_mp1_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mp1");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MP1;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mp1.ras_if = &ras->ras_block.ras_comm;
 
@@ -137,6 +139,7 @@ int amdgpu_mca_mpio_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mpio");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MPIO;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mpio.ras_if = &ras->ras_block.ras_comm;
 
-- 
2.53.0



