Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1B438A701;
	Sat, 12 Sep 2026 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205412; cv=none; b=Qzo50VeW80NiUCvoC1JdeI5lxqanCNEJHeH4zEmZOgf67nM7ncxRtjp0z5lzK+R0PakcUjAAZThdoRw2/Qv5v/bUlfZpA43Qjp/n94XAoM0T/YZ4FEuk4ZLoR2FS8Ox3G8/ztwDElemzXTOdZl5TKqccmS8sO9IbUnhDJSVjtew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205412; c=relaxed/simple;
	bh=R2mfv7LcwyAZx4B83JLDbywVrfWXwd8As9l+9cBDQAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuVo7JW3HeHam+uSkP2MN0x2D/g3VsliAfs+KefYvDVBp48HPYh8mjm32NTua/YzDKOMZ/XTwwNc8NhzH9l73C8Pwo01JAYNyarlQX/bmhePgJKC1Zm5DncppuNtcLTi1oYNgcjykLizHmV8c92uPkz0a0Iuu36fWjhx+6zLW28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIZDZdFr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIZDZdFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2E11F000FF;
	Sat, 12 Sep 2026 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205411;
	bh=mWjvp7foVtlxalQ64C4ojGaZ0TCErEhjEf73hO7an0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIZDZdFrxhim8uZlUBQmUOZspO1TgbMx9m3I+jQQLLfaz120QzDkWgwY4OdaQEL09
	 H7o6BdzGTGntq979aXCIE/xvN6fdivNz4lrjbGhOQ6WUgIY1HtrWvsO9CP6VZ0NWpj
	 zaAuZImxj3xJJw8GGHRhuYlXrFkgoRcXw8L8BlR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1785/1815] virtio-net: Ensure that TCP packets dont overflow gso_segs
Date: Sat, 12 Sep 2026 08:58:55 +0200
Message-ID: <20260912065730.937871173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



