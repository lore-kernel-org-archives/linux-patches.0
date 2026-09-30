Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861750E5B0;
	Wed, 30 Sep 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785712; cv=none; b=C7ukt4Q216Klz7LXznS8kAebfILTPoSQNAG2xzyib74L66o4VR7iWZ8ox8yk0O5ujlFJyS69N9fxeim20QD9sikEJtPGcnozuBnDvRdNYqjUlhM23hhAQ54TxImwe4bxM95ZG6LdNAYYPGXVTuXyytJ4HQybGqCO2q9oa8PMvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785712; c=relaxed/simple;
	bh=4Ip2d4iC/bkWeqeX6xNwiYC5c/bt2r4eyyqbVIJvJ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b038hd+VUgGMTWDjVxeN5BCm5BUrjOe0AzrzZOC4VicHUEiBhhn04D9HDSzzI8cJx33g3dAKZd4y7bw+A/WgI5vsILsfRTSSG0w+ENlaLwyE1cMS1bq7qfaud0WF5XLDSuQJNTg3lAaY39igWOdyZGnCfCYxE46gGKx/MaZj8K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3OFkT+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3OFkT+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438251F00893;
	Wed, 30 Sep 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785707;
	bh=dhauMKZ+c5il+SWLogRG1mbRfL4eCUoKf105w1X5xQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3OFkT+5W68Dy6EjC50mllS4mJ0sKteCTh0fdP/Pp3WIUw4BmN+iaubJiv5zpPCBs
	 wxbqfyqiaT49243focUYdljGCckexIGKXhBYuE6ef2V5h6dAfRaSvPtqJPvNz+dMcj
	 sbvw8jR/tgj2Eee3PMiWa1NEEvQnkvW/mGV/Ui+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 605/982] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
Date: Wed, 30 Sep 2026 17:22:21 +0200
Message-ID: <20260930152429.774479766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 06e11b50336b2..66abeaaaa5aa5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1902,11 +1902,13 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
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
@@ -1914,6 +1916,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 		pr_warn("%s speed is unknown, defaulting to %u\n", netdev->name,
 			netdev_speed);
 	}
+	dev_put(netdev);
+	rtnl_unlock();
 
 	if (netdev_speed <= SPEED_1000) {
 		*width = IB_WIDTH_1X;
-- 
2.53.0



