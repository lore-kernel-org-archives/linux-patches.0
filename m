Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D991C5D77;
	Fri, 21 Nov 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733390; cv=none; b=t08QS/7KFw7sd4p5BFLRIMozPMMVST9r34l0HY/DcULS/iBB3XT3X+G/BePxTFHeFlwDJZIskHhvEkTxkl6joUWuRInohg2t7qm/8Fb2qgEI4G2OBEI7YpD+EtaznkimxOKQmvpYcghHD+/R8nFFxf6bvTmPGzp1it7zpkJJVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733390; c=relaxed/simple;
	bh=Ik/z6Dr640/e7wVwIm9zt5zCQhtJqIixwxyLVVvpUpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxxTCaTYZxmWTGPfnSPKtFTF3RsivM0ovqWCt2AXX1gcJAd4cGxK8q8G5au0ojSKTAx/V+5X+DF8ft66wDJGl9m0zmchxUvjV/RFCmDZleX5jp3fYLBQptghYxWZXKBuz6tRnMGv0En1RG5mebpdoCsU2XRdEJrMTOJw4U1vzjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubi3ZBVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubi3ZBVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD11C4CEF1;
	Fri, 21 Nov 2025 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733390;
	bh=Ik/z6Dr640/e7wVwIm9zt5zCQhtJqIixwxyLVVvpUpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubi3ZBVhjdsyKhSDBZWyUQaM5tgPN0Z+ei7hq9eoyh3y4syagGL6qX53elzG4BGiY
	 Is3sk5OGFFp6j1JiMuO5PcfrotoO1t9sI4ZkhhIxTeU/ojC/YIfSfhjbt3qx8bxVng
	 bAycp7QMTXPXisk1IiGodYvhy6+SkllcY3cH1I1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 451/529] net: dsa: improve shutdown sequence
Date: Fri, 21 Nov 2025 14:12:30 +0100
Message-ID: <20251121130247.056744917@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6c24a03a61a245fe34d47582898331fa034b6ccd ]

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
dp->master->dsa_ptr = NULL; is concurrent with receive packet
processing. dsa_switch_rcv() checks once whether dev->dsa_ptr is NULL,
but afterwards, rather than continuing to use that non-NULL value,
dev->dsa_ptr is dereferenced again and again without NULL checks:
dsa_master_find_slave() and many other places. In between dereferences,
there is no locking to ensure that what was valid once continues to be
valid.

Both problems have the common aspect that closing the master interface
solves them.

In the first case, dev_close(master) triggers the NETDEV_GOING_DOWN
event in dsa_slave_netdevice_event() which closes slave ports as well.
dsa_port_disable_rt() calls phylink_stop(), which synchronously stops
the phylink state machine, and ds->ops->phy_read() will thus no longer
call into the driver after this point.

In the second case, dev_close(master) should do this, as per
Documentation/networking/driver.rst:

| Quiescence
| ----------
|
| After the ndo_stop routine has been called, the hardware must
| not receive or transmit any data.  All in flight packets must
| be aborted. If necessary, poll or wait for completion of
| any reset commands.

So it should be sufficient to ensure that later, when we zeroize
master->dsa_ptr, there will be no concurrent dsa_switch_rcv() call
on this master.

The addition of the netif_device_detach() function is to ensure that
ioctls, rtnetlinks and ethtool requests on the slave ports no longer
propagate down to the driver - we're no longer prepared to handle them.

The race condition actually did not exist when commit 0650bf52b31f
("net: dsa: be compatible with masters which unregister on shutdown")
first introduced dsa_switch_shutdown(). It was created later, when we
stopped unregistering the slave interfaces from a bad spot, and we just
replaced that sequence with a racy zeroization of master->dsa_ptr
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
[ Modification: Using dp->master and dp->slave instead of dp->conduit and dp->user ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 07736edc8b6a5..c9bf1a9a6c99b 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -1613,6 +1613,7 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch);
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *master, *slave_dev;
+	LIST_HEAD(close_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1622,10 +1623,16 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 
 	rtnl_lock();
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		list_add(&dp->master->close_list, &close_list);
+
+	dev_close_many(&close_list, true);
+
 	dsa_switch_for_each_user_port(dp, ds) {
 		master = dsa_port_to_master(dp);
 		slave_dev = dp->slave;
 
+		netif_device_detach(slave_dev);
 		netdev_upper_dev_unlink(master, slave_dev);
 	}
 
-- 
2.51.0



