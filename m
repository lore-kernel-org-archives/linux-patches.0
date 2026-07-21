Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D95D46D0A0;
	Tue, 21 Jul 2026 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659811; cv=none; b=e9ImBixXE8WQTmFQPQe3HjgxvuVJ7wSG0/IP2L6Tie+s2boRos1e+LD1htMY+ittd1bJwCsjVuJ1o+BvFfye+ZDhnI/PhERjMYpgB4bkzljaVVa9HBlFNFTgokuTM3dBHUyvLTorBuWN5MdyslVE28+Cq/xK2ZWGRm6D5WSxAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659811; c=relaxed/simple;
	bh=uiViAyBzm8+1eLDrC+JwFm8jKCwM7k+eR6j7GEXlUJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGA4gUjIzy81SBrwNiT2GRZYj5Up6DYhvwiyTK5eLnb8quriVglRtN2X0S02ZLCo4TlWKXzc7zozRDKuWsw5Up9iJYVUaaQ0T0re0dwivDGP82T5prl0IQ9BXj8/VcdyTh3QN8LuCMvRYjRJcbX/eBmUe3RQnu/mxh3ESf6Srlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xnm7MQCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xnm7MQCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B28A1F000E9;
	Tue, 21 Jul 2026 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659810;
	bh=G1XU0Ng7fYY8POyruky1XXmVfM1nTHrPJp0k25z9fU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xnm7MQCJ7aBmojS7SHXZKZEzy8CVMxQQZ7amCRqrk08qw+3Uq86gIwcKVG0v254oY
	 CUwbOh0oKJMCySmw1g6cfwnhYN/marBCxv03fHQOVFY2T51+NE5rXqDRqjHKJV9Ruz
	 QxrfuUFS7FLyET5N53irLHK7PYF8yZKrrY7wbRDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Ebner <f.ebner@proxmox.com>,
	Gabriel Goller <g.goller@proxmox.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0743/2077] virtio_net: do not allow tunnel csum offload for non GSO packets
Date: Tue, 21 Jul 2026 17:06:56 +0200
Message-ID: <20260721152610.319549419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 86c51f0f23136ea5ef5541f607287e07150cd23f ]

Fiona reports broken connectivity for virtio net setup using UDP tunnel
inside the guest and NIC with not UDP tunnel TSO support in the host.

Currently the virtio_net driver exposes csum offload for UDP-tunneled,
TCP non GSO packets. Such packet reach the host as CSUM_PARTIAL ones
with the 'encapsulation' flag cleared, as the virtio specification do
not support this specific kind of offload.

HW NICs with UDP tunnel TSO support - and those drivers directly
accessing skb->csum_start/csum_offset - are still capable of computing
the needed csum correctly, but otherwise the packets reach the wire with
bad csum on both the inner and outer transport header.

Address the issue explicitly disabling csum offload for UDP tunneled,
non GSO packets via the ndo_features_check op.

Fixes: 56a06bd40fab ("virtio_net: enable gso over UDP tunnel support.")
Reported-by: Fiona Ebner <f.ebner@proxmox.com>
Closes: https://bugzilla.proxmox.com/show_bug.cgi?id=7627
Tested-by: Fiona Ebner <f.ebner@proxmox.com>
Tested-by: Gabriel Goller <g.goller@proxmox.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Gabriel Goller <g.goller@proxmox.com>
Tested-by: Gabriel Goller <g.goller@proxmox.com>
Link: https://patch.msgid.link/6c3b6c47fb05c100f384630dc48f3975cf37b67a.1781195144.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f4adcfee7a8001..7d2eeb9b122667 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6222,6 +6222,19 @@ static void virtnet_free_irq_moder(struct virtnet_info *vi)
 	rtnl_unlock();
 }
 
+static netdev_features_t virtnet_features_check(struct sk_buff *skb,
+						struct net_device *dev,
+						netdev_features_t features)
+{
+	/* Inner csum offload is only available for GSO packets. */
+	if (skb->encapsulation &&
+	    (!skb_is_gso(skb) || netif_needs_gso(skb, features)))
+		return features & ~NETIF_F_CSUM_MASK;
+
+	/* Passthru. */
+	return features;
+}
+
 static const struct net_device_ops virtnet_netdev = {
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
@@ -6235,7 +6248,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_bpf		= virtnet_xdp,
 	.ndo_xdp_xmit		= virtnet_xdp_xmit,
 	.ndo_xsk_wakeup         = virtnet_xsk_wakeup,
-	.ndo_features_check	= passthru_features_check,
+	.ndo_features_check	= virtnet_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
 	.ndo_tx_timeout		= virtnet_tx_timeout,
-- 
2.53.0



