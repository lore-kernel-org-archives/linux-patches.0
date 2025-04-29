Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFCE221DA7;
	Tue, 29 Apr 2025 17:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948842; cv=none; b=MnFk2Al9vX5HwO5WjVRKHAr/N/TNEgjv6KXQkYixn0X4fa0WaLfKgwzFvqP7Vs1X8ZQOFLlnj/JNVvi2R1PY5e2LqnJg94S0SvDT33lfTCxCKsk114Wqh2UjZ7MkFxpkTGT0x8kKU/ecqOG8kdJfObBX7ZQGNosd2BvCjSRnijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948842; c=relaxed/simple;
	bh=20yHXa2VTPfLDnlWwcQsCvf9Lyp8JCXPiQyVhuFcqOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwp9BtoSqpk5j2F5oncRQo8lO1cEjbQNXzEZP1/oFhQuh12XkDAEh00Uw7qEZ8TmNLYwEAEfFI5kVNna0uqeZ1BI9y6up4P5Q3YUbo54gu1IV0RB6hjSHmzHEUpcCBqApQAdm9DBKa8sQ/tC6TaGidl5eIuWqCjtEMC3au9MdOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9pzQClI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9pzQClI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC8C4CEE3;
	Tue, 29 Apr 2025 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948841;
	bh=20yHXa2VTPfLDnlWwcQsCvf9Lyp8JCXPiQyVhuFcqOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9pzQClIb7QQ5N4JHUeSEfbCygb7iDZEFldvpPp60jt91f0Lidsc9uvbh9+TkKqze
	 mEDyFhF+M3IV0LEjgGyr6CQjzCyYIbkVS9OGUllegcy2eU/Vz19bfKHbL5cIrVg57b
	 IXca4Kg5B13DLSmejQH6PPnixriSkU/O+nzVSrwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/373] RDMA/hns: Fix wrong maximum DMA segment size
Date: Tue, 29 Apr 2025 18:40:11 +0200
Message-ID: <20250429161128.679205313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 83a6b8fbe10f0..4fc8e0c8b7ab0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -544,7 +544,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
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



