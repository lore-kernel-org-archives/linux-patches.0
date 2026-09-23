Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8A531AF3;
	Wed, 23 Sep 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174171; cv=none; b=Fj5JpdS1DGOgKHPz3TVhF0PYQOf4D2IzvEgiVDryuKnl1TgxffWt7Ym8ubRl6kTa5IrRluUEbqD07UTdYi8N05T9OWrV/OgoSoo7tJ1Yv5YE10+0tf3Mep4z/HkQACuRjz59BPMY09+fkBLBushZMlrstxdwZuVJtuc4UYHZwTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174171; c=relaxed/simple;
	bh=l7comICOUgmJ78UhUSkYuG7JlBetfIqoQeTkJ/W5bgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnDjeEcKC+YAa1XxhCzKvqh3O0ghDUjO+Fpbv854GD3ktJWpPfV8D2QrLF9lOMQG91Ogt/OWdvRLX3FZZ2CpUNeYI5rHea/4edaDerBQxDqaMyE0eAvUQ399H7hsqh39JwI6AuBQhZgTOOOxzcCPin/PkcM3QDJk81sKb7MxFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ec5bfQIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ec5bfQIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E1A1F000FF;
	Wed, 23 Sep 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174169;
	bh=9xbs3iwSU083a6FgXp7/9LNLHa7+jJ64hjNoJeluQCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ec5bfQIafHKygJOv6CtJNNIIRzRfFkI6SokFcGC7imdxJmJa/PmKF6FNpDIuLkuzD
	 sFmERXSDFQFSMIlsLTpeqcpO3Ubcx03GO5r5tlV9zJq4mEpK0S3OMzmGUbVb+MlBWh
	 3SH1NFpA9C+cZ14bAEeo/vb5bAXuWs8NRuebn39s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/398] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
Date: Wed, 23 Sep 2026 16:01:46 +0200
Message-ID: <20260923140644.260738426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

[ Upstream commit ef9fbe1b93f3b617b96e86d5cd76b3fa44514cb5 ]

ib_device_get_netdev() intentionally returns a referenced net_device even
when it is unregistering, so matching and cleanup callers can still find
the association. The reference keeps struct net_device allocated, but does
not guarantee that the device remains operational.

ib_get_eth_speed() uses the returned device operationally by invoking its
ethtool callback. Although that call is made under RTNL, the function does
not verify the registration state first. An asynchronous RDMA port query
can therefore call into a netdev after NETDEV_UNREGISTER and ndo_uninit
have completed.

Check for NETREG_REGISTERED while holding RTNL and return -ENODEV for a
device which is being unregistered. Keeping RTNL across the check and the
ethtool operation prevents unregister from starting between them.

Keep the speed fallback and warning under RTNL as well, so the warning can
safely read netdev->name. Drop the netdev reference before releasing RTNL
once all accesses to the device are complete.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Link: https://patch.msgid.link/20260812081708.32468-1-krystianmkaniewski@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4357164a9976c..fcc21fb5fb86c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2051,11 +2051,13 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 		return -ENODEV;
 
 	rtnl_lock();
-	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
-	rtnl_unlock();
-
-	dev_put(netdev);
+	if (READ_ONCE(netdev->reg_state) != NETREG_REGISTERED) {
+		dev_put(netdev);
+		rtnl_unlock();
+		return -ENODEV;
+	}
 
+	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
 	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
@@ -2064,6 +2066,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 			pr_warn("%s speed is unknown, defaulting to %u\n",
 				netdev->name, netdev_speed);
 	}
+	dev_put(netdev);
+	rtnl_unlock();
 
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
 			       speed, width);
-- 
2.53.0



