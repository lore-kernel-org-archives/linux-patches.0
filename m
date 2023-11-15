Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245B03A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDCmMA2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E53C433C8;
	Wed, 15 Nov 2023 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078028;
	bh=AOE0qB9gQV6O8v5IRiQXTz5N1fmEap3Jsv5VJoCTTE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDCmMA2fdu1sSGTgCrP1mBkbun57KSIjuIcywl/zKV3yhivhLqVCPNP5CwlpyLKJ7
	 X4+KA9KKviG04WFKBDoclVfwaua5+Kxeh7MWc5JFCNZgCQiH8QXOZZtVhCWS0c9cui
	 ceXgbQWasrS1OZ2TsFOUA3YkdgmgBPSxKJF3fWuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/379] tcp: fix cookie_init_timestamp() overflows
Date: Wed, 15 Nov 2023 14:22:21 -0500
Message-ID: <20231115192649.053266027@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 73ed8e03388d16c12fc577e5c700b58a29045a15 ]

cookie_init_timestamp() is supposed to return a 64bit timestamp
suitable for both TSval determination and setting of skb->tstamp.

Unfortunately it uses 32bit fields and overflows after
2^32 * 10^6 nsec (~49 days) of uptime.

Generated TSval are still correct, but skb->tstamp might be set
far away in the past, potentially confusing other layers.

tcp_ns_to_ts() is changed to return a full 64bit value,
ts and ts_now variables are changed to u64 type,
and TSMASK is removed in favor of shifts operations.

While we are at it, change this sequence:
		ts >>= TSBITS;
		ts--;
		ts <<= TSBITS;
		ts |= options;
to:
		ts -= (1UL << TSBITS);

Fixes: 9a568de4818d ("tcp: switch TCP TS option (RFC 7323) to 1ms clock")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     |  2 +-
 net/ipv4/syncookies.c | 20 +++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 548c75c8a34c7..19646fdec23dc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -810,7 +810,7 @@ static inline u32 tcp_time_stamp(const struct tcp_sock *tp)
 }
 
 /* Convert a nsec timestamp into TCP TSval timestamp (ms based currently) */
-static inline u32 tcp_ns_to_ts(u64 ns)
+static inline u64 tcp_ns_to_ts(u64 ns)
 {
 	return div_u64(ns, NSEC_PER_SEC / TCP_TS_HZ);
 }
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 26fb97d1d4d9a..f9514cf87649e 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -41,7 +41,6 @@ static siphash_aligned_key_t syncookie_secret[2];
  * requested/supported by the syn/synack exchange.
  */
 #define TSBITS	6
-#define TSMASK	(((__u32)1 << TSBITS) - 1)
 
 static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 		       u32 count, int c)
@@ -62,27 +61,22 @@ static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
  */
 u64 cookie_init_timestamp(struct request_sock *req, u64 now)
 {
-	struct inet_request_sock *ireq;
-	u32 ts, ts_now = tcp_ns_to_ts(now);
+	const struct inet_request_sock *ireq = inet_rsk(req);
+	u64 ts, ts_now = tcp_ns_to_ts(now);
 	u32 options = 0;
 
-	ireq = inet_rsk(req);
-
 	options = ireq->wscale_ok ? ireq->snd_wscale : TS_OPT_WSCALE_MASK;
 	if (ireq->sack_ok)
 		options |= TS_OPT_SACK;
 	if (ireq->ecn_ok)
 		options |= TS_OPT_ECN;
 
-	ts = ts_now & ~TSMASK;
+	ts = (ts_now >> TSBITS) << TSBITS;
 	ts |= options;
-	if (ts > ts_now) {
-		ts >>= TSBITS;
-		ts--;
-		ts <<= TSBITS;
-		ts |= options;
-	}
-	return (u64)ts * (NSEC_PER_SEC / TCP_TS_HZ);
+	if (ts > ts_now)
+		ts -= (1UL << TSBITS);
+
+	return ts * (NSEC_PER_SEC / TCP_TS_HZ);
 }
 
 
-- 
2.42.0



