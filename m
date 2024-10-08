Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232EF1DDC24;
	Tue,  8 Oct 2024 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389571; cv=none; b=Hl3wPzhNcLjlPl7SQUQjdx51IduRdtlyRPsGOIYa1IImKWeRPfYIqtmQFyLYDcQ5MEMFV6O1vG0sAVzgpjGm13qo6oPdlG6sCPCQh0Wk4z4CZgvwKkB0oF7QoD4nR0oUq1vVlvkuTMvUVU+Jg6B44irPmVR7jrlTjSFX165cL9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389571; c=relaxed/simple;
	bh=AeZyHMfnhJ1D1xD/M/zNahqMU0AxOT0+9I+ePQwh7zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk7TBfR5IKDOrMJpUx/P9riVSBAHQ6H4mFxlIhDEboYHE3HYcGArGZyuiVXZaq4GlxaSb4ymMVejJcO6YqZlyQGHqjFtuhlv2cS+0CPGlAZS37En8ar7Id8nFDBVr0YgHzV8YXxwSbR/l6vx6taOcPTK916apGOBDvpBwYBVI1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkUchfe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkUchfe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE4AC4CEC7;
	Tue,  8 Oct 2024 12:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389570;
	bh=AeZyHMfnhJ1D1xD/M/zNahqMU0AxOT0+9I+ePQwh7zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkUchfe9yiRQfjW84KJEuAQHHCQ4OSYNpHL6ZRc52SN1r0nnBKFkSWr9W6Dd4YTn8
	 Upn243GJFaO69TtMXuD3mrkO8HgeVhPP7oLPEV5gwdiohFp3RkPlc7QntCfpysySXV
	 qDgIsA4YV2p0E6S2DS71ZC9VUjzA/VdAb1EiVr+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 033/482] net: dsa: improve shutdown sequence
Date: Tue,  8 Oct 2024 14:01:36 +0200
Message-ID: <20241008115649.603257389@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 12521a7d40481..03ef2a2af4309 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -1579,6 +1579,7 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch);
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *conduit, *user_dev;
+	LIST_HEAD(close_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1588,10 +1589,16 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 
 	rtnl_lock();
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		list_add(&dp->conduit->close_list, &close_list);
+
+	dev_close_many(&close_list, true);
+
 	dsa_switch_for_each_user_port(dp, ds) {
 		conduit = dsa_port_to_conduit(dp);
 		user_dev = dp->user;
 
+		netif_device_detach(user_dev);
 		netdev_upper_dev_unlink(conduit, user_dev);
 	}
 
-- 
2.43.0



