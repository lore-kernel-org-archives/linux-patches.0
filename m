Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06F6133987;
	Tue, 20 Feb 2024 21:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463167; cv=none; b=k5FUU5jcx06cCrvdW2QL5xV+RchIMpuwZQJURmVSrZgeABcmxewhchtDb81uO9B8Sg4rFSmTukIGyoMZSjNWdDviJzZ+GDZ/+yGm61/fRv0u7RzmQgj9MWscAHMjH3DMnGAcTcAiVHOibHBnzluJVFYV71EM8EnPSPUG+xgPUgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463167; c=relaxed/simple;
	bh=BTOUe2PZDTDNZsv85VBSeHxpLCHqsJOWoi4lzM/OW2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOkGuW0JU0NQB0D/nqbmiFKEJAzcriyXtnJFSpsItNyooqpPs1ti6YlsWfa2mlUmvlyvGWoWaCvIDJMcDEaKEeOGj2X+WIqrijv9JNWeg1fBCXlFasBucWmyi83lQqhxzONJ97PWdxoWAkjkqxWksCwp+LMu8ceOouY878HAgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8TJYHsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8TJYHsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD35C433C7;
	Tue, 20 Feb 2024 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463167;
	bh=BTOUe2PZDTDNZsv85VBSeHxpLCHqsJOWoi4lzM/OW2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8TJYHsTV7hXsVYMUYSLh1TPf9ArAntAIRdq/y6tZNVDhURPJfLLKEcRwVWg2TudL
	 7eN8RzlS7F/MHNFFozJWBkboCOceuJfdwV1nTBo2b7R6Ubz1kfkY3GsiFEbSyNjWGF
	 ASZ+LvF1/p9BVxQTc5CwMNv6jH2BijXxBm0J4w3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 156/197] hv_netvsc: Register VF in netvsc_probe if NET_DEVICE_REGISTER missed
Date: Tue, 20 Feb 2024 21:51:55 +0100
Message-ID: <20240220204845.745008755@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shradha Gupta <shradhagupta@linux.microsoft.com>

commit 9cae43da9867412f8bd09aee5c8a8dc5e8dc3dc2 upstream.

If hv_netvsc driver is unloaded and reloaded, the NET_DEVICE_REGISTER
handler cannot perform VF register successfully as the register call
is received before netvsc_probe is finished. This is because we
register register_netdevice_notifier() very early( even before
vmbus_driver_register()).
To fix this, we try to register each such matching VF( if it is visible
as a netdevice) at the end of netvsc_probe.

Cc: stable@vger.kernel.org
Fixes: 85520856466e ("hv_netvsc: Fix race of register_netdevice_notifier and VF register")
Suggested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |   82 ++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 20 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -42,6 +42,10 @@
 #define LINKCHANGE_INT (2 * HZ)
 #define VF_TAKEOVER_INT (HZ / 10)
 
+/* Macros to define the context of vf registration */
+#define VF_REG_IN_PROBE		1
+#define VF_REG_IN_NOTIFIER	2
+
 static unsigned int ring_size __ro_after_init = 128;
 module_param(ring_size, uint, 0444);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of 4K pages)");
@@ -2181,7 +2185,7 @@ static rx_handler_result_t netvsc_vf_han
 }
 
 static int netvsc_vf_join(struct net_device *vf_netdev,
-			  struct net_device *ndev)
+			  struct net_device *ndev, int context)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(ndev);
 	int ret;
@@ -2204,7 +2208,11 @@ static int netvsc_vf_join(struct net_dev
 		goto upper_link_failed;
 	}
 
-	schedule_delayed_work(&ndev_ctx->vf_takeover, VF_TAKEOVER_INT);
+	/* If this registration is called from probe context vf_takeover
+	 * is taken care of later in probe itself.
+	 */
+	if (context == VF_REG_IN_NOTIFIER)
+		schedule_delayed_work(&ndev_ctx->vf_takeover, VF_TAKEOVER_INT);
 
 	call_netdevice_notifiers(NETDEV_JOIN, vf_netdev);
 
@@ -2342,7 +2350,7 @@ static int netvsc_prepare_bonding(struct
 	return NOTIFY_DONE;
 }
 
