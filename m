Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F270381AEC;
	Thu, 20 Aug 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239212; cv=none; b=tZWVmZjJoqERjxGF/kCMwhhv8ohhJv8WOGMB2IVI7HfjPDs6LK3jm2sMTZ0eWdi6ovAjMyPpn54Iuc11t1csVKsZWjbJss1AslZjGpV/Qv7v+u6n5c+ETT/hMcQ4cYMtSe91/UqxqGtiobzxwNYvGB/eRgpomVjbWODz5wRldOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239212; c=relaxed/simple;
	bh=OJ5KXfGf/ZVY0AI+mDE5CaNOO2Wc3LVgCKKfUDshz7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5y541UVRWsUHIxC/tkAp7bC8j+0gRRf9LprO5oouhIUPhQT/vKsE03HX5dM8OXQvkzP7ZwPIrjQB+cHeWcNZCq3rjjDZl8qZu3t+l5Fh54Ef/dFdo0H2t2N4NYoWNs+Tl9AxPTl5cvj5hvCet2i+K5HKjeHz7NFzU9OCQ+k8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6Lc32NB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6Lc32NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D013C1F000E9;
	Thu, 20 Aug 2026 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239211;
	bh=J2sDd6VAlF06sg8lFYulO65aamlOQr62QeIMScUkT0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6Lc32NBJ8t6k3vilP+1fSqujdZpaKAYKurzajXUKbNsjsIRfrs71QVZ7HGlntMVh
	 VDRUSd/8OypsxK1bslq3cyBCnpRypGv84H/UxAzAFfvZjTvXaU++GMtoeHHLuWmiNP
	 3w8pUDl5ZGe+f37ZtSX2F5l8I5IgY9csYaxcu5qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/217] tcp: fix icsk_ack.ato bitfield overflow
Date: Thu, 20 Aug 2026 16:55:56 +0200
Message-ID: <20260820145243.377086142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index c1769031a9e93..05521a3509a96 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1006,9 +1006,9 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
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
index 1e6d7d90371a9..9ebce13fa8ad8 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -333,7 +333,9 @@ void tcp_delack_timer_handler(struct sock *sk)
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



