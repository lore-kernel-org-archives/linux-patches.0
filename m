Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E918A33032E;
	Wed,  3 Dec 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777125; cv=none; b=poGjdlY759hZzHIb5SKxjB6h+l2tIxBhMNf9Z4qNcQEpaisA/veU/nsjF8Qb5rC+5bSjyiB36DsL1LBkMnaQinnUexguPTxLjkQMAFYRQT1+A2Qg35CwfpUBdRacKNw+8e1hxy8S3UBpYmjWkTFwl0EycvnOM+6Wh2nH+dPTXe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777125; c=relaxed/simple;
	bh=1jboQfgkXuZVm1N8MAljNmfUuUcOjQvsPwLYFKAb+mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnnlZQD3h/42uKBgzxojsXhw29dvA6TKZRy4rg6eAjnfZUv2DCcZCdjQKqhUsL4qqS1AxfSiuwP+lYxecvWbvmYWIZvSdw4uY6Q9+KywE6AvacmtUMNOSUbkaJav1FpjEVQANv6nJFj+EZw7hB3Q7JEvUn6wECW67chM16m798o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2wrmmSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2wrmmSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDEDC116B1;
	Wed,  3 Dec 2025 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777124;
	bh=1jboQfgkXuZVm1N8MAljNmfUuUcOjQvsPwLYFKAb+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2wrmmSb+2qyYp7OjNR3vQ3myAnAYZZyUWYGUFdrrzW8zYCxRWTUM3RLxHi9GEhc8
	 GqixRdZ/Le7q8hSa9kcMvQ+BogqwWmtd9+dYzIgkMgj9QhSwZKGF5Y0WOhbVL/Xm14
	 hLmtN0fcBQ0dqcXjmKFYFgF42UX0gY5i9rTvlcHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Kohler <jon@nutanix.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 072/146] virtio-net: avoid unnecessary checksum calculation on guest RX
Date: Wed,  3 Dec 2025 16:27:30 +0100
Message-ID: <20251203152349.102083394@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Kohler <jon@nutanix.com>

commit 1cd1c472343b06d6d32038636ce51bfa2251e3cf upstream.

Commit a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP
GSO tunneling.") inadvertently altered checksum offload behavior
for guests not using UDP GSO tunneling.

Before, tun_put_user called tun_vnet_hdr_from_skb, which passed
has_data_valid = true to virtio_net_hdr_from_skb.

After, tun_put_user began calling tun_vnet_hdr_tnl_from_skb instead,
which passes has_data_valid = false into both call sites.

This caused virtio hdr flags to not include VIRTIO_NET_HDR_F_DATA_VALID
for SKBs where skb->ip_summed == CHECKSUM_UNNECESSARY. As a result,
guests are forced to recalculate checksums unnecessarily.

Restore the previous behavior by ensuring has_data_valid = true is
passed in the !tnl_gso_type case, but only from tun side, as
virtio_net_hdr_tnl_from_skb() is used also by the virtio_net driver,
which in turn must not use VIRTIO_NET_HDR_F_DATA_VALID on tx.

cc: stable@vger.kernel.org
Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20251125222754.1737443-1-jon@nutanix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun_vnet.h     |    2 +-
 drivers/net/virtio_net.c   |    3 ++-
 include/linux/virtio_net.h |    7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -244,7 +244,7 @@ tun_vnet_hdr_tnl_from_skb(unsigned int f
 
 	if (virtio_net_hdr_tnl_from_skb(skb, tnl_hdr, has_tnl_offload,
 					tun_vnet_is_little_endian(flags),
-					vlan_hlen)) {
+					vlan_hlen, true)) {
 		struct virtio_net_hdr_v1 *hdr = &tnl_hdr->hash_hdr.hdr;
 		struct skb_shared_info *sinfo = skb_shinfo(skb);
 
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3340,7 +3340,8 @@ static int xmit_skb(struct send_queue *s
 		hdr = &skb_vnet_common_hdr(skb)->tnl_hdr;
 
 	if (virtio_net_hdr_tnl_from_skb(skb, hdr, vi->tx_tnl,
-					virtio_is_little_endian(vi->vdev), 0))
+					virtio_is_little_endian(vi->vdev), 0,
+					false))
 		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -384,7 +384,8 @@ virtio_net_hdr_tnl_from_skb(const struct
 			    struct virtio_net_hdr_v1_hash_tunnel *vhdr,
 			    bool tnl_hdr_negotiated,
 			    bool little_endian,
-			    int vlan_hlen)
+			    int vlan_hlen,
+			    bool has_data_valid)
 {
 	struct virtio_net_hdr *hdr = (struct virtio_net_hdr *)vhdr;
 	unsigned int inner_nh, outer_th;
@@ -394,8 +395,8 @@ virtio_net_hdr_tnl_from_skb(const struct
 	tnl_gso_type = skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL |
 						    SKB_GSO_UDP_TUNNEL_CSUM);
 	if (!tnl_gso_type)
-		return virtio_net_hdr_from_skb(skb, hdr, little_endian, false,
-					       vlan_hlen);
+		return virtio_net_hdr_from_skb(skb, hdr, little_endian,
+					       has_data_valid, vlan_hlen);
 
 	/* Tunnel support not negotiated but skb ask for it. */
 	if (!tnl_hdr_negotiated)


