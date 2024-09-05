Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4818198E93;
	Thu,  5 Sep 2024 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529771; cv=none; b=iVwFLMFETEKirq8p+3hxWNpEaUqENmh7sAD0RmETauxsawBDeQfGRvbKG23ZQeHLF15tjYfsqdLdEmlLwRXzgEMVuE3v5sSIxHPc5EbFqBoDzIf5tZsqADUo2CHmtBrDuJ3wgbkVZFF70HaXhBH9YbCHVmEr5XcU+vf1gjkVqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529771; c=relaxed/simple;
	bh=TndsJC4PT8zMre6jyufq6CJXp38xh0n8+egDbpXQ+YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkP3Fnv85FzskYzRP7CPSlOVqj14SXF0j/8QJZfA76eRU0FhhBZi5CYOfSk5tZxGDVEpSQ8zXKgWhM+16zxGQlr5NRcrAqb6b4MhVygalFdfejW/Bpg/b1cvBU/rGVhl/DAWbikJqVd71q0J7olcQBxXJJ/o9Q2LUNCU0f8kGZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azyR+9iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azyR+9iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F2C4CEC6;
	Thu,  5 Sep 2024 09:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529771;
	bh=TndsJC4PT8zMre6jyufq6CJXp38xh0n8+egDbpXQ+YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azyR+9iOmEPN7ffI5+oxOaeQIo6Fh24vTU/6pmBTEJ8/Omt/i2jGAx012vXj9b8uz
	 bLwIWsRGRxBdiufXq9uX3pohM2iCMdBZS7wzf5RlF/cc1OxlqDmOTLVP6mfZCW+cSb
	 5GmbXZQAM28o+4fDK6hLuTnenHBwM0J73MnD+ibw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/184] tcp: annotate data-races around tw->tw_ts_recent and tw->tw_ts_recent_stamp
Date: Thu,  5 Sep 2024 11:40:51 +0200
Message-ID: <20240905093737.605616768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 69e0b33a7fce4d96649b9fa32e56b696921aa48e ]

These fields can be read and written locklessly, add annotations
around these minor races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c      | 12 +++++++-----
 net/ipv4/tcp_minisocks.c | 22 ++++++++++++++--------
 net/ipv6/tcp_ipv6.c      |  6 +++---
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8f8f93716ff8..3b7430201397 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -116,6 +116,7 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 	const struct inet_timewait_sock *tw = inet_twsk(sktw);
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
+	int ts_recent_stamp;
 
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
@@ -154,9 +155,10 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 	   If TW bucket has been already destroyed we fall back to VJ's scheme
 	   and use initial timestamp retrieved from peer table.
 	 */
-	if (tcptw->tw_ts_recent_stamp &&
+	ts_recent_stamp = READ_ONCE(tcptw->tw_ts_recent_stamp);
+	if (ts_recent_stamp &&
 	    (!twp || (reuse && time_after32(ktime_get_seconds(),
-					    tcptw->tw_ts_recent_stamp)))) {
+					    ts_recent_stamp)))) {
 		/* inet_twsk_hashdance() sets sk_refcnt after putting twsk
 		 * and releasing the bucket lock.
 		 */
@@ -180,8 +182,8 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 			if (!seq)
 				seq = 1;
 			WRITE_ONCE(tp->write_seq, seq);
-			tp->rx_opt.ts_recent	   = tcptw->tw_ts_recent;
-			tp->rx_opt.ts_recent_stamp = tcptw->tw_ts_recent_stamp;
+			tp->rx_opt.ts_recent	   = READ_ONCE(tcptw->tw_ts_recent);
+			tp->rx_opt.ts_recent_stamp = ts_recent_stamp;
 		}
 
 		return 1;
@@ -1066,7 +1068,7 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_tw_tsval(tcptw),
-			tcptw->tw_ts_recent,
+			READ_ONCE(tcptw->tw_ts_recent),
 			tw->tw_bound_dev_if, &key,
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			tw->tw_tos,
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0fbebf6266e9..5e4a12d01622 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -101,16 +101,18 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 	struct tcp_options_received tmp_opt;
 	struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
 	bool paws_reject = false;
+	int ts_recent_stamp;
 
 	tmp_opt.saw_tstamp = 0;
-	if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
+	ts_recent_stamp = READ_ONCE(tcptw->tw_ts_recent_stamp);
+	if (th->doff > (sizeof(*th) >> 2) && ts_recent_stamp) {
 		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
 
 		if (tmp_opt.saw_tstamp) {
 			if (tmp_opt.rcv_tsecr)
 				tmp_opt.rcv_tsecr -= tcptw->tw_ts_offset;
-			tmp_opt.ts_recent	= tcptw->tw_ts_recent;
-			tmp_opt.ts_recent_stamp	= tcptw->tw_ts_recent_stamp;
+			tmp_opt.ts_recent	= READ_ONCE(tcptw->tw_ts_recent);
+			tmp_opt.ts_recent_stamp	= ts_recent_stamp;
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -152,8 +154,10 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		twsk_rcv_nxt_update(tcptw, TCP_SKB_CB(skb)->end_seq);
 
 		if (tmp_opt.saw_tstamp) {
-			tcptw->tw_ts_recent_stamp = ktime_get_seconds();
-			tcptw->tw_ts_recent	  = tmp_opt.rcv_tsval;
+			WRITE_ONCE(tcptw->tw_ts_recent_stamp,
+				  ktime_get_seconds());
+			WRITE_ONCE(tcptw->tw_ts_recent,
+				   tmp_opt.rcv_tsval);
 		}
 
 		inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
@@ -197,8 +201,10 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		}
 
 		if (tmp_opt.saw_tstamp) {
-			tcptw->tw_ts_recent	  = tmp_opt.rcv_tsval;
-			tcptw->tw_ts_recent_stamp = ktime_get_seconds();
+			WRITE_ONCE(tcptw->tw_ts_recent,
+				   tmp_opt.rcv_tsval);
+			WRITE_ONCE(tcptw->tw_ts_recent_stamp,
+				   ktime_get_seconds());
 		}
 
 		inet_twsk_put(tw);
@@ -225,7 +231,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 	if (th->syn && !th->rst && !th->ack && !paws_reject &&
 	    (after(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt) ||
 	     (tmp_opt.saw_tstamp &&
-	      (s32)(tcptw->tw_ts_recent - tmp_opt.rcv_tsval) < 0))) {
+	      (s32)(READ_ONCE(tcptw->tw_ts_recent) - tmp_opt.rcv_tsval) < 0))) {
 		u32 isn = tcptw->tw_snd_nxt + 65535 + 2;
 		if (isn == 0)
 			isn++;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3385faf1d5dc..66f6fe5afb03 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1196,9 +1196,9 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 	tcp_v6_send_ack(sk, skb, tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_tw_tsval(tcptw),
-			tcptw->tw_ts_recent, tw->tw_bound_dev_if, &key,
-			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority,
-			tw->tw_txhash);
+			READ_ONCE(tcptw->tw_ts_recent), tw->tw_bound_dev_if,
+			&key, tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel),
+			tw->tw_priority, tw->tw_txhash);
 
 #ifdef CONFIG_TCP_AO
 out:
-- 
2.43.0



