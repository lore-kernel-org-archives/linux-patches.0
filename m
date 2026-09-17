Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2762E4078D3;
	Thu, 17 Sep 2026 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671360; cv=none; b=YCT8il1LjPMXvbNhPXgNuZTUCYeRefuhYxsmI8wwGygdPI3DHqbhvrx7+c0uQj6Y2kN/RCrziNLjlNENS6MWUG9g6C8/UI0vSxow3hR60HHYkuat8RvsMw+1RCk2RZHv2SYviUwevs3iFa3AXk1BOdvT+M17qhnoXbPgBQtZEGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671360; c=relaxed/simple;
	bh=Gh696LQ/PT4nugOGpjNE6OD7lVjyesItEAZbyECk3Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPY8Afk+KJH7ZzOT8uK1Mz8Z/PmAczRC6mJf+r0cW3QAyAc4Oljna5IJyA2hdRhLUFHjRRBJJoZ/ZHD0F0uLClBBZ0f9jl4xwYERip/9BlsvoaRjwV3HPT2fqHwVE2psKUL6ZAiNhy7BFZq1AP4AaS9IiYxWJdeFPP6iDWthh1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohSGF0Dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohSGF0Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2081F000FF;
	Thu, 17 Sep 2026 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671358;
	bh=WGNR5ImkxYWKlY1ZD6ZAQvQWZTfoUl+hmHwMhfjTplE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohSGF0Dw19dS4CCUZuA1A2rP/8xwZYVzf21+m5KtojAJTK7JXzZGuIrO1BKD7Kkr8
	 pqI2wef7FMaWxHx57VY1aB3HyHlnW1H58d7Vp35krRr5x7oJwfLbzHjxl4eSaHxvCZ
	 2R2ZM83vbJQ0ocpCdd3JcyL4TU5eMc6aUZgSnKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0923/1102] iommu/tegra241-cmdqv: Publish an LVCMDQ only after it is fully initialized
Date: Thu, 17 Sep 2026 16:14:26 +0100
Message-ID: <20260917151603.806225394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit cbc41aacd49e695338940196e7084770365e1b68 ]

tegra241_vintf_init_lvcmdq() stores the freshly allocated vcmdq pointer to
the vintf->lvcmdqs[] array, before tegra241_vcmdq_alloc_smmu_cmdq() builds
the vcmdq->cmdq. The error ISR dereferences that cmdq, so a latched LVCMDQ
error (e.g. one inherited across a kexec) firing in this window would make
tegra241_vintf0_handle_error() pass the still-zeroed arm_smmu_cmdq down to
__arm_smmu_cmdq_skip_err(), dereferencing NULL queue register pointers.

Drop the store from tegra241_vintf_init_lvcmdq() and publish the vcmdq at
the end of the allocation instead, with an smp_store_release() that pairs
with an smp_load_acquire() in the ISR, which can see a fully built LVCMDQ
or NULL.

The user-owned LVCMDQ allocation moves accordingly, publishing the vcmdq
once tegra241_vcmdq_hw_init_user() succeeds, using a plain store since a
user VINTF's lvcmdqs[] has no lockless reader -- the error ISR only walks
the VINTF0 array.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 8d42c63717b6e..2c7b668c84234 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -261,12 +261,19 @@ static void tegra241_vintf0_handle_error(struct tegra241_vintf *vintf)
 
 		while (map) {
 			unsigned long lidx = __ffs64(map);
-			struct tegra241_vcmdq *vcmdq = vintf->lvcmdqs[lidx];
-			u32 gerror = readl_relaxed(REG_VCMDQ_PAGE0(vcmdq, GERROR));
+			struct tegra241_vcmdq *vcmdq;
+			u32 gerror;
 
+			map &= ~BIT_ULL(lidx);
+
+			/* Pairs with smp_store_release() publishing it */
+			vcmdq = smp_load_acquire(&vintf->lvcmdqs[lidx]);
+			if (!vcmdq)
+				continue;
+
+			gerror = readl_relaxed(REG_VCMDQ_PAGE0(vcmdq, GERROR));
 			__arm_smmu_cmdq_skip_err(&vintf->cmdqv->smmu, &vcmdq->cmdq);
 			writel(gerror, REG_VCMDQ_PAGE0(vcmdq, GERRORN));
-			map &= ~BIT_ULL(lidx);
 		}
 	}
 }
@@ -541,7 +548,6 @@ static int tegra241_vintf_init_lvcmdq(struct tegra241_vintf *vintf, u16 lidx,
 	vcmdq->page0 = cmdqv->base + TEGRA241_VINTFi_LVCMDQ_PAGE0(idx, lidx);
 	vcmdq->page1 = cmdqv->base + TEGRA241_VINTFi_LVCMDQ_PAGE1(idx, lidx);
 
-	vintf->lvcmdqs[lidx] = vcmdq;
 	return 0;
 }
 
@@ -578,14 +584,15 @@ tegra241_vintf_alloc_lvcmdq(struct tegra241_vintf *vintf, u16 lidx)
 	/* Build an arm_smmu_cmdq for each LVCMDQ */
 	ret = tegra241_vcmdq_alloc_smmu_cmdq(vcmdq);
 	if (ret)
-		goto deinit_lvcmdq;
+		goto free_vcmdq;
+
+	/* Pairs with the smp_load_acquire() in the error ISR */
+	smp_store_release(&vintf->lvcmdqs[lidx], vcmdq);
 
 	dev_dbg(cmdqv->dev,
 		"%sallocated\n", lvcmdq_error_header(vcmdq, header, 64));
 	return vcmdq;
 
-deinit_lvcmdq:
-	tegra241_vintf_deinit_lvcmdq(vintf, lidx);
 free_vcmdq:
 	kfree(vcmdq);
 	return ERR_PTR(ret);
-- 
2.53.0



