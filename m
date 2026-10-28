Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217023;
	b=PDTnD0UIrZ/ahe/ZIbqLDHaGpisPk8jZkkqpgtRMz74j9veIgzkdFPTi1tUyOlUO++Ga
	 czEGvGY0IOUt2AuZNSsOaA/gV4lfH1nVUXacpDyAUj+52RTvL8iIDjnh6uYT+fppkIbUC
	 8fJUCgbVt/l+m7WZpU+K2uOOV+cJLfE/XhoJsqlr7FMs/P28uLuZtRgeJuxYs9LhyvcDZ
	 2Ek+mZbgJVM5oygILSGyJzt2GsuNg6OZz/4lNpbiQ+SrNNCu1DkhAEq91ePfRxQCT0WAV
	 QO3VaTRBboeoxlzM50yrtEfBmcF5Ctt5NkAeS0w03u/8JFTd1bUjwbsuIvmBWsQeegg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wtb0/ytd0dpsw5dx6rJwFGerf4EaV2xAmnnKtC79TRE=;
	b=Is+e8KVcwko0s+sukIOtQuztBs2YKG8mvE9x+EjgeP5xOeabLs6gims46926eOQdO7VV
	 8TEjFFSogBIiqom1ZoyiJkr93dVNRsGg/DWlnzvVlqJHq1jCI+K0IGfnSPqGGd6HlVB77
	 j5YDAVuRM9Zoy+Jkm7pM2ah6myPQuPf14rsdp78I6QlbxDkRI9rv/X4L2898GnE3YC1ie
	 k1yOspVHDkRoubjXXKRfojxnf+Jlpv4PZXyd/tsruNHnmvszjIo1Yt7ZMgmE20VZIWHad
	 dmKVl2/0zAgoLTf+ZJhBz/1pIs8gnLHJbVOwnfvoVxiIomMH7/AIYLCa1SKqOT4j/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YatCciCP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE34606A320;
	Wed, 28 Oct 2026 19:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YatCciCP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4851F01825;
	Wed, 28 Oct 2026 19:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217023;
	bh=Wtb0/ytd0dpsw5dx6rJwFGerf4EaV2xAmnnKtC79TRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YatCciCPL7a/0BR+R/i/rsONwF18mxwhPyuCq98g5CrKrnS10rFG1axep9qRlE8Ij
	 G9Kq1iW+pX6kk25E2oGGEFC/DDDcO4g3+0tY6D+Ik+8rI6Tx96oshh7rw3Lw1HcX0j
	 Ue1u6yM0Ex3i9oqWVypqZ85K4C4UE0Gc5mU6whCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <theminershive@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 1761/1887] sctp: validate chunk length in the inqueue parser
Date: Wed, 28 Oct 2026 18:04:17 +0100
Message-ID: <20261028170539.532173279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Vosburgh <theminershive@gmail.com>

commit 6cfc1b90cb86f4aabc69fb8e30128e07e2cdfa3a upstream.

SCTP chunks always include a four-byte generic header, but
sctp_inq_pop() currently accepts shorter declared lengths. A zero-length
chunk leaves chunk_end at the current header.

When ASCONF is covered by the association's SCTP-AUTH policy,
sctp_assoc_bh_rcv() can continue before the state machine performs its
normal chunk-length check. sctp_inq_pop() then returns the same malformed
chunk repeatedly and the receive softirq can lock up.

A remote SCTP peer can trigger this after establishing an association on
a kernel built with CONFIG_IP_SCTP and configured with
net.sctp.addip_enable=1 and net.sctp.auth_enable=1. The reproducer did
not require application credentials, a shared SCTP AUTH key, or
net.sctp.addip_noauth_enable=1.

On commit f967455fb2a5 ("seg6: reset IP6CB after IPv6 decapsulation"),
one zero-length ASCONF caused repeated
watchdog soft-lockup reports in a two-vCPU KVM guest. All 3 pre-trigger
health probes succeeded, while 36 of 37 post-trigger probes failed. With
this change, all 37 post-trigger probes succeeded and no equivalent
soft-lockup signature appeared.

Reject chunks shorter than the generic SCTP header at the shared inqueue
parser boundary. Mark the packet for discard before either caller can
continue processing it, while preserving the four-byte generic minimum.
Declared-length 1 through 4 controls and kernel-generated ASCONF traffic
remained healthy. The patched sctp_hello selftest passed for IPv4 and
IPv6.

The complete private reproducer and validation evidence are available
directly to maintainers on request.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Cc: stable@vger.kernel.org
Signed-off-by: Charles Vosburgh <theminershive@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260827-sctp-zero-chunk-inqueue-v2-1-2e7669c6a6cb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/inqueue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -212,8 +212,10 @@ new_skb:
 	chunk->chunk_end = ((__u8 *)ch) + SCTP_PAD4(ntohs(ch->length));
 	skb_pull(chunk->skb, sizeof(*ch));
 	chunk->subh.v = NULL; /* Subheader is no longer valid.  */
-
-	if (chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb)) {
+	if (unlikely(ntohs(ch->length) < sizeof(*ch))) {
+		chunk->pdiscard = 1;
+	} else if (chunk->chunk_end + sizeof(*ch) <=
+		   skb_tail_pointer(chunk->skb)) {
 		/* This is not a singleton */
 		chunk->singleton = 0;
 	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {


