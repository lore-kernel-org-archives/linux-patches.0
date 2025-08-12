Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A2305E08;
	Tue, 12 Aug 2025 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022302; cv=none; b=S8UL84q/EWeQVRW/aqwxnx8PwoPU7HSoS58oIfJxSW6t58HoNnGhxzjfv5I0tV3K30JtyJA54jmmLkgRjZvu4f4b8ZgRZhA/T1pnCu9L5l3bhOWB7M+yqQ5t54rwGBLrGjrkSaFsN203DIJBeFRYxhZt6sD5x8aWj40WU9q0aNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022302; c=relaxed/simple;
	bh=YSjymwP1CZ229tw8JTLBG0mZGI9H278f42wAsitl++s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyfGWnFLnGpUN6Gs06KFbt5T0efe9BtMEz1yNZbA3dmlYdt8ZMojCs8cHPTSRsQpHxEwsoJ/XsybO4kIOPKlVyygWIYvYV2F4PwK5JhifcQGgAOSvnGUSJUKYpsL3HciMaXsm6CtgKI/R6/iz2avxc01IAAnRqPqsPORkBWm85M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxmtUl7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxmtUl7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98BFC4CEF0;
	Tue, 12 Aug 2025 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022302;
	bh=YSjymwP1CZ229tw8JTLBG0mZGI9H278f42wAsitl++s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxmtUl7ynzT5OgRUrFsiYP538+c2+80/ru3ovkpOLn7Dp6LPwPYNhTI6PsUgF0Av3
	 zEKxbagfxLqQQ1BxJtNULV8/RTWQOaXeQTMq1fIxN+6Ozd2TUbIeWV9mkC0sjRTwy4
	 wNPNxrvtsRPMgZreqIo6OexIagYfuQx3sWj7DzEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/369] iommu/amd: Fix geometry.aperture_end for V2 tables
Date: Tue, 12 Aug 2025 19:26:53 +0200
Message-ID: <20250812173019.131207313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8637afa79cfa6123f602408cfafe8c9a73620ff1 ]

The AMD IOMMU documentation seems pretty clear that the V2 table follows
the normal CPU expectation of sign extension. This is shown in

  Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation

Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
would have three regions in the page table: lower, non-canonical, upper.

The manual describes that the V1 table does not sign extend in section
2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA

Further, Vasant has checked this and indicates the HW has an addtional
behavior that the manual does not yet describe. The AMDv2 table does not
have the sign extended behavior when attached to PASID 0, which may
explain why this has gone unnoticed.

The iommu domain geometry does not directly support sign extended page
tables. The driver should report only one of the lower/upper spaces. Solve
this by removing the top VA bit from the geometry to use only the lower
space.

This will also make the iommu_domain work consistently on all PASID 0 and
PASID != 1.

Adjust dma_max_address() to remove the top VA bit. It now returns:

5 Level:
  Before 0x1ffffffffffffff
  After  0x0ffffffffffffff
4 Level:
  Before 0xffffffffffff
  After  0x7fffffffffff

Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e315e3045a3d..6a019670efc7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2352,8 +2352,21 @@ static inline u64 dma_max_address(void)
 	if (amd_iommu_pgtable == AMD_IOMMU_V1)
 		return ~0ULL;
 
-	/* V2 with 4/5 level page table */
-	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
+	/*
+	 * V2 with 4/5 level page table. Note that "2.2.6.5 AMD64 4-Kbyte Page
+	 * Translation" shows that the V2 table sign extends the top of the
+	 * address space creating a reserved region in the middle of the
+	 * translation, just like the CPU does. Further Vasant says the docs are
+	 * incomplete and this only applies to non-zero PASIDs. If the AMDv2
+	 * page table is assigned to the 0 PASID then there is no sign extension
+	 * check.
+	 *
+	 * Since the IOMMU must have a fixed geometry, and the core code does
+	 * not understand sign extended addressing, we have to chop off the high
+	 * bit to get consistent behavior with attachments of the domain to any
+	 * PASID.
+	 */
+	return ((1ULL << (PM_LEVEL_SHIFT(amd_iommu_gpt_level) - 1)) - 1);
 }
 
 static bool amd_iommu_hd_support(struct amd_iommu *iommu)
-- 
2.39.5



