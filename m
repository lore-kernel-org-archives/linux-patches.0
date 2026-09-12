Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C468930DD2F;
	Sat, 12 Sep 2026 19:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240788; cv=none; b=UdSUhIFIWvq0IV6WQ8iacDLAWg2rEzkWxBCo/x1a+l4+9EvORXk8i4+tcgE53ZM2pZ+OzYq25CrqWL1vRQLvqYnWX+3OnGHpdf45zeeDcHijBmqwOPwWV9EsMiDOqRO5nnQLyDUIcO+FUjHHs5LetyJaOLxMIbiNFVxt/C2LP8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240788; c=relaxed/simple;
	bh=Fbwlp5FZWV3TENGjKG3/uW7GOBDKE5pLumvgJOK8jTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/EI5kMyehoAg1wG7tm8DsiqNZh/05Mh+y8GXhjhJCSTUB4Cp80TAeNJmqJhFpyN58rM0R5X7CI9/mDT8WINAuDGTsyCRQ7gk422bWgcA6PPRZyKifO9yZo5HbGuo7Fd+n0yyogUCP3l894kU0p9MvashOyGWhPrhtX+6kSHldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW/dZbVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW/dZbVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808ED1F000FF;
	Sat, 12 Sep 2026 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240786;
	bh=ZB8CUFMvKnMZBjMM88/YrrQIkibdGhT2vG2bzt2k0O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW/dZbVj0TfaKN2lAd/8fR9JA/nmEq4GyCXjsstgw+/gY+2vNKyWYMC469ZeFPabO
	 w6ujMQQhYQtfl478NVypjStEnyVmFixQ4XB40WyewrwiW+m+4mkJx7S5MJSdjU1EuE
	 a2jfScxPu2V2ihdBCsLw+9P/dI1LPrruTtbVV2Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 908/935] virtio-net: Ensure that TCP packets dont overflow gso_segs
Date: Sat, 12 Sep 2026 09:05:38 +0200
Message-ID: <20260912065547.645392924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit c27c449d455aafd9018a3cbab150f1c42c87923f ]

The user can specify any gso_size in a packet crafted with an AF_PACKET
PACKET_VNET_HDR socket, even smaller than TCP_MIN_GSO_SIZE = 8. At the
same time, GSO_MAX_SIZE = 8 * GSO_MAX_SEGS = 8 * 65535. When the user
crafts a packet with gso_size < 8, there is a risk for partial GSO to
overflow the 16-bit gso_segs field when dividing the SKB length by
gso_size.

Adjust gso_size of TCP packets to be at least TCP_MIN_GSO_SIZE = 8. Keep
gso_size of UDP GSO packets, as gso_size=1 is valid and explicitly
tested at tools/testing/selftests/net/tun.c:649.

Fixes: 7c6d2ecbda83 ("net: be more gentle about silly gso requests coming from user")
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260822120117.1163423-2-alice.kernel@fastmail.im
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 62613d4d84b71..5b3ddaa4c8815 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -4,6 +4,7 @@
 
 #include <linux/if_vlan.h>
 #include <linux/udp.h>
+#include <net/tcp.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
 
@@ -164,6 +165,9 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			if (skb->ip_summed == CHECKSUM_PARTIAL &&
 			    skb->csum_offset != offsetof(struct tcphdr, check))
 				return -EINVAL;
+
+			BUILD_BUG_ON(TCP_MIN_GSO_SIZE * GSO_MAX_SEGS < GSO_MAX_SIZE);
+			gso_size = max(gso_size, TCP_MIN_GSO_SIZE);
 			break;
 		}
 
-- 
2.53.0



