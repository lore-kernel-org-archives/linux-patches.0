Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55133C18B;
	Sat, 12 Sep 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226571; cv=none; b=cr3nuIC7Aes0L69jyL03zk9lGkl2xLaluv+LZQ5oT3JUemL5AzXAjvyiU9RlW+kHyIv2Alo+mmkMcgmZN7eb+02ENcTYH3MNjcAtLfTNKoOCWimhBtuxDOJq7hxJURzGY7vJ72lUXfB8juH17sH+Twwv3gF/EznJ7YEnxk5gEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226571; c=relaxed/simple;
	bh=P2darfTgk8A5LYYvKxZPVXMeEiIQqCdilMBNxYdRCXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1gwO0vOr8vl3BsBIsgUvqqUFZ9vatkFPvl4QNuW81RRLjC09B9ndOjcBnKQTe9z8BwkGGAcsp2djI7RH73xMjjArpZeOPJLw3pNqf16+8xdMc/kJwgaLfljNXShMUpUK8Vah+cnr5v+uQ57tcehqSRmugsYmjHcgz2/yDtl3yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgBhgmh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgBhgmh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2418D1F000FF;
	Sat, 12 Sep 2026 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226570;
	bh=shrIGZxOVIX+uF2S6VoOCDGGhF7TQvPEemiHTQhACBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgBhgmh7h1GrhRbFuPhEsCGgsvH4NFAr4+uNaiqVrPHzR+2zc52DpFSC9SH+0M/ln
	 yaS+5bDJ2zB1WXxCL95j9OC6Fmcut3Arby1gJdQ27iYKAi+DhF2+PKisBpKAvyZjiK
	 JQKM1Sr5qx3PAQk38V1KuXaZD7xanJS0a/4fR8O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1416/1424] net: hsr: enable promiscuous mode on interlink port with fwd offload
Date: Sat, 12 Sep 2026 09:04:08 +0200
Message-ID: <20260912065638.969601267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



