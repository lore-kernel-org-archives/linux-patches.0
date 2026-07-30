Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505C443F8D3;
	Thu, 30 Jul 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421869; cv=none; b=HIbM/E5En7sJjvP9qWUR/i001HfOVAyXmjc55Vljjk1ZgXLTlUn3ghNikbS3FLqrPL+UePOCAmhyYvB49MU65LJRI/Mzkwa9w/iRAsVXtTjvFzOg6HzXq+eZcg4DNjtny2Vwc5PDEUyZp4SEgmNTuBSoOiGv73IelSmq3RneIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421869; c=relaxed/simple;
	bh=wE1Am4YBYbCa8QG5tWR2Cros4bNid41b47S8N+pT8GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxIk1ak8JikWF1rh0U8wF8IQ8NbyBf6Iqq9VAeemvmtI8RU8JEDkkXhdiPpjgDKJ6tFrYX1rueXDII2lEi5Y0ie7PYWAFbxa94sZT/MaFF5fFetCWMe8Z8+KoM0++FYaMqIxGPPNpNo0HbaKarzAJSL2KgeteyVNYx+o7dyHDLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON4y0c0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON4y0c0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410541F000E9;
	Thu, 30 Jul 2026 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421867;
	bh=0reHL9lfaQwwDRE92MEhAcyj75qDhNYlVclNFU1xHp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON4y0c0TXoA/cRvFewUedVbDtCKEt2xWTQLfJ1Jr1omMiyjVXzgAo6UVsCA+2aN8M
	 OGSIlFxCmhvH1pr4tRpfql+0bCkNxrNCWqhbxQxJZBqUSUap2qD+Up/JbV3F9M1kyQ
	 J02KVf3DYzF/ZeWvh5/PENVmPzDAWDSSqa2OPIAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Zanda <enrico.zanda@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 247/744] vhost-net: fix TX stall when vhost owns virtio-net header
Date: Thu, 30 Jul 2026 16:08:40 +0200
Message-ID: <20260730141449.543593815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index b9af63fb630602..6949b704166d58 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -722,10 +722,12 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
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



