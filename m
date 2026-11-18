Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061827;
	b=LJoLMEiayk/nOd5ZTumwvg8+/LYiu0FANDAcd6JXMiJOIj1Uzm0fhk4AYPibSIfBYUSJ
	 tjMwfZK0cR5hf4z8raA+g206lFzHWwWvi400WFU/5CnL4OG9EEmFIr+GObe+SUZ/xhNfU
	 ICxnJgIG+DUvHhc/6BkH8f/C0v97TdMAiLs31Raz/dqhwWmlDpjhdHe6zsa2kj/dd2WZu
	 TSW26UwDJXNNuT34cgfYNJFbIIP0auNGW2zHoPs6cKJs42SukJAlEaGXZGuMQRXG8gvaa
	 OqUoapL1QBYHTxqEIndDgq+9vE23A6lhE3tN6Tv6eKP6oRQIHVsJlYWIALawccsbJcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMZvkYU2fpUeu7F7e9fCxfNR7GjxG2WiL6ILzIR8br4=;
	b=g1MqYWuejMRUibxlm+k2N9Y8oTTf1tah82l0j3JRvcvl57oAK2CY7Fjj5Nz8P5voP1Ly
	 kiSkUvFyAsz7fqh3COpnEo70k/bCO4sCoR7RVOVKoy9yoI/tTGxrmhQ+VCuRSz7L9VruS
	 Ae9LIA22DgXG7K+e4Zx43i1hhofL285iZ6vi6k87CjJ4RCemgAHFbQPd/SPQRXappjjJc
	 f+SDTalOFMivlDLsHF/pvUILOOdp9M2yWZdMGI3TuZURs+uhPDw/BJ87rPqrIHhOcMEcz
	 74uLdcD21kFVJOc1xvKZJ40gb3legtK0YmVtLTs3MPSc5pbQh9dPyOlimD+x9yDeZ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVlqZTB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A41606A320;
	Thu, 19 Nov 2026 04:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVlqZTB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3DF1F000C4;
	Thu, 19 Nov 2026 04:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061827;
	bh=aMZvkYU2fpUeu7F7e9fCxfNR7GjxG2WiL6ILzIR8br4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVlqZTB86OIqRMdM8sl43SYcoy0aUFxJXL98mFoc4/ec7afGdHJ+irqELefeuUy1I
	 qtcaiZfjkkB4TlM+qn46yvE1LrJyVPfXHIQDBacC88Ip+QgtQpq+HR1NB4oLOzBInu
	 DeHkxJ2IYEr6e1adxOYDIasGF1TTgX0JGpGkBQtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1685/1848] usbnet: switch to core handling of rx/tx byte/packet counters
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150030.300058125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit af0c351cc34857ad7b254850b9392d99da46be9e ]

Use netdev->tstats instead of a member of usbnet for storing a pointer
to the per-cpu counters. This allows us to use core functionality for
statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 95a5c641fc7b ("usbnet: fix smp_processor_id() use in preemptible context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c   | 23 +++++++----------------
 include/linux/usb/usbnet.h |  6 ++----
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 4b34544d88aa8..20713b67ea2b2 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -314,7 +314,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->stats64);
+	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
 	unsigned long flags;
 	int	status;
 
@@ -990,15 +990,6 @@ int usbnet_set_link_ksettings(struct net_device *net,
 }
 EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings);
 
-void usbnet_get_stats64(struct net_device *net, struct rtnl_link_stats64 *stats)
-{
-	struct usbnet *dev = netdev_priv(net);
-
-	netdev_stats_to_stats64(stats, &net->stats);
-	dev_fetch_sw_netstats(stats, dev->stats64);
-}
-EXPORT_SYMBOL_GPL(usbnet_get_stats64);
-
 u32 usbnet_get_link (struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -1233,7 +1224,7 @@ static void tx_complete (struct urb *urb)
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
-		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->stats64);
+		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
 		unsigned long flags;
 
 		flags = u64_stats_update_begin_irqsave(&stats64->syncp);
@@ -1614,7 +1605,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
 
-	free_percpu(dev->stats64);
+	free_percpu(net->tstats);
 	free_netdev(net);
 }
 EXPORT_SYMBOL_GPL(usbnet_disconnect);
@@ -1626,7 +1617,7 @@ static const struct net_device_ops usbnet_netdev_ops = {
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_set_rx_mode	= usbnet_set_rx_mode,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -1689,8 +1680,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->driver_info = info;
 	dev->driver_name = name;
 
-	dev->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!dev->stats64)
+	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!net->tstats)
 		goto out0;
 
 	dev->msg_enable = netif_msg_init (msg_level, NETIF_MSG_DRV
@@ -1842,7 +1833,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 */
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
-	free_percpu(dev->stats64);
+	free_percpu(net->tstats);
 out0:
 	free_netdev(net);
 out:
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 6aaef1a3e16c8..a3c2583b31d92 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -65,8 +65,6 @@ struct usbnet {
 	struct usb_anchor	deferred;
 	struct tasklet_struct	bh;
 
-	struct pcpu_sw_netstats __percpu *stats64;
-
 	struct work_struct	kevent;
 	unsigned long		flags;
 #		define EVENT_TX_HALT	0
@@ -288,7 +286,7 @@ extern int usbnet_status_start(struct usbnet *dev, gfp_t mem_flags);
 extern void usbnet_status_stop(struct usbnet *dev);
 
 extern void usbnet_update_max_qlen(struct usbnet *dev);
-extern void usbnet_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats);
+
+#define usbnet_get_stats64 dev_get_tstats64
 
 #endif /* __LINUX_USB_USBNET_H */
-- 
2.53.0



