Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466F61C6881;
	Tue, 27 Aug 2024 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772823; cv=none; b=niSYPRvYfxQAoNx44JCzyxYt9weaPbjMNX0X9Dgs4N297hkvE+mlwRwGJuoRktuQf/bA9qqSgbNDO+8EOgR6EtHWVwvRBusJ5RfZRcP+VeyVDEh4tqrgQLzS2ptttTEbe5euioTw4HLKna1ZMRmntSoqsC3ejFSmqj7orLD/ELE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772823; c=relaxed/simple;
	bh=0jUYRQSgQEkHhZswmILE+kEgYgvmkuCWzXvO4D2pZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmrySnWUSKUVU9IkDUW3cnt7X5XxprAGutdR5N8JNsyMXlcaqkvWL4m8xNrT9MR1k3zvCbxjeLR061HIthosir7lxSw+E9/0FPKeV96QElpBBy7e/pOc4BNaIh2TGAtPBi58lTPU3HVUC8a6VXnVOWNuKkw2ArJXTLQBvKZZAPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVQMLKEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVQMLKEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A942AC61052;
	Tue, 27 Aug 2024 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772823;
	bh=0jUYRQSgQEkHhZswmILE+kEgYgvmkuCWzXvO4D2pZJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVQMLKEXrkd1yA3v0RfX0vI4db9rDQ8dGod0F9P5gDehYEDXZBG9GueNahR2USU8s
	 nz4ZgxhsyGD3inKEJl0BRd3rAVOB0Lo9EU3QrTMKsnQmuVjqReiahIkpS0JSfKg6zY
	 aKJxezn1bd/fOp6ZF6fo97KfPB+NoIOdAxcqqp8M=
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
Subject: [PATCH 6.1 302/321] net: more strict VIRTIO_NET_HDR_GSO_UDP_L4 validation
Date: Tue, 27 Aug 2024 16:40:10 +0200
Message-ID: <20240827143849.752339387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
 include/linux/virtio_net.h |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

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
@@ -155,9 +155,22 @@ retry:
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


