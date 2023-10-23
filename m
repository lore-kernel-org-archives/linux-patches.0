Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119A613FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyj10dIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E19DC433C7;
	Mon, 23 Oct 2023 11:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059259;
	bh=kSY42+fR68Adgo1EnYnYIec3S5fbAk3xpejJzPxmEpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyj10dIMxf82K2Q6ntOUW+gb93UwTDrAms36Pm3l94LfrFv2CS1SG2R57LWJvx3sz
	 oXQ4kzYgtmYY+40efyPBwutDIheE3bOPhjTgIqsHcASHFYxVZ7He8973b4wxkXKMaT
	 PEVMPjXp+jI/5RVydvaoi5+xvTj/nAS9tfHZ12cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01cdbc31e9c0ae9b33ac@syzkaller.appspotmail.com,
	syzbot+c99d835ff081ca30f986@syzkaller.appspotmail.com,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 091/241] net: more strict VIRTIO_NET_HDR_GSO_UDP_L4 validation
Date: Mon, 23 Oct 2023 12:54:37 +0200
Message-ID: <20231023104836.111766102@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit fc8b2a619469378717e7270d2a4e1ef93c585f7a upstream.

Syzbot reported two new paths to hit an internal WARNING using the
new virtio gso type VIRTIO_NET_HDR_GSO_UDP_L4.

    RIP: 0010:skb_checksum_help+0x4a2/0x600 net/core/dev.c:3260
    skb len=64521 gso_size=344
and

    RIP: 0010:skb_warn_bad_offload+0x118/0x240 net/core/dev.c:3262

Older virtio types have historically had loose restrictions, leading
to many entirely impractical fuzzer generated packets causing
problems deep in the kernel stack. Ideally, we would have had strict
validation for all types from the start.

New virtio types can have tighter validation. Limit UDP GSO packets
inserted via virtio to the same limits imposed by the UDP_SEGMENT
socket interface:

1. must use checksum offload
2. checksum offload matches UDP header
3. no more segments than UDP_MAX_SEGMENTS
4. UDP GSO does not take modifier flags, notably SKB_GSO_TCP_ECN

Fixes: 860b7f27b8f7 ("linux/virtio_net.h: Support USO offload in vnet header.")
Reported-by: syzbot+01cdbc31e9c0ae9b33ac@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/0000000000005039270605eb0b7f@google.com/
Reported-by: syzbot+c99d835ff081ca30f986@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/0000000000005426680605eb0b9f@google.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 7b4dd69555e4..27cc1d464321 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,8 +3,8 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <linux/udp.h>
 #include <uapi/linux/tcp.h>
-#include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
 
 static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
@@ -151,9 +151,22 @@ retry:
 		unsigned int nh_off = p_off;
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* UFO may not include transport header in gso_size. */
-		if (gso_type & SKB_GSO_UDP)
+		switch (gso_type & ~SKB_GSO_TCP_ECN) {
+		case SKB_GSO_UDP:
+			/* UFO may not include transport header in gso_size. */
 			nh_off -= thlen;
+			break;
+		case SKB_GSO_UDP_L4:
+			if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+				return -EINVAL;
+			if (skb->csum_offset != offsetof(struct udphdr, check))
+				return -EINVAL;
+			if (skb->len - p_off > gso_size * UDP_MAX_SEGMENTS)
+				return -EINVAL;
+			if (gso_type != SKB_GSO_UDP_L4)
+				return -EINVAL;
+			break;
+		}
 
 		/* Kernel has a special handling for GSO_BY_FRAGS. */
 		if (gso_size == GSO_BY_FRAGS)
-- 
2.42.0



