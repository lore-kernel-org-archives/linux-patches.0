Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381FB3419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQMEUgrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A561EC433C7;
	Mon,  9 Oct 2023 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859586;
	bh=tdYwdRi/LlVspOO1/jx7rUF6n2mR9kQg3e1L8m8cDQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQMEUgrAQKDmTat/5kzHrUObEYhNpD7MMV5/5gxYmiL1Gkdk81mf7yXnA/HlIkUSz
	 pSkkaWce3vP8gSm3EvaxJpLvdbvKrSPAB2ONyxAp6dLotwdhngL7XpfkV2qCIuU1iN
	 vX+8eus9284GxzS6chmjdT5/IcLLKyMquOGrq5VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/91] nvme-pci: do not set the NUMA node of device if it has none
Date: Mon,  9 Oct 2023 15:06:13 +0200
Message-ID: <20231009130112.946964540@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvme/host/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b06d2b6bd3feb..163497ef48fd7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2501,8 +2501,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	size_t alloc_size;
 
 	node = dev_to_node(&pdev->dev);
-	if (node == NUMA_NO_NODE)
-		set_dev_node(&pdev->dev, first_memory_node);
 
 	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
-- 
2.40.1



