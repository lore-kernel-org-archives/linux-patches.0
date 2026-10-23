Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774230;
	b=4/6chRD9AZV2MlUSPXqstqmaOBHfJNlbSsROHTZ8a8V+QnCLnJ9BdmPMwCRJYR7NUHKG
	 X8Rg3YPcbOXqtoCRMf3RVjbwb2HqxDWRhQ1p4EJLnhr5ToGca/VVvz2gy5HbP+RyitzYB
	 81d0B1B3ChQNqm5SatqprA56nMZPLQ8bvnMGfiN8lNBjrYrk7m42PAtbT5EI2rzKLCzDl
	 letsDVQ+28eOZyxrQenwVBmi9u/ggZVmnwicUZT40B63FOq25zsgK+J7nGcHxLbSpOvHN
	 gu9cpZ4SnTHo/G2URf9/Qsewm3cVoa9dufya4Wh7RoVMXCR9oFO9sOT2E4tuqdBx2tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOBB+2YaGRd8FJIFnsRSqRihs5+VPD8v0kmYGnpprfs=;
	b=xQEMuchZYZ2Mnp34GNe7Vl3i/t8maLJ6YM0aEujhcM7BJ4v44pcrzn4RIeq9XSsQQszJ
	 +ZkfA9c3oXRNfRDPwf/cjRtGHYxgo6OIsLLhcGCk1nijcLPlavs7uszgtppp4OGb7Cvk+
	 BgIKmEarLzzNzDgjVyI/NpJmmJqB/V3sjffIxCTl/MlUHPB/cuQ+MszLLkRVE2hSBo6k/
	 TQVPTVZembp7UBaa0u8yREh/wgDFzMVvcU7fkVx/M9wT3VkSEIKU695FEDRcy9Pa0M04K
	 oUbTfTKmEZtPqcSwOBDtNScVkirZu+WSWSjwBbr5ewf/DQi7QGvy3sE/pwTarjSNYFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jyrb0+hd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79C606A322;
	Fri, 23 Oct 2026 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jyrb0+hd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1281F01825;
	Fri, 23 Oct 2026 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774229;
	bh=nOBB+2YaGRd8FJIFnsRSqRihs5+VPD8v0kmYGnpprfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jyrb0+hdpJMOyqtc9Evg5rjeKo8lWxVL63c3A58cl30x1dGDv5od33I1nK8GcQWXC
	 H581+WBOu95LZHjNYaHy3stHKC7oK/k0ERJqfksIu+0uLzcRizOPV3bygOWfEnj0od
	 GXi3nBO2B7mBSx3tC64uLoMdjir+b1nNMYqCFfyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <theminershive@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 137/193] sctp: validate chunk length in the inqueue parser
Date: Fri, 23 Oct 2026 18:36:54 +0200
Message-ID: <20261023163717.449399245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


