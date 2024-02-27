Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7707713B2AC;
	Tue, 27 Feb 2024 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042262; cv=none; b=pXuMAdRhUfRUijg1bvUh6bdVt2iru6b0qshs2UufkXbUBRO09lrPy7BvUm8GJnmLSBe9JqDFq9BMXxrPzcRLRCi6kLzO/9Zcefpudl2T7nbw7QxBQvVGwWp8D2Gq048qCN8qSbYeFQx12FQIzUVN0FX7cd33XVJISPzS29dA4ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042262; c=relaxed/simple;
	bh=8Ia2xotCHpZIICalmfDrKfu9zVmqegcn50La0TDQwHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV7nUAMj1EJyWEodCIT8B5q9hsfe9vlcsUox7M2gVUIOTlVJn4879sGBvvxEivs4ffeXkdH7hfSo2tzh5fMjh4SfD3MSy3wAgPZ+x9Z7JbTY1QqbNJk/JVJV74SYSfA5k9fZ7OA+KDajJvJPX4/K2rb3TE80z8EWB8djQqmRpwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5qZNa/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5qZNa/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FBFC433C7;
	Tue, 27 Feb 2024 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042262;
	bh=8Ia2xotCHpZIICalmfDrKfu9zVmqegcn50La0TDQwHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5qZNa/NM73o8GBo7mVVenAabD7kCV61CFCt88ZgzL3n4GuGal9mCp/RWXJ6/vQmd
	 AOK4PGSwK+WN76oUAOzUqlLKNGDJrl8O57WFdGseOFcRZvpHakDu9r2VOwe2859BG5
	 2lztoo7o3bWrAmFi+PGHuOzFcdf/QPTLEvcPZ8nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/299] net: bridge: switchdev: Ensure deferred event delivery on unoffload
Date: Tue, 27 Feb 2024 14:25:46 +0100
Message-ID: <20240227131633.304610808@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



