Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207708;
	b=gxOUqUn+/wWemGsgbtBb1beYPlrf3dblEt37jy0sWL9/k2/NAKnFxQ03fTYZ/cEpBVrb
	 oWQxDHJ5JAFKzrONz9vtPSCJ+n/loxZHi11eWOqXcrHjHh80fwOVoFNgxtBMlg0HgO78t
	 Yot5ipmRuysOWF6g01qBalxHXd27g4xVajtLuIWA0av21VZB0+zfSDWuCcmHfENiVHT4y
	 wDKDFmxhSr1LPcwGf0QGKO7CqNVo6eJhSmi8yHzYvSr343bRv2vYng51fFdiVfd/6dikv
	 Ni7Z9nRsPMSsws2MVKBMqlPx+q0ldsD1UqsE9bufSRd1/Ilft/oa1pUJSzEjlWzBwYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ukz5ACLFOB5F0HpFRTOjfpZEEum5kbzISQ4GgZBMTNA=;
	b=SxaDQXLNcUw7OTq6vGFLqkI82q2Dupwb264dokmfuoAVr2vaydd06zZ3kauOMWSrc4O9
	 NN1BJ6IP/X2Xnql31qsnlSk1K8RqUlB1WyBrBF+wLea5GwtMXHplo+RLUSiZNHMXHyj6V
	 y4m7AVRQCa3cEvhEfkZrCnv1vX5LLtW3TNSFcNjDYaaw/MZZAtJYC19khZf4n6P978ZnW
	 aTtIEmwrLQjVdrOvpD9n2UJ77sZYxLxCHED2eoUnTNSAYqiLEWBljEOJEbumLLMKfwwuc
	 cqg1t13YTZwAAA39COKf0zD9GIXvjKA1t91pUMV6Oz8dtetTzyr2fpsfLNMAwllgoLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m3D/U/BT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1127606A325;
	Wed, 28 Oct 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3D/U/BT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC66A1F031E4;
	Wed, 28 Oct 2026 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207707;
	bh=Ukz5ACLFOB5F0HpFRTOjfpZEEum5kbzISQ4GgZBMTNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3D/U/BTtFzp5nC5gl9ByAP43CrBJAb82SyG8h261ZgwRGckK8ZzYuQXKg3IzCfmO
	 eaPmBmEJpopvOnxecy+X/cAogecgxKIYdNQzSTGY4F5Y3a6tUBAdtOiMRu7IXXbJif
	 IZX4+UlwlkpeyLJ6/DkQJfEQ3Qsr0pNlDyElNRzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <theminershive@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 110/247] sctp: validate chunk length in the inqueue parser
Date: Wed, 28 Oct 2026 17:58:33 +0100
Message-ID: <20261028165950.004327575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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


