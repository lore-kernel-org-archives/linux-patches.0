Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F463C;
	Thu, 15 Aug 2024 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732198; cv=none; b=FQ8tgrxLLQ3x3JQgzwY6J0O/OHzR/rXiLznJ7/K/1nNjQdZ+PeUg/gNsOZFXCYRDcDtBtGxd+R9XjZW2rSYiDMattnBOXA/xDsz8rXCJG7I1bo+ZTcZxI99MJAd0XkoQDJjMyGp/rpINod5soFQbLVc/lkhCfzbjq1c8T8/VlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732198; c=relaxed/simple;
	bh=zMrhvWwEsHr1y5gd230qhETHk6HYVFFubPM05omDSS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPsFjESlhUUfgnQ+0HIlPN5dYvm28A6PukoS1/ECI7X69Jr7WuETErH7f+FOmP9V4HBqyzARCosKnIw110DN0o7syQAwMgxndVvqbUBncNjXHG1UN3006rJk4QcxtF/xJaaiNIYDpiX0zF31i6mBlljAa2Hgr67bxmLpj1Ic0vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bsx5B21W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bsx5B21W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B32C32786;
	Thu, 15 Aug 2024 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732198;
	bh=zMrhvWwEsHr1y5gd230qhETHk6HYVFFubPM05omDSS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bsx5B21WPlCtzAqeFbsx8c+vOMDBySzV/MKA4ICnVmW0WeWK0IcQikSyHrFYLj5Kc
	 4+bfxV1WS3VBSVGLUyZs9eDXUXNXLVOZsl62vtDZpRtD2BCg+mg7PfnMSTU9hoeZ1A
	 LWxRwW6je6T13L+dyDmLGZlU0DeRJo+MHiohxiAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/352] RDMA/device: Return error earlier if port in not valid
Date: Thu, 15 Aug 2024 15:22:50 +0200
Message-ID: <20240815131923.278322987@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94c3bad72cc59..3848fe0449a4c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2106,6 +2106,9 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	unsigned long flags;
 	int ret;
 
+	if (!rdma_is_port_valid(ib_dev, port))
+		return -EINVAL;
+
 	/*
 	 * Drivers wish to call this before ib_register_driver, so we have to
 	 * setup the port data early.
@@ -2114,9 +2117,6 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
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



