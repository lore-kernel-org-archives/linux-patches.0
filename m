Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C77469859;
	Thu, 20 Aug 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247180; cv=none; b=iCBqYSMV3wLjV9u9z4I9kCCdtM+we/jjkR7n7Q4XrIe4SKZLWm/DxRuYLbKjzrRlEpO7a9i5T5iBK7gd3hKg7ZdqJnwfexy41JdGhoAT7J7iHB2mblzL+bpg8KDnNG+Bjb64iLoJ0Xw19Msxx1msQ0LeXTXfgIMrkiuiXS5f0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247180; c=relaxed/simple;
	bh=4Ip+XRkLM+YqGPFaFcZI2LmGBxK7la+VMiZ3Wi9Isi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNBBFhTOjjZCJzqRLJKfDKV0FzW3P/khb+JguEN5Ib2QuyKYuUNKpU6u4UIN/gz6zhk+dZIonzIwLD91fH+a92d6GPvBKsOqSsVQFDeIqnPfSi8DX8xZjvnpOiKho4ysoGqnj5OSLD9IMpC5xwaB8jZVZHJcSCPCLx3ozwj/wCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9m15JLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9m15JLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FBB1F00A3A;
	Thu, 20 Aug 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247177;
	bh=9yAt0PdPKJl+d3iRIv750GuGys/JJtDBmBYOyc4BsVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9m15JLM2LA6QO8DdQKu0mpyRoN6RQskn3Usg0hpKSD+rC5aNRdEXyL6lL94aUPj1
	 wsPVC7igNz92fYFmtlPAB6X4HOeg4vm4NHlFZjPMmC3bFNVs9Q/YDsrxC3fMoR3hgg
	 N7Y9VqDCptNl7kapyaChVx+8vlmt1v6x5HP6BIFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/220] net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()
Date: Thu, 20 Aug 2026 16:56:05 +0200
Message-ID: <20260820145228.735943412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tap.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1199,10 +1199,21 @@ static int tap_get_user_xdp(struct tap_q
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
@@ -1210,15 +1221,8 @@ static int tap_get_user_xdp(struct tap_q
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


