Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209557;
	b=PE0huI5tQ+aUaNb2ACBF4iYDbc9y65exPMlHhx2sLDQX7fAgk9ZE1s6qMVxvdhQDMoFH
	 rJhX5ZEsbuuv2BGfPVVwpO2/RWPl734fndhuCYNvPCGp6Kq4oIhzrD5YJerP+wgfxifTH
	 K+2AfoVObLunQscroRzyPmJgdGSp/n8crY1g0nf60KiIGCIXYc2U9S9FsZS0mcp4/l0Ac
	 KHxJdIyYMkqsB+L6MfgbDd0pgGqSF3U0ZzPTEfbUIH85ZjU8L8JjTtQxH/wQL1EeK94IE
	 uCFhDDfxlbCCh9bqt0s9NTDDZBKC9ZRLgV/VfGyDeSsJT/+ekBdaUrKLcoVYXSv8MEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eYfF6kWFCqu/DjJrMlw0cWWbkHnBCYrJKNl3w5OTBmI=;
	b=uBeFj07fTz0R3oedH7efFeq+o1xd9z+mWQmvKqVvbzuS/ngWpl8cW06HgHMbrL/xapw3
	 p/7B5tVHG5LqE/VZNxFmk6VcbaY1dwMVQh4hWc+PBzQEiWNgiFfK41XpyaHa1A6ukAeQQ
	 EfsawRT4+RtO+AN9Ei9oqisZHlX1oXHls2qF4svsiNVNjawZ5cD+ef2XNRqd4Z9pNtUZ5
	 NpvuXvkGsOZEwD04fQQjWdfbc2yd1l0/aF+3NifIL8r8rntotQ8qI5bCykiDM4JsXKs92
	 pQhMRX91jRHJMRC9noa5XQvfit48YACg838++SNs4b92g2T1LcoxXS1GsTQ0GZmn2Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9eKRaO4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A604606A31A;
	Wed, 28 Oct 2026 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9eKRaO4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8321F01825;
	Wed, 28 Oct 2026 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209557;
	bh=eYfF6kWFCqu/DjJrMlw0cWWbkHnBCYrJKNl3w5OTBmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9eKRaO4Xrro/AMP6HSZk1q8m3EmdlyxNFE0BLyLu0drp38mrXHvD28ldumG7g6GU
	 nu7soE9Qm6DrfVj7jZ/+/F/jcJMVgZhsCt9mXi5qbG73jGfVYJizS6HodvCE5gOOoO
	 TCpl+IG4bB+OWXRj4itWjS9ctVxXk6q/xML3zkkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <theminershive@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 470/516] sctp: validate chunk length in the inqueue parser
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028170014.616198363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -205,8 +205,10 @@ new_skb:
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


