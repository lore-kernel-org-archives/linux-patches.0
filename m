Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A5F154BE0;
	Mon, 10 Mar 2025 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628795; cv=none; b=G+YZ688ehHJJi46A8IE1hkG3e/IpvjdI0tgO0eFMH8VASMGUWb6leGMCjLIuucN8OEjGwuYy/Eo7UPU4ZMsKmRPOb9yDVR73nCuzC8ofsgBB6QAtyRKinrS6ye0lxIsBr3uboJqfPsOD8hCGpzrTg/E2FmNaiF9o5djN1pKhdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628795; c=relaxed/simple;
	bh=nK0cQoYW+YRt7vWe9FMQ7MQAdFXlmH/Zk8dmvV4jCe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgKtkK7DYUrfYYmkKJkx7lWNGPxmsv8mbHjn+Fcq2A92jP5w2wGUG2v2SrUtZGVTaLKixPcr4HHjvDDSLNuZtFfdniXL/n3Oz54LngIOqX5BhAhjp1yx85cyH/eKn80NWfuPIFrXg3mWuNXsGfj5oLH56UHmvjEQa6UmZrdsBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMB6OU4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMB6OU4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D1CC4CEE5;
	Mon, 10 Mar 2025 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628795;
	bh=nK0cQoYW+YRt7vWe9FMQ7MQAdFXlmH/Zk8dmvV4jCe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMB6OU4RlN7vlNnJwGAQClUp8029+F6fyqaPOuCiF2gzaWr14crpsMiXNAVqEcBJw
	 fQdhZGqtJ4SQ1kBZWHAZlTSYMkKrCgHGacfj1QzZGoskkgZfZqxtv6KyeAsEse+2V3
	 qPAxv3kyU0WYDZwrCiKTch+QBxXDN4kO05iPOqfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/620] net: avoid race between device unregistration and ethnl ops
Date: Mon, 10 Mar 2025 17:58:37 +0100
Message-ID: <20250310170548.382514873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 12e070eb6964b341b41677fd260af5a305316a1f ]

The following trace can be seen if a device is being unregistered while
its number of channels are being modified.

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: CPU: 3 PID: 3754 at kernel/locking/mutex.c:564 __mutex_lock+0xc8a/0x1120
  CPU: 3 UID: 0 PID: 3754 Comm: ethtool Not tainted 6.13.0-rc6+ #771
  RIP: 0010:__mutex_lock+0xc8a/0x1120
  Call Trace:
   <TASK>
   ethtool_check_max_channel+0x1ea/0x880
   ethnl_set_channels+0x3c3/0xb10
   ethnl_default_set_doit+0x306/0x650
   genl_family_rcv_msg_doit+0x1e3/0x2c0
   genl_rcv_msg+0x432/0x6f0
   netlink_rcv_skb+0x13d/0x3b0
   genl_rcv+0x28/0x40
   netlink_unicast+0x42e/0x720
   netlink_sendmsg+0x765/0xc20
   __sys_sendto+0x3ac/0x420
   __x64_sys_sendto+0xe0/0x1c0
   do_syscall_64+0x95/0x180
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

This is because unregister_netdevice_many_notify might run before the
rtnl lock section of ethnl operations, eg. set_channels in the above
example. In this example the rss lock would be destroyed by the device
unregistration path before being used again, but in general running
ethnl operations while dismantle has started is not a good idea.

Fix this by denying any operation on devices being unregistered. A check
was already there in ethnl_ops_begin, but not wide enough.

Note that the same issue cannot be seen on the ioctl version
(__dev_ethtool) because the device reference is retrieved from within
the rtnl lock section there. Once dismantle started, the net device is
unlisted and no reference will be found.

Fixes: dde91ccfa25f ("ethtool: do not perform operations on net devices being unregistered")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20250116092159.50890-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index b3729bdafb602..0ffcd0e873b60 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -41,7 +41,7 @@ int ethnl_ops_begin(struct net_device *dev)
 		pm_runtime_get_sync(dev->dev.parent);
 
 	if (!netif_device_present(dev) ||
-	    dev->reg_state == NETREG_UNREGISTERING) {
+	    dev->reg_state >= NETREG_UNREGISTERING) {
 		ret = -ENODEV;
 		goto err;
 	}
-- 
2.39.5



