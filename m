Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE7405C2D;
	Wed, 20 May 2026 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302568; cv=none; b=KIL9TMYueXTLvZThFdb9A28aYC5lp7Yj/r9zzBqHgI78zOoeibAj+SJnmFWhC0cpHUdcRoquWdhMmPR3O9WRE9LlFOH9bvOqXfudynZsGfskV1f6FmXkmSEhzz572bLjbU+O8OSUB43gYbKTdiHWjNnH6Tn95GHYp5WoM/TE0K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302568; c=relaxed/simple;
	bh=bIvID8CagBNeoFB2wKkO9hn6qTr+v4q1vzLjOZEHm30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qha+EKF5BhWCh8HUKMqBA02GNlrmiS8V3KecJ1SoZfZuZabwP35q/r6VDslw7DfK8njfjuOW9VHXx/Xcb13+XkGsGJuyn6dG7DSOwvD37GMXhwUj9QCqpq3AoaWbonEKMM9EEs7WjVtvxMmpeXThbqoxe5fEVYnHvncY4pPESyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMWJ1yLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMWJ1yLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E8A1F000E9;
	Wed, 20 May 2026 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302567;
	bh=QoZ4sZrrtrjLxGITU3xnV+GxTjKT/qWiM5SjZCXB+mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMWJ1yLlmV5JKyKOXdpNrVwD10B3e1yi4ugNpJkX9YCJCmHSqXnxHmAqQsvWT3gHn
	 5mPNakOZ/xKBktLCBvedxaWbbgjfMkqUydqv+rco9R7p5tvLC8TpCoSRGghJVpYstR
	 VKl8YTBQttxpMTkXzj6KSPOSBSZ71LXE4k3ootno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/508] tcp: annotate data-races around tp->bytes_retrans
Date: Wed, 20 May 2026 18:22:20 +0200
Message-ID: <20260520162105.506120104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5efc7b9f7cbd43401f1af81d3d7f2be00f93390d ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: fb31c9b9f6c8 ("tcp: add data bytes retransmitted stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c6b58bbb43c8a..2ab4b8f4d8d10 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3988,8 +3988,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, READ_ONCE(tp->bytes_sent),
 			  TCP_NLA_PAD);
-	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS, tp->bytes_retrans,
-			  TCP_NLA_PAD);
+	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS,
+			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, tp->dsack_dups);
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1fd807236c651..ea982c3670d33 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3350,7 +3350,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 	WRITE_ONCE(tp->total_retrans, tp->total_retrans + segs);
-	tp->bytes_retrans += skb->len;
+	WRITE_ONCE(tp->bytes_retrans, tp->bytes_retrans + skb->len);
 
 	/* make sure skb->data is aligned on arches that require it
 	 * and check if ack-trimming & collapsing extended the headroom
-- 
2.53.0



