Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6086F51AEEE;
	Wed, 30 Sep 2026 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789327; cv=none; b=gMgM75CUfhU3As5X3qBGRNkHxD7Nh3N7Tp8prdpAjXfisj2KfOQsCerE2/zB5w6jZBROi5GKOayiPnmAGt0LpcV++I2Pj6TqAGvg8MYwggcGEfzYlXkB2QvuRzKCVV4hBwnzFseiUWGpWj9952dWIDCYZNG1Iq5aRmnMrvRSdv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789327; c=relaxed/simple;
	bh=aiIQ4V4gGPyy4RgL8p1SP3nv/ygg4LiZo5MaWDMT1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rdtu3afOMvrsCan0cPdlFdS5SP6iCLQBRQcbzk+3zcI+RaQDUE6oChb6ZOevuCju2NSis74pg0ZballC1yWEofb3rwakETdH8gRLF89ywNZF7i3lbSqmzR3KOkknu7MTxnsbrG1REqXBr7AdFouCYdqPPrvDd4zZCkP9LLm5WtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUKmiEo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUKmiEo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5901F000FF;
	Wed, 30 Sep 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789326;
	bh=s6Goniv0+Md9XZyhPRRK3938JHqZABztGZrA5fblHF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUKmiEo+44LWbVm7v3UUxWjEnXCWSKgl0U0T2shW671HagXDbLBEMH62R/W3bTK4P
	 6uKErWvRcH5+nNMCS9NiPUij7o9ljCem49hf4Bz4EVWP2Xth1bkg/+9nyygiPnkbBp
	 CrRG8V3JdCukDhiUq4QI1h8w0htBskXdlMmKh238=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f2f6312ad1b5a0bfe316@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Haseeb Malik <haseebulhaq55@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/877] macsec: initialize SecY before registering the netdevice
Date: Wed, 30 Sep 2026 17:22:28 +0200
Message-ID: <20260930152424.114157868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haseeb Malik <haseebulhaq55@gmail.com>

[ Upstream commit c2de369c5c5b8599ca10fd5ca8d11fcd845c1331 ]

Creating a MACsec device with MAC offload over an LRO-capable lower
device triggers a warning in rtmsg_ifinfo_build_skb() when IPv4
forwarding is enabled by default.

register_netdevice() invokes inetdev_init(), which disables LRO and emits
a NETDEV_FEAT_CHANGE notification. This reaches macsec_fill_info() before
macsec_add_dev() initializes the SecY. key_len is still zero, so
macsec_fill_info() returns -EMSGSIZE and trips the WARN_ON in
rtmsg_ifinfo_build_skb(), even though the skb has enough space.

Even without the warning, notifications during registration can report
uninitialized SecY attributes, including the SCI. This ordering has existed
since the driver was introduced.

Initialize the SecY and apply the new-link attributes before registration.
Move MAC address inheritance into macsec_newlink() so the SCI can also be
initialized before registration-time notifications report it. Move the
per-CPU statistics and metadata destination allocation into ndo_init(),
and release partial allocations on failure.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: syzbot+f2f6312ad1b5a0bfe316@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f2f6312ad1b5a0bfe316
Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lists.openwall.net/linux-kernel/2026/08/19/552
Signed-off-by: Haseeb Malik <haseebulhaq55@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260921-fix-macsec-net-v3-1-accf94f93f5e@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 84 +++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ce4a08f77724f..fd6f88cfaff61 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3579,6 +3579,22 @@ static int macsec_dev_init(struct net_device *dev)
 	if (err)
 		return err;
 
+	err = -ENOMEM;
+	macsec->stats = netdev_alloc_pcpu_stats(struct pcpu_secy_stats);
+	if (!macsec->stats)
+		goto destroy_gro_cells;
+
+	macsec->secy.tx_sc.stats =
+		netdev_alloc_pcpu_stats(struct pcpu_tx_sc_stats);
+	if (!macsec->secy.tx_sc.stats)
+		goto free_secy_stats;
+
+	macsec->secy.tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC,
+						       GFP_KERNEL);
+	if (!macsec->secy.tx_sc.md_dst)
+		goto free_tx_sc_stats;
+	macsec->secy.tx_sc.md_dst->u.macsec_info.sci = macsec->secy.sci;
+
 	macsec_inherit_tso_max(dev);
 
 	dev->hw_features = real_dev->hw_features & MACSEC_OFFLOAD_FEATURES;
