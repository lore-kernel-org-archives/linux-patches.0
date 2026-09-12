Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5F2EF653;
	Sat, 12 Sep 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226319; cv=none; b=EhbwyVHZXnUIRNPtzo1sasri9Te6ex9yngeqm99Dh0lv2iSEffnauVVhkTNTUZcMVVfabso1rbHOOsj7GwboJJmv1rWA6pb/j+zn3HpQjgWq+GALFiXveZ+IakYGFi+68chpM2uCwNfcVay6rLwwCvuelfiTukC5s5J8E3wYP0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226319; c=relaxed/simple;
	bh=dNon+eT+hCExhnCBqt3m98NBTMAZJ4NSF5j0KYPv+90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWtcN9TcJOWWegyYalV0nkD8DDjz28XE2p08gk6OQ8lEKOW7U1Wn27d8g5YpGhrm3h35u3hs4ALQGh5NNiEOYHAhx5CuP2v2LqsEyMNyD2UixB2PYsSt//G7dMxmnIFrUkgPl8V2f4iBDnbuenKdUgCsCNr4sf8W5DC7aA03bQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9oIZZw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9oIZZw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860FF1F000FF;
	Sat, 12 Sep 2026 15:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226318;
	bh=uxMmdgeh1nEPxhcZOUFl9STQ/PLHaI41aK2YVPNjSBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9oIZZw+j/fQYn+tHAsDOOfvUpaUeM9Pc39RikCGYey8/KI9o6hVOxYtjsj9bdSka
	 JEs7rnZNio3+kyBpD/1s42uRf8L9K4O7VU89/bFJYZPQi8pWD/AanoJn+ITqmpXHKG
	 ZCxXBgeosn+5KGz/xj8wugZmysSEgpY823tVIdAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1379/1424] virtio-net: Ensure that TCP packets dont overflow gso_segs
Date: Sat, 12 Sep 2026 09:03:31 +0200
Message-ID: <20260912065638.140001355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02a9f4dc594d0..d2cab10569644 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -6,6 +6,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/udp.h>
+#include <net/tcp.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/virtio_net.h>
 
@@ -178,6 +179,9 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
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



