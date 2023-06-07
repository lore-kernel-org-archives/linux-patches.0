Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA110FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0753BC433D2;
	Wed,  7 Jun 2023 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169742;
	bh=KpOX9yBY2MN4DXxOyvmtbBMABnM8CIwuq22oglNh8XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0n9LVTg/hyQGSDaX0AqRuRf3QajgkHYllhuW9jdL3RxkFbC/vUIkacpemU83ioW4
	 X0cjOGyuTxOEOWTTqSjlwJdF63LRzYoC1cFMzG6gBqItNsVZc3vvp8IzY6HKVtWqTv
	 eyXhnyYtAM/bIFndRhcFDlYKBQ/ZmCALnOC3Ib0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 167/286] drm/msm: Be more shouty if per-process pgtables arent working
Date: Wed,  7 Jun 2023 22:14:26 +0200
Message-ID: <20230607200928.573323026@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 5c054db54c43a5fcb5cc81012361f5e3fac37637 ]

Otherwise it is not always obvious if a dt or iommu change is causing us
to fall back to global pgtable.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/537359/
Link: https://lore.kernel.org/r/20230516222039.907690-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index c2507582ecf34..0d6a69cd6f7a5 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -234,7 +234,12 @@ struct msm_mmu *msm_iommu_pagetable_create(struct msm_mmu *parent)
 	/* Get the pagetable configuration from the domain */
 	if (adreno_smmu->cookie)
 		ttbr1_cfg = adreno_smmu->get_ttbr1_cfg(adreno_smmu->cookie);
-	if (!ttbr1_cfg)
+
+	/*
+	 * If you hit this WARN_ONCE() you are probably missing an entry in
+	 * qcom_smmu_impl_of_match[] in arm-smmu-qcom.c
+	 */
+	if (WARN_ONCE(!ttbr1_cfg, "No per-process page tables"))
 		return ERR_PTR(-ENODEV);
 
 	/*
-- 
2.39.2



