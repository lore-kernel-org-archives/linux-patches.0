Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674F71E86F;
	Tue, 30 Jul 2024 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359108; cv=none; b=t+dTHKbs4FIhgrbtruy1nWZFTsqKd8FSapOx5mqoqeHIZqR6lswYLfaTB8Ri5kneDKEsY2OXIzcjt4ZZHlw3HdWdAHTdHDrKrfnXsNAssdlWH+RySO0b61BPrAsiTevfyFH0J1E3Pw2hTs1frbTYEMFw3v+PVCxIpr0nucOQyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359108; c=relaxed/simple;
	bh=U+Ek3Bcs76dEdLg3k6rJhVWDe/uRtpKgudrbqzN9RdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaRFt2pfWGLuLznOHynGEut5Vnx7l36YQyG6sifEeRWvF1XI82wYCWNBRhIL8iPCVouIf1WaHQJPrvLUUQDA/qTY7ZO6916T9/mRCeT4Zu/akAqjYGS8Um3sAzHZuBDNJY+yOq6uQmHBE0XU5nNIg/dv6/fUCCVGn5gdx/fO3OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A18vKCOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A18vKCOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39CAC32782;
	Tue, 30 Jul 2024 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359108;
	bh=U+Ek3Bcs76dEdLg3k6rJhVWDe/uRtpKgudrbqzN9RdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A18vKCOJAqFG5diaciFOA3MXNf5UKD0eTDKsuzK+tjnRtiNT27gXXZLwvbEHNQXkr
	 sOO8Eca5NjCriyfyAR9LfGg+Sheqe/9Ptf6/S0JYpLqfr3cpiR68t9ozQ0VBm6aTKW
	 hNPTd443wsmzqshwJ3qX9Op3cZy/O7yqXp/ERrnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 434/809] RDMA/device: Return error earlier if port in not valid
Date: Tue, 30 Jul 2024 17:45:10 +0200
Message-ID: <20240730151741.845372756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 55aa7aa32d4ab..e0cff28bb0ef1 100644
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



