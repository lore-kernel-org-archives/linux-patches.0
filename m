Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47933C433EF;
	Mon, 16 Jan 2023 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887773;
	bh=QM7aua7ZEybVKMFCACZuR1qlc+bR4qXQAeiUNikaH4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1h5JXiSqHIH+QVGAJpI9XYNrVHVmQh3A83VyOqBvTGZHNxCsskt8MiHsgml1yrSo+
	 IgMe18+Mk+5NDbH0xrYtE0yYurEvmyaI6C5gzJJ+ngWwvu49Wvdw2MeiS77JJaqMUU
	 mjVCTdQxqXZJmwOess2PClO8wjos+av6uIdjBXJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 277/521] iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
Date: Mon, 16 Jan 2023 16:48:59 +0100
Message-Id: <20230116154859.549317690@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 73f5fc5f884ad0c5f7d57f66303af64f9f002526 ]

The fsl_pamu_probe() returns directly when create_csd() failed, leaving
irq and memories unreleased.
Fix by jumping to error if create_csd() returns error.

Fixes: 695093e38c3e ("iommu/fsl: Freescale PAMU driver and iommu implementation.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221121082022.19091-1-yuancan@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/fsl_pamu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index 8540625796a1..b6a0c6d3b204 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -1134,7 +1134,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
 		if (ret) {
 			dev_err(dev, "could not create coherence subdomain\n");
-			return ret;
+			goto error;
 		}
 	}
 
-- 
2.35.1



