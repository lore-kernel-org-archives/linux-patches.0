Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1813B2BF;
	Tue, 27 Feb 2024 13:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041204; cv=none; b=czT6rdAh5/WD2Wh5U/9Y09va4vF80ccBQKPIzE+SdxKI2/6Cuoqm7j2gD/h/fq4MERdteozoIRPb6L32G5tZeu296Jo8/aPPEb8rsK4m1G003gTcluncRB324ZXvIzhdHVr8SPnwH6JWimPEN5M6FdOdsysqW2RlAScSPGLiMXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041204; c=relaxed/simple;
	bh=26TQcuCXAiSvYbuqNzjUycKPK3wXqvXoZK/CGHjsizc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDPLpw6CGDqMUwezwmEuorXGr+FiZKWMafUIxUqt9QHc8OPdo+PbvpYODI5BE6iutIl7QTpzCHt2QDLaR6XeE2fiBGcoU5yAgYWumCBqYyhnoELfDSisXc/RU3kEvh5Fh3wZ4FbCc9ZXmPYw0ImVvnVCj6SKHNY3qYI7Cjdw4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ+1N6p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ+1N6p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4D8C433C7;
	Tue, 27 Feb 2024 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041204;
	bh=26TQcuCXAiSvYbuqNzjUycKPK3wXqvXoZK/CGHjsizc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ+1N6p3NL++tjRbz7PXZB5e3CXKvTTo4ofiLH8wPWWI9l6mfdy4oLx4ue2X7Fr1I
	 /G8CE3To+L9/hrQycs01Ss/BAuFRVLKAYQ27EuRr/qLgdYySXqWFGMpHzKAJ6W1omC
	 6W5Xue/NepIqJGQCCY6kMHHe0IsRRpuiPWRGc540=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 258/334] net: bridge: switchdev: Ensure deferred event delivery on unoffload
Date: Tue, 27 Feb 2024 14:21:56 +0100
Message-ID: <20240227131639.252202323@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit f7a70d650b0b6b0134ccba763d672c8439d9f09b ]

When unoffloading a device, it is important to ensure that all
relevant deferred events are delivered to it before it disassociates
itself from the bridge.

Before this change, this was true for the normal case when a device
maps 1:1 to a net_bridge_port, i.e.

   br0
   /
swp0

When swp0 leaves br0, the call to switchdev_deferred_process() in
del_nbp() makes sure to process any outstanding events while the
device is still associated with the bridge.

In the case when the association is indirect though, i.e. when the
device is attached to the bridge via an intermediate device, like a
LAG...

    br0
    /
  lag0
  /
swp0

...then detaching swp0 from lag0 does not cause any net_bridge_port to
be deleted, so there was no guarantee that all events had been
processed before the device disassociated itself from the bridge.

Fix this by always synchronously processing all deferred events before
signaling completion of unoffloading back to the driver.

Fixes: 4e51bf44a03a ("net: bridge: move the switchdev object replay helpers to "push" mode")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_switchdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6a7cb01f121c7..7b41ee8740cbb 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -804,6 +804,16 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
 	br_switchdev_vlan_replay(br_dev, ctx, false, blocking_nb, NULL);
+
+	/* Make sure that the device leaving this bridge has seen all
+	 * relevant events before it is disassociated. In the normal
+	 * case, when the device is directly attached to the bridge,
+	 * this is covered by del_nbp(). If the association was indirect
+	 * however, e.g. via a team or bond, and the device is leaving
+	 * that intermediate device, then the bridge port remains in
+	 * place.
+	 */
+	switchdev_deferred_process();
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.43.0



