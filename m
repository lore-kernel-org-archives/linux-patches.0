Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA1232692B;
	Wed,  8 Apr 2026 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674925; cv=none; b=VbRtXIJ5rbZIWAQYAGYuqRBrisXogooSUZAcQ6QYAqq9xVMzQh6iaIoxjb0Y1QCwQ4lnXg/nzbN02TiasgVVoCQrDxg4Y9m80gy2QGdXsT8tz8wqc5NAcxHp6uaOQ794/MRDFymCtOAHQz6VpfHwEEaIx3eM2JwgsuYpxcKlnG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674925; c=relaxed/simple;
	bh=dXaP59EI5+tcNDh6U+k3NHP53kWSZOMBXRpOptHfgUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCcdE6ngiFsRaxKgXZhfzmUGmHuCRk22kYVZleK+XdnSXctPNXnbbZNO3eMjXtcYuuNJ6VOWmFMRvDhFippYp7qscvcJy1IxLhmL0qvLjviBQtg7l7qNLESV/ppWpYl4YuqVLnU5pUeRzCQAh34YLVtkkEWI/Ab5d5xaOkxTfT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po41f+kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po41f+kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EBBC19421;
	Wed,  8 Apr 2026 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674925;
	bh=dXaP59EI5+tcNDh6U+k3NHP53kWSZOMBXRpOptHfgUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Po41f+kfZzhdgBgIgd09hacJn1Mg7bhtWCBors2GF57QrvZjX47JzEg7d/DvWszbv
	 EEPHH6LWmyKO9JyzxwJoUVjJJl7flqJL3Q2/8LLsJyeGrvO4NbZCASsXbVGZtnYOOt
	 ZSlKfu7OAo1OhcUcWO36yXy7cuuDKWtTyojUUOFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 279/311] virtio_net: clamp rss_max_key_size to NETDEV_RSS_KEY_LEN
Date: Wed,  8 Apr 2026 20:04:39 +0200
Message-ID: <20260408175949.798289079@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

commit b4e5f04c58a29c499faa85d12952ca9a4faf1cb9 upstream.

rss_max_key_size in the virtio spec is the maximum key size supported by
the device, not a mandatory size the driver must use. Also the value 40
is a spec minimum, not a spec maximum.

The current code rejects RSS and can fail probe when the device reports a
larger rss_max_key_size than the driver buffer limit. Instead, clamp the
effective key length to min(device rss_max_key_size, NETDEV_RSS_KEY_LEN)
and keep RSS enabled.

This keeps probe working on devices that advertise larger maximum key sizes
while respecting the netdev RSS key buffer size limit.

Fixes: 3f7d9c1964fc ("virtio_net: Add hash_key_length check")
Cc: stable@vger.kernel.org
Signed-off-by: Srujana Challa <schalla@marvell.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260326142344.1171317-1-schalla@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -381,8 +381,6 @@ struct receive_queue {
 	struct xdp_buff **xsk_buffs;
 };
 
-#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
-
 /* Control VQ buffers: protected by the rtnl lock */
 struct control_buf {
 	struct virtio_net_ctrl_hdr hdr;
@@ -486,7 +484,7 @@ struct virtnet_info {
 
 	/* Must be last as it ends in a flexible-array member. */
 	TRAILING_OVERLAP(struct virtio_net_rss_config_trailer, rss_trailer, hash_key_data,
-		u8 rss_hash_key_data[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+		u8 rss_hash_key_data[NETDEV_RSS_KEY_LEN];
 	);
 };
 static_assert(offsetof(struct virtnet_info, rss_trailer.hash_key_data) ==
@@ -6708,6 +6706,7 @@ static int virtnet_probe(struct virtio_d
 	struct virtnet_info *vi;
 	u16 max_queue_pairs;
 	int mtu = 0;
+	u16 key_sz;
 
 	/* Find if host supports multiqueue/rss virtio_net device */
 	max_queue_pairs = 1;
@@ -6842,14 +6841,13 @@ static int virtnet_probe(struct virtio_d
 	}
 
 	if (vi->has_rss || vi->has_rss_hash_report) {
-		vi->rss_key_size =
-			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
-		if (vi->rss_key_size > VIRTIO_NET_RSS_MAX_KEY_SIZE) {
-			dev_err(&vdev->dev, "rss_max_key_size=%u exceeds the limit %u.\n",
-				vi->rss_key_size, VIRTIO_NET_RSS_MAX_KEY_SIZE);
-			err = -EINVAL;
-			goto free;
-		}
+		key_sz = virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+
+		vi->rss_key_size = min_t(u16, key_sz, NETDEV_RSS_KEY_LEN);
+		if (key_sz > vi->rss_key_size)
+			dev_warn(&vdev->dev,
+				 "rss_max_key_size=%u exceeds driver limit %u, clamping\n",
+				 key_sz, vi->rss_key_size);
 
 		vi->rss_hash_types_supported =
 		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));


