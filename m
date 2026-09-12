Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477A288B2;
	Sat, 12 Sep 2026 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208594; cv=none; b=cW5sO9oCfV27GuXjnH9FAytDbwEeQ15eXnj/QhhNeMthsg4VRmhV8najwnjKqhZqSwNgKp2FVkra5LfRS5U5sijgB2SiDogZvUVhvAGhLUFQBxDGQK/Nrht25g4XKrks3T89psw0NtzDKrFhu1LP5e9F1rEOSZLwroti9nEwpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208594; c=relaxed/simple;
	bh=MfJRDwhxevWa8DkUlzY7pA7rO1IGlnXcJ4Acw6RA21E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stCEJPYOD+brI1hdKGn7Guno8hcQmVrQ2Nhet9QFOcqAj2waASkV+Ese8KvIfZcmq5+ef2Nwq3TeGaeW3Pg2GjaxW6V7k/CpxPShW5a59OlXk73V/zr7uzG5p51YHKqxPsVNPb17CZqTpCyQVtyvmmUXiFfzVdEO3/jPNHk8VIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHBqwWSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHBqwWSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBDA1F000FF;
	Sat, 12 Sep 2026 10:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208593;
	bh=+0U62NTxcVE91pJyCbO2PEJQ3qbRj1K3zV9aO2+tEpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHBqwWSigtn7oapjop4OQbScAmX86/IxtVhYycL7TgsKifqbm/r/hEDuLgfMEowYc
	 amHnW+N/+iMszehroK/9ShTberFC7fQH6eLvEH6G5a6CdCQLpC+QX/I9bBH4WaTbLu
	 X1f72rWgmswWQaadvgDIrhEIO9q085UEgBPm7XIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0606/1518] iommu/tegra241-cmdqv: Fix VINTF0 leak on the init-failure path
Date: Sat, 12 Sep 2026 08:46:15 +0200
Message-ID: <20260912065637.133319233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit f40f3144477314b489e4bc209c06cb51679fe82b ]

tegra241_cmdqv_init_structures() allocates VINTF0 with kzalloc_obj(), inits
it, and preallocates its logical VCMDQs. Two of its error paths leak.

When tegra241_cmdqv_init_vintf() fails it returns before VINTF0 reaches the
cmdqv->vintfs[] array, so the devres unwind on probe failure cannot reach
it; free it directly there.

A later VCMDQ preallocation failure instead leaves VINTF0 published, and so
this time the unwind does reach tegra241_cmdqv_remove_vintf(), which then
frees it from vintf->hyp_own. But tegra241_vintf_hw_init() sets that flag
only afterward, from a HW read-back, so the still-uninited VINTF0 reads as
guest-owned and leaks, with mutex_destroy() and ida_destroy() run on fields
it never set up.

Decide ownership from vintf->idx instead, the index assigned when its id is
allocated: idx 0 is the kernel-owned VINTF0, while idx >= 1 marks a guest
VINTF. So the in-kernel free decision in tegra241_cmdqv_remove_vintf() and
tegra241_vintf_free_lvcmdq() now keys on idx too, and hyp_own stays a pure
HW-readback state.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 29aa7acd194b9..2b55a221c35a6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -710,7 +710,7 @@ static void tegra241_vintf_free_lvcmdq(struct tegra241_vintf *vintf, u16 lidx)
 	dev_dbg(vintf->cmdqv->dev,
 		"%sdeallocated\n", lvcmdq_error_header(vcmdq, header, 64));
 	/* Guest-owned VCMDQ is free-ed with hw_queue by iommufd core */
-	if (vcmdq->vintf->hyp_own)
+	if (!vcmdq->vintf->idx)
 		kfree(vcmdq);
 }
 
@@ -808,7 +808,7 @@ static void tegra241_cmdqv_remove_vintf(struct tegra241_cmdqv *cmdqv, u16 idx)
 
 	dev_dbg(cmdqv->dev, "VINTF%u: deallocated\n", vintf->idx);
 	tegra241_cmdqv_deinit_vintf(cmdqv, idx);
-	if (!vintf->hyp_own) {
+	if (vintf->idx) {
 		mutex_destroy(&vintf->lvcmdq_mutex);
 		ida_destroy(&vintf->sids);
 		/* Guest-owned VINTF is free-ed with viommu by iommufd core */
@@ -988,6 +988,12 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
 	ret = tegra241_cmdqv_init_vintf(cmdqv, 0, vintf);
 	if (ret) {
 		dev_err(cmdqv->dev, "failed to init vintf0: %d\n", ret);
+		/*
+		 * tegra241_cmdqv_init_vintf() failed to publish the vintf0 to
+		 * cmdqv->vintfs[], so the probe unwind path that goes through
+		 * cmdqv->vintfs[] would miss it. Free it here.
+		 */
+		kfree(vintf);
 		return ret;
 	}
 
-- 
2.53.0



