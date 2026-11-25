Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624467;
	b=pjqx83nA3ehhzj5f5njfU5YTI+Z5AObgIcfjf2pEzjYgnc5+ts9SPC+Pa6uwp4TwDfzN
	 4ebrF4HXqMtLH0kxaGZvstS3C5eO1xau/NruS200T2HgJ/BZ2XqHI4wo3b9EFPARENexn
	 qypX5vkAurQRF12ooou9XgDCiKJxVe3UncX5HXr/UKBd3rib0FbAc9gc+lLCxE/6NbW/M
	 IvBTj4m2wec62WPAhi5QKXX6qEkmESEe3kfMkOrDXqLZjLPHKClE6lK4ohafolro+76Vi
	 qcVS/rmIf0KvdzfZMYzyfQPEpTUV1KWU4ngIWHVi5BiRlmqGQRtbT+V3+bvih3GNiNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbH4e662m649eAEeilPuR4qtbRmtY1Ikh+Ecu97dgeI=;
	b=GmH0clbcQl3FLD1/kYT49E7NpUcSlEd84XcqZ6qrGlu5t12D3nP+mdabqBIKUwRq599B
	 QpLPJfvqIF2MvQ038t/qKWF3m2KMOShOvRNegs4VP38zAo42MGSr2ZMba83YDa7cGIAv+
	 bvVhNJ7PU2iNMrFcz2xrsogx45fFrAJhOa2E7e/EaLYG4MbVoKmGIVX8nGxvhmKiM+cDu
	 I1zahIZPRlXYofVNFlKL34GPaHF9VtCu8x0XyV6enmFU4AS9O63C1ua70/O6uvYT9eoSP
	 TEOmeh4ENiY4ZrLiy54Go+JgLSvj7qPGAWm2gRUnONJ/CaP7e64bUc/867Rhhw+nsQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfWsc2pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD13606A338;
	Wed, 25 Nov 2026 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfWsc2pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A601C1F000C4;
	Wed, 25 Nov 2026 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624467;
	bh=FbH4e662m649eAEeilPuR4qtbRmtY1Ikh+Ecu97dgeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfWsc2pqQUJaA9lM1ZDfIEXHsyKVezRufE29esYLRugTHRVJ3n6FF4DhYQUT9a+g6
	 xYcVuvfTYjHo6zu2ujBosqMDVH4k3KbvkyLA2pPWnDL/yODRePgegVYiJ/e5cTbt5Y
	 rE4/OqxO9mGrcRssqicF6LQHlGKOlC45lPLgf/fc=
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
Subject: [PATCH 6.12 202/816] tcp: Fix dup-ack detection on non-SACK bidirectional data transfer.
Date: Wed, 25 Nov 2026 15:29:10 +0100
Message-ID: <20261125143853.870600448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e529ecb9b42b8..547adefba7ea9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -104,7 +104,8 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
-#define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
+#define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED|	\
+				 FLAG_SND_UNA_ADVANCED)
 #define FLAG_CA_ALERT		(FLAG_DATA_SACKED|FLAG_ECE|FLAG_DSACKING_ACK)
 #define FLAG_FORWARD_PROGRESS	(FLAG_ACKED|FLAG_DATA_SACKED)
 
@@ -3717,11 +3718,11 @@ static int tcp_ack_update_window(struct sock *sk, const struct sk_buff *skb, u32
 		nwin <<= tp->rx_opt.snd_wscale;
 
 	if (tcp_may_update_window(tp, ack, ack_seq, nwin)) {
-		flag |= FLAG_WIN_UPDATE;
 		tcp_update_wl(tp, ack_seq);
 
 		if (tp->snd_wnd != nwin) {
 			tp->snd_wnd = nwin;
+			flag |= FLAG_WIN_UPDATE;
 
 			/* Note, it is the only place, where
 			 * fast path is recovered for sending TCP.
@@ -4036,7 +4037,6 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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



