Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7372BDC0E;
	Sat, 12 Sep 2026 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212454; cv=none; b=IL0yHgCToQW+UcxCASk4Pupzmmez/V4/j29ALnXk8rHto0c7zEkrfsni5DLQruWT5KX1WdBfBmGexZtbzzyuNjSqO21t0uxDWQYGm68jwr1n99tWxhpuKMnDbccggfqG945TEYQ8u9B2vFvQQgJ0kVOO7O/keO+GIFcRRwEoa1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212454; c=relaxed/simple;
	bh=EYG6YFxuw9j3ou9DdOVcyczOsXGyTohl5wKdJqEsDBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKPrOyGxd+9Bb/xIfsBZpGfLW1z9M8T67b6CB7RKcuzu3WbGVZ2KSlqmNKuOuQHXDiz2iwOH2nK7lzupW/RGFdp31p6mOm5Q0R6TAPgsSk/jUxkEMcu2KJzjyasXrM7QskjKzzhpXVDhSZOseM9Ni0R+B70q5KReoFzJ7KOHrtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6OI+3rW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6OI+3rW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EE91F00893;
	Sat, 12 Sep 2026 11:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212453;
	bh=wPWTH5xJzkWARsuquQ8wi0Zk7CgAWCGeT/rkOPDrlNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6OI+3rWgwSGIfQ1dXv7M8mEKT4w+/N/kl6olRjx1j1Ee8tBcPwH0faptnaldnD+2
	 l0uJHv4310H+36yLaa8yfHch1JS/+m5V3A3rd9BmSwdqBfVyoiw+ett+ko60yHfS9b
	 jy7eGzLg+/76wUgxb9WXLp2ujZvZP/iUsLT4h3u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1441/1518] virtio-net: Ensure that TCP packets dont overflow gso_segs
Date: Sat, 12 Sep 2026 09:00:10 +0200
Message-ID: <20260912065656.154195313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index f36d21b5bc19e..c381b916c1b54 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -6,6 +6,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/udp.h>
+#include <net/tcp.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
 
@@ -179,6 +180,9 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
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



