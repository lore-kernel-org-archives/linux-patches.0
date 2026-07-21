Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA41439904;
	Tue, 21 Jul 2026 21:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669964; cv=none; b=Ii7OboemRuraZ3H3T39ECTapVnPXlLFdZ8aPsv+KAyzKDmWUv4T2Sw9rqAJvetPQPl0HV0KFjSINgF33Cm/d3D/6pyWcEZW9Vgal18OzxoEQb1fD8PchtvUiaFPrF7akzXX47ZwGPyhZEbU8x7prDqFHT8Koi3FvR9pYHJrrBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669964; c=relaxed/simple;
	bh=SNXC45PnrydvGWNKIdjCtFZkgTPmaaQ1oxUVrt1dR6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOvxnZSwzPeZp8YLk6oQGk8p7cxG6y3zRNTGVSEJ8H7H3E0LwMFzL1oPj2+d1/kI2pssd0FWSXnQlSGqs4KUGCn6fK9PyD79kfI/CSaAt4Uwuf3+WCW861JUCSFgP0SP780XAoTZ6weEzLCngymMnVdBuhRU8Z3Hn0JtIxpuXnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpCWHSRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpCWHSRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737EA1F000E9;
	Tue, 21 Jul 2026 21:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669963;
	bh=TIW+Y5KHIq9F7JgnpLK1ZPIr1tgxzIpAAWXXzZzfkRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpCWHSRbzTCjEnbeKrVq0hfREPV3eY938GZf0bpSexYiz9ZaC8LQPND+lAFOvhEW5
	 qfBqTxEAgT9c9501DOn7gff1F6lDY0faiyv/Vhps539Fu33GpX+7nTfc0JT8L878/E
	 +s1f7GRWib2zsVjpSZm37QBAe3qrmb/4rSk8Ew1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0746/1067] netfilter: nf_nat_sip: reload possible stale data pointer
Date: Tue, 21 Jul 2026 17:22:27 +0200
Message-ID: <20260721152441.265927038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 77e43bcb7ec177e293a5c3f1b91a2c5aebfb6c68 upstream.

quoting sashiko:
 ------------------------------------------------------------------------
 [..] noticed a potential memory bug and header corruption involving the
 SIP NAT helper.

 In net/netfilter/nf_nat_sip.c:nf_nat_sip():
	if (skb_ensure_writable(skb, skb->len)) {
		nf_ct_helper_log(skb, ct, "cannot mangle packet");
		return NF_DROP;
	}
	uh = (void *)skb->data + protoff;
	uh->dest = ct_sip_info->forced_dport;
	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo, protoff,
				      0, 0, NULL, 0)) {

 If a cloned or fragmented SKB is reallocated by skb_ensure_writable(), the
 old data buffer is freed. However, nf_nat_sip() fails to update *dptr to
 point to the new buffer.

 It also appears to use nf_nat_mangle_udp_packet() on what could be a TCP
 packet, which would overwrite the sequence number with a checksum update.
 ------------------------------------------------------------------------

nf_conntrack_sip linerizes skbs, hence no fragmented skb can be seen.
But clones are possible, so rebuild dptr.

Disable nf_nat_mangle_udp_packet() branch for TCP streams.
It doesn't look like this can ever happen, else we should have received
bug reports about this, so just check the conntrack is UDP and drop
otherwise.

The calling conntrack_sip set ->forced_dport for SIP_HDR_VIA_UDP messages,
so I don't think this is ever expected to be true for a TCP stream.

Fixes: 7266507d8999 ("netfilter: nf_ct_sip: support Cisco 7941/7945 IP phones")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_nat_sip.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -283,13 +283,24 @@ next:
 
 	/* Mangle destination port for Cisco phones, then fix up checksums */
 	if (dir == IP_CT_DIR_REPLY && ct_sip_info->forced_dport) {
+		int doff = *dptr - (const char *)skb->data;
 		struct udphdr *uh;
 
+		if (doff <= 0) {
+			DEBUG_NET_WARN_ON_ONCE(1);
+			return NF_DROP;
+		}
+
+		/* ct_sip_info->forced_dport only expected with UDP */
+		if (nf_ct_protonum(ct) != IPPROTO_UDP)
+			return NF_DROP;
+
 		if (skb_ensure_writable(skb, skb->len)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle packet");
 			return NF_DROP;
 		}
 
+		*dptr = skb->data + doff;
 		uh = (void *)skb->data + protoff;
 		uh->dest = ct_sip_info->forced_dport;
 


