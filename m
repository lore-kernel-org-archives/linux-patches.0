Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BE539FCE;
	Mon,  6 Jan 2025 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178871; cv=none; b=jtmUqgUXPMVBJ5hqtVUcInc1E5LGGBZeWuSEPtutY7GPbcLJLEfj+ctjuGrJHPUmKxsCdimPLEph3ttc+RXKyUbeqxX0qmffddojJsbNP8QsLbdKq8XbW4XjPaFCqw5eTZsjosE6p9/AyGuWCBwU45mUk0bGcnUzG/w20Q4aEvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178871; c=relaxed/simple;
	bh=JIdSS6TiV7XLrK+VHPCffdB/SCeN0vaKYYVBbm1v1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h00lcUi308NH16Mx1AyhvGsbWcJN9qfIS1N+K5DHEksm4+S6/kQF+48mhmfgHUnJCyfHJwP/CA7By0w2y2o6cgUlAwRgCQh/YA4q2HyfsZpGu3v5zw3Vsc1TmubNjaJmMjhNhU7z6Nw5XwbCsVqKy8r2ddNXZsCni2JVhRVlMho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seY99ov+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seY99ov+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD33C4CED2;
	Mon,  6 Jan 2025 15:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178871;
	bh=JIdSS6TiV7XLrK+VHPCffdB/SCeN0vaKYYVBbm1v1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seY99ov+jlXJKpv3nVS0C60E1DWWuyuk48fsq7OMohKDheT2VUTLtfn1uQ10OMHbA
	 DMZp/E4F7e7D+CKcTZzKDTQDnLuUz6WT3mkzoPZN9Whw59RgnvWcDsHcq386C5MfGd
	 nVtalBMQ+3az3gKtJ8+N/HIpjOtqZtecQdYxAWVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Peilin He <he.peilin@zte.com.cn>,
	xu xin <xu.xin16@zte.com.cn>,
	Kun Jiang <jiang.kun2@zte.com.cn>,
	Fan Yu <fan.yu9@zte.com.cn>,
	Yutan Qiu <qiu.yutan@zte.com.cn>,
	Yaxin Wang <wang.yaxin@zte.com.cn>,
	tuqiang <tu.qiang35@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH 5.15 103/168] net: dsa: improve shutdown sequence
Date: Mon,  6 Jan 2025 16:16:51 +0100
Message-ID: <20250106151142.351194812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 6c24a03a61a245fe34d47582898331fa034b6ccd upstream.

Alexander Sverdlin presents 2 problems during shutdown with the
lan9303 driver. One is specific to lan9303 and the other just happens
to reproduce there.

The first problem is that lan9303 is unique among DSA drivers in that it
calls dev_get_drvdata() at "arbitrary runtime" (not probe, not shutdown,
not remove):

phy_state_machine()
-> ...
   -> dsa_user_phy_read()
      -> ds->ops->phy_read()
         -> lan9303_phy_read()
            -> chip->ops->phy_read()
               -> lan9303_mdio_phy_read()
                  -> dev_get_drvdata()

But we never stop the phy_state_machine(), so it may continue to run
after dsa_switch_shutdown(). Our common pattern in all DSA drivers is
to set drvdata to NULL to suppress the remove() method that may come
afterwards. But in this case it will result in an NPD.

The second problem is that the way in which we set
dp->conduit->dsa_ptr = NULL; is concurrent with receive packet
processing. dsa_switch_rcv() checks once whether dev->dsa_ptr is NULL,
but afterwards, rather than continuing to use that non-NULL value,
dev->dsa_ptr is dereferenced again and again without NULL checks:
dsa_conduit_find_user() and many other places. In between dereferences,
there is no locking to ensure that what was valid once continues to be
valid.

Both problems have the common aspect that closing the conduit interface
solves them.

In the first case, dev_close(conduit) triggers the NETDEV_GOING_DOWN
event in dsa_user_netdevice_event() which closes user ports as well.
dsa_port_disable_rt() calls phylink_stop(), which synchronously stops
the phylink state machine, and ds->ops->phy_read() will thus no longer
call into the driver after this point.

In the second case, dev_close(conduit) should do this, as per
Documentation/networking/driver.rst:

| Quiescence
| ----------
|
| After the ndo_stop routine has been called, the hardware must
| not receive or transmit any data.  All in flight packets must
| be aborted. If necessary, poll or wait for completion of
| any reset commands.

So it should be sufficient to ensure that later, when we zeroize
conduit->dsa_ptr, there will be no concurrent dsa_switch_rcv() call
on this conduit.

The addition of the netif_device_detach() function is to ensure that
ioctls, rtnetlinks and ethtool requests on the user ports no longer
propagate down to the driver - we're no longer prepared to handle them.

The race condition actually did not exist when commit 0650bf52b31f
("net: dsa: be compatible with masters which unregister on shutdown")
first introduced dsa_switch_shutdown(). It was created later, when we
stopped unregistering the user interfaces from a bad spot, and we just
replaced that sequence with a racy zeroization of conduit->dsa_ptr
(one which doesn't ensure that the interfaces aren't up).

Reported-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Closes: https://lore.kernel.org/netdev/2d2e3bba17203c14a5ffdabc174e3b6bbb9ad438.camel@siemens.com/
Closes: https://lore.kernel.org/netdev/c1bf4de54e829111e0e4a70e7bd1cf523c9550ff.camel@siemens.com/
Fixes: ee534378f005 ("net: dsa: fix panic when DSA master device unbinds on shutdown")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20240913203549.3081071-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Peilin He <he.peilin@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Yutan Qiu <qiu.yutan@zte.com.cn>
Cc: Yaxin Wang <wang.yaxin@zte.com.cn>
Cc: tuqiang <tu.qiang35@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1656,6 +1656,7 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch)
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *master, *slave_dev;
+	LIST_HEAD(close_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1665,6 +1666,11 @@ void dsa_switch_shutdown(struct dsa_swit
 
 	rtnl_lock();
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		list_add(&dp->master->close_list, &close_list);
+
+	dev_close_many(&close_list, true);
+
 	list_for_each_entry(dp, &ds->dst->ports, list) {
 		if (dp->ds != ds)
 			continue;
@@ -1675,6 +1681,7 @@ void dsa_switch_shutdown(struct dsa_swit
 		master = dp->cpu_dp->master;
 		slave_dev = dp->slave;
 
+		netif_device_detach(slave_dev);
 		netdev_upper_dev_unlink(master, slave_dev);
 	}
 


