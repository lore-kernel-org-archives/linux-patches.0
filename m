Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AB2874E6;
	Thu, 20 Aug 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238587; cv=none; b=kVLDrv6tWbsfRwodXXyEjmuoX+tgCAKnLhH07RLmYUl/reXIEyOLGt86ebwXePgdRyK2imabZuP/tyBc27GWLPN/nAZ2whpv0hKBzKXG3Y/wgV6mtRJaIf338J9L75FyQ6n4uvrc5SsAtjUJ7aPXFF+/RUvlLSvChospYxNhwL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238587; c=relaxed/simple;
	bh=ssBf+tNNvz2mFaiZvWmpRiMvLBFK6ofy0H29gQ15z8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Epdh5n17nTd2cHm99I06STA3JXHgj6zy9kvhgBpBV4bBF3bhgzYHfWXGftQhLQ5ozqignZ8UoZzANsr2scw6xkvZJqrABsk+2876Xif0O7D1ZbjdZBp3l4QRsM4ahJXnVv4cJXd2uMeTznBAF2OVYms1CALtAvS0ueRDCQ2CDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5OhWBfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5OhWBfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FCB1F00A3A;
	Thu, 20 Aug 2026 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238586;
	bh=jurNvqNqSX+ciUAZF6s3wAPkA293hkyR/SAAJuo5PEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5OhWBfdojjdd4Nyo7nth6bypcnb1AwZYC56hSTcDvmgJEMngaPERgS7xNURiyFc3
	 CwXzv951/NATlZUJz93YyP3/AhsgAOPt5/Ppp/QfcB65hbBe7/wHwcGwGQdiikMRt6
	 +pvSjQNMsRip2QvJtsnfYEUnEp3ufd7pG3dtFeeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 200/228] tcp: fix icsk_ack.ato bitfield overflow
Date: Thu, 20 Aug 2026 16:55:42 +0200
Message-ID: <20260820145251.116679588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 60837e4b840a9c3f7ec826e3584df0bc6542a2c2 ]

On cross-region connections we observed delayed ACKs suddenly turning
into immediate ACKs plus a TCP_MAX_QUICKACKS burst, as if the
connection had just received its first data segment.

Commit 95b9a87c6a6b ("tcp: record last received ipv6 flowlabel")
squeezed icsk_ack.ato into 8 bits, sized for TCP_DELACK_MAX. But both
writers still bound ato by icsk_rto, which can be well above 255
jiffies, so the bitfield assignment silently wraps mod 256: repeated
delack timer misses double ato up to icsk_rto, storing 320 as 64 and
256 as 0, and ato == 0 is the "first data packet" sentinel in
tcp_event_data_recv().

Clamp both writers to TCP_DELACK_MAX, which the static_assert already
guarantees to fit and tcp_send_delayed_ack() effectively caps ato at
anyway.

Fixes: 95b9a87c6a6b ("tcp: record last received ipv6 flowlabel")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20260807014437.36687-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 +++---
 net/ipv4/tcp_timer.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e2c022f02c644..d774f049b5bf2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1039,9 +1039,9 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 			/* The fastest case is the first. */
 			icsk->icsk_ack.ato = (icsk->icsk_ack.ato >> 1) + TCP_ATO_MIN / 2;
 		} else if (m < icsk->icsk_ack.ato) {
-			icsk->icsk_ack.ato = (icsk->icsk_ack.ato >> 1) + m;
-			if (icsk->icsk_ack.ato > icsk->icsk_rto)
-				icsk->icsk_ack.ato = icsk->icsk_rto;
+			icsk->icsk_ack.ato = min3((icsk->icsk_ack.ato >> 1) + (u32)m,
+						  icsk->icsk_rto,
+						  (u32)TCP_DELACK_MAX);
 		} else if (m > icsk->icsk_rto) {
 			/* Too long gap. Apparently sender failed to
 			 * restart window, so that we send ACKs quickly.
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 322db13333c70..c94270d99ce4f 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -334,7 +334,9 @@ void tcp_delack_timer_handler(struct sock *sk)
 	if (inet_csk_ack_scheduled(sk)) {
 		if (!inet_csk_in_pingpong_mode(sk)) {
 			/* Delayed ACK missed: inflate ATO. */
-			icsk->icsk_ack.ato = min_t(u32, icsk->icsk_ack.ato << 1, icsk->icsk_rto);
+			icsk->icsk_ack.ato = min3((u32)icsk->icsk_ack.ato << 1,
+						  icsk->icsk_rto,
+						  (u32)TCP_DELACK_MAX);
 		} else {
 			/* Delayed ACK missed: leave pingpong mode and
 			 * deflate ATO.
-- 
2.53.0



