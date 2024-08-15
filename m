Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B41B0117;
	Thu, 15 Aug 2024 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731262; cv=none; b=pL2RrpA/IPcKrdIKYg81wVLoJrz3Lz2iY7HsWkXqlpWeWtU+bpQTfbUKEfYawUZbjSFQD/mN+ahmPMAuFueE7y8ySoC+qxBBb3GdFblvCev1nrWQh304ERyu1x7XaGOQCMeg1BCY4nHA2NwmNH7tjyULwWAFMoI06cp8We6wGys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731262; c=relaxed/simple;
	bh=gYrMKAo0Li5Lz/2XCOQU6mBYDlIx7WdjfTl5uV8Fdq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHG8TXKgnDmRsOO/lC8V3awTI2ZfXr2QqHxaV37rN0t25R8YHthrl96K68HocdqF9jYoT+k09gV53xlH4Xv6iZrHsTts1wskHg22bjfrQr+ul68/pLo2vev7YxNjqCCH4ieeEhtOlc/Wcfttn/4lhfqQljlLlQqGTrotvnh6kP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecG8LeT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecG8LeT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDDEC32786;
	Thu, 15 Aug 2024 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731262;
	bh=gYrMKAo0Li5Lz/2XCOQU6mBYDlIx7WdjfTl5uV8Fdq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecG8LeT8zAfa5ZPPof0oMS6x7RlSE5ImJOhaf46Umv13U8jbkTAZTebl645SPyvhR
	 0Ze09da6kQDAcHparCDFRUVmfvnqaf67ZbISy1pXKHBBf9iIb/q5vQflXrlsqzFUY6
	 8hH4o3UHFzz8ROuuGFy1+W50WNRAZrqQGpAr3fds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/259] RDMA/device: Return error earlier if port in not valid
Date: Thu, 15 Aug 2024 15:23:27 +0200
Message-ID: <20240815131905.660829708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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
index c7c3b9bae938c..c46d68e6ccd0e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2125,6 +2125,9 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	unsigned long flags;
 	int ret;
 
+	if (!rdma_is_port_valid(ib_dev, port))
+		return -EINVAL;
+
 	/*
 	 * Drivers wish to call this before ib_register_driver, so we have to
 	 * setup the port data early.
@@ -2133,9 +2136,6 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
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



