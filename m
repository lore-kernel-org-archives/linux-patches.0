Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95B18E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mX/cnQ71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ECEC433C9;
	Mon,  9 Oct 2023 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858255;
	bh=SY4bmwYqYiULSmlCrEaYB8GN6Uz+huPGif9FayFboeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mX/cnQ71CWxGsF7/wEn9/NMBWteuY8cljiW8aFF4mT0C1KXqnsrbAu09YaMaRma0B
	 IJVIRfvXIcyn0o3klh0ihIShVGsycVblcfLKsXmPdBY54GeD1rElqJNLd3fGIHqTF5
	 hPY1eNTzrDI6iQlF8rDeMy3trVqqSeHAdLiJYbpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/131] nvme-pci: do not set the NUMA node of device if it has none
Date: Mon,  9 Oct 2023 15:01:44 +0200
Message-ID: <20231009130118.255685929@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a58711c488509..486e44d20b430 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2841,8 +2841,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	size_t alloc_size;
 
 	node = dev_to_node(&pdev->dev);
-	if (node == NUMA_NO_NODE)
-		set_dev_node(&pdev->dev, first_memory_node);
 
 	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
-- 
2.40.1



