Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B5D321B8;
	Mon, 11 Dec 2023 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJWJMm6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB542C433C9;
	Mon, 11 Dec 2023 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320913;
	bh=RkMo2ZwONLv+iWdupGQhQqFsZSB9+5G1ewBqxgVIorc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJWJMm6A5owT/fJbSddng1Ldd+bj3Jt6f6EgDQeSdrlbGdj5uY/1QGRC9mNE/NY5h
	 Hi8cmCVsT0sm0/+OVGzSFoWhAqZCfC9euFq0sV6uBwfP73a+9dXcUq5MhiOBQSztzD
	 QTjOrvvM5dQxPItpgplcgw4cM4xtY6qbJGk9or18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yepeng Pan <yepeng.pan@cispa.de>,
	Christian Rossow <rossow@cispa.de>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/141] tcp: do not accept ACK of bytes we never sent
Date: Mon, 11 Dec 2023 19:21:41 +0100
Message-ID: <20231211182028.363941947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d501dd326fb1c73f1b8206d4c6e1d7b15c07e27 ]

This patch is based on a detailed report and ideas from Yepeng Pan
and Christian Rossow.

ACK seq validation is currently following RFC 5961 5.2 guidelines:

   The ACK value is considered acceptable only if
   it is in the range of ((SND.UNA - MAX.SND.WND) <= SEG.ACK <=
   SND.NXT).  All incoming segments whose ACK value doesn't satisfy the
   above condition MUST be discarded and an ACK sent back.  It needs to
   be noted that RFC 793 on page 72 (fifth check) says: "If the ACK is a
   duplicate (SEG.ACK < SND.UNA), it can be ignored.  If the ACK
   acknowledges something not yet sent (SEG.ACK > SND.NXT) then send an
   ACK, drop the segment, and return".  The "ignored" above implies that
   the processing of the incoming data segment continues, which means
   the ACK value is treated as acceptable.  This mitigation makes the
   ACK check more stringent since any ACK < SND.UNA wouldn't be
   accepted, instead only ACKs that are in the range ((SND.UNA -
   MAX.SND.WND) <= SEG.ACK <= SND.NXT) get through.

This can be refined for new (and possibly spoofed) flows,
by not accepting ACK for bytes that were never sent.

This greatly improves TCP security at a little cost.

I added a Fixes: tag to make sure this patch will reach stable trees,
even if the 'blamed' patch was adhering to the RFC.

tp->bytes_acked was added in linux-4.2

Following packetdrill test (courtesy of Yepeng Pan) shows
the issue at hand:

0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
+0 bind(3, ..., ...) = 0
+0 listen(3, 1024) = 0

// ---------------- Handshake ------------------- //

// when window scale is set to 14 the window size can be extended to
// 65535 * (2^14) = 1073725440. Linux would accept an ACK packet
// with ack number in (Server_ISN+1-1073725440. Server_ISN+1)
// ,though this ack number acknowledges some data never
// sent by the server.

+0 < S 0:0(0) win 65535 <mss 1400,nop,wscale 14>
+0 > S. 0:0(0) ack 1 <...>
+0 < . 1:1(0) ack 1 win 65535
+0 accept(3, ..., ...) = 4

// For the established connection, we send an ACK packet,
// the ack packet uses ack number 1 - 1073725300 + 2^32,
// where 2^32 is used to wrap around.
// Note: we used 1073725300 instead of 1073725440 to avoid possible
// edge cases.
// 1 - 1073725300 + 2^32 = 3221241997

// Oops, old kernels happily accept this packet.
+0 < . 1:1001(1000) ack 3221241997 win 65535

// After the kernel fix the following will be replaced by a challenge ACK,
// and prior malicious frame would be dropped.
+0 > . 1:1(0) ack 1001

Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Yepeng Pan <yepeng.pan@cispa.de>
Reported-by: Christian Rossow <rossow@cispa.de>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20231205161841.2702925-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a3453b4ac339c..e51b5d887c24b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3796,8 +3796,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	 * then we can probably ignore it.
 	 */
 	if (before(ack, prior_snd_una)) {
+		u32 max_window;
+
+		/* do not accept ACK for bytes we never sent. */
+		max_window = min_t(u64, tp->max_window, tp->bytes_acked);
 		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
-		if (before(ack, prior_snd_una - tp->max_window)) {
+		if (before(ack, prior_snd_una - max_window)) {
 			if (!(flag & FLAG_NO_CHALLENGE_ACK))
 				tcp_send_challenge_ack(sk, skb);
 			return -1;
-- 
2.42.0



