Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F6D3A0E85;
	Sat, 17 Oct 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255177; cv=none; b=ba64t1kny/+nC7P786oWAdt+diFkRmvo2HOrCyVjk/EVSCNSnm6IwMV7X7BGA0tGEucQ0ZgiAocpjOf4zDdhyTALSzCUGwDBCCeXd3iL59cYeLz4tHHkEHFyu7KMS5TJh/HZs6oqu2lRV2T2pzlWNZs836SUFOD1dYIiGg+OKmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255177; c=relaxed/simple;
	bh=RpGsRz7FxGDUh02Yca8OrG5xzhIMxnhtTxDfCRx8S4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctqdvkTepFvVh5GI8YOf3kFmE7pDp0E4o8icpkOv2R6YEgIxqmdsyEg0Z396t/+ockjNOeM4zDgpYThJ0vGojHXuE8+i6XCmRMTdfL0VfC7v+3lY7nRvuVaLVzfTlX6NuuOnAAz9q931SRvTwfttftLI7Df/fC6ltQWjacRryZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZsVDVAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZsVDVAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5881F000C5;
	Sat, 17 Oct 2026 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255176;
	bh=gznqurOHfESxvoHyCTFU0mCj1zdAN/rYMAaFY3nohcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZsVDVAWK1jzK5pcTviE2euZhbr5haU26ZfSYe+5/aFcg98oHv1xb9Fz4tkb7HgRY
	 nV0Eb+PNuMfjLo8yN1+yxdZoZVLJpkra/yX9dqxCRBakn8mS+/VxmcxQXM/Jo8P7th
	 xyzjymdmi1IcdL6NDzwXAqEUn/BsGgldBk3I1qH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 689/869] iommu/tegra241-cmdqv: Fix VINTF0 leak on the init-failure path
Date: Sat, 17 Oct 2026 17:58:50 +0200
Message-ID: <20261017160054.641732912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 2c7b668c84234..335928aa0ef59 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -778,6 +778,12 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
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



