Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571451F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE3CC433CB;
	Fri, 21 Jul 2023 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955926;
	bh=4xEtw08rc/2nHWBBHKlJLz2lOPBGeT06VfD0bBd/KSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMTMCZm4qdrqe/6BPk/JQFXHnaKIBAjZX8Hq8fUmpmeR4TT3B0s7QMgbitmm2SfP1
	 lCHUCgkmA8E4YnqSys+MKUmXvdOfZZmbICUt8VGsy9W5vjsMMDFiJDLZTBcmaY0xFR
	 Ir+0rcNT9s/sXaMGoAQYTAo3IlowEx26lNLAM6LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 051/292] udp6: add a missing call into udp_fail_queue_rcv_skb tracepoint
Date: Fri, 21 Jul 2023 18:02:40 +0200
Message-ID: <20230721160530.994492935@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Babrou <ivan@cloudflare.com>

[ Upstream commit 8139dccd464aaee4a2c351506ff883733c6ca5a3 ]

The tracepoint has existed for 12 years, but it only covered udp
over the legacy IPv4 protocol. Having it enabled for udp6 removes
the unnecessary difference in error visibility.

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Fixes: 296f7ea75b45 ("udp: add tracepoints for queueing skb to rcvbuf")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-traces.c | 2 ++
 net/ipv6/udp.c        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 805b7385dd8da..6aef976bc1da2 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -63,4 +63,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(udp_fail_queue_rcv_skb);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(sk_data_ready);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e5a337e6b9705..debb98fb23c0b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -45,6 +45,7 @@
 #include <net/tcp_states.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_tunnel.h>
+#include <trace/events/udp.h>
 #include <net/xfrm.h>
 #include <net/inet_hashtables.h>
 #include <net/inet6_hashtables.h>
@@ -680,6 +681,7 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 		kfree_skb_reason(skb, drop_reason);
+		trace_udp_fail_queue_rcv_skb(rc, sk);
 		return -1;
 	}
 
-- 
2.39.2



