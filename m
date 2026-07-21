Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14DE4EA395;
	Tue, 21 Jul 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656275; cv=none; b=HNZScouw2TVOukXEhnKTDWfCfE2rry96FRQhbMiNoofhYPcjxTsDarMmfGzeBa9wb4bYVrG6ef4k90JPKr8XzQTprR+Wjv3rrIURmSdaOq/Di7d7V5dLKCL24N6n2g4qHI4eoAc6Uq8hHCxyb1Mey+rzvr4McxgtwwHx6p26IYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656275; c=relaxed/simple;
	bh=7NN5Ci7FSzpM00Umg/XcsEBe9ZwHL0L5rFD5GxOuGz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHtzLB+SI+I0yU6cO+X9xUlwm6glIZT2x25PhZYfcb7+NPuBj9MD3DX+5EQt/u1cKHxo8Ame7BjLPcDhNfoRd+4q2WzFx84oZxYa1+4ea72/q3s7vaxLhLIixRo1YNwZRroamsaCYFC8Y5dZlb6qAP9lM0EVxXCUD2y0+D79QJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RakMirr4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RakMirr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33E11F00A3D;
	Tue, 21 Jul 2026 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656273;
	bh=Qz3gbDhrpRJ8aAuoxE9jZwPfIv2EIJO7BWi/LEUHceg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RakMirr4QbWLz7gDAYox0BAEc7EBO9jgUpuRNxG0aLhCaA2c16ll1SE5k+9ZsLY3F
	 BEXMDS3nFDoLZWiEK1OKDlxQsGAmdM70tcqDjFM6pkUPsIvwDFWOQzp2dBUvLL/O6r
	 G5XNCKIaVAvvi4q+YTLfe2mTdQKFBFzwvNOuXAXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0323/1611] drm/amdgpu: set sub_block_index for mca ras sub-blocks
Date: Tue, 21 Jul 2026 17:07:19 +0200
Message-ID: <20260721152522.353145798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 3ca03b5e0f9139..e1e4a61b1301c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
@@ -99,6 +99,7 @@ int amdgpu_mca_mp0_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mp0");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MP0;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mp0.ras_if = &ras->ras_block.ras_comm;
 
@@ -123,6 +124,7 @@ int amdgpu_mca_mp1_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mp1");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MP1;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mp1.ras_if = &ras->ras_block.ras_comm;
 
@@ -147,6 +149,7 @@ int amdgpu_mca_mpio_ras_sw_init(struct amdgpu_device *adev)
 
 	strcpy(ras->ras_block.ras_comm.name, "mca.mpio");
 	ras->ras_block.ras_comm.block = AMDGPU_RAS_BLOCK__MCA;
+	ras->ras_block.ras_comm.sub_block_index = AMDGPU_RAS_MCA_BLOCK__MPIO;
 	ras->ras_block.ras_comm.type = AMDGPU_RAS_ERROR__MULTI_UNCORRECTABLE;
 	adev->mca.mpio.ras_if = &ras->ras_block.ras_comm;
 
-- 
2.53.0



