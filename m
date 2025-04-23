Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381C828DEF9;
	Wed, 23 Apr 2025 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421961; cv=none; b=ECi3U/kZf+PzxeReyEK4rjNM6c60ldthYMr6bdLgg5MmzipGdOQ1L0TEgv2NqW9nNQztEo2yjzmH5ACCfp84o8L8KD92uy3u8NsYTJv77Vl/FECEOBRbFk9Uu2elrWPrczEft3cSQVnspBEqIiGyj2bDPkdpio3QUqRr4Nxs6Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421961; c=relaxed/simple;
	bh=8f/HGOZ1y5RCyJQehh6qvMC9PW0sUM6P+nWSp6dxBaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjacJz2daWmTzNU9O5+Z9xdP94Ca4c+o2bpSnQEqOy6aeFGcnqRs0DSpho+C0/Gafg0NjtJnzvXMIPDEk0JriKHrRfDSbuP9gzoTLa/lkCZF2vT+htl4lJyPcmz+JBYlTAQxCwggDKBBoNMDXuomq5+hzQPJ2kA3BCc4MnCEKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2cPmeOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2cPmeOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66524C4CEE3;
	Wed, 23 Apr 2025 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421960;
	bh=8f/HGOZ1y5RCyJQehh6qvMC9PW0sUM6P+nWSp6dxBaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2cPmeOXfoNczIsxBTGlvqmTxKC4hjIe2p53AAdg4snOg4WjQiNmEziKMwvp4y7KS
	 aF8TYZElr0AZnLBtE0qXgvFtwK8Q/baG7VuqDN4nGifJUivQRnptQ3bFiW6h532aiH
	 KnvPPdoHRMEmeprWISSZSgTHXA0psqWZoMJD2B2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/393] RDMA/hns: Fix wrong maximum DMA segment size
Date: Wed, 23 Apr 2025 16:42:28 +0200
Message-ID: <20250423142653.781330903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9beb2c91fb86e0be70a5833c6730441fa3c9efa8 ]

Set maximum DMA segment size to 2G instead of UINT_MAX due to HW limit.

Fixes: e0477b34d9d1 ("RDMA: Explicitly pass in the dma_device to ib_register_device")
Link: https://patch.msgid.link/r/20250327114724.3454268-3-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index dcd763dbb636d..a7e4c951f8fe4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -731,7 +731,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		if (ret)
 			return ret;
 	}
-	dma_set_max_seg_size(dev, UINT_MAX);
+	dma_set_max_seg_size(dev, SZ_2G);
 	ret = ib_register_device(ib_dev, "hns_%d", dev);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
-- 
2.39.5



