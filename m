Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774917;
	b=Vs/b2LsRQCGa00SHSuwtWIcEHGQv7CRzdxFZ4ypUvSr9/gFRlMJNa7A3XGpk4+XkYnYM
	 A/6ofuGIjLwVlx2LZndxa61A4I3+RHZCkXguPCreYab4oi83ao8z+So79FG8WKprY0Dnr
	 sAC44YQGhVUOo4OcHKh2/JoRXiky4okad7RfZCawiI2k91yLg9gw5RIVJzrecyyZ1XjeR
	 m5VQwXrDUfKhmJ6p8ZzakelMBl4dThVAm2QTkRkfHOH9K1R27uGhBWxuNmKqbvVPILLwg
	 M1GscCo8s/yP9B/PgR8c5V22pr6AGe41cF9J0N1uCKc3r9/ylUbX0BX6C2NiyWTMiKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IALod0vEC7M6FPCBDjO8/wOQW0qlHa5SzfuSsyRMSxQ=;
	b=RUm5I4NQhQTCvFNXT/BxRJ/1iMRq/67Ws3n+R6udgxkcRl/cf6zUgQMzs//QLwC9U/m4
	 qW4xrBWGPGGyQUxjW8K3EyRxWnxQ8YJOkPbCpCpZ+/Q7ZeIsQMxiPKzG4mWS+gP4JnPBq
	 NXJqSr9pi1AKC5R7pW1tm06PHGgp22J7AgNbLm5Qj70n84asq+icMbXXkElyl9x3XWi6B
	 o4Fo4RRmulVR8jwsxvbcaW3y5j8uW9//gOzRiZ+Hgz2HNzDqrZ49fdIRyuMciFAxQE0y8
	 +Zh5AI2bHEcXAMwWrJe5Gm6NJyOSLrWoHn3gdHHaeXezWyMWzPiR9+61Z023Ij22KxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OP+5Zdqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758DB606A31A;
	Fri, 23 Oct 2026 17:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OP+5Zdqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F6E1F01825;
	Fri, 23 Oct 2026 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774917;
	bh=IALod0vEC7M6FPCBDjO8/wOQW0qlHa5SzfuSsyRMSxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OP+5Zdqwm2N2jp8iMNol0hZbO/5CBeku+guoaigogy9L2wZ8ihCFWpxWjoVPQ0U1O
	 pOtEtABgFHWFNreESiaqRQ36wh/0UldDTGvBn8UpWakjbovcy7GqzbC/k38aHaMA5u
	 Nc5UyfV4fBlrWn7YAnv8Ck9eZl2kTn9GO+1zRUrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <theminershive@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 200/242] sctp: validate chunk length in the inqueue parser
Date: Fri, 23 Oct 2026 18:40:42 +0200
Message-ID: <20261023163718.521171430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


