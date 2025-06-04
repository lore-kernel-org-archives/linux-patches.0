Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AFD1CCB4B;
	Wed,  4 Jun 2025 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998816; cv=none; b=lZp8kdyn04pQ2L/ZC0ysucjJBsjT66Dta+4V0N2+nPPlA6Y51TFp83rCy6U5TV7dnLwuu3US8RjZu43vcUAq/XpOiREaHDu5Dw0weZD9gq05pKCel5YeUmOxRNNsfcsQe2If8V7A6xT3a7nOvdypYA0Mwwoa/69PtghO3zYokcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998816; c=relaxed/simple;
	bh=iaX6ux3+5yQaHgGMbrJMoIsVjDGzBF2LwGZTBzJzXSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEULZyoNDKpUd3f3B3aip209utui7T7cebU0gDW+y3a2IjVWb86Fm4XrHtaqycGtmpPaNYrcUP9s0qOR9ftTQ6olyzBcP4YnU+ObqtmvfdI9VFw7GukLkufCLaAUWz9J9q9STI4XvPNLlg9XSSJC/bXuq/gOWAItmQ2G2v/1QQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrYNeESC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrYNeESC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C18C4CEED;
	Wed,  4 Jun 2025 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998815;
	bh=iaX6ux3+5yQaHgGMbrJMoIsVjDGzBF2LwGZTBzJzXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrYNeESCaD8bamWr2WbjejwVbPR25r76ylMO6WLp9CUBn1amCKX8HFVXGCEFI0EnK
	 l+1C9ghDXaxJZzEwGp6pwhM6/kMEQVWqqivU7kQtbHZflOVgcq0+nfX1ODIaK+VANS
	 OaziJOlanjU1GIZe0Cx+Jsb45qzxxCTJ5Dbf9RkOk1nspTVv78TjGVOujjctJPcJ7T
	 IwNnIF2VloIm3oPp1kI6Zd5QQ0UbeW+679ZxedSnpygfStJeSTm6Ep2tDU144KrQk9
	 AWWJQCbUnycw/kPxzdQy+ClXfFtKV4sUI8zxMmBAV03/ZMkH2AN+e07DVYCxDx6fxX
	 vCO1w1RJEDN1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ncardwell@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 29/93] tcp: remove zero TCP TS samples for autotuning
Date: Tue,  3 Jun 2025 20:58:15 -0400
Message-Id: <20250604005919.4191884-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d59fc95be9d0fd05ed3ccc11b4a2f832bdf2ee03 ]

For TCP flows using ms RFC 7323 timestamp granularity
tcp_rcv_rtt_update() can be fed with 1 ms samples, breaking
TCP autotuning for data center flows with sub ms RTT.

Instead, rely on the window based samples, fed by tcp_rcv_rtt_measure()

