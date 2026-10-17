Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05B3B2FCA;
	Sat, 17 Oct 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259511; cv=none; b=ix4ZbYM2F7Ghnb1JqSWRS955iIf/NHYzxmCrMMVGL00mUGN6UlhVTOtrqDvf6CAIVBkMbu0TZYwb6Vgt1R5+Y9zSELBd7vdV7k9AA3P1/BlscVL59k3YkpgNJbOLI6K2ePJjKfFbRBBi5ikiUjSVTq1TBTSxPZPOvPEA2iUc0zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259511; c=relaxed/simple;
	bh=+rWflcDubzXHWP7vxpMn5toeROu9nectMTfWHbZqWSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmGSxgnOuU2Fg0E+PbAkma6HpvUDMUN64Jzeq64eqwyql1pHzmMgLRZIUAi4yh6z6t5ZG8Qg0Jmk4WXHn75vO1BAtWe3FJhwHIZGVqfxy/0AfoYm2M3LEJLgeeDlraqxw30Xry0KDdh+8udG7Fou6Su2Y1Q0OeGe+EpZV4otc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGd1z/Zm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGd1z/Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3424A1F000C4;
	Sat, 17 Oct 2026 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259509;
	bh=b62JaTcoEOerD1CoDx0bVPoiV76wX3n3S3lDSleqAt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGd1z/ZmxZWpm5+SKjo/78ZwsvIp/IP4eRzsKeokyasD8N2ufCQtwizdKu4w9KhWc
	 abJvCLryzHTZJtilrIOBYpPcX914bAjnVZnBZEWJ1wDYu9mTK1Y0+8mayN4g48qHTH
	 EGCD7aIZAHnQ17RLQlMhvavZZRPRnT8YshqgZbo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1197/1674] net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()
Date: Sat, 17 Oct 2026 17:57:49 +0200
Message-ID: <20261017160501.865166150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 3874892dd27d5387aa9a06f58d9060f18f351d24 ]

The commit 4f61f133f354 ("net: tap: NULL pointer derefence in
dev_parse_header_protocol when skb->dev is null") fixed a crash in
tap_get_user() by assigning skb->dev before calling tun_vnet_hdr_to_skb().
This is required because virtio_net_hdr_to_skb() may invoke
dev_parse_header_protocol(), which dereferences skb->dev. Without the
assignment, a NULL pointer dereference can occur.

However, tap_get_user_xdp() still parses the virtio-net header before
assigning skb->dev. When the vhost TX path passes an XDP buffer containing
a GSO virtio-net header but the protocol is set to zero on purpose,
tun_vnet_hdr_to_skb() can reach dev_parse_header_protocol() while skb->dev
is still NULL, resulting in a crash.

Fix this by looking up the tap device and assigning skb->dev before calling
tun_vnet_hdr_to_skb(), matching the ordering already used in
tap_get_user(). Preserve the existing RCU read-side critical section across
dev_queue_xmit().

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Cc: stable@vger.kernel.org
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260802224612.264563-1-dongli.zhang@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 40aea069c3ad3..d8bcb34236267 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1200,10 +1200,21 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (!tap) {
+		kfree_skb(skb);
+		rcu_read_unlock();
+		return 0;
+	}
+	skb->dev = tap->dev;
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			rcu_read_unlock();
 			goto err_kfree;
+		}
 	}
 
 	/* Move network header to the right position for VLAN tagged packets */
@@ -1211,15 +1222,8 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
-	if (tap) {
-		skb->dev = tap->dev;
-		skb_probe_transport_header(skb);
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	skb_probe_transport_header(skb);
+	dev_queue_xmit(skb);
 	rcu_read_unlock();
 
 	return 0;
-- 
2.53.0



