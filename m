Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FB33F20FA;
	Wed, 20 May 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299047; cv=none; b=Dw4imU20e73iz6d1ebKta2OXArt5xhBLZt6lZGyUzyTNp3Y6szbr6DyvtZzW0c3Yl+8ItawcEDWKtlH/qZweS0D4mudnAqBW3m9B/Zgo0v+DbwAGrP5GeGnjY3r0RoMDeI7X0vQUrHXr3VrfXCvwAvwV2SR4UBmYyXYtFCuIvtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299047; c=relaxed/simple;
	bh=yoyCm9/yAle6/x7GpmTPkMaKimUXxIC8d9Z94e6y3Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmLTPU0X1Q2whEEpbvv3I2YCwMUImWggXeEeW7NU/i/auhDHvCDLAypEitp6XxVPGaO8ilADGhQvzEbt9bnXiPuCX2IeNGEPkj5IuXSJYbNDTuScg4J0Z9kJNlEPbBqVwTS9qFMpd5HSG59L2Ef1RJxs61+m1SijfLeLTUQinag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAsPWcGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAsPWcGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6FE1F000E9;
	Wed, 20 May 2026 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299046;
	bh=v7g5aOc+STugu9tT8MkOQR+eXydSY9pzy5kMalTj9E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAsPWcGcubFAHWOHbAeJuF4ZGs59wiT2FxAS+ZrB4UKifDQAiixTQmG7WHLAvLtT+
	 bZavGmUe7s/xVvT84yMSenmjQTBu7Qv55viMkok2UX08DwOQRyBdqftHMYeSnBCmxK
	 YDbn6e2S+9TO6XLf/uEoZvsXxNfVb7cy1MCJi/ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 642/957] tcp: annotate data-races around tp->srtt_us
Date: Wed, 20 May 2026 18:18:45 +0200
Message-ID: <20260520162148.450333161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 290b693ce7c9d48588d88b15a782a3efc6fa036b ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: e8bd8fca6773 ("tcp: add SRTT to SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-12-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c       | 5 +++--
 net/ipv4/tcp_input.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2e62441515fee..a799329281532 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3605,7 +3605,8 @@ static void tcp_enable_tx_delay(struct sock *sk, int val)
 	if (delta && sk->sk_state == TCP_ESTABLISHED) {
 		s64 srtt = (s64)tp->srtt_us + delta;
 
-		tp->srtt_us = clamp_t(s64, srtt, 1, ~0U);
+		WRITE_ONCE(tp->srtt_us,
+			   clamp_t(s64, srtt, 1, ~0U));
 
 		/* Note: does not deal with non zero icsk_backoff */
 		tcp_set_rto(sk);
@@ -4442,7 +4443,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, READ_ONCE(tp->dsack_dups));
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, READ_ONCE(tp->reord_seen));
-	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
+	nla_put_u32(stats, TCP_NLA_SRTT, READ_ONCE(tp->srtt_us) >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
 		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e8ba52c908da1..5fb5f3f6393c1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1099,7 +1099,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 
 		tcp_bpf_rtt(sk, mrtt_us, srtt);
 	}
-	tp->srtt_us = max(1U, srtt);
+	WRITE_ONCE(tp->srtt_us, max(1U, srtt));
 }
 
 void tcp_update_pacing_rate(struct sock *sk)
-- 
2.53.0



