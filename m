Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705107;
	b=NHKQX9HzTE3SA5th5sc+jKX65fhUHkfr+UZqJO6ub7xtKhMgqNiZpCBEgaSYTZGPOkYa
	 iSNr9FYHejtaPC1RoVzhXSfjilKVB57CJ4XBrEoB+8YQhRhB8QaLtG3ESOqjOJHDaL8TL
	 N9QQ+EcXbF57fE/ZaLQISNl4tZ5Iaz5NYZ4J3A5kIcrBZ0k1wla9OGYEzWb8ALcbFYfMx
	 NO1n2gMEGZAZ1ntRZIGLCd1JDL8asN7ZFKbnAMy4hOuAXwd7XSDFEFMTUgdkt/XbbikqV
	 7Z0t0yh05F/okfu3FC3A0jahvgW4TWYPUFLcrIAtmV6iAGi7EcuqCmP8iQwS9OgvDHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nLVF/BYVtI0HuWYbVdhPcVpEvsMfcH88M7WVucv+2RI=;
	b=olQQlZEHfbA13kR+CRH9gJqyK0QrLJUM7vRt2hqIHZsryQJexCHAvPa9aEb5daxsWZDA
	 S+A3s40YEW9WadLWbLi0OaGKyJkfgRALFnWb4/lXqI9vn6TnjekgRjPlCPT0oZG8rjr4M
	 I7/jGZYO2dXOlervN0Ir1Sotng/TGWPSWB5aISIBXJP0Xiar2S8AZQKK+eKePaTx3zyvI
	 vo/Ysm+HwSRG7SSj1uosKX68UA/kU3wMnBQ6A6ZivtrpnF5xXgsNN5AtYxWyr/5FdXJaT
	 gT6ZwFylRJ4enNvDiPRZ/UPcNNYZcIjUerk5vLjH7F8Zpvxqlz9IkD0JatBG/0N10YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OA/ZPNNI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21804606A321;
	Thu, 26 Nov 2026 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OA/ZPNNI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27981F000C4;
	Thu, 26 Nov 2026 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705106;
	bh=nLVF/BYVtI0HuWYbVdhPcVpEvsMfcH88M7WVucv+2RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA/ZPNNI5vrmLautdoe0sK0MhpBAE6WccJj3Hxj7Le3yOa9mstuM5cgp/98dr2HIU
	 ivhWyVNxaVG5h0tsdl/sNqYRIq38BoUYsZguDi9Hd5DUO8irZeueuu3WtwFjQ7YXar
	 XCXm0GXzqUzdmHj+m4aUQ2tx3NP5FG5fHJZZvK30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Williams <Tom.D.Williams@MorganStanley.com>,
	Guillaume Nault <gnault@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/319] tcp: Fix dup-ack detection on non-SACK bidirectional data transfer.
Date: Thu, 26 Nov 2026 15:37:34 +0100
Message-ID: <20261126144008.685209062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 11140c51df12e594d6bf2c8d2af5dec63b0219ac ]

When receiving a pure ack from a peer that also sends data, we can
have SEG.SEQ > SND.WL1, even though the segment contains no data. This
makes tcp_may_update_window() return true (because of the
"after(ack_seq, tp->snd_wl1)" condition), and tcp_ack_update_window()
then adds FLAG_WIN_UPDATE to the segment set of flags, even when
there's no window update.

