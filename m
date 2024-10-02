Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6021D0423;
	Wed,  2 Oct 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875292; cv=none; b=oUaUp+9xjm2656qBUFwcMWRXMKNTeaht9qihjn8DHCqgXsgD4qk9UXzrbCwi3GOD0tKqWYeGFCW9atu2zXpixl1dvIoKb9iTCGZ3f+9V7Vs8IUFbxnGvN7calYga0xMP38RpjwE3DYhlVWhMhx6IeAR/A2RPbWIKxvPHeYpN3E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875292; c=relaxed/simple;
	bh=/l1U8ZFqZijvPC0UsmWLiQafZyJscAwZvyFSe7Ti5is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVtheBBg1ADdbxMvtPFqWqov/2K6AYJyb9OLI5s1YEMPfb88f1tAF+C6CbrPP4teS3vyYVk9CUmNLJ7KQ5+X6msRzdJCDBETkW1BXm2JPGC5TDzoJYwagGru4cjYb4VBDfbPmH/hqNUYuBbgbgx1RpLDXgHqOJYWIXht+ZqhsQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjP2GNZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjP2GNZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0064C4CEC5;
	Wed,  2 Oct 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875292;
	bh=/l1U8ZFqZijvPC0UsmWLiQafZyJscAwZvyFSe7Ti5is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjP2GNZFPReGooGsbcSKNbJ6oYQ/KL42L21qJpyN27tc7sKDNMTG9ubo5HUURm5Jk
	 CZlKSbqGDeU74uyPTfs0fCpt1rVwh4mWgX74c5HOAf1TqHasWToHVGaaGlWLiWUiO1
	 7MSLFhnXIHIRq3PebGRRMoSC0D63oM5U7YEX6HEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
	Gia-Khanh Nguyen <gia-khanh.nguyen@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 021/695] virtio-net: synchronize operstate with admin state on up/down
Date: Wed,  2 Oct 2024 14:50:19 +0200
Message-ID: <20241002125823.338204611@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit df28de7b00502761eba62490f413c65c9b175ed9 ]

This patch synchronizes operstate with admin state per RFC2863.

This is done by trying to toggle the carrier upon open/close and
synchronize with the config change work. This allows to propagate
status correctly to stacked devices like:

ip link add link enp0s3 macvlan0 type macvlan
ip link set link enp0s3 down
ip link show

Before this patch:

3: enp0s3: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:05:00:00:09 brd ff:ff:ff:ff:ff:ff
......
5: macvlan0@enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether b2:a9:c5:04:da:53 brd ff:ff:ff:ff:ff:ff

After this patch:

3: enp0s3: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:05:00:00:09 brd ff:ff:ff:ff:ff:ff
...
5: macvlan0@enp0s3: <NO-CARRIER,BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether b2:a9:c5:04:da:53 brd ff:ff:ff:ff:ff:ff

Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Gia-Khanh Nguyen <gia-khanh.nguyen@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20240814052228.4654-4-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c392d6019398 ("virtio-net: synchronize probe with ndo_set_features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 78 +++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a1c1ec5a64b8..60833e7b5a935 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2884,6 +2884,25 @@ static void virtnet_cancel_dim(struct virtnet_info *vi, struct dim *dim)
 	net_dim_work_cancel(dim);
 }
 
+static void virtnet_update_settings(struct virtnet_info *vi)
+{
+	u32 speed;
+	u8 duplex;
+
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
+		return;
+
+	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
+
+	if (ethtool_validate_speed(speed))
+		vi->speed = speed;
+
+	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);
+
+	if (ethtool_validate_duplex(duplex))
+		vi->duplex = duplex;
+}
+
 static int virtnet_open(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -2902,6 +2921,15 @@ static int virtnet_open(struct net_device *dev)
 			goto err_enable_qp;
 	}
 
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
+		if (vi->status & VIRTIO_NET_S_LINK_UP)
+			netif_carrier_on(vi->dev);
+		virtio_config_driver_enable(vi->vdev);
+	} else {
+		vi->status = VIRTIO_NET_S_LINK_UP;
+		netif_carrier_on(dev);
+	}
+
 	return 0;
 
 err_enable_qp:
@@ -3380,12 +3408,22 @@ static int virtnet_close(struct net_device *dev)
 	disable_delayed_refill(vi);
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
+	/* Prevent the config change callback from changing carrier
+	 * after close
+	 */
+	virtio_config_driver_disable(vi->vdev);
+	/* Stop getting status/speed updates: we don't care until next
+	 * open
+	 */
+	cancel_work_sync(&vi->config_work);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		virtnet_disable_queue_pair(vi, i);
 		virtnet_cancel_dim(vi, &vi->rq[i].dim);
 	}
 
+	netif_carrier_off(dev);
+
 	return 0;
 }
 
@@ -5094,25 +5132,6 @@ static void virtnet_init_settings(struct net_device *dev)
 	vi->duplex = DUPLEX_UNKNOWN;
 }
 
-static void virtnet_update_settings(struct virtnet_info *vi)
-{
-	u32 speed;
-	u8 duplex;
-
-	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
-		return;
-
-	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
-
-	if (ethtool_validate_speed(speed))
-		vi->speed = speed;
-
-	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);
-
-	if (ethtool_validate_duplex(duplex))
-		vi->duplex = duplex;
-}
-
 static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
 {
 	return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
@@ -6521,6 +6540,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		goto free_failover;
 	}
 
+	/* Disable config change notification until ndo_open. */
+	virtio_config_driver_disable(vi->vdev);
+
 	virtio_device_ready(vdev);
 
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
@@ -6570,25 +6592,25 @@ static int virtnet_probe(struct virtio_device *vdev)
 		vi->device_stats_cap = le64_to_cpu(v);
 	}
 
-	rtnl_unlock();
-
-	err = virtnet_cpu_notif_add(vi);
-	if (err) {
-		pr_debug("virtio_net: registering cpu notifier failed\n");
-		goto free_unregister_netdev;
-	}
-
 	/* Assume link up if device can't report link status,
 	   otherwise get link status from config. */
 	netif_carrier_off(dev);
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
-		schedule_work(&vi->config_work);
+		virtnet_config_changed_work(&vi->config_work);
 	} else {
 		vi->status = VIRTIO_NET_S_LINK_UP;
 		virtnet_update_settings(vi);
 		netif_carrier_on(dev);
 	}
 
+	rtnl_unlock();
+
+	err = virtnet_cpu_notif_add(vi);
+	if (err) {
+		pr_debug("virtio_net: registering cpu notifier failed\n");
+		goto free_unregister_netdev;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
 		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
 			set_bit(guest_offloads[i], &vi->guest_offloads);
-- 
2.43.0



