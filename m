Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607511A6166;
	Tue, 30 Jul 2024 16:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357981; cv=none; b=X64r4mQ3ORXejv6F8/i658zq/MRS6ZXh2rzZLI4scdLICmcUXcAdbDAMRtGJrklMFb/PxQKP909XX2Gt4XfGmbpRs2plGHN1GETI1WeggqAC8ebpgi2doFju9gOXEYSRweF3f9ZwXy3l2IVvDD5ShI2u+kuwua18ZGTDizjmGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357981; c=relaxed/simple;
	bh=6ii5d7VjRUlPKuZuAnDW1j3mhXCsuW7qASFE7/7k+6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sljl9K0Egqs4fLYIQs8FvnfaFupS95e88IgLAR5hnm4dJv3s82YVBDPVfJOFufPz4ChUnHWr9VrbW5cLyuTXaVPTOBZh4yQymFEaYSHhyhYsgs0fIopdWTzckZasUDrP/YbOPs1lju+A/E6inAQPPRw1Aq1xLkD82kxY+8rJG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpqrkkWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpqrkkWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC3BC32782;
	Tue, 30 Jul 2024 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357981;
	bh=6ii5d7VjRUlPKuZuAnDW1j3mhXCsuW7qASFE7/7k+6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpqrkkWgRErAdbWq6iCD9qjhd/FmYL1UXurwD2s1J8OxkkvyJMyoWyti2DLhOAK2R
	 0qRXvtIu27/hgzqdGbbbDccwb0a7gk8+1+8uSLX8EinNxFJFKJJTS1jf6cK6VqTIZB
	 j1EB+fsR2FSmMg4y+WCHIPLPmtsnOpA6rYQfBPlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/568] RDMA: Fix netdev tracker in ib_device_set_netdev
Date: Tue, 30 Jul 2024 17:46:54 +0200
Message-ID: <20240730151651.874034509@linuxfoundation.org>
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
index e70804d8de828..56dd030045a20 100644
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



