Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD036D9F5;
	Sat, 12 Sep 2026 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240514; cv=none; b=UWiqwUIc73a96fgz7sh9f9Kiya3rmFWlCeFViKHtRvqTim+8Bs0LraunWC58ysCyymkLxK/12GCOv9rePkt/Aeee9zZqWNi+vwF5TtMhUpf+Be5bIlaE14IbwOfZP8l0XzVRjVtwKJm+AknN5E73WpTOM9hWfX5bMj0tBWE7jBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240514; c=relaxed/simple;
	bh=pF15xKXJdbooRoG0NtUc1LlCpNEH+mD6vEjeTJ5CK5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExvSMLnI8irU4S/RxAczxXmjkb494nFgUOrMxEnrU+mK6mIlkeycdl/7Z7rH4AHPwe6oM6Aa8NY4rSU6KLeyjv1Bf9ePwIHS6BLzhtwNpFYPOfjk3nOCS4IUNUjBnfFvbGMBM+1pokKppBQZESEl1lXLQVhMh4cyszmJWn/GEK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIKlBUXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIKlBUXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC8C1F000FF;
	Sat, 12 Sep 2026 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240513;
	bh=bLiNR6uI1rIg15UnvLp6IJuPhpQ45f70raRDymj4ykg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIKlBUXmkVfsxrN3JS8WxLbyVXyl0kfLxH3NEa1AOUKns0D37SCQZA4WFKjFGR2Uq
	 7IkrTu3Nxz8SRejLimrCRSQqVpl3V8xLdo4GXMYJI8PD4XxDkjEVM+YxkIoFt/ioM/
	 8T6sThPdNJBeOL3ZbteYMtEYlH/VbuJeYekiwx4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+4638111fe2a12980@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 884/935] net: qualcomm: rmnet: restore skb->dev on deaggregated frames
Date: Sat, 12 Sep 2026 09:05:14 +0200
Message-ID: <20260912065547.089519972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 312acd8d97af1..cee7946bf0319 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -396,6 +396,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (!skbn)
 		return NULL;
 
+	skbn->dev = skb->dev;
 	skb_reserve(skbn, RMNET_MAP_DEAGGR_HEADROOM);
 	skb_put(skbn, packet_len);
 	memcpy(skbn->data, skb->data, packet_len);
-- 
2.53.0