Since FLAG_WIN_UPDATE prevents the segment from being considered as
dup-ack (as it's part of FLAG_NOT_DUP), this can inhibit fast
retransmit on non-SACK connections, making recovery very slow as it
now entirely relies on RTO.

The "DUPLICATE ACKNOWLEDGMENT" definition of RFC 5681, section 2,
says that lack of window update is a necessary condition for a dup ack:
"(e) the advertised window in the incoming acknowledgment equals the
advertised window in the last incoming acknowledgment.". Spurious
window updates can thus prevent dup ack detection and, in the end, fast
retransmit.

Avoid this scenario by setting FLAG_WIN_UPDATE only when a window
update actually occurs. Pure acks with SEG.SEQ > SND.WL1 can now
be detected as dup-ack and trigger fast retransmission.

Also, stop setting FLAG_WIN_UPDATE in tcp_ack()'s header prediction
path. One of the conditions for header prediction to happen is that
received segments don't trigger a window update. This flag update was
thus wrong to begin with. Now that tcp_ack_update_window() sets
FLAG_WIN_UPDATE only if a window update actually occurred, we need the
header prediction path to stop reporting spurious window updates too.
Otherwise BPF programs would get inconsistent window update information
(CA_ACK_WIN_UPDATE) between fast an slow paths.

Finally, add FLAG_SND_UNA_ADVANCED to the definition of FLAG_NOT_DUP.
This is necessary for the case where an incoming segment acknowledges
less than a full segment of the retransmit queue. Such segments were
not considered dubious by tcp_ack_is_dubious() because of the spurious
FLAG_WIN_UPDATE flag, which prevented the segment from being seen as a
duplicate ack. Now that FLAG_WIN_UPDATE doesn't cover this scenario
anymore, we need another way to mark these acks as non-duplicate.
Adding FLAG_SND_UNA_ADVANCED to FLAG_NOT_DUP is the natural way of
doing this, since, by definition, a segment advancing SND.UNA, even by
a small amount, cannot be a duplicate ack.

A side effect of this patch is that repeated zero window acks received
from peer can now be considered duplicate acks (because of the the
"|| !win" condition in tcp_may_update_window()). Therefore, they can
now trigger fast retransmission and fast recovery, including congestion
window reduction, when the peer is stalled. This is RFC compliant and
shouldn't have any negative effect.

Add packetdrill selftest. Before this patch, the 1001:2001 segment was
retransmitted upon RTO, now it's sent right after reception of the
third duplicate ack.

Thanks to Tom Williams for the investigation help and initial
reproducer.

Reported-by: Tom Williams <Tom.D.Williams@MorganStanley.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/6426d558e45fc6ab724c40af62e4a8793215dd8a.1793219189.git.gnault@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c                          |  6 +--
 .../tcp_bidir_fast_retransmit_nosack.pkt      | 42 +++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/net/packetdrill/tcp_bidir_fast_retransmit_nosack.pkt

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8b8c892810ee1..54e30bc368ca5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -103,7 +103,8 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
-#define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
+#define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED|	\
+				 FLAG_SND_UNA_ADVANCED)
 #define FLAG_CA_ALERT		(FLAG_DATA_SACKED|FLAG_ECE|FLAG_DSACKING_ACK)
 #define FLAG_FORWARD_PROGRESS	(FLAG_ACKED|FLAG_DATA_SACKED)
 
@@ -3632,11 +3633,11 @@ static int tcp_ack_update_window(struct sock *sk, const struct sk_buff *skb, u32
 		nwin <<= tp->rx_opt.snd_wscale;
 
 	if (tcp_may_update_window(tp, ack, ack_seq, nwin)) {
-		flag |= FLAG_WIN_UPDATE;
 		tcp_update_wl(tp, ack_seq);
 
 		if (tp->snd_wnd != nwin) {
 			tp->snd_wnd = nwin;
+			flag |= FLAG_WIN_UPDATE;
 
 			/* Note, it is the only place, where
 			 * fast path is recovered for sending TCP.
@@ -3919,7 +3920,6 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		 */
 		tcp_update_wl(tp, ack_seq);
 		tcp_snd_una_update(tp, ack);
-		flag |= FLAG_WIN_UPDATE;
 
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPACKS);
 	} else {
diff --git a/tools/testing/selftests/net/packetdrill/tcp_bidir_fast_retransmit_nosack.pkt b/tools/testing/selftests/net/packetdrill/tcp_bidir_fast_retransmit_nosack.pkt
new file mode 100644
index 0000000000000..5c66b7171d229
--- /dev/null
+++ b/tools/testing/selftests/net/packetdrill/tcp_bidir_fast_retransmit_nosack.pkt
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Verify that non-SACK connections properly detect duplicate acks when mixed
+// with other data segments from peer.
+
+`./defaults.sh`
+
+    0     socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
+   +0...0 connect(4, ..., ...) = 0
+
+   // Three-way handshake, SACK not supported by peer
+   +0 > S  0:0(0) <mss 1460,sackOK,TS val 0 ecr 0,nop,wscale 8>
+   +0 < S. 0:0(0) ack 1 win 65535 <mss 1000>
+   +0 > .  1:1(0) ack 1
+
+   // Send 1000 bytes, peer acks everything
+   +0 send(4, ..., 1000, 0) = 1000
+   +0 > P. 1:1001(1000) ack 1
+   +0 < .  1:1(0) ack 1001 win 65535
+
+   // Send 4000 more bytes
+   +0 send(4, ..., 4000, 0) = 4000
+   +0 > P. 1001:5001(4000) ack 1
+
+   // Receive first dup-ack (considering segment 1001-2001 was lost)
+   +0 < .  1:1(0) ack 1001 win 65535
+
+   // Receive unrelated data segment from peer and ack it
+   +0 < P. 1:11(10) ack 1001 win 65535
+   +0 > .  5001:5001(0) ack 11
+
+   // Receive second dup-ack
+   +0 < .  11:11(0) ack 1001 win 65535
+
+   // Receive another data segment from peer and ack it
+   +0 < P. 11:21(10) ack 1001 win 65535
+   +0 > .  5001:5001(0) ack 21
+
+   // Receive third dup-ack, which should trigger fast retransmit (without
+   // waiting for RTO)
+   +0 < .  21:21(0) ack 1001 win 65535
+   +0 > .  1001:2001(1000) ack 21
-- 
2.53.0



