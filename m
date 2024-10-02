Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA61474BC;
	Wed,  2 Oct 2024 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879515; cv=none; b=mIBo4J+ykKBbUOZFIt4VHX2T74jWtDSOnMYrJUi0jge7ToczEn7o9BIQodd/unhX31wpWwUhcJvBvftm/wO0u4QMievNAIotIDOS6se+kJlGqjoH49kgzvh5IM4YeB8A91nN91Dm1va5JnfciYFaTcp3hZD4xEUNk9MwNlQiA6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879515; c=relaxed/simple;
	bh=aU8XjO7rioQDJkc+5IApDHSJ43vcagpyUuZ9J4lOMtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCp92wCFgFDwIK9f60sRkRx8MvmlrmfjsxH8A3GZ5v8QmRu2luTlrVeYIo5SJCUFwhYCiuM06bS5kPJk4zzwXIIWWXgzXAho3Yr6mKsW6fPFDB7B+a1m8+p7kzRnCoipDK6HXRXoTOkUZixqIUMc2EPotAW0doTC9NhYUEGGlo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqgbHjJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqgbHjJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6226C4CEC2;
	Wed,  2 Oct 2024 14:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879515;
	bh=aU8XjO7rioQDJkc+5IApDHSJ43vcagpyUuZ9J4lOMtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqgbHjJQBQndl4pKNy8xyebyaLpgXdnbVEH/BWpTtnjL9KiQWzpXGUhrIQcrBxuQw
	 lHyrmZS1CSoL+eROwDISHabUCBcBPmj284k+Wb7SkimKfztS2v3UUc6C3DaIYWGOvA
	 OY1h/j4XqWf5z2DvfDc9kWYicPvLilbbea99EJR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/538] iommu/amd: Do not set the D bit on AMD v2 table entries
Date: Wed,  2 Oct 2024 14:56:07 +0200
Message-ID: <20241002125757.295792192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9ef2e0a62f67..cbf0c46015125 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -50,7 +50,7 @@ static inline u64 set_pgtable_attr(u64 *page)
 	u64 prot;
 
 	prot = IOMMU_PAGE_PRESENT | IOMMU_PAGE_RW | IOMMU_PAGE_USER;
-	prot |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
+	prot |= IOMMU_PAGE_ACCESS;
 
 	return (iommu_virt_to_phys(page) | prot);
 }
-- 
2.43.0



