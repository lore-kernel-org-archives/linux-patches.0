Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15F18133B;
	Wed,  3 Jul 2024 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004768; cv=none; b=YFqMmXXkJTUPRyer3v0DYTJc9PDSQUpUFZfGKsQyXC/D/l2W99GesJpeRXY95A7QDWSz5H0SdYdCvYDNDx1/8lWbuT3nQQaSlOz0d9AlSs3hU6oOzh8xqFuGPM7lNL9DxJvBUvLRuUQptLPbwYnGln1zhtuAVRtzH04ojWXnAhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004768; c=relaxed/simple;
	bh=cWXTUDnIOpScoksmZWYM+AeRomocNtg1a03BNXKUO0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJIQRGnBfMxbRWbDLFE++PiMiyGRDDEbf+chiiiUmdRtFnPm2X+bj8a4tNl2I6pJGKcxaYCZLxQdIgB9AUXWo+VgeVDWMdgL3ZZyKIF1T/0Ph67gKbpGDweXSG3rlbwB434Z0i1WtcqrQylPNQtuzlAoI1baruIDl8qwLuMitFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr+fuYzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr+fuYzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09389C2BD10;
	Wed,  3 Jul 2024 11:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004768;
	bh=cWXTUDnIOpScoksmZWYM+AeRomocNtg1a03BNXKUO0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr+fuYzF3yi4MwhDZBi3WgNmILoCUdVE0VKc44N1OApDEoNfxUETCkZB3n5W4b82O
	 xQ/uuCOusl2CvTrCFkBD1iSSmSlJpQrJmDLcj+QNqsZr7JCucdML3mZo6KOU9oBOvr
	 2dAtYznnG//uAD1Vgt46I/w/LLz5ngE48cJy5bTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/290] virtio_net: checksum offloading handling fix
Date: Wed,  3 Jul 2024 12:38:52 +0200
Message-ID: <20240703102909.885015772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4029c56dfcf0f..f7ed99561c192 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3112,8 +3112,16 @@ static int virtnet_probe(struct virtio_device *vdev)
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



