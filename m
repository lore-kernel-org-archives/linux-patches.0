Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926E2BAF4;
	Wed,  4 Jun 2025 00:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998600; cv=none; b=rZVS26I5h0bRtCeHN9aD3tUjMClFDnBEZcTQaJrRsqBAWvFrPl3wI77VywHgvu2I1VDXQeRtXH/Xs/+n40y2pv6+H694vVzkH+ekB1l7Jo6Y9xEBXE+pa/QD+P7z9GUDpoo9lkUVs1rICHRAJqwlY04n/QUY61YeoncWuSdvp9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998600; c=relaxed/simple;
	bh=KqJnWM8VqqTefw6EGg6yTiKWszrOK87ZWQ8mMwXnDzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I56ABAXm2YLrJ7Xtmsr8hqzyTp1shsNvhlp4AljvN654H7uDPeOmhPRkaN5xzm1yGfLt5rIoubfwYpi2FSK9XoNjcm1FSrWJFolKtN0ECiEEaZi2Ijdp0O17gTreA7I9KRtQ1I+2FK2WZzpkCuUJGovdOGdJIEHpN4evmkkUt44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWILMIef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWILMIef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B37C4CEF2;
	Wed,  4 Jun 2025 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998600;
	bh=KqJnWM8VqqTefw6EGg6yTiKWszrOK87ZWQ8mMwXnDzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWILMIefRRdCcYsRxqSJ2Px5wbEnE+tislFLuZfkvOppDG3kGbkvNdHDhZPyC/Kfk
	 UQp7kLLIz/j5KtM47gpXoO7c1ByW0sPhtpkakTOrtQ/fKqHQvqFDOonURdSmuRC8Gx
	 jDr41g640LtMHyf2VBgVZIcE3teqsONM86d6g7mwh6cl5jT5iTJwLyF2qZYT7w2RPT
	 oASyquBG1m98idWxPLHUz0gjSpbvSI1jOiUFSJa4rdH7oU2fkAkS+YsDJRaKISkEGE
	 JnlcHjpp3UbapZ3ycGhAK78l2l7AnOUAdYA8EbHcCD7QmGyJNrtV44FXNFVlHnnuh1
	 1HB+dAhJQobGw==
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
Subject: [PATCH AUTOSEL 6.14 034/108] tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows
Date: Tue,  3 Jun 2025 20:54:17 -0400
Message-Id: <20250604005531.4178547-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd171461b90a2d2cf230943df60d580174633718 ]

tcp_rcv_state_process() must tweak tp->advmss for TS enabled flows
before the call to tcp_init_transfer() / tcp_init_buffer_space().

Otherwise tp->rcvq_space.space is off by 120 bytes
(TCP_INIT_CWND * TCPOLEN_TSTAMP_ALIGNED).

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Detailed Analysis ### Nature of the Fix This commit addresses a **subtle
but significant bug** in the TCP receive buffer space initialization for
passive (server-side) connections when TCP timestamps are enabled. The
fix is a simple 2-line reordering that moves the `advmss` adjustment for
timestamp options **before** the call to `tcp_init_transfer()`. ### The
Problem 1. **Root Cause**: In `tcp_rcv_state_process()` for
`TCP_SYN_RECV` state, the `tp->advmss` reduction for timestamp options
(`TCPOLEN_TSTAMP_ALIGNED = 12 bytes`) was happening **after**
`tcp_init_transfer()` was called. 2. **Impact**: Since
`tcp_init_transfer()` calls `tcp_init_buffer_space()`, which initializes
`tp->rcvq_space.space` using the formula: ```c tp->rcvq_space.space =
min3(tp->rcv_ssthresh, tp->rcv_wnd, (u32)TCP_INIT_CWND linux
tp->advmss); ``` The calculation was using an **unadjusted `advmss`
value**, leading to a 120-byte overestimate: - `TCP_INIT_CWND (10) ×
TCPOLEN_TSTAMP_ALIGNED (12) = 120 bytes` 3. **Consequence**: The
`rcvq_space.space` field is critical for TCP receive buffer auto-tuning
in `tcp_rcv_space_adjust()`, and this miscalculation could lead to
suboptimal buffer management and performance issues. ### Why This Should
Be Backported #### ✅ **Bug Fix Criteria Met**: 1. **Clear Bug**: This
fixes a real initialization ordering bug that affects TCP performance 2.
**User Impact**: Affects all passive TCP connections with timestamp
options enabled (very common) 3. **Minimal Risk**: The fix is a simple
2-line reordering with no functional changes 4. **Contained Scope**:
Only affects the initialization path in `tcp_rcv_state_process()` #### ✅
**Follows Stable Tree Rules**: 1. **Important**: TCP receive buffer
tuning affects network performance for most connections 2. **Small &
Contained**: The change moves just 2 lines of existing code 3. **No
Regression Risk**: The fix corrects an obvious ordering error without
introducing new logic 4. **No Architectural Changes**: No new features
or major changes to TCP stack #### ✅ **Comparison with Similar
Backported Commits**: The provided reference commits show a pattern of
TCP receive buffer and `rcvq_space` related fixes being consistently
backported: - Integer overflow fixes in `tcp_rcv_space_adjust()` ✅
**Backported** - Data race fixes for `sysctl_tcp_moderate_rcvbuf` ✅
**Backported** - MPTCP `rcv_space_init` fixes ✅ **Backported** -
Timestamp handling in `tcp_rcv_space_adjust()` ✅ **Backported** This fix
follows the exact same pattern: a small, surgical fix to TCP receive
buffer initialization logic. ### Technical Verification Looking at the
code change in `/home/sasha/linux/net/ipv4/tcp_input.c:6872-6873`, the
fix simply moves: ```c if (tp->rx_opt.tstamp_ok) tp->advmss -=
TCPOLEN_TSTAMP_ALIGNED; ``` from **after** `tcp_init_transfer()` to
**before** it. This ensures that when `tcp_init_buffer_space()` is
called within `tcp_init_transfer()`, it uses the correct timestamp-
adjusted `advmss` value. The change is **safe, targeted, and addresses a
clear functional bug** that affects TCP performance for a large class of
connections. It meets all criteria for stable tree backporting.

 net/ipv4/tcp_input.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a132a200215ed..85bd0a4c5e558 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6853,6 +6853,9 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (!tp->srtt_us)
 			tcp_synack_rtt_meas(sk, req);
 
+		if (tp->rx_opt.tstamp_ok)
+			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
+
 		if (req) {
 			tcp_rcv_synrecv_state_fastopen(sk);
 		} else {
@@ -6878,9 +6881,6 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 
-		if (tp->rx_opt.tstamp_ok)
-			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
-
 		if (!inet_csk(sk)->icsk_ca_ops->cong_control)
 			tcp_update_pacing_rate(sk);
 
-- 
2.39.5

