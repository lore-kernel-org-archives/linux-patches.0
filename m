Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F111D0499;
	Wed,  2 Oct 2024 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877805; cv=none; b=NzPJtSzxDIQ7CnY1m3GTXRKYNefWGcfe68Syu9cA98XDl1jPEVE7TEpZbTW8ivI3a9EaVoJUlb/U+ThY0cD2HAR4MatETUYHnyrE2B2xrz/+IrBOscUQKNHhxqkszM4rUeg9+C6d/M7J5f4MuxXiSZpWijv9R/il4I+gRHyL1JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877805; c=relaxed/simple;
	bh=g9tDrD1UyJYRTv2Z5NVqMwqzZH7IGIWI9l+w5eGYr+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+/x6Di+81VwbPezU0jzPzCnCl1d6ZAGrSI2b/stOfxphT9Nbp67SIjxCVMbaCQnL1LkcHfV8gdG5pV48LRhTyNaFJDlJnVBuKY8Vrhni3smtW9ZT40LWTQ9UEANfnejymm7APe/GJrEH71l5WL075evO/m4rofwI+hlqFfLvqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQf3FeHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQf3FeHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30197C4CEC2;
	Wed,  2 Oct 2024 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877805;
	bh=g9tDrD1UyJYRTv2Z5NVqMwqzZH7IGIWI9l+w5eGYr+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQf3FeHM9XYqoDDxIu9adPzkamw56gRYZlAv0aX/X7Ttvn8+54ag6jqmq/1HA2zJb
	 KHfH3pFcE3lU6eRWxbQ9O3QqxAVpeJFkPWmUunGb4yVyNc2GA/zrIaWbtmOk7XKnYb
	 qR662DJdlizXTq/F+0Kb2taNPw2wCsncFNaiarBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 169/634] iommu/amd: Do not set the D bit on AMD v2 table entries
Date: Wed,  2 Oct 2024 14:54:29 +0200
Message-ID: <20241002125817.781029483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 2910a7fa1be090fc7637cef0b2e70bcd15bf5469 ]

The manual says that bit 6 is IGN for all Page-Table Base Address
pointers, don't set it.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/14-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index acfe79b326293..743f417b281d4 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -51,7 +51,7 @@ static inline u64 set_pgtable_attr(u64 *page)
 	u64 prot;
 
 	prot = IOMMU_PAGE_PRESENT | IOMMU_PAGE_RW | IOMMU_PAGE_USER;
-	prot |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
+	prot |= IOMMU_PAGE_ACCESS;
 
 	return (iommu_virt_to_phys(page) | prot);
 }
-- 
2.43.0



