Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDB8530E18;
	Thu, 17 Sep 2026 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659961; cv=none; b=FJRJW3UbCQ+5yny8pYq2nB9LLeCoCooXqGbHCNSRb/+O7c7DnmNXamRX1MZx8yhGneizkdu4+QKr0VQwrykmxfKXja3ww0cyAEO9kyFKz53KwKZVU/jKtTy95rv3ZAmGo64o9Ps2C6DZ1Z1g5IW3N47pkBriKBdw8yGKQ1lT/Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659961; c=relaxed/simple;
	bh=qI3Z/oz2EUWHAu5nw0oWr9p8htYsKBKLyNFF/4pUBJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdQULBgbQplMBgrpcCtf3dAVqM+zP9DF3mHLtWhCmwh/T/qS3PCsnu+2zeebJZhtv3eO/sLWsgNi658BI09z2xviGmX8xmi3OLGUM5TdkvVhoC+w6mQAY6JZp1PZdK1jPE0kNna6yOCA5ar0G5FrKM3WnXbcPi+JPaHLp5IaqMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7V4+QGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7V4+QGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108011F00893;
	Thu, 17 Sep 2026 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659955;
	bh=nhh9YMDmpG7H4PPxA5Su0vyeLsFFvhumpJkKccnYZdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7V4+QGtxr24y5QyLbdZVnA8823muzIYFLsZnejML64fXkTJeT+T7w4xs7OK5WNwq
	 iIjpz0EESPVOKYdpoqgT3DbwC50jwq7mOBOXDwmqFtM9dzKFg4EkG0UHvxNQPkYk5Y
	 VjdzXnFjCcVDJgS40UTeXRP9fczCvGmnN555nCxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faicker Mo <faicker.mo@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 430/733] net: net_failover: Fix the deadlock in net_failover_slave_name_change()
Date: Thu, 17 Sep 2026 16:12:18 +0100
Message-ID: <20260917151402.548922341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Faicker Mo <faicker.mo@gmail.com>

[ Upstream commit 985a663bf00799c1daf1c5789efa6406958780c8 ]

This is a sibling fix of commit
b84c5632c7b3 ("net: net_failover: Fix the deadlock in slave register").
There is netdev_lock_ops() in the upper callers, so using netif_open()
instead of dev_open().

Call Trace:
 __schedule+0x2bb/0x650
 schedule+0x27/0xb0
 schedule_preempt_disabled+0x15/0x30
 __mutex_lock.constprop.0+0x550/0xaf0
 __mutex_lock_slowpath+0x13/0x20
 mutex_lock+0x3b/0x50
 dev_open+0x3b/0xe0
 net_failover_slave_name_change+0x22/0x40
 failover_event+0xd4/0x1e0
 notifier_call_chain+0x62/0xf0
 raw_notifier_call_chain+0x16/0x30
 call_netdevice_notifiers_info+0x50/0x80
 netif_change_name+0x200/0x330
 do_setlink.isra.0+0xb12/0xdf0
 ? security_capable+0x9a/0x1e0
 ? ns_capable+0x31/0x60
 rtnl_setlink+0x302/0x670
 ? netlink_recvmsg+0x296/0x340
 ? security_capable+0x9a/0x1e0
 ? __pfx_rtnl_setlink+0x10/0x10
 rtnetlink_rcv_msg+0x384/0x460
 ? __pfx_rtnetlink_rcv_msg+0x10/0x10
 netlink_rcv_skb+0x61/0x120
 rtnetlink_rcv+0x15/0x30
 netlink_unicast+0x28f/0x3c0
 netlink_sendmsg+0x216/0x450
 __sys_sendto+0x222/0x230
 __x64_sys_sendto+0x24/0x40
 x64_sys_call+0x1d5d/0x2390
 do_syscall_64+0x105/0x5a0
 ? do_syscall_64+0x140/0x5a0
 ? exc_page_fault+0x94/0x1e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Signed-off-by: Faicker Mo <faicker.mo@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260908040708.3972058-1-faicker.mo@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/net_failover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 3f7d31033bae8..1b5213e870703 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -675,7 +675,7 @@ static int net_failover_slave_name_change(struct net_device *slave_dev,
 	/* We need to bring up the slave after the rename by udev in case
 	 * open failed with EBUSY when it was registered.
 	 */
-	dev_open(slave_dev, NULL);
+	netif_open(slave_dev, NULL);
 
 	return 0;
 }
-- 
2.53.0



