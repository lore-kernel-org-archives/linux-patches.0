Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4929B77C;
	Thu, 25 Jun 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393019; cv=none; b=UbWv44KkAjd+7VgM8HJPHIO1Orlu6i7k0NYgpJf3cjuQ8xZmLfD2HSipWSFa9cA7mDrhhyGLtAowOYIASGyGnGdaYO/8RqHUbQncdoUDXac/OZpQyzudUINhRORZM8VH5iUuKSdn/1A1JLJlVVBGqjcXO5Ca4iSpdGmi0FIoay8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393019; c=relaxed/simple;
	bh=aYqbxT6aME9wiI2vSftUKJfDVa85+9Kcctyk/k9Csiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWLBV6JDiILhXkH5tvF/zMDmh/8fWIx7h86yAe4YX8nviNuxLrT2wrbOBbnRaYz3tEW35bCUmZFrBKHLQTvrumpV+seRB577IPMY0T3khJcgkckDezv2kloCLjxkbvN4W5975XsqnT2xsKldFcbiIxMHo46c+4+5WVmq+Spq1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERuWGl2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERuWGl2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F41F000E9;
	Thu, 25 Jun 2026 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393018;
	bh=yn/Eq0/1g4sQ9KTg0teWbAGPmoF9cnzVHdM7rFea4BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERuWGl2Yt/u8ByxsCahplC1CJuRAg0Q7YPupNw0Gil8wPfbzwtcNDolUYVNEfwDPV
	 JmXt9JMUE41ASCBbBDvPD2JghPdDQ6iWiEVAqy92hB0hq802Pwd61tNAd/HXiFKy0l
	 Q0seccA95rgQM+QpdFfelJO3b5UTeDrYp3W+YPKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faicker Mo <faicker.mo@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 32/49] net: net_failover: Fix the deadlock in slave register
Date: Thu, 25 Jun 2026 14:03:44 +0100
Message-ID: <20260625125642.054179746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faicker Mo <faicker.mo@gmail.com>

commit b84c5632c7b31f8910167075a8128cfb9e50fcfe upstream.

There is netdev_lock_ops() before the NETDEV_REGISTER notifier
in register_netdevice(), so use the non-locking functions
in net_failover_slave_register().
failover_slave_register() in failover_existing_slave_register() adds lock
and unlock ops too.

Call Trace:
 <TASK>
 __schedule+0x30d/0x7a0
 schedule+0x27/0x90
 schedule_preempt_disabled+0x15/0x30
 __mutex_lock.constprop.0+0x538/0x9e0
 __mutex_lock_slowpath+0x13/0x20
 mutex_lock+0x3b/0x50
 dev_set_mtu+0x40/0xe0
 net_failover_slave_register+0x24/0x280
 failover_slave_register+0x103/0x1b0
 failover_event+0x15e/0x210
 ? dropmon_net_event+0xac/0xe0
 notifier_call_chain+0x5e/0xe0
 raw_notifier_call_chain+0x16/0x30
 call_netdevice_notifiers_info+0x52/0xa0
 register_netdevice+0x5f4/0x7c0
 register_netdev+0x1e/0x40
 _mlx5e_probe+0xe2/0x370 [mlx5_core]
 mlx5e_probe+0x59/0x70 [mlx5_core]
 ? __pfx_mlx5e_probe+0x10/0x10 [mlx5_core]

Fixes: 4c975fd70002 ("net: hold instance lock during NETDEV_REGISTER/UP")
Signed-off-by: Faicker Mo <faicker.mo@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/net_failover.c |   12 ++++++------
 net/core/failover.c        |    6 +++++-
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -502,7 +502,7 @@ static int net_failover_slave_register(s
 
 	/* Align MTU of slave with failover dev */
 	orig_mtu = slave_dev->mtu;
-	err = dev_set_mtu(slave_dev, failover_dev->mtu);
+	err = netif_set_mtu(slave_dev, failover_dev->mtu);
 	if (err) {
 		netdev_err(failover_dev, "unable to change mtu of %s to %u register failed\n",
 			   slave_dev->name, failover_dev->mtu);
@@ -512,11 +512,11 @@ static int net_failover_slave_register(s
 	dev_hold(slave_dev);
 
 	if (netif_running(failover_dev)) {
-		err = dev_open(slave_dev, NULL);
+		err = netif_open(slave_dev, NULL);
 		if (err && (err != -EBUSY)) {
 			netdev_err(failover_dev, "Opening slave %s failed err:%d\n",
 				   slave_dev->name, err);
-			goto err_dev_open;
+			goto err_netif_open;
 		}
 	}
 
@@ -562,10 +562,10 @@ static int net_failover_slave_register(s
 err_vlan_add:
 	dev_uc_unsync(slave_dev, failover_dev);
 	dev_mc_unsync(slave_dev, failover_dev);
-	dev_close(slave_dev);
-err_dev_open:
+	netif_close(slave_dev);
+err_netif_open:
 	dev_put(slave_dev);
-	dev_set_mtu(slave_dev, orig_mtu);
+	netif_set_mtu(slave_dev, orig_mtu);
 done:
 	return err;
 }
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -12,6 +12,7 @@
 #include <uapi/linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
+#include <net/netdev_lock.h>
 #include <net/failover.h>
 
 static LIST_HEAD(failover_list);
@@ -221,8 +222,11 @@ failover_existing_slave_register(struct
 	for_each_netdev(net, dev) {
 		if (netif_is_failover(dev))
 			continue;
-		if (ether_addr_equal(failover_dev->perm_addr, dev->perm_addr))
+		if (ether_addr_equal(failover_dev->perm_addr, dev->perm_addr)) {
+			netdev_lock_ops(dev);
 			failover_slave_register(dev);
+			netdev_unlock_ops(dev);
+		}
 	}
 	rtnl_unlock();
 }


