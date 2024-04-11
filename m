Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EA6BB29;
	Thu, 11 Apr 2024 10:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832566; cv=none; b=vCh/O4evUv3jg+l115BJzXfxdy7aF8h+VVQ9WDawjiRyaO7EuQiux2n5mnS0uKTtFbTRaKMKM5WKHGmTQNyugcieLAgKTiS051hLTS+Ii3mFfOIyt7h4P9QUQwJYuY/0CKyO7gcwwSQJsMerV7ZLO39WtHpzReq9+HAKHBbCjKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832566; c=relaxed/simple;
	bh=xmCJSSU+klBcdiA5HBLEgf1IAY3ld/N77LLOLtMyoco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZbt1tTNwRI3MQXb2SQGr+CLhpP6ZjyHoKKaKe6JpnB5tVxpi7gLlMzHmK6PGoPX5jF8/310uDXs8KCWBO4wsYWViyFy7fLTaXmVKPs/xbrmNRntICgZbQR3C81P55voYmCG0+NRxu/ty0wPVCGQV/fZw+ONuysNvmK2Tl9fcbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Inlkrm4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Inlkrm4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A4AC433C7;
	Thu, 11 Apr 2024 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832566;
	bh=xmCJSSU+klBcdiA5HBLEgf1IAY3ld/N77LLOLtMyoco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inlkrm4MBa02kvQf7z4UM1rZN+hHVGNZeZsEyAgsUn+kNl/RyySVhHaENCLbIvpTY
	 Xq7jdUqfoMloDsTm1lzLDRhMNnQhScBGkpY8T1oV4AamXvP0eo3+xsCCC+HRTCzsA/
	 0ghLMgePrQDcJCPy/M8OxJGMQ9EjTFQ+uCTIwd5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Richter <rafael.richter@gin.de>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	xu.xin16@zte.com.cn,
	Vladimir Oltean <olteanv@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 01/57] net: dsa: fix panic when DSA master device unbinds on shutdown
Date: Thu, 11 Apr 2024 11:57:09 +0200
Message-ID: <20240411095408.029941837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit ee534378f00561207656663d93907583958339ae upstream.

Rafael reports that on a system with LX2160A and Marvell DSA switches,
if a reboot occurs while the DSA master (dpaa2-eth) is up, the following
panic can be seen:

systemd-shutdown[1]: Rebooting.
Unable to handle kernel paging request at virtual address 00a0000800000041
[00a0000800000041] address between user and kernel address ranges
Internal error: Oops: 96000004 [#1] PREEMPT SMP
CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00042-g8f5585009b24 #32
pc : dsa_slave_netdevice_event+0x130/0x3e4
lr : raw_notifier_call_chain+0x50/0x6c
Call trace:
 dsa_slave_netdevice_event+0x130/0x3e4
 raw_notifier_call_chain+0x50/0x6c
 call_netdevice_notifiers_info+0x54/0xa0
 __dev_close_many+0x50/0x130
 dev_close_many+0x84/0x120
 unregister_netdevice_many+0x130/0x710
 unregister_netdevice_queue+0x8c/0xd0
 unregister_netdev+0x20/0x30
 dpaa2_eth_remove+0x68/0x190
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x94/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_device_remove+0x24/0x40
 __fsl_mc_device_remove+0xc/0x20
 device_for_each_child+0x58/0xa0
 dprc_remove+0x90/0xb0
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_bus_remove+0x80/0x100
 fsl_mc_bus_shutdown+0xc/0x1c
 platform_shutdown+0x20/0x30
 device_shutdown+0x154/0x330
 __do_sys_reboot+0x1cc/0x250
 __arm64_sys_reboot+0x20/0x30
 invoke_syscall.constprop.0+0x4c/0xe0
 do_el0_svc+0x4c/0x150
 el0_svc+0x24/0xb0
 el0t_64_sync_handler+0xa8/0xb0
 el0t_64_sync+0x178/0x17c

It can be seen from the stack trace that the problem is that the
deregistration of the master causes a dev_close(), which gets notified
as NETDEV_GOING_DOWN to dsa_slave_netdevice_event().
But dsa_switch_shutdown() has already run, and this has unregistered the
DSA slave interfaces, and yet, the NETDEV_GOING_DOWN handler attempts to
call dev_close_many() on those slave interfaces, leading to the problem.

The previous attempt to avoid the NETDEV_GOING_DOWN on the master after
dsa_switch_shutdown() was called seems improper. Unregistering the slave
interfaces is unnecessary and unhelpful. Instead, after the slaves have
stopped being uppers of the DSA master, we can now reset to NULL the
master->dsa_ptr pointer, which will make DSA start ignoring all future
notifier events on the master.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: xu.xin16@zte.com.cn
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1634,7 +1634,6 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch)
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *master, *slave_dev;
-	LIST_HEAD(unregister_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1655,25 +1654,13 @@ void dsa_switch_shutdown(struct dsa_swit
 		slave_dev = dp->slave;
 
 		netdev_upper_dev_unlink(master, slave_dev);
-		/* Just unlinking ourselves as uppers of the master is not
-		 * sufficient. When the master net device unregisters, that will
-		 * also call dev_close, which we will catch as NETDEV_GOING_DOWN
-		 * and trigger a dev_close on our own devices (dsa_slave_close).
-		 * In turn, that will call dev_mc_unsync on the master's net
-		 * device. If the master is also a DSA switch port, this will
-		 * trigger dsa_slave_set_rx_mode which will call dev_mc_sync on
-		 * its own master. Lockdep will complain about the fact that
-		 * all cascaded masters have the same dsa_master_addr_list_lock_key,
-		 * which it normally would not do if the cascaded masters would
-		 * be in a proper upper/lower relationship, which we've just
-		 * destroyed.
-		 * To suppress the lockdep warnings, let's actually unregister
-		 * the DSA slave interfaces too, to avoid the nonsensical
-		 * multicast address list synchronization on shutdown.
-		 */
-		unregister_netdevice_queue(slave_dev, &unregister_list);
 	}
-	unregister_netdevice_many(&unregister_list);
+
+	/* Disconnect from further netdevice notifiers on the master,
+	 * since netdev_uses_dsa() will now return false.
+	 */
+	dsa_switch_for_each_cpu_port(dp, ds)
+		dp->master->dsa_ptr = NULL;
 
 	rtnl_unlock();
 out:


