Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912A233F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19557C433F0;
	Mon, 16 Jan 2023 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886043;
	bh=Aqzm1KWORN7E0eTLNCo64Adar1vNIwOiUWfy42C8bLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/REm3wkCLGaupH0qlMxuZilRnT3f/hfQaqxW5kdPxsemqNT13FS/CAr0Gao6qdqH
	 j6IRXzJvPkAm53gqLlPG/SUJQ9OqKjn1VZUNvXn3+dfvkUeN5fIzMInMMP1Y0XKXuE
	 Zr66Yaphv2q52jve/PcJzARU2xsVc3T/2/dp8HM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/658] RDMA/hfi: Decrease PCI device reference count in error path
Date: Mon, 16 Jan 2023 16:45:41 +0100
Message-Id: <20230116154921.136477666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 9b51d072da1d27e1193e84708201c48e385ad912 ]

pci_get_device() will increase the reference count for the returned
pci_dev, and also decrease the reference count for the input parameter
*from* if it is not NULL.

If we break out the loop in node_affinity_init() with 'dev' not NULL, we
need to call pci_dev_put() to decrease the reference count. Add missing
pci_dev_put() in error path.

Fixes: c513de490f80 ("IB/hfi1: Invalid NUMA node information can cause a divide by zero")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221117131546.113280-1-wangxiongfeng2@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/affinity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 1aeea5d65c01..832b878fa67e 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -218,6 +218,8 @@ int node_affinity_init(void)
 	for (node = 0; node < node_affinity.num_possible_nodes; node++)
 		hfi1_per_node_cntr[node] = 1;
 
+	pci_dev_put(dev);
+
 	return 0;
 }
 
-- 
2.35.1



