Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00532D613;
	Wed, 23 Apr 2025 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419612; cv=none; b=gaTfKS4GMbTqfcjk1D7exzOvSyo6qe8+yaoT5bVDbJCMCfLvt/6HaFs/MGGW9Zy49ClYStFSgqJtD4XnIErj2mtvexTIZgdkjozyQk26Pi4uc3OaE2wAoTdW9hyILg7bMhiOICAHzL3lubkl5sRbJ4EDc1krXWv7+lFF3JWMxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419612; c=relaxed/simple;
	bh=UK/Iw/WZQVeldeE7eRoSIrNC76edMHPotmY03H1zn3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhalzfO/Ssse5prcIn9lF+Gnil5cXCEmzN28+dCddC2I9oBNAUpJowrQGGJ49Xjcs3oGMHHIe2t4JfwQ74fMZi+IiPsdLfPuRC1TMP2+8Z37If+akWbpjsynttue7GbOaaLDIl8pVB71an1loeQa0WMX5L/feLk6WQnmZ8IoLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpY+mUNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpY+mUNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642B2C4CEE2;
	Wed, 23 Apr 2025 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419612;
	bh=UK/Iw/WZQVeldeE7eRoSIrNC76edMHPotmY03H1zn3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpY+mUNX0YNS1juWHU+PM/N2UyNeT5UpBysaCLU3vH6jyQ1zVDQyJ94cwCk69yhuQ
	 CYzw3dBKIX1eqmyiSMWQguw+SUMSdVhzLAltJeYgqPJvW45RBQS6qj+m7cfQkl7C/t
	 NccE/OBUwxZymvUbjKSc53Hm2f0uJcK+80w8idPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/223] RDMA/hns: Fix wrong maximum DMA segment size
Date: Wed, 23 Apr 2025 16:41:32 +0200
Message-ID: <20250423142617.940737411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
index cf89a8db4f64c..8d0b63d4b50a6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -763,7 +763,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
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



