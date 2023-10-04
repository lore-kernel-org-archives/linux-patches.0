Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D02D1F61F
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLDl8u4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F128FC433C7;
	Wed,  4 Oct 2023 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444284;
	bh=98/h7ZuOQNmq9bPPA7ZOpskXaIcJRaovQPrwyP0EXmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLDl8u4hsL0SSoXqtVbDkUNM3Ufz6WMF5RTrhq/yYLixZ0vegqxvi40Dp2J6mGGXF
	 a/+lpHwHMw9Vu3lcdVHCRFZbF+2FljgIMS8k75J+BtBtC/0A2UM0vv9iRhfY4Nxumy
	 yEfcNfi6WWmbIqRqYmdtewslrGzBEhc3SGS5UIrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 196/321] nvme-pci: do not set the NUMA node of device if it has none
Date: Wed,  4 Oct 2023 19:55:41 +0200
Message-ID: <20231004175238.310132515@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <ptyadav@amazon.de>

[ Upstream commit dad651b2a44eb6b201738f810254279dca29d30d ]

If a device has no NUMA node information associated with it, the driver
puts the device in node first_memory_node (say node 0). Not having a
NUMA node and being associated with node 0 are completely different
things and it makes little sense to mix the two.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2f57da12d9836..347cb5daebc3c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2916,9 +2916,6 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 	struct nvme_dev *dev;
 	int ret = -ENOMEM;
 
-	if (node == NUMA_NO_NODE)
-		set_dev_node(&pdev->dev, first_memory_node);
-
 	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
-- 
2.40.1



