Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64847DF94;
	Thu, 20 Aug 2026 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247256; cv=none; b=iCX3eU9tTiQV4HR8+oPmNyRr3ZbC7jQNut4+6N3Q7Jn9N/hvdn9Tjs80fDE5O2CsGbKeQ8ZoE8flBHTydfv27lZU5AeWG1WW3CtLV/EUOSwKc6ZWfTH3oHB/P4JNUMx7PprTH6LW1sfhYJ9s8vgHBxStjtRZyhcAqZzIEHhlVFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247256; c=relaxed/simple;
	bh=z3mtJEWhAGXAnKx+SEH+H3x4812ZCWksIBhn81nQwpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onDoDicqccf9QNBvPT41URGrbRFWweS23U9JIiJVu1DPr3pc9X8UmkdGlSWWO7RKNLfT6vC7uSD3gMU9rgdkCgXvfDJfTzQ3S+RyCmcDFFIkRMlWozy0Xb6Ajno+4mkuMmzT+5D4u8oWEb+FBwZa2dBZ4SL0tptQ0VPe4e6qpY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6g2cOL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6g2cOL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C101F000E9;
	Thu, 20 Aug 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247255;
	bh=e0LXMaI0BrVDx5Th+aDjB0FpXkd9x+S8SkA0WZ54Ilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6g2cOL0h1tueRKyGa8q6qB6Hoa8JyqsV0Q9tObkngku31N5IyKN9B3NwTam6MkIu
	 Xsb20knQWuLyCfJgvKRcoEcmMaupQL112OY3d8hlitJpWvpCFaF0SG98q6uhJ1JBr5
	 HHh1gp4cdsSZA/2w4KQ1h1rDD7Hk+ae4V58HAZ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/220] tcp: fix icsk_ack.ato bitfield overflow
Date: Thu, 20 Aug 2026 16:56:33 +0200
Message-ID: <20260820145229.615987597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96800d5e16a4c..55b34cf309be7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -853,9 +853,9 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
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
index 16a410386ffa6..a58094b0acd4f 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -332,7 +332,9 @@ void tcp_delack_timer_handler(struct sock *sk)
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



