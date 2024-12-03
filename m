Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F91AB6C9;
	Tue,  3 Dec 2024 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241327; cv=none; b=p8dQ0ln+jEkPgAAeaWG+ov1aSyjAxzRQY6HLSsS4crEZ0lq5q2mOaTFJqWaDk18VxPX9Mb2kxt3AX2RFhNG5dYq8RkC8UGyUfIqlV6OKyVgRm2paGyUKFg0EYaCxLYvuvgWN7NWhj0uFyoEd2lpb1b3V2nfZMmULba8DpvitMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241327; c=relaxed/simple;
	bh=rsS7cSzdlTyPpCW5Oz/ubJE1FyUz0YEJPwdH7qkbWFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg3u9yeu6jONvenSl2Pb02I3xvmtMzTzFXIHvg41WeXgDjN3pTuV1C+2O+/xZvUrX7WXWe26ny19Zl1+bUBXRbP6Qzv7EjSJFCp5d1FY8CovTKe34heb+91R3V1MubR+hbS7pH8xPhmzB8GBjZngLxim12ALB9Bo6A2ltlnYj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZb0cMqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZb0cMqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAACC4CECF;
	Tue,  3 Dec 2024 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241327;
	bh=rsS7cSzdlTyPpCW5Oz/ubJE1FyUz0YEJPwdH7qkbWFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZb0cMqFL2dy/nTJG5kF9qIfSw6/BlIvsjn+0p3pb0YEznQ0kb7b70lM2ehsQRetV
	 jNaq5JX047fpBrwh/EbxsKMVtAHymRij0sKSh6dUn4TPjuHlfkstHhEYj3zYIbblz8
	 SwMLriZ9b9lQR8fMjpWBS0jKcwM7nNSMZynA2mTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/826] iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB
Date: Tue,  3 Dec 2024 15:41:56 +0100
Message-ID: <20241203144758.935867678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 016991606aa01c4d92e6941be636c0c897aa05c7 ]

Commit c7fc12354be0 ("iommu/amd/pgtbl_v2: Invalidate updated page ranges
only") missed to take domain lock before calling
amd_iommu_domain_flush_pages(). Fix this by taking protection domain
lock before calling TLB invalidation function.

Fixes: c7fc12354be0 ("iommu/amd/pgtbl_v2: Invalidate updated page ranges only")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-2-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 25b9042fa4530..c616de2c5926e 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -268,8 +268,11 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 out:
 	if (updated) {
 		struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
+		unsigned long flags;
 
+		spin_lock_irqsave(&pdom->lock, flags);
 		amd_iommu_domain_flush_pages(pdom, o_iova, size);
+		spin_unlock_irqrestore(&pdom->lock, flags);
 	}
 
 	if (mapped)
-- 
2.43.0



