Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8273E0093;
	Fri, 15 May 2026 16:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861114; cv=none; b=GOkE/kg4qMmz5cMlKf+Qfgo8AE+FYmv9DJe+wryK9fVL+xntKTx1tn44q9tKh6LvX2OSTF6YqU5p3cESPWjYEAZsePfu2Dt/Z04GfiFihkzR7RI0m7HcfK22hqGgVdJfbh3RTEbMTbFHiT6had5NXb721lxNwFzOq/unVr0+HtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861114; c=relaxed/simple;
	bh=RfxGcFBDTYa1fInqPuMRFJLfVvQJ6e419vo3FyVCii8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvBR2Wl2Z6zd1qOSCJyTj2V9rpu91bSn2xAfFOpBEORPIeqj6ZjmzYRwjsIDp/2pobHy91Jw1K5jF9EO740ErIBVhybRK3UPm37sqWexCAR8UqwWJqIeENaGEIWzl6QjOxwRj8K+Yr4aB4wI69kYWy1NLm9pFb417H5Tjqu526o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJojjNkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJojjNkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DF6C2BCB0;
	Fri, 15 May 2026 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861114;
	bh=RfxGcFBDTYa1fInqPuMRFJLfVvQJ6e419vo3FyVCii8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJojjNkdnkp0TJvSo2SvQmO5rBpTCqerCu1p2HJXs9tod8LWrM1ts1Ft+aRrbLPcQ
	 doZHR1qJyZjaDv8Waln7hfJLNr0eWcsoGtNcd6MOwzhe6oYeJSU5UjTommN3S35fG0
	 3a8FN8he9supGNb/MEjXyKlCQBqMmV9AOirvM2dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/474] iommu/amd: Use atomic64_inc_return() in iommu.c
Date: Fri, 15 May 2026 17:44:32 +0200
Message-ID: <20260515154718.551616594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

commit 5ce73c524f5fb5abd7b1bfed0115474b4fb437b4 upstream.

Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
to use optimized implementation and ease register pressure around
the primitive for targets that implement optimized variant.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241007084356.47799-1-ubizjak@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Stable-dep-of: 9e249c48412828e807afddc21527eb734dc9bd3d ("iommu/amd: serialize sequence allocation under concurrent TLB invalidations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index d119a104a3436..6d0d28050052a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1209,7 +1209,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (!iommu->need_sync)
 		return 0;
 
-	data = atomic64_add_return(1, &iommu->cmd_sem_val);
+	data = atomic64_inc_return(&iommu->cmd_sem_val);
 	build_completion_wait(&cmd, iommu, data);
 
 	raw_spin_lock_irqsave(&iommu->lock, flags);
@@ -2877,7 +2877,7 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 		return;
 
 	build_inv_irt(&cmd, devid);
-	data = atomic64_add_return(1, &iommu->cmd_sem_val);
+	data = atomic64_inc_return(&iommu->cmd_sem_val);
 	build_completion_wait(&cmd2, iommu, data);
 
 	raw_spin_lock_irqsave(&iommu->lock, flags);
-- 
2.53.0



