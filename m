Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3C282F03;
	Sat, 12 Sep 2026 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232344; cv=none; b=EexU/hlBKc27rTzQ+K1P4n0T6jLe7485GgZaOA34MD56t0Y0uRhKmMdj6JvdwaJO8uK+Ver9tCXnEwiHMdHZ8zNBOWHa4eYANhg3g9I7r6ZNL9aejMQ2V38KdGZGfyd8QF8CtIj8xS4ABFBLx/M5a9kcqRArUv079vxkNUSTckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232344; c=relaxed/simple;
	bh=hC6f5knlW2dRxjAF1UsMElKEHq5jvQA7RAJNQ+dRlWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAMHjyNYpRbrDv9UzxxRp3Y5vXOpGO+wlR29R1RYur/TYyoBDIg+w1MVrtUGClOlzTvCLfPIS8xjFc47ZryFgurSX6RDAnQYrYoshLMcyH6/o3/7ByUQwqts8Y7SX+almXjKWs4J+9FlNW8GcWTkSZ1ZCMdFF9FREmNOVoJfQpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOAHJJCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOAHJJCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB411F000FF;
	Sat, 12 Sep 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232343;
	bh=ebhOwtDVS+EPMLydP6J3o2t4vW+/vqkeOzWPnKHUR/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOAHJJCIRq5zoxnOPi85OoDqLuK/NUWIyu8xqPNoK0k1KSqVsnwZYjyaqoFHk1b8G
	 ob4qr0t3rJNGqPdn/v7V8MD9DjoycfXZJ7vJ9AfP+uFIURpmUlelOX63q7DGE0Lj/O
	 +5Tfs05wBDnpGAYyaUu7MVAkrF70Hs7XabH02pK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1182/1191] net: hsr: enable promiscuous mode on interlink port with fwd offload
Date: Sat, 12 Sep 2026 09:05:10 +0200
Message-ID: <20260912065614.686761834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit a2dc179481d18f6df7274522571b64dd50f31e81 ]

hsr_portdev_setup() skips promiscuous mode on non-master ports when
hsr->fwd_offloaded is set. fwd_offloaded is derived only from the ring
slaves' NETIF_F_HW_HSR_FWD bit, so this also skips it for the interlink
port, which never gets forwarding offload. Without promiscuous mode,
the interlink NIC drops unicast frames addressed to hsr_dev's MAC
(e.g. SAN traffic to the RedBox), breaking RedBox whenever the ring is
HW-offloaded.

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260908090856.2876114-1-danishanwar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 5c98e24587f59..8c6694245b282 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -139,9 +139,12 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	int res;
 
 	/* Don't use promiscuous mode for offload since L2 frame forward
-	 * happens at the offloaded hardware.
+	 * happens at the offloaded hardware. The interlink port never
+	 * gets forwarding offload (RedBox forwarding to/from it is done
+	 * by this driver), so it still needs promiscuous mode to receive
+	 * frames addressed to hsr_dev's MAC rather than its own.
 	 */
-	if (!port->hsr->fwd_offloaded) {
+	if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK) {
 		res = dev_set_promiscuity(dev, 1);
 		if (res)
 			return res;
@@ -164,7 +167,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 fail_rx_handler:
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
-	if (!port->hsr->fwd_offloaded)
+	if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK)
 		dev_set_promiscuity(dev, -1);
 
 	return res;
@@ -227,7 +230,7 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_update_features(master->dev);
 		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
 		netdev_rx_handler_unregister(port->dev);
-		if (!port->hsr->fwd_offloaded)
+		if (!port->hsr->fwd_offloaded || port->type == HSR_PT_INTERLINK)
 			dev_set_promiscuity(port->dev, -1);
 		if (port->type == HSR_PT_SLAVE_A || port->type == HSR_PT_SLAVE_B)
 			vlan_vids_del_by_dev(port->dev, master->dev);
-- 
2.53.0



