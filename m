Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8A24889B;
	Mon, 24 Feb 2025 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408063; cv=none; b=JwX48YwNsQAITZLcf+B7y4woHAKlJGinmt4WuqATWri6K5UvDqEoggOOptAJqgBpbUwdUELFZZITWGapgabP4E1+UCnHtO2hgBZL/uhYylQ1VJ1l4sQBO53vk6G9y2eoWCb9T9Y8YuZM8Cv7lndFEr0bjwH6l5SHtcl5/QLH+dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408063; c=relaxed/simple;
	bh=YRZJucXn0zLHhnLHVps9osRXA+KSWkLKyZsmjLx2MsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKspyK6Ur/0v+hfyuEYMoWQcoSRIwcnowbwpmrEznHvK/+4L16+bWpWPH00WQOEauPxrEX+ZNKGH1O6jaNs2fO6C8Z1zaWhFC2SV72UKxp/S6dCajJ/iktQ0Qx+HH+cvUqrLuBZbsUX8KtvbiOYDUSvYnw+gqMXOK6fUCwhkXPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIhSdf9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIhSdf9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DFCC4CED6;
	Mon, 24 Feb 2025 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408063;
	bh=YRZJucXn0zLHhnLHVps9osRXA+KSWkLKyZsmjLx2MsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIhSdf9Xy4pxBQ8VAQaSnSwK1a9Gl/XcSIpq7Iy86CfJid9K/umwdNmipQrBCmZID
	 CUp5Yz4TsrX5z2N1xnCLnp4SMPoIX6UPvAZLaIUQdf7vAt11HKLSifCDmNAfnsp5G1
	 /dR/bI5BhNNWkb/QBbV1jW7R9MS+ExdG/9eXZLaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/140] tcp: drop secpath at the same time as we currently drop dst
Date: Mon, 24 Feb 2025 15:34:48 +0100
Message-ID: <20250224142606.511672530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 9b6412e6979f6f9e0632075f8f008937b5cd4efd ]

Xiumei reported hitting the WARN in xfrm6_tunnel_net_exit while
running tests that boil down to:
 - create a pair of netns
 - run a basic TCP test over ipcomp6
 - delete the pair of netns

The xfrm_state found on spi_byaddr was not deleted at the time we
delete the netns, because we still have a reference on it. This
lingering reference comes from a secpath (which holds a ref on the
xfrm_state), which is still attached to an skb. This skb is not
leaked, it ends up on sk_receive_queue and then gets defer-free'd by
skb_attempt_defer_free.

The problem happens when we defer freeing an skb (push it on one CPU's
defer_list), and don't flush that list before the netns is deleted. In
that case, we still have a reference on the xfrm_state that we don't
expect at this point.

We already drop the skb's dst in the TCP receive path when it's no
longer needed, so let's also drop the secpath. At this point,
tcp_filter has already called into the LSM hooks that may require the
secpath, so it should not be needed anymore. However, in some of those
places, the MPTCP extension has just been attached to the skb, so we
cannot simply drop all extensions.

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/5055ba8f8f72bdcb602faa299faca73c280b7735.1739743613.git.sd@queasysnail.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h       | 14 ++++++++++++++
 net/ipv4/tcp_fastopen.c |  4 ++--
 net/ipv4/tcp_input.c    |  8 ++++----
 net/ipv4/tcp_ipv4.c     |  2 +-
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b3917af309e0f..78c755414fa87 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -40,6 +40,7 @@
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
+#include <net/xfrm.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -630,6 +631,19 @@ void tcp_fin(struct sock *sk);
 void tcp_check_space(struct sock *sk);
 void tcp_sack_compress_send_ack(struct sock *sk);
 
+static inline void tcp_cleanup_skb(struct sk_buff *skb)
+{
+	skb_dst_drop(skb);
+	secpath_reset(skb);
+}
+
+static inline void tcp_add_receive_queue(struct sock *sk, struct sk_buff *skb)
+{
+	DEBUG_NET_WARN_ON_ONCE(skb_dst(skb));
+	DEBUG_NET_WARN_ON_ONCE(secpath_exists(skb));
+	__skb_queue_tail(&sk->sk_receive_queue, skb);
+}
+
 /* tcp_timer.c */
 void tcp_init_xmit_timers(struct sock *);
 static inline void tcp_clear_xmit_timers(struct sock *sk)
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 0f523cbfe329e..32b28fc21b63c 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -178,7 +178,7 @@ void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb)
 	if (!skb)
 		return;
 
-	skb_dst_drop(skb);
+	tcp_cleanup_skb(skb);
 	/* segs_in has been initialized to 1 in tcp_create_openreq_child().
 	 * Hence, reset segs_in to 0 before calling tcp_segs_in()
 	 * to avoid double counting.  Also, tcp_segs_in() expects
@@ -195,7 +195,7 @@ void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb)
 	TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_SYN;
 
 	tp->rcv_nxt = TCP_SKB_CB(skb)->end_seq;
-	__skb_queue_tail(&sk->sk_receive_queue, skb);
+	tcp_add_receive_queue(sk, skb);
 	tp->syn_data_acked = 1;
 
 	/* u64_stats_update_begin(&tp->syncp) not needed here,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6074b4c3ab940..10d38ec0ff5ac 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4874,7 +4874,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		tcp_rcv_nxt_update(tp, TCP_SKB_CB(skb)->end_seq);
 		fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
 		if (!eaten)
-			__skb_queue_tail(&sk->sk_receive_queue, skb);
+			tcp_add_receive_queue(sk, skb);
 		else
 			kfree_skb_partial(skb, fragstolen);
 
@@ -5065,7 +5065,7 @@ static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
 				  skb, fragstolen)) ? 1 : 0;
 	tcp_rcv_nxt_update(tcp_sk(sk), TCP_SKB_CB(skb)->end_seq);
 	if (!eaten) {
-		__skb_queue_tail(&sk->sk_receive_queue, skb);
+		tcp_add_receive_queue(sk, skb);
 		skb_set_owner_r(skb, sk);
 	}
 	return eaten;
@@ -5148,7 +5148,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		__kfree_skb(skb);
 		return;
 	}
-	skb_dst_drop(skb);
+	tcp_cleanup_skb(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
 	reason = SKB_DROP_REASON_NOT_SPECIFIED;
@@ -6098,7 +6098,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 			/* Bulk data transfer: receiver */
-			skb_dst_drop(skb);
+			tcp_cleanup_skb(skb);
 			__skb_pull(skb, tcp_header_len);
 			eaten = tcp_queue_rcv(sk, skb, &fragstolen);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 705320f160ac8..2f49a504c9d3e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1842,7 +1842,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	 */
 	skb_condense(skb);
 
-	skb_dst_drop(skb);
+	tcp_cleanup_skb(skb);
 
 	if (unlikely(tcp_checksum_complete(skb))) {
 		bh_unlock_sock(sk);
-- 
2.39.5



