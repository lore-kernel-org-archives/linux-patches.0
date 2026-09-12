Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4BF2F0C7E;
	Sat, 12 Sep 2026 08:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200028; cv=none; b=RP55BolFxeNHbw0Uu3eSzGFQxUkM68OicEuxiwxSnS8HiQQYBzxteXfuVP6rpCe0aFXAQm584hpl/FG6BV6xsR8pGy9C0a+GwTs+jLmmaipu4+BRDYIamjGhDfC6jGdoniKJh83n0SjATtopw0hoqa6mp2fTJLLYd4KXM1IJEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200028; c=relaxed/simple;
	bh=Y1UIOyqwMWb8SxD6PpLScI0VjAN452Zk1OCwdf9Dqtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2nkxOeFucey+R9obyRjR1m9PSGdQ0eOEw89HmD0bzqh/LjGKFvghewsw9Re/Y6kei7D0vtefqEmncdv3DsmFMuoEmB3RfIU6uOxB7g3dUEwe/4l7kD2S1sc6/XGhPePKavBfpRoW+r4t5c9vYRhi/JrgZh+qlhUaJK70caHSMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+Ua50vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+Ua50vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76331F000FF;
	Sat, 12 Sep 2026 08:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200026;
	bh=euJZs5CcHOPH2Ffg162TIS03e8olzeJMZV+FuG2zT64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+Ua50vLyUVMSaH8/s++R1NiA+IFOYvJwMryrZcDz8nuE5bl7xsGaHjCdR00PAIqd
	 wPUB7czPxBKNYUabBiPAPhAva/om0wtlrICrdPNCX8U91BTmGyapWgfEnnxgKIFr6V
	 Ss1iqdwhtyIBUYwbTPxV0c8jBRxg8M3YPzX8k7Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0706/1815] iommu/tegra241-cmdqv: Free the error IRQ before tearing down VINTFs
Date: Sat, 12 Sep 2026 08:40:56 +0200
Message-ID: <20260912065705.468524973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 61f0d437988e5730b04442f6a7d30a9907339f2a ]

tegra241_cmdqv_remove() tears each VINTF down first, then calls free_irq().
Tearing a VINTF down frees vintf0 and clears cmdqv->vintfs[0]. An error in
that window makes tegra241_cmdqv_isr() read the stale slot and hand it to
tegra241_vintf0_handle_error(), which dereferences a NULL or freed pointer.

Free the IRQ before tearing the VINTFs down. free_irq() waits for in-flight
handlers to finish and blocks new ones, so no ISR can observe a VINTF as it
is torn down.

Note: a user-owned VINTF (viommu) could outlive this teardown, which unmaps
cmdqv->base and frees cmdqv->vintfs, so a later viommu close then touches
freed memory. This is neither introduced nor fixed here: a physical IOMMU
is not a pluggable device, so iommufd by design holds no reference on the
one behind a viommu, and this teardown is not expected while that viommu is
still alive.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 3d9554de5da27..7c1956c94ef53 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -832,6 +832,14 @@ static void tegra241_cmdqv_remove(struct arm_smmu_device *smmu)
 		container_of(smmu, struct tegra241_cmdqv, smmu);
 	u16 idx;
 
+	/*
+	 * Free the IRQ before tearing down the VINTFs. free_irq() waits for any
+	 * in-flight tegra241_cmdqv_isr() to finish and blocks new ones, so the
+	 * ISR cannot dereference a VINTF that is freed by the loop below.
+	 */
+	if (cmdqv->irq > 0)
+		free_irq(cmdqv->irq, cmdqv);
+
 	/* Remove VINTF resources */
 	for (idx = 0; idx < cmdqv->num_vintfs; idx++) {
 		if (cmdqv->vintfs[idx]) {
@@ -844,8 +852,6 @@ static void tegra241_cmdqv_remove(struct arm_smmu_device *smmu)
 	/* Remove cmdqv resources */
 	ida_destroy(&cmdqv->vintf_ids);
 
-	if (cmdqv->irq > 0)
-		free_irq(cmdqv->irq, cmdqv);
 	iounmap(cmdqv->base);
 	kfree(cmdqv->vintfs);
 	put_device(cmdqv->dev); /* smmu->impl_dev */
-- 
2.53.0



