Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A627466A;
	Fri,  7 Aug 2026 15:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116529; cv=none; b=iZF9c1n517/DapMsyjxRbsefUhBN6XnWD5nRMoyZY/LnQ0mFxmYUqIICxC11vwbABZX0iLT7SClzW82VWpcEUpy/xMK+cZJ4fbemGmwBmJdtR8DMvJoaoGBZcTy75pjLsJ8sGpplRe/NCcDUhfD6GM7x1Y2St3XYFJWzsh7wBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116529; c=relaxed/simple;
	bh=YU93LJiwR3fKh7d4oNbwGohRPM1/j/58nZtpYbjMPF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NniDzvDxH+Li8BNh4PbWz2sLufTCwV01uVZV9/o77ipqdMRv2gXQgZzbne5WiWuTkjsEeYxwk7ObNTtdoaErH/lEzqCcuYFiolbcNeMbAVsempk8gAJjtL0bD3jRHoXiepzgM7nuh4LLHt7fB1FKEaiB9/SV6uprNNaprvWTB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFdGTSHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFdGTSHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7202C1F000E9;
	Fri,  7 Aug 2026 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116528;
	bh=g4a0Ar4E1Ls+Rwm3sq2iE9mZTvfmXLA+Jg5RPDbkuEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFdGTSHcVWzvzq/IePq5khA5SYUxlybeokwV0gX/r2ucyThUwFOHidVZ7gtrfm4Rb
	 iqmAjvFxsWc8j59NcnLhjhmlxbuNRnKD3RJDIkI/qE4JO29nGkUjy6IzZqSGRUyBg1
	 4sXfhn1QHpi9Cx0B/ndNlDBX+dzSpeEHM6JcvjrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <albinwyang@tencent.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/261] iommu/sva: move x86 disable check before allocation
Date: Fri,  7 Aug 2026 16:39:25 +0200
Message-ID: <20260807143419.854611989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Wei Yang <albinwyang@tencent.com>

Backport of commit 72f98ef9a4be ("iommu: disable SVA when CONFIG_X86 is
set") placed the IS_ENABLED(CONFIG_X86) early-return in
iommu_sva_bind_device() after iommu_sva_alloc_pasid() and kzalloc(handle),
while upstream puts it at the function start.

On x86 this leaks the kzalloc'd struct iommu_sva (early return skips
kfree) and a globally allocated PASID (mm->pasid wrongly set, never
unbound). Move the check before any allocation/side effect.

Fixes: 240cd7f2812c ("iommu: disable SVA when CONFIG_X86 is set")

Signed-off-by: Wei Yang <albinwyang@tencent.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-sva.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 611733c02b7c0..a340b805b82b7 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -62,6 +62,9 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 	struct iommu_sva *handle;
 	int ret;
 
+	if (IS_ENABLED(CONFIG_X86))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/* Allocate mm->pasid if necessary. */
 	ret = iommu_sva_alloc_pasid(mm, dev);
 	if (ret)
@@ -71,9 +74,6 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 	if (!handle)
 		return ERR_PTR(-ENOMEM);
 
-	if (IS_ENABLED(CONFIG_X86))
-		return ERR_PTR(-EOPNOTSUPP);
-
 	mutex_lock(&iommu_sva_lock);
 	/* Search for an existing domain. */
 	domain = iommu_get_domain_for_dev_pasid(dev, mm->pasid,
-- 
2.53.0



