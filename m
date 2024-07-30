Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABEA183CD5;
	Tue, 30 Jul 2024 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357697; cv=none; b=fADdewWvUifstkmm4vn2IxjUVX2gSSPPp5V1tBwVIoXGWTOEUmPegSb5zAUtwZx1DvLGK9qQqE1Lz7ECsfg+RAgJUjUKPPdW8/BN10Y8TAgc7nTDJWHmoNMWEifj+QcDFm29ZvDyfjn+Z42FFh9E1hf7Hyd0Tp/0ZZ3h0mvAzoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357697; c=relaxed/simple;
	bh=SGfLjqopNp6PSQXV2MbYGBis9U+FB7ihUw9a1otlYZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUseEaP/TTJTF5JVHhluAvJq+2fnQteoUmsYpj5i8eoMKuixUUSbpkfGXQXI2H/AnBqdk08RaCFLsvRKHfHeJFgibRqO5tVJFTu2FXBr8g6Xn3OFydOxQ2jMeyMj3GYiwgjNcPzLlqiSIbY6m4ZdCbxp1ZToZ2FJ+oQZAO0oXIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcRWdHDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcRWdHDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C5CC4AF0A;
	Tue, 30 Jul 2024 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357697;
	bh=SGfLjqopNp6PSQXV2MbYGBis9U+FB7ihUw9a1otlYZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcRWdHDEKYRr+Y6TmwQcEBh2Q1rSiQW0cgEhv2qdpX4gvbgONrzMcqZxkQDs5ZpDK
	 /R31lNsgSRSMkVen/Wl1gnCxSdqLfB+yQmbBpJaCwpO0Pb048hiipbtRK3zivhCetk
	 lW47FOZFdgNlPz2djkIVNdR3rnJLv6qdudIgrNJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/568] RDMA/device: Return error earlier if port in not valid
Date: Tue, 30 Jul 2024 17:46:29 +0200
Message-ID: <20240730151650.897335005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index db0a58c82838d..d1b5908c70cdc 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2146,6 +2146,9 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 	unsigned long flags;
 	int ret;
 
+	if (!rdma_is_port_valid(ib_dev, port))
+		return -EINVAL;
+
 	/*
 	 * Drivers wish to call this before ib_register_driver, so we have to
 	 * setup the port data early.
@@ -2154,9 +2157,6 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
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



