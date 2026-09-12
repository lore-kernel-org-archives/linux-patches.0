Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D7361DDC;
	Sat, 12 Sep 2026 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200009; cv=none; b=BbxXwmQW30E/qfxpqB1PPEItWz03FlqMuZ7WCKWyR+zrS6dTwS1Ux6kuPO34Q9082XjmGUgJOzItebhZT935G7abb0QMPJiNbh6msojE6VLjrXUkBDrl7I8cjjuWd4xuSpEsxNvVg3GWKfQ2LaQXqs7MXatJwq/ebqLWSScMmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200009; c=relaxed/simple;
	bh=lH7VQzLSelUqHPTit9b7+ygcbc687aB6UJOgejl4GI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDPgQ1zKKlm++I9MwZag4OV2RQFgGlItFq37YY/XpQ09H711L0dtgkqDmmzMkeP6m63KegVMXmSzjNuDTPFKWRb1vxeYTKIvxTdqQLCISpmMZt8728+dnTdGcH5NOFWNaUb7uiri/M2VdDaV2OD2o8wKP5zuNRAPUGNU+gb/q0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sv2T3W9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sv2T3W9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99911F000FF;
	Sat, 12 Sep 2026 08:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200007;
	bh=UTmIcTnebvXqEMqqu8/UeGJkCB91pyZ/O3u/YCngCX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sv2T3W9m0OJXkHROr4AZCXQzwamlxXGLQkyEcyX7AaUnl3ImFaCX1OXgbpNbco+1P
	 vTLjZ09nJ6TZ4p9qnMXaLhzy9zyFS5pBUgb1OxSJzZx/4XK/vlTlY3KkSTYG6w63zM
	 SZVwQyZZ7o3yonzN8rJWYA6Eqdl20vpC1GjxuvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0702/1815] iommu/tegra241-cmdqv: Publish an LVCMDQ only after it is fully initialized
Date: Sat, 12 Sep 2026 08:40:52 +0200
Message-ID: <20260912065705.371827234@linuxfoundation.org>
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
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index e5f52c0f6e9ad..6e14ed3207242 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -320,12 +320,19 @@ static void tegra241_vintf0_handle_error(struct tegra241_vintf *vintf)
 
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
@@ -668,7 +675,6 @@ static int tegra241_vintf_init_lvcmdq(struct tegra241_vintf *vintf, u16 lidx,
 	vcmdq->page0 = cmdqv->base + TEGRA241_VINTFi_LVCMDQ_PAGE0(idx, lidx);
 	vcmdq->page1 = cmdqv->base + TEGRA241_VINTFi_LVCMDQ_PAGE1(idx, lidx);
 
-	vintf->lvcmdqs[lidx] = vcmdq;
 	return 0;
 }
 
@@ -707,14 +713,15 @@ tegra241_vintf_alloc_lvcmdq(struct tegra241_vintf *vintf, u16 lidx)
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
@@ -1142,13 +1149,15 @@ static int tegra241_vintf_alloc_lvcmdq_user(struct iommufd_hw_queue *hw_queue,
 	if (ret)
 		goto unmap_lvcmdq;
 
+	/* No lockless reader of a user VINTF's lvcmdqs[]; mutex-serialized */
+	vintf->lvcmdqs[lidx] = vcmdq;
+
 	hw_queue->destroy = &tegra241_vintf_destroy_lvcmdq_user;
 	mutex_unlock(&vintf->lvcmdq_mutex);
 	return 0;
 
 unmap_lvcmdq:
 	tegra241_vcmdq_unmap_lvcmdq(vcmdq);
-	tegra241_vintf_deinit_lvcmdq(vintf, lidx);
 undepend_vcmdq:
 	if (vcmdq->prev)
 		iommufd_hw_queue_undepend(vcmdq, vcmdq->prev, core);
-- 
2.53.0



