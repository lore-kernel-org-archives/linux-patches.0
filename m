Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665E61AC8AE;
	Thu, 15 Aug 2024 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729645; cv=none; b=F0qAZuNttDYm/ULgJyMmnaUw79csStbxav07uR7Qi//a4awyjPpFOYNzsadVOQSE3zXxTxrjrR6j+H2mgHrWWmLgpuHDCt9B9GsqQ0dR143kwuhXfnWRlNOIEzRE2fcRilYbZNRdYfSizJ1GV6HSXaXhpgMCYiHwWMcoTk+0ZcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729645; c=relaxed/simple;
	bh=9DqzkG0nIHpfaBo0AqMBMqL/Ry10sW9U4v2KSJosmkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tigGfsMT2yIyul+TXxZXsYkhHlpuUV+1ouiFf7c4s5MRlh0tvAt42rArSo6cXLhJZQJ2KDO5hHRamCDg/RjkSxeHbMoC//ZdHV0vaicM6deHYGHmXCZlwN3piGlu4TUnS2APYm9REvAJ/HXZPdgy7qz7cA02BE2dxXo1bOhHP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd3/bJvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd3/bJvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CDDC4AF0C;
	Thu, 15 Aug 2024 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729645;
	bh=9DqzkG0nIHpfaBo0AqMBMqL/Ry10sW9U4v2KSJosmkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd3/bJvyIwI8UQe8NAmqnID/REFJfcuk7lwZ+PPU7zcu4lJSts4H6wHiCCz/sD5uO
	 2+fzEUJZlqpevuMmAi7d/ESvoI6dXI6f8yhBaQ3EEY1Pu1sAZBMLRUy+5OoYo0I5RF
	 /yRqhjkQoy8uAP2B5NJ2jq5ocBdmlToPqMvGaXn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/484] RDMA/device: Return error earlier if port in not valid
Date: Thu, 15 Aug 2024 15:19:50 +0200
Message-ID: <20240815131946.505607646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 917918f57a7b139c043e78c502876f2c286f4f0a ]

There is no need to allocate port data if port provided is not valid.

Fixes: c2261dd76b54 ("RDMA/device: Add ib_device_set_netdev() as an alternative to get_netdev")
Link: https://lore.kernel.org/r/022047a8b16988fc88d4426da50bf60a4833311b.1719235449.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 725f2719132fb..5d1ce55fda71e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2145,6 +2145,9 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	unsigned long flags;
 	int ret;
 
+	if (!rdma_is_port_valid(ib_dev, port))
+		return -EINVAL;
+
 	/*
 	 * Drivers wish to call this before ib_register_driver, so we have to
 	 * setup the port data early.
@@ -2153,9 +2156,6 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	if (ret)
 		return ret;
 
-	if (!rdma_is_port_valid(ib_dev, port))
-		return -EINVAL;
-
 	pdata = &ib_dev->port_data[port];
 	spin_lock_irqsave(&pdata->netdev_lock, flags);
 	old_ndev = rcu_dereference_protected(
-- 
2.43.0



