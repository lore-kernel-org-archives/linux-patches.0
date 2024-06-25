Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674813C90B;
	Tue, 25 Jun 2024 10:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309695; cv=none; b=oj0EyOSkB4ZfT6YGiVlIFZARAtpmMCa1XW+G2vB9lecwCjddgINL9ZOnP9ULcq1mNcucg1JUJoQJq+cXeV3ieCqSOnqxJxNgFu5fzTVfLjfu2hOuH/UXwdBhhe/ysLRV1VehPLunooh6o/P6MDvnd1RXdBJS+96XmPucGSVL4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309695; c=relaxed/simple;
	bh=cfqRFxd9g1FbPN/wVJYI1Kt91LDsxwp3sOQDPwD7akk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVHvQQ9CbilkD1bA5d6Yyur+uh/W8BCzHYxBagOANP4X996z0UEoLiyiBc6weIST8c556AJ91XRf/4YXLPnohiVD+zGkNmXyQ9UYgtqDY+IJWYUb/aGtl/E/+/vK66nxn1buqLBS0euWTJvXyV0XPnTEC/cVSZs6Zvjkm/bj6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SpSNduX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SpSNduX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737EDC32781;
	Tue, 25 Jun 2024 10:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309695;
	bh=cfqRFxd9g1FbPN/wVJYI1Kt91LDsxwp3sOQDPwD7akk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SpSNduXYMv0/U9eR0NHvqcl5+Pb2RcrwSuWRWgZg35VqfRS8J8kYRhgUwcFBiFSi
	 ERzMjR4QPGIcq8l/ScSBt01pzrA0Cz/vCGLggGQ72SJHcRNG+UslqyALdHbyUZQPTw
	 5TVCD/KiyM+CtEBLCE+L6Hn1wAxpVonSk+wfdqNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/131] virtio_net: checksum offloading handling fix
Date: Tue, 25 Jun 2024 11:33:46 +0200
Message-ID: <20240625085528.641611936@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit 604141c036e1b636e2a71cf6e1aa09d1e45f40c2 ]

In virtio spec 0.95, VIRTIO_NET_F_GUEST_CSUM was designed to handle
partially checksummed packets, and the validation of fully checksummed
packets by the device is independent of VIRTIO_NET_F_GUEST_CSUM
negotiation. However, the specification erroneously stated:

  "If VIRTIO_NET_F_GUEST_CSUM is not negotiated, the device MUST set flags
   to zero and SHOULD supply a fully checksummed packet to the driver."

This statement is inaccurate because even without VIRTIO_NET_F_GUEST_CSUM
negotiation, the device can still set the VIRTIO_NET_HDR_F_DATA_VALID flag.
Essentially, the device can facilitate the validation of these packets'
checksums - a process known as RX checksum offloading - removing the need
for the driver to do so.

This scenario is currently not implemented in the driver and requires
correction. The necessary specification correction[1] has been made and
approved in the virtio TC vote.
[1] https://lists.oasis-open.org/archives/virtio-comment/202401/msg00011.html

Fixes: 4f49129be6fa ("virtio-net: Set RXCSUM feature if GUEST_CSUM is available")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 32cddb633793d..61cc0ed1ddc13 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3818,8 +3818,16 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
-		dev->features |= NETIF_F_RXCSUM;
+
+	/* 1. With VIRTIO_NET_F_GUEST_CSUM negotiation, the driver doesn't
+	 * need to calculate checksums for partially checksummed packets,
+	 * as they're considered valid by the upper layer.
+	 * 2. Without VIRTIO_NET_F_GUEST_CSUM negotiation, the driver only
+	 * receives fully checksummed packets. The device may assist in
+	 * validating these packets' checksums, so the driver won't have to.
+	 */
+	dev->features |= NETIF_F_RXCSUM;
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
 		dev->features |= NETIF_F_GRO_HW;
-- 
2.43.0