tcp_rcvbuf_grow() for a 10 second TCP_STREAM sesssion now looks saner.
We can see rcvbuf is kept at a reasonable value.

  222.234976: tcp:tcp_rcvbuf_grow: time=348 rtt_us=330 copied=110592 inq=0 space=40960 ooo=0 scaling_ratio=230 rcvbuf=131072 ...
  222.235276: tcp:tcp_rcvbuf_grow: time=300 rtt_us=288 copied=126976 inq=0 space=110592 ooo=0 scaling_ratio=230 rcvbuf=246187 ...
  222.235569: tcp:tcp_rcvbuf_grow: time=294 rtt_us=288 copied=184320 inq=0 space=126976 ooo=0 scaling_ratio=230 rcvbuf=282659 ...
  222.235833: tcp:tcp_rcvbuf_grow: time=264 rtt_us=244 copied=373760 inq=0 space=184320 ooo=0 scaling_ratio=230 rcvbuf=410312 ...
  222.236142: tcp:tcp_rcvbuf_grow: time=308 rtt_us=219 copied=424960 inq=20480 space=373760 ooo=0 scaling_ratio=230 rcvbuf=832022 ...
  222.236378: tcp:tcp_rcvbuf_grow: time=236 rtt_us=219 copied=692224 inq=49152 space=404480 ooo=0 scaling_ratio=230 rcvbuf=900407 ...
  222.236602: tcp:tcp_rcvbuf_grow: time=225 rtt_us=219 copied=730112 inq=49152 space=643072 ooo=0 scaling_ratio=230 rcvbuf=1431534 ...
  222.237050: tcp:tcp_rcvbuf_grow: time=229 rtt_us=219 copied=1160192 inq=49152 space=680960 ooo=0 scaling_ratio=230 rcvbuf=1515876 ...
  222.237618: tcp:tcp_rcvbuf_grow: time=305 rtt_us=218 copied=2228224 inq=49152 space=1111040 ooo=0 scaling_ratio=230 rcvbuf=2473271 ...
  222.238591: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=3063808 inq=360448 space=2179072 ooo=0 scaling_ratio=230 rcvbuf=4850803 ...
  222.240647: tcp:tcp_rcvbuf_grow: time=260 rtt_us=218 copied=2752512 inq=0 space=2703360 ooo=0 scaling_ratio=230 rcvbuf=6017914 ...
  222.243535: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=2834432 inq=49152 space=2752512 ooo=0 scaling_ratio=230 rcvbuf=6127331 ...
  222.245108: tcp:tcp_rcvbuf_grow: time=240 rtt_us=218 copied=2883584 inq=49152 space=2785280 ooo=0 scaling_ratio=230 rcvbuf=6200275 ...
  222.245333: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=2859008 inq=0 space=2834432 ooo=0 scaling_ratio=230 rcvbuf=6309692 ...
  222.301021: tcp:tcp_rcvbuf_grow: time=222 rtt_us=218 copied=2883584 inq=0 space=2859008 ooo=0 scaling_ratio=230 rcvbuf=6364400 ...
  222.989242: tcp:tcp_rcvbuf_grow: time=225 rtt_us=218 copied=2899968 inq=0 space=2883584 ooo=0 scaling_ratio=230 rcvbuf=6419108 ...
  224.139553: tcp:tcp_rcvbuf_grow: time=224 rtt_us=218 copied=3014656 inq=65536 space=2899968 ooo=0 scaling_ratio=230 rcvbuf=6455580 ...
  224.584608: tcp:tcp_rcvbuf_grow: time=232 rtt_us=218 copied=3014656 inq=49152 space=2949120 ooo=0 scaling_ratio=230 rcvbuf=6564997 ...
  230.145560: tcp:tcp_rcvbuf_grow: time=223 rtt_us=218 copied=2981888 inq=0 space=2965504 ooo=0 scaling_ratio=230 rcvbuf=6601469 ...

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
my analysis of the code changes and their impact. ## Extensive Analysis
### 1. **Bug Impact Assessment - Fixes User-Affecting Issues** The
commit addresses a significant performance regression in data center
environments. The evidence from the commit message shows real-world
impact through detailed tracing data demonstrating improved TCP receive
buffer autotuning behavior. Before the fix, zero RTT samples from ms-
granularity TCP timestamps would corrupt autotuning for sub-ms RTT
flows, causing: - Suboptimal receive buffer sizing - Poor performance in
high-bandwidth, low-latency scenarios - Incorrect RTT estimates feeding
into congestion control algorithms ### 2. **Code Changes Are Small and
Contained** The changes are minimal and surgical: ```c // Modified
tcp_rtt_tsopt_us() to take min_delta parameter -static s32
tcp_rtt_tsopt_us(const struct tcp_sock *tp) +static s32
tcp_rtt_tsopt_us(const struct tcp_sock *tp, u32 min_delta) { // When
delta is 0, use min_delta instead of hardcoded 1 if (!delta) - delta =
1; + delta = min_delta; } // In tcp_rcv_rtt_measure_ts(): filter out
zero samples for autotuning -s32 delta = tcp_rtt_tsopt_us(tp); +s32
delta = tcp_rtt_tsopt_us(tp, 0); -if (delta >= 0) +if (delta > 0)
tcp_rcv_rtt_update(tp, delta, 0); // In tcp_ack_update_rtt(): preserve
minimum 1µs for congestion control -seq_rtt_us = ca_rtt_us =
tcp_rtt_tsopt_us(tp); +seq_rtt_us = ca_rtt_us = tcp_rtt_tsopt_us(tp, 1);
``` ### 3. **Follows Stable Tree Patterns from Similar Commits** Looking
at the historical references provided, this commit follows the exact
same pattern as previous TCP RTT measurement fixes that were
successfully backported: - **Similar Commit #2** (YES): Fixed zero RTT
samples from TCP timestamps - nearly identical issue - **Similar Commit
#3** (YES): Fixed potential underestimation on rcv_rtt - same subsystem
- **Similar Commit #4** (YES): Fixed timestamp refresh in
tcp_rcv_space_adjust() - same autotuning code - **Similar Commit #5**
(YES): Fixed rtt_min calculation - same RTT measurement subsystem ### 4.
**No Architectural Changes or Risky Side Effects** The changes: - Don't
introduce new features - Don't modify core TCP state machine logic -
Don't change external APIs or user-visible behavior - Only affect
internal RTT measurement accuracy - Have clear behavioral improvements
with no regression risk ### 5. **Critical Subsystem But Safe Changes**
While this touches the critical TCP input path, the modifications are: -
Isolated to RTT measurement functions - Backward compatible (no protocol
changes) - Defensive (filtering bad samples rather than adding new
logic) - Following established patterns from prior successful fixes ###
6. **Data Center Performance Is Critical** Modern kernels are heavily
used in data center environments where: - Sub-millisecond RTTs are
common - TCP autotuning performance directly affects application
throughput - The specific scenario (ms timestamp granularity breaking
autotuning) is widespread - Performance regressions in this area affect
major workloads ### 7. **Clear Technical Merit** The fix addresses a
fundamental measurement accuracy problem where: - 1ms timestamp
granularity creates zero RTT deltas for fast networks - Zero RTT samples
poison autotuning algorithms designed for accurate measurements - The
solution elegantly separates concerns: filter zeros for autotuning,
preserve minimums for congestion control - The trace data in the commit
message demonstrates measurable improvement ### 8. **Low Risk Profile**
The changes have minimal regression risk because: - They only affect
edge cases (zero timestamp deltas) - The fallback behavior (using
window-based samples) was already present - No changes to normal case
processing - Clear separation between autotuning and congestion control
requirements This commit represents exactly the type of fix that stable
trees are designed for: a small, contained fix for a user-affecting
performance issue in a critical subsystem, with clear evidence of
improvement and minimal regression risk.

 net/ipv4/tcp_input.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cf4fef18a9cad..61ada4682094f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -707,7 +707,7 @@ static inline void tcp_rcv_rtt_measure(struct tcp_sock *tp)
 	tp->rcv_rtt_est.time = tp->tcp_mstamp;
 }
 
