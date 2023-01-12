Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B879C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB1C433D2;
	Thu, 12 Jan 2023 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533286;
	bh=ktuX8+BF2iMYWONt6KFRQzimjLaD2mX2w366/WV1G2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baswzrGE17zLM3UPg0CQlVlU1GA5lpilph5lo6kC6hqUhcYc7wGIZxUm2WTtnnptL
	 2yi3tQsy4n0V3gSWQPwDQ3hiNNudFInT79lvmvbnWq1H0xh3nss7Reb5CdT13vRMMZ
	 A30VN8ltIDhDFEOXGjkeuK/bYDZaxYgJqP2nMVq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/783] iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
Date: Thu, 12 Jan 2023 14:52:25 +0100
Message-Id: <20230112135544.198370038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index b9a974d97831..25689bdf812e 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -1122,7 +1122,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
 		if (ret) {
 			dev_err(dev, "could not create coherence subdomain\n");
-			return ret;
+			goto error;
 		}
 	}
 
-- 
2.35.1