-static int netvsc_register_vf(struct net_device *vf_netdev)
+static int netvsc_register_vf(struct net_device *vf_netdev, int context)
 {
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device *netvsc_dev;
@@ -2382,7 +2390,7 @@ static int netvsc_register_vf(struct net
 
 	netdev_info(ndev, "VF registering: %s\n", vf_netdev->name);
 
-	if (netvsc_vf_join(vf_netdev, ndev) != 0)
+	if (netvsc_vf_join(vf_netdev, ndev, context) != 0)
 		return NOTIFY_DONE;
 
 	dev_hold(vf_netdev);
@@ -2480,10 +2488,31 @@ static int netvsc_unregister_vf(struct n
 	return NOTIFY_OK;
 }
 
+static int check_dev_is_matching_vf(struct net_device *event_ndev)
+{
+	/* Skip NetVSC interfaces */
+	if (event_ndev->netdev_ops == &device_ops)
+		return -ENODEV;
+
+	/* Avoid non-Ethernet type devices */
+	if (event_ndev->type != ARPHRD_ETHER)
+		return -ENODEV;
+
+	/* Avoid Vlan dev with same MAC registering as VF */
+	if (is_vlan_dev(event_ndev))
+		return -ENODEV;
+
+	/* Avoid Bonding master dev with same MAC registering as VF */
+	if (netif_is_bond_master(event_ndev))
+		return -ENODEV;
+
+	return 0;
+}
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
-	struct net_device *net = NULL;
+	struct net_device *net = NULL, *vf_netdev;
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info = NULL;
 	struct netvsc_device *nvdev;
@@ -2592,6 +2621,30 @@ static int netvsc_probe(struct hv_device
 	}
 
 	list_add(&net_device_ctx->list, &netvsc_dev_list);
+
+	/* When the hv_netvsc driver is unloaded and reloaded, the
+	 * NET_DEVICE_REGISTER for the vf device is replayed before probe
+	 * is complete. This is because register_netdevice_notifier() gets
+	 * registered before vmbus_driver_register() so that callback func
+	 * is set before probe and we don't miss events like NETDEV_POST_INIT
+	 * So, in this section we try to register the matching vf device that
+	 * is present as a netdevice, knowing that its register call is not
+	 * processed in the netvsc_netdev_notifier(as probing is progress and
+	 * get_netvsc_byslot fails).
+	 */
+	for_each_netdev(dev_net(net), vf_netdev) {
+		ret = check_dev_is_matching_vf(vf_netdev);
+		if (ret != 0)
+			continue;
+
+		if (net != get_netvsc_byslot(vf_netdev))
+			continue;
+
+		netvsc_prepare_bonding(vf_netdev);
+		netvsc_register_vf(vf_netdev, VF_REG_IN_PROBE);
+		__netvsc_vf_setup(net, vf_netdev);
+		break;
+	}
 	rtnl_unlock();
 
 	netvsc_devinfo_put(device_info);
@@ -2748,28 +2801,17 @@ static int netvsc_netdev_event(struct no
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
+	int ret = 0;
 
-	/* Skip our own events */
-	if (event_dev->netdev_ops == &device_ops)
-		return NOTIFY_DONE;
-
-	/* Avoid non-Ethernet type devices */
-	if (event_dev->type != ARPHRD_ETHER)
-		return NOTIFY_DONE;
-
-	/* Avoid Vlan dev with same MAC registering as VF */
-	if (is_vlan_dev(event_dev))
-		return NOTIFY_DONE;
-
-	/* Avoid Bonding master dev with same MAC registering as VF */
-	if (netif_is_bond_master(event_dev))
+	ret = check_dev_is_matching_vf(event_dev);
+	if (ret != 0)
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_POST_INIT:
 		return netvsc_prepare_bonding(event_dev);
 	case NETDEV_REGISTER:
-		return netvsc_register_vf(event_dev);
+		return netvsc_register_vf(event_dev, VF_REG_IN_NOTIFIER);
 	case NETDEV_UNREGISTER:
 		return netvsc_unregister_vf(event_dev);
 	case NETDEV_UP:


