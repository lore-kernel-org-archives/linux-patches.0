Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5E46AA89;
	Tue, 21 Jul 2026 22:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672310; cv=none; b=DgnNY5yoadKOkABtupLGIjeh4uAchPlAIqRlbyaC2q8x+0ZFDzqdMtkm1ELJT4umI5uoOsjfWhziRQpcNeYYDTQ6PlIxsAZyW6wxYZ/4Q1+HEkW4ZVzIEVD385OdDqRL0iPa39dS0BT5ldHLWa8431fhcpwYuwmz/ujizo+2VQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672310; c=relaxed/simple;
	bh=PlLEfMgr8dFyD+pF3Z4J3ki1iKF2xkwwxEHAMyNngeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IL9zhu5SshIEI90LfvrsEN5su0U4castLXDA9mXV8QXkRwOPkqVE5ZVuTwq4oaPCZ72c/+VUaQsMRGOjQeVNu4tP4tBkDmPf8dbZBspK+tbrf3rM+qJBnfGQo3ItVeEow1rIj2b0GUVG7Zv/BURzgS8U1KK3s6iuoyKQIlsxpMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONSaMFSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONSaMFSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1A81F000E9;
	Tue, 21 Jul 2026 22:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672309;
	bh=xNWwrmpa7JZXELIyAdjwURoOoMX1X11+x8XN9mi9Fls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONSaMFSX0TUUO0qZQu4OBbPUlpiZmSctUxa8g1rd0AwbPQU6uF34XXXsjQQVCX49W
	 ioO4Bm1NlmR0940G5MGSq9jijtVAF6cXqi6SX4xgAhSlCC9TKArf+JOX6FTFXVW31i
	 PttoTlz44JnHfAF00CZfixc1rvCE5pQUsN/gHVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 575/843] netfilter: nf_nat_sip: reload possible stale data pointer
Date: Tue, 21 Jul 2026 17:23:30 +0200
Message-ID: <20260721152418.983148769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nf_nat_sip.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -283,13 +283,22 @@ next:
 
 	/* Mangle destination port for Cisco phones, then fix up checksums */
 	if (dir == IP_CT_DIR_REPLY && ct_sip_info->forced_dport) {
+		int doff = *dptr - (const char *)skb->data;
 		struct udphdr *uh;
 
+		if (doff <= 0)
+			return NF_DROP;
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
 