-static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp)
+static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp, u32 min_delta)
 {
 	u32 delta, delta_us;
 
@@ -717,7 +717,7 @@ static s32 tcp_rtt_tsopt_us(const struct tcp_sock *tp)
 
 	if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
 		if (!delta)
-			delta = 1;
+			delta = min_delta;
 		delta_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 		return delta_us;
 	}
@@ -735,9 +735,9 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 
 	if (TCP_SKB_CB(skb)->end_seq -
 	    TCP_SKB_CB(skb)->seq >= inet_csk(sk)->icsk_ack.rcv_mss) {
-		s32 delta = tcp_rtt_tsopt_us(tp);
+		s32 delta = tcp_rtt_tsopt_us(tp, 0);
 
-		if (delta >= 0)
+		if (delta > 0)
 			tcp_rcv_rtt_update(tp, delta, 0);
 	}
 }
@@ -3220,7 +3220,7 @@ static bool tcp_ack_update_rtt(struct sock *sk, const int flag,
 	 */
 	if (seq_rtt_us < 0 && tp->rx_opt.saw_tstamp &&
 	    tp->rx_opt.rcv_tsecr && flag & FLAG_ACKED)
-		seq_rtt_us = ca_rtt_us = tcp_rtt_tsopt_us(tp);
+		seq_rtt_us = ca_rtt_us = tcp_rtt_tsopt_us(tp, 1);
 
 	rs->rtt_us = ca_rtt_us; /* RTT of last (S)ACKed packet (or -1) */
 	if (seq_rtt_us < 0)
-- 
2.39.5