@@ -3591,8 +3607,6 @@ static int macsec_dev_init(struct net_device *dev)
 
 	macsec_set_head_tail_room(dev);
 
-	if (is_zero_ether_addr(dev->dev_addr))
-		eth_hw_addr_inherit(dev, real_dev);
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
@@ -3600,6 +3614,14 @@ static int macsec_dev_init(struct net_device *dev)
 	netdev_hold(real_dev, &macsec->dev_tracker, GFP_KERNEL);
 
 	return 0;
+
+free_tx_sc_stats:
+	free_percpu(macsec->secy.tx_sc.stats);
+free_secy_stats:
+	free_percpu(macsec->stats);
+destroy_gro_cells:
+	gro_cells_destroy(&macsec->gro_cells);
+	return err;
 }
 
 static void macsec_dev_uninit(struct net_device *dev)
@@ -4127,26 +4149,11 @@ static sci_t dev_to_sci(struct net_device *dev, __be16 port)
 	return make_sci(dev->dev_addr, port);
 }
 
-static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
+static void macsec_init_secy(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_secy *secy = &macsec->secy;
 
-	macsec->stats = netdev_alloc_pcpu_stats(struct pcpu_secy_stats);
-	if (!macsec->stats)
-		return -ENOMEM;
-
-	secy->tx_sc.stats = netdev_alloc_pcpu_stats(struct pcpu_tx_sc_stats);
-	if (!secy->tx_sc.stats)
-		return -ENOMEM;
-
-	secy->tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
-	if (!secy->tx_sc.md_dst)
-		/* macsec and secy percpu stats will be freed when unregistering
-		 * net_device in macsec_free_netdev()
-		 */
-		return -ENOMEM;
-
 	if (sci == MACSEC_UNDEF_SCI)
 		sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
@@ -4160,15 +4167,12 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	secy->xpn = DEFAULT_XPN;
 
 	secy->sci = sci;
-	secy->tx_sc.md_dst->u.macsec_info.sci = sci;
 	secy->tx_sc.active = true;
 	secy->tx_sc.encoding_sa = DEFAULT_ENCODING_SA;
 	secy->tx_sc.encrypt = DEFAULT_ENCRYPT;
 	secy->tx_sc.send_sci = DEFAULT_SEND_SCI;
 	secy->tx_sc.end_station = false;
 	secy->tx_sc.scb = false;
-
-	return 0;
 }
 
 static struct lock_class_key macsec_netdev_addr_lock_key;
@@ -4228,6 +4232,24 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (rx_handler && rx_handler != macsec_handle_frame)
 		return -EBUSY;
 
+	if (is_zero_ether_addr(dev->dev_addr))
+		eth_hw_addr_inherit(dev, real_dev);
+
+	if (data && data[IFLA_MACSEC_SCI])
+		sci = nla_get_sci(data[IFLA_MACSEC_SCI]);
+	else if (data && data[IFLA_MACSEC_PORT])
+		sci = dev_to_sci(dev, nla_get_be16(data[IFLA_MACSEC_PORT]));
+	else
+		sci = dev_to_sci(dev, MACSEC_PORT_ES);
+
+	/* Registration can notify listeners before returning. */
+	macsec_init_secy(dev, sci, icv_len);
+	if (data) {
+		err = macsec_changelink_common(dev, data);
+		if (err)
+			return err;
+	}
+
 	err = register_netdevice(dev);
 	if (err < 0)
 		return err;
@@ -4240,31 +4262,11 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		goto unregister;
 
-	/* need to be already registered so that ->init has run and
-	 * the MAC addr is set
-	 */
-	if (data && data[IFLA_MACSEC_SCI])
-		sci = nla_get_sci(data[IFLA_MACSEC_SCI]);
-	else if (data && data[IFLA_MACSEC_PORT])
-		sci = dev_to_sci(dev, nla_get_be16(data[IFLA_MACSEC_PORT]));
-	else
-		sci = dev_to_sci(dev, MACSEC_PORT_ES);
-
 	if (rx_handler && sci_exists(real_dev, sci)) {
 		err = -EBUSY;
 		goto unlink;
 	}
 
-	err = macsec_add_dev(dev, sci, icv_len);
-	if (err)
-		goto unlink;
-
-	if (data) {
-		err = macsec_changelink_common(dev, data);
-		if (err)
-			goto del_dev;
-	}
-
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
-- 
2.53.0



