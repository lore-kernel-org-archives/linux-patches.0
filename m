Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802C844213E;
	Thu, 30 Jul 2026 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423960; cv=none; b=hvDpaZIXVSJi8OwUuTDSYRPGFOlQJzUNYleF8niHUaaO6ctuPXbNtMZbX6WwneE5i8PS4t61lvpaSXsJVRipNQJmP+APXNwjVObQ1shvGB4ETo8KHhOLYSQFSNENH3yKAg+1r3XTBdUo1VBkfIwXAUlKnMmR1TX0RmOx452di7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423960; c=relaxed/simple;
	bh=7a8x8NQX4zJeVZYv6bb77ro5sEIgdPpNnBub8OTeawU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdS6shjL+vNClphPZh4R5gYjRUKMIlZkm0zNXDASIE93Rp0DvJN1eZS4j3xFJwSxU9t4iqTLZYXSiYQoT62sAzuCdhHnNjX1YQUXYQpCD2CXMk8iPNWYcDSGe1ibNaJo/rdlFastOsbvdZF2Jnxd6Q4auk60+fAb/cmdYkUKzd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6iVQuxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6iVQuxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCA01F000E9;
	Thu, 30 Jul 2026 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423959;
	bh=S1B9L+I+jz1yr6e06qakXWpZKOmG4gLk/aCLPsONqPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6iVQuxO4JUOz3Rg7OSBFPZbYk0l/0xFbJlZSzgCY/JReMCRhavexBwMkDev3OLmH
	 svXugvYLrsI0Mizzp8Fsa5cWAWIUpcBss/sr12n0rtPbuRMxIcl9fkaItMyC1yBeM6
	 GwwK+i3PYabHsapiA8tzbxjPo+44+/rTl2IABQCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Zanda <enrico.zanda@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/675] vhost-net: fix TX stall when vhost owns virtio-net header
Date: Thu, 30 Jul 2026 16:09:17 +0200
Message-ID: <20260730141449.965382728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Enrico Zanda <enrico.zanda@arm.com>

[ Upstream commit 3c0d10f233f19153f81fef685b5c6716776a5af3 ]

When vhost owns the virtio-net header, i.e. when
VHOST_NET_F_VIRTIO_NET_HDR is negotiated, sock_hlen is 0,
meaning that no header will be forwarded to the TAP device.

In the current vhost_net_build_xdp() implementation,
when sock_hlen == 0, the gso pointer can point at the start of the
Ethernet frame instead of a virtio-net header.
This results in a wrong interpretation of the destination MAC address
bytes as struct virtio_net_hdr fields.

This can, for some MAC addresses, trigger -EINVAL and return early
before the TX descriptor is completed, which can stall vhost-net TX.

Before 97b2409f28e0, the gso pointer was set to the zeroed padding area,
using it as a synthetic virtio-net header. Restore that behavior.

Fixes: 97b2409f28e0 ("vhost-net: reduce one userspace copy when building XDP buff")
Signed-off-by: Enrico Zanda <enrico.zanda@arm.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260708152242.2268848-1-enrico.zanda@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b2b90732b1d595..89d5438ba7af97 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -724,10 +724,12 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 		goto err;
 	}
 
-	gso = buf + pad - sock_hlen;
-
-	if (!sock_hlen)
+	if (!sock_hlen) {
 		memset(buf, 0, pad);
+		gso = buf;
+	} else {
+		gso = buf + pad - sock_hlen;
+	}
 
 	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
 	    vhost16_to_cpu(vq, gso->csum_start) +
-- 
2.53.0



