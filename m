Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E470135F15
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qli6CrDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890E2C433C8;
	Wed, 15 Nov 2023 22:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085731;
	bh=cnM7oveAIb/n9EfR1pNVxLRcKxMX0LZVzgqcSIu/FEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qli6CrDcYV+s+Y00FitxwuCARfBGlczbxYtN2zKAcd+0//EYDkaH3/CDdmBrdEh4T
	 yU7YS6NG4zQRPYZJHwR4o+kKDwTfe3xQkDw1j0eYrihs8f3+Y9xBAofPRIo0H3OTmk
	 RQzYxW62gI5mxhS57mE5VWElf483bNicdb9Jqb9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/119] tcp: Remove one extra ktime_get_ns() from cookie_init_timestamp
Date: Wed, 15 Nov 2023 17:00:07 -0500
Message-ID: <20231115220133.146975964@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 200ecef67b8d09d16ec55f91c92751dcc7a38d40 ]

tcp_make_synack() already uses tcp_clock_ns(), and can pass
the value to cookie_init_timestamp() to avoid another call
to ktime_get_ns() helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 73ed8e03388d ("tcp: fix cookie_init_timestamp() overflows")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     | 12 +++++++++---
 net/ipv4/syncookies.c |  4 ++--
 net/ipv4/tcp_output.c |  2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4fcae463ba194..2be7d26434180 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -553,7 +553,7 @@ static inline u32 tcp_cookie_time(void)
 u32 __cookie_v4_init_sequence(const struct iphdr *iph, const struct tcphdr *th,
 			      u16 *mssp);
 __u32 cookie_v4_init_sequence(const struct sk_buff *skb, __u16 *mss);
-u64 cookie_init_timestamp(struct request_sock *req);
+u64 cookie_init_timestamp(struct request_sock *req, u64 now);
 bool cookie_timestamp_decode(const struct net *net,
 			     struct tcp_options_received *opt);
 bool cookie_ecn_ok(const struct tcp_options_received *opt,
@@ -775,10 +775,16 @@ static inline u32 tcp_time_stamp(const struct tcp_sock *tp)
 	return div_u64(tp->tcp_mstamp, USEC_PER_SEC / TCP_TS_HZ);
 }
 
+/* Convert a nsec timestamp into TCP TSval timestamp (ms based currently) */
+static inline u32 tcp_ns_to_ts(u64 ns)
+{
+	return div_u64(ns, NSEC_PER_SEC / TCP_TS_HZ);
+}
+
 /* Could use tcp_clock_us() / 1000, but this version uses a single divide */
 static inline u32 tcp_time_stamp_raw(void)
 {
-	return div_u64(tcp_clock_ns(), NSEC_PER_SEC / TCP_TS_HZ);
+	return tcp_ns_to_ts(tcp_clock_ns());
 }
 
 void tcp_mstamp_refresh(struct tcp_sock *tp);
@@ -790,7 +796,7 @@ static inline u32 tcp_stamp_us_delta(u64 t1, u64 t0)
 
 static inline u32 tcp_skb_timestamp(const struct sk_buff *skb)
 {
-	return div_u64(skb->skb_mstamp_ns, NSEC_PER_SEC / TCP_TS_HZ);
+	return tcp_ns_to_ts(skb->skb_mstamp_ns);
 }
 
 /* provide the departure time in us unit */
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 3f6c9514c7a93..88d53d37fbe96 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -62,10 +62,10 @@ static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
  * Since subsequent timestamps use the normal tcp_time_stamp value, we
  * must make sure that the resulting initial timestamp is <= tcp_time_stamp.
  */
-u64 cookie_init_timestamp(struct request_sock *req)
+u64 cookie_init_timestamp(struct request_sock *req, u64 now)
 {
 	struct inet_request_sock *ireq;
-	u32 ts, ts_now = tcp_time_stamp_raw();
+	u32 ts, ts_now = tcp_ns_to_ts(now);
 	u32 options = 0;
 
 	ireq = inet_rsk(req);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 16e0249b11f6c..0107436860171 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3349,7 +3349,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	now = tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(req->cookie_ts))
-		skb->skb_mstamp_ns = cookie_init_timestamp(req);
+		skb->skb_mstamp_ns = cookie_init_timestamp(req, now);
 	else
 #endif
 	{
-- 
2.42.0



