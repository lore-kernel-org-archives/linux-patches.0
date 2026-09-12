Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A33A5E88;
	Sat, 12 Sep 2026 20:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243432; cv=none; b=YQkC6BWCo1uZTzQ1AFywa/92ZsiKQNyS56FBWbtyDJYd7xFAnjLSE7zIE3HsrrqYZt0LxVR+hrHMusAA87HXcOi42XiVqAHWyfM7xf9NM4ug84NJCuZCnUo3O0oRLvkHxUOX33YD1cDAdE8UAFI0Wl4UOK00xy1TDLpKZ2BQUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243432; c=relaxed/simple;
	bh=l/NtQW6PhZgk1/6IjCPuQC4nKIbFvHS1tYeiNA/djTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlz0bAaCiQUMWvtwdMT6kmeKSxE7LgpYfz6ctIWX8dwbv2+gOW4KVaJAty6drww2qb9NV8tzNt0efo74sgr1i0F3x80a0H75PPtozYmxjvbSqRj0zZgr91XMLFMXJI2jmTgPvlMx84+dcuSCfV7HUWCEKzsAC0DsNZrW1LUs5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqLHroG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqLHroG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7103D1F000FF;
	Sat, 12 Sep 2026 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243430;
	bh=eUVMc1N1KIovjAQy3YUoMw/Ag+O6mMmhWAVzWp+odgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqLHroG2hUn35qSzuxpf2G+L/pD6IePt11X13sYJPBUihXfp7rzDJfGUjEVbGVwHK
	 l/bc2xxwSduJLHQ40Ve5i5dvv4/Pbpbr7LT3x5Sb3Ue/vhkgQdFAbo2YVnpzY++TEY
	 FXn5+CgFAgGpvOz0R5Zbb/tg2u4+7lT9/pxlDG8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+4638111fe2a12980@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 754/798] net: qualcomm: rmnet: restore skb->dev on deaggregated frames
Date: Sat, 12 Sep 2026 09:06:22 +0200
Message-ID: <20260912065534.349172818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit a66734a1c5e36525ea07e9f4547fddc51e916de3 ]

rmnet_map_deaggregate() allocates each sub-frame with alloc_skb() and
leaves skb->dev NULL. __rmnet_map_ingress_handler() assigns
skb->dev = ep->egress_dev only on the data path, but a MAP command frame
is dispatched to rmnet_map_command() before that, so rmnet_map_send_ack()
runs netif_tx_lock(skb->dev) on a NULL device. An unprivileged user
reaches this by unsharing a user+net namespace, creating an rmnet link
over a tap device with INGRESS_DEAGGREGATION and INGRESS_MAP_COMMANDS,
and writing an aggregated frame carrying a flow-control command to the
tap fd.

Restore the assignment dropped by 378e25357ac7, so every skb leaving
rmnet_map_deaggregate() has a valid device.

  BUG: KASAN: null-ptr-deref in _raw_spin_lock (kernel/locking/spinlock.c:158)
  Write of size 4 at addr 00000000000004b4 by task exploit/144
  Call Trace:
   _raw_spin_lock (kernel/locking/spinlock.c:158)
   netif_tx_lock (net/sched/sch_generic.c:497)
   rmnet_map_command (drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:67)
   rmnet_rx_handler (drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:125)
   __netif_receive_skb_core.constprop.0 (net/core/dev.c:6103)
   ...
   __netif_receive_skb_one_core (net/core/dev.c:6214)
   netif_receive_skb (net/core/dev.c:6474)
   tun_get_user (drivers/net/tun.c:1966)
   tun_chr_write_iter (drivers/net/tun.c:2012)
   vfs_write (fs/read_write.c:687)
   ksys_write (fs/read_write.c:739)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 378e25357ac7 ("net: qualcomm: rmnet: Remove unnecessary device assignment")
Reported-by: co+4638111fe2a12980@bugs.sh
Closes: https://lore.kernel.org/netdev/ijg79FFMfIvKJbivdJEKvTO90Q9dTvyBkJck@bugs.sh/T/#u
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820195240.1631458-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index a655bb8d5c57b..fcda268cf3fe3 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -354,6 +354,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (!skbn)
 		return NULL;
 
+	skbn->dev = skb->dev;
 	skb_reserve(skbn, RMNET_MAP_DEAGGR_HEADROOM);
 	skb_put(skbn, packet_len);
 	memcpy(skbn->data, skb->data, packet_len);
-- 
2.53.0



