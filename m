Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5809118E04F;
	Tue, 30 Jul 2024 17:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359339; cv=none; b=YSzETivkmgR3UNhNfMVbpxhcs43I6o5g6bUpNnYweoPwdFECJyNj0HQ/284eAg5c3X1MdieA3FLMpanK66FEPugNoCW0c5lOH0IMOKKJaXwFJJjS7DGCHHyT5+TOqm+OEypGuIgYT9D/vd/1L6iTL0qkv6JE671/w2JvYuiq+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359339; c=relaxed/simple;
	bh=3FwC84y5n2gSwgfu69PkjsE7MUcYAr0YWjOVx7LZBpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMXnqNXT4cIFlsKSwGuUjp6jX0rlngOSoLtS6X5lNvADKRV7h3/NKJtJyS5vFXAorPz+pQZTWHV6VtK6/i4v2ORHzHtHiIazCZNm++7YAA8LtO6SyKlw5eeH9n4SllbOvgsJynC0jVIUePIGwhQ+8As5CJSJI96YB6MzGF0tFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X92S3iMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X92S3iMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA8CC32782;
	Tue, 30 Jul 2024 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359338;
	bh=3FwC84y5n2gSwgfu69PkjsE7MUcYAr0YWjOVx7LZBpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X92S3iMDCiQmNeeWTFCvjcIMvgtd6Eatt55DChQH77z5b2WrWRqjNRjS3emedFIPY
	 3kSJ4tQJAjCzd4aMYpk5LCKGroQ59nhm5xILKTRGBAzuipz0WfwDmE4ULN3T17D+Aa
	 4Uy77HPFFrD3/5QKNsIdikbyX4iU2ISAYosSfCZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 470/809] RDMA: Fix netdev tracker in ib_device_set_netdev
Date: Tue, 30 Jul 2024 17:45:46 +0200
Message-ID: <20240730151743.300162249@linuxfoundation.org>
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

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2043a14fb3de9d88440b21590f714306fcbbd55f ]

If a netdev has already been assigned, ib_device_set_netdev needs to
release the reference on the older netdev but it is mistakenly being
called for the new netdev. Fix it and in the process use netdev_put
to be symmetrical with the netdev_hold.

Fixes: 09f530f0c6d6 ("RDMA: Add netdevice_tracker to ib_device_set_netdev()")
Signed-off-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240710203310.19317-1-dsahern@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e0cff28bb0ef1..46d1c2c32d719 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2166,16 +2166,12 @@ int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 		return 0;
 	}
 
-	if (old_ndev)
-		netdev_tracker_free(ndev, &pdata->netdev_tracker);
-	if (ndev)
-		netdev_hold(ndev, &pdata->netdev_tracker, GFP_ATOMIC);
 	rcu_assign_pointer(pdata->netdev, ndev);
+	netdev_put(old_ndev, &pdata->netdev_tracker);
+	netdev_hold(ndev, &pdata->netdev_tracker, GFP_ATOMIC);
 	spin_unlock_irqrestore(&pdata->netdev_lock, flags);
 
 	add_ndev_hash(pdata);
-	__dev_put(old_ndev);
-
 	return 0;
 }
 EXPORT_SYMBOL(ib_device_set_netdev);
-- 
2.43.0



