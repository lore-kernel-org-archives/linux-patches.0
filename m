Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E517F280A3C;
	Tue, 27 May 2025 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364902; cv=none; b=JqjZZmkWYofCzhIQv6CNRXAfyNYk7vLPVj6dM+/LINO2cTAO18a08rMJGAiPkGQTMyzcL9hsQ5p7lMbFjxnyp/IOFldVugFfKSJVfiRmQ6CUOzGE3Y3BUOknL5QyQf4253YwPWsj2bPjbAfGcLhI+S6I8LPlrtzIbrGrR/sIvxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364902; c=relaxed/simple;
	bh=bgTVe32QtAjl9D5fAEHzFfLy0g52UJH+r6W2MsFhU9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozx4ioN6iktU/vUujq/a+3xY1rST5xgrdf2IraaPpdQM4mJyXm2XGv+uSkTioHfIuSGqtUd5ibWQJLtYY3sTD79bUR/DGEhDgG2EBPdRFFHCOfjFU5rGmm93BLcqkRHod8VRm61IKADts45zQFWeCQ4kb0zkw1JyvxAqK0Mtn4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdGQ1JVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdGQ1JVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F215C4CEE9;
	Tue, 27 May 2025 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364901;
	bh=bgTVe32QtAjl9D5fAEHzFfLy0g52UJH+r6W2MsFhU9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdGQ1JVRLXQjE16XmktL8o4cU1foB6eVRTYEiCRdLqPY4V5akxWd4xFRnSGoVQzXK
	 byEBIHD5nLD/U/SwZJICTXJQGDCEFj5o7mz9PIC6eJrbL8/KdNlxqQThJbfEO3vmIo
	 oPikwN0XLxZQrtzPi2sJdD2wjiFEGP7z7+3VRGAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/626] iommu/amd/pgtbl_v2: Improve error handling
Date: Tue, 27 May 2025 18:21:35 +0200
Message-ID: <20250527162453.228582942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 36a1cfd497435ba5e37572fe9463bb62a7b1b984 ]

Return -ENOMEM if v2_alloc_pte() fails to allocate memory.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250227162320.5805-4-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c616de2c5926e..a56a273963059 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -254,7 +254,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		pte = v2_alloc_pte(cfg->amd.nid, pgtable->pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
-			ret = -EINVAL;
+			ret = -ENOMEM;
 			goto out;
 		}
 
-- 
2.39.5



