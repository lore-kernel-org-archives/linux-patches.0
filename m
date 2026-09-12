Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A218041F5CA;
	Sat, 12 Sep 2026 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207993; cv=none; b=sJeEqCGJFSnqRsYp3qOM2/X+NsUeaUIZOZbrO1TQNhBmML4hCaafjIHh5+UHvJbQo/6x4bxXagcSom8WE0qMURKbhno/6qBJtm+BLDo5KzdtG1nDay/mnf2xY/GcPWxEUKka6yyCv1eRrJf4ZXiM9APjDK0+nB336Y2XCUoMhIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207993; c=relaxed/simple;
	bh=egBK1uNKOcsQt7UWOyX+8AFVRB+wpZDJOQ8V9a+hxR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPjsAXr66aGswgWjZI4x6MctnOfSFNexJThxqkXXzlzMrwxtMKSvCF1tTnfpXVGFRTvNSM2Nj804ZCvEX77WMmneTN6Uq5qf0Wp8wCq4976Dtvf976fZeVGCUTKUkr++WMgh1B7g+raizBMvbZl1+lTv83DYwkdSLyHQgVGCAAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QC0ep/Zk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QC0ep/Zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8E11F000FF;
	Sat, 12 Sep 2026 10:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207989;
	bh=YPdXZglIvJtcBROijswRFqd9Y4IvP82U8RWCMHd4W6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QC0ep/ZkJhhXQeEwtLiB/1pn2W55o8wTf3KpUPPjYSuUofMu3vRXqJIWgm2dSBwNf
	 2ENM4VaYbe7yXmmeoA8h58WSiuEHaU3MXsc9hYfjg3uOGkalHaSM/FWJHrHXj7o3yx
	 w6ChBTEH2mF+ZF3l+sLsoCjJlYFBVGH4FqX4Zryw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0526/1518] iommu/arm-smmu-v3: Declare eats_s1chk and eats_trans as host-endian u64
Date: Sat, 12 Sep 2026 08:44:55 +0200
Message-ID: <20260912065635.344229634@linuxfoundation.org>
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

[ Upstream commit 4455286274474e95f223c68c215d32c864404889 ]

arm_smmu_get_ste_update_safe() declares the eats_s1chk and eats_trans
locals as __le64, but initializes them from FIELD_PREP(), which returns a
host-endian value, and passes them through cpu_to_le64() at the use sites.

Sparse reports the following warnings:

>> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1122:38: sparse: sparse: cast from restricted __le64
   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1124:33: sparse: sparse: cast from restricted __le64

Declare both locals as u64 so the type matches FIELD_PREP() and the
existing cpu_to_le64() at the use sites performs the host-to-little-endian
conversion. No functional change.

Fixes: 7cad80048595 ("iommu/arm-smmu-v3: Mark EATS_TRANS safe when computing the update sequence")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202606151017.QU0evpH9-lkp@intel.com/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 01f448acd8dce..d645f7edbd107 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1097,9 +1097,9 @@ VISIBLE_IF_KUNIT
 void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
 				  __le64 *safe_bits)
 {
-	const __le64 eats_s1chk =
+	const u64 eats_s1chk =
 		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_S1CHK);
-	const __le64 eats_trans =
+	const u64 eats_trans =
 		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_TRANS);
 
 	/*
-- 
2.53.0



