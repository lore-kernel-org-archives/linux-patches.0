Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722E81A616B;
	Tue, 30 Jul 2024 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356547; cv=none; b=imkPcgVHIx0iMNJ9xrjBspn/feVvPM4JAqiaJqpDmwLhc9s5Wev8XVbEKjd/QRZNXlXK2jCyaMhL7NTAqcseXhh/Rk27oSib1U1CpA7U1s3M+TZxqPl8UJGv9IK8OD2IcfWg4jbY+jJaMprnqqLptfBFfKspWlQk7gE4Djguz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356547; c=relaxed/simple;
	bh=CPnnry+PswEsrwadX4iRz20QvZKXLtQFw3srJymms8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIXY+AjHmfC6Vy13j4dtBxtjX5RjTjG/mdcSHjSfTdHMrHk1heEebcy7PS0kiKDXc6+yhzytkHMPVa5Jia96yUZMLkLxd56fnGAQ+0hB1e55eTinj7T7Xy4TxtAhGaF2orPPZl3zHtwJi3XzLKrYb6FyBiS7JG+wrsA7Oj8F1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JX+z1RKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JX+z1RKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0916C32782;
	Tue, 30 Jul 2024 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356547;
	bh=CPnnry+PswEsrwadX4iRz20QvZKXLtQFw3srJymms8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX+z1RKWQ3sYKHv9C0KMaxLCHIaM4bPuUg7QCITVeVDw99Kac50VHZor2wyyzF09J
	 /GjnDh+OaMAG5dl+rXGiOAYzqi6Xndb1SsGFLqzKA506WHlqgs947TYA/0WGbUDlbi
	 uGDkwBKD5tfin1zxyllqYTG8gstm4puQDSW0DfII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/440] RDMA/device: Return error earlier if port in not valid
Date: Tue, 30 Jul 2024 17:47:19 +0200
Message-ID: <20240730151623.915675711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 453188db39d83..291ded20934c8 100644
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



