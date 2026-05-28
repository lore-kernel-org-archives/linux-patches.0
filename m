Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C0A2F260C;
	Thu, 28 May 2026 20:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998896; cv=none; b=hM7aQYXe0ab8KTHoDx0R0aTeY4w+2Ps8VnI+raAAnNLXdWMhj8/1O81ApG+2N7UdxReJw2NkAj4rbneWccTRpYFeHekqRIfGXfUojmhgN9npZya8Rm3Q/yHxqV4HWXe14VQXzGmhFIWlWijfv8sJSm/0VY7bK4+sEzQBfsgynyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998896; c=relaxed/simple;
	bh=OnK/7pp7z24HlTaZhQ+6ucgSAkTuUVX8dtBit6sqHeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAv35KzwxMtzWhNpea7cK7ELUABIiQRPVZhE30dfjHXjUqk8IpTr1zEdts6hq018fuuejUc2UL0DH5cBPmhAMWHk4uyxws1KTplh9wEUMLUMYNfPAaCoWGVbRbD4K6yqEUM3sazdY8J1AZcseKjwCKgp3yP/TOUTH156OOIFmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiTacWvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiTacWvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F251F000E9;
	Thu, 28 May 2026 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998895;
	bh=ZRBPwjnUIAU3VJlohHDIEKx1SAkaSe43QvXoQ0GyezI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiTacWvwxkpVAQruAyd8pZbawlaIYvTDAj6Ghe9PL8Km7WAq2CC4Qhua46BswqTJK
	 BUIr1fs3yRxWrmHljZ1BGz/ppYnSJ1cqDcucgC4OQuPIjquU785RWp85FmTMTrTfl/
	 4puCSBS77F6UIQRgPJhbTe8AFpfIZ4o2pNeS30R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 336/461] iommu: Fix loss of errno on map failure for classic ops
Date: Thu, 28 May 2026 21:47:45 +0200
Message-ID: <20260528194657.082372146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 6fc7e8a3b8115294f60f5c89de27330bf1b9c98e ]

A typo, likely from a rebase, inverted the condition and caused
errors to be lost. Fix it to be "if (ret)".

This was breaking iommu_create_device_direct_mappings() on drivers
that don't use iommupt and don't fully set up their domain in
alloc_pages() (i.e., SMMUv2). In this case the first call of
iommu_create_device_direct_mappings() should fail due to the
incompletely initialized domain. Since it wrongly returns success,
the second call to iommu_create_device_direct_mappings() doesn't
happen and IOMMU_RESV_DIRECT is never set up.

Cc: stable@vger.kernel.org
Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Reported-by: Josua Mayer <josua@solid-run.com>
Closes: https://lore.kernel.org/all/321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 0735c54804c7 ("iommu: Handle unmap error when iommu_debug is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 973be8e2ab4c8..84ae594824a55 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2709,7 +2709,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 		return 0;
 	}
 	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	trace_map(iova, paddr, size);
-- 
2.53.0



