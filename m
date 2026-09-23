Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481C7367B65;
	Wed, 23 Sep 2026 14:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172671; cv=none; b=b0w1jljvjnZt9ZuwzKbtQyoZniieOhWN777u627z2RPk7wHGQgD16zF755Ni/FFYwI2bfBZytRkwiTe4qQiY0MDKJOwk+VBAXeY1rVnLPfGL4pqN2w2Gzrj52pTrnA0B3dmbK6R3A/cGBpsQgOqYV0mE/voL0VBa1k4AnEYYYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172671; c=relaxed/simple;
	bh=SYtYOrqLJAIHZJCULKh7Kxv6WnoAJ8px4nthTeAzajY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLnnFF+DIAsUlsh1zzrc9H7g9a+2Ob9Dz3Q1z5JBUjvt9+Db+T7xEuPZX0VaaewXWRLYzHl2qsVO8XdHCgjQc6Rei4eqTJ80WJHKY8fxl7mtnVvcwPEXSPu0YXhEQ1JfnwZHrauaY4H5XRwkwq07jUgh2nWquzI8UxYXwbDb9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD5rq3U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD5rq3U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CD31F00898;
	Wed, 23 Sep 2026 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172669;
	bh=OOPwa+jEr3juuB1/jmw6FpvK57FX/naFo2HYP6bsTeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD5rq3U4YDRsIim120trg4FljZ5qzFovY6B4TI7NFIJyoj/LgmrHVgODzFR8HpisZ
	 NZR02G5G56rif4ruFxkiA7VBypnZXIZjo+P1P1baJbRSaTpI4kC2Jfe0dpgBpzzZI4
	 XCZ0PaA5iCUcv9VMZUtfKAuy29VrVcQUD/66+nuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 027/438] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
Date: Wed, 23 Sep 2026 16:00:48 +0200
Message-ID: <20260923140645.484333791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f8b219bd308bd..5447d39fa89dd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2056,11 +2056,13 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
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
@@ -2069,6 +2071,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 			pr_warn("%s speed is unknown, defaulting to %u\n",
 				netdev->name, netdev_speed);
 	}
+	dev_put(netdev);
+	rtnl_unlock();
 
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
 			       speed, width);
-- 
2.53.0



