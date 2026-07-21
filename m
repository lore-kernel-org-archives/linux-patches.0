Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4746F4A7;
	Tue, 21 Jul 2026 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656754; cv=none; b=GkW2os6W1fUZIa7NLVolkHNPCJLcFcG3DotcnKoZ/9uM5b7LsiCVE8vADX4HNVWBM+g3gZ0iwpMpnICJD62ckO33GDps2ooLCnNoUPLVBIudpdauKZkS0udjhomwRvrdV63GKKp2fU3ZpHr1OQJbiU91uuopDObTFXjPSqba0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656754; c=relaxed/simple;
	bh=h25tIp/X+jxONgMGa879B6gic7MAcqc0hrbGg4xgLCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAxX97h0peML5auFR7UKJmySToawfOt35O/FxAMGV7x8FnueWmfrrISjxOJswPB9JvNw6ii69I11g2Dteo02KKAVPSDDikTUbykxkaRDg/SuS5HwM3E1sQTCFFQvDtYhQl6SwRpRaEeuE2U8RQRoWrVSp8627v4ZdcdAIl3gJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogP2NRKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogP2NRKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A1E1F000E9;
	Tue, 21 Jul 2026 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656753;
	bh=QgMwlaLR3jBE/GeCh4fiM7k/xisWo1O329kmgSgZ6ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogP2NRKdLMzsJ+iO2NPg2WPbKPBNWyhKLDXH4+gjdKC0LFVs4yphuT9O6uMU3tyRU
	 jMmr5ea5Bduj5OolbtZuYi6GwpPwdrBBkaiS0v57G4DKIMXXug5HE+C7TDAY9IYcS9
	 pxRGkzXY+fE+T3HWg/mNj8VhvSucsgwfcY0QIuZ4=
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
Subject: [PATCH 6.18 0504/1611] virtio_net: do not allow tunnel csum offload for non GSO packets
Date: Tue, 21 Jul 2026 17:10:20 +0200
Message-ID: <20260721152526.682987840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aed65dbf3fca0c..8f7872d65a6168 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6280,6 +6280,19 @@ static void virtnet_free_irq_moder(struct virtnet_info *vi)
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
@@ -6293,7 +6306,7 @@ static const struct net_device_ops virtnet_netdev = {
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



