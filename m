Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B3519AD5C;
	Tue,  8 Apr 2025 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112570; cv=none; b=IURfFHITdPl1ObBCMlnY0j0cU8BfR/wMCyPJRGMcCS2D7ogDR+4L9zmWfHH8wS5YcaAeypEEj1thd2r5gBTQ86FgB0UDeYIc0y54VvR7kis2G4zsBkCQyfRnKg+6JqzIXZTzyhLZrhHu6TLZeJTAkCDiv/qYHGTyyNhRyRsBsbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112570; c=relaxed/simple;
	bh=VbuYX/V4nlhmKrGC1CDP6sTCv5QNuGy1qEGnhqOg31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lvq7LxmkpL+l1oUfqMoD8T/9Mrv2j1Wiz3PyWxdL9oK7PkuTc8glU+w8KsTdxVWx2ifhs693MRATojE0hrFvpaq26Mc6p6dgQyKNsnjEfW2625sDc3ezNJBA61TZp2ix56+8CKc0CVjxK1xflsC/eql123maUjgJcVnn2QcSYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB91UiAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB91UiAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB455C4CEE5;
	Tue,  8 Apr 2025 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112570;
	bh=VbuYX/V4nlhmKrGC1CDP6sTCv5QNuGy1qEGnhqOg31M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB91UiAh3iNNrc4zSeS7fivTby64iMF7YwZnBBKRwySswPG3WGUR8OtEaeQmDFZD0
	 ungNfyfmuiGkVDJMhttah7rQxjnlfGx+9rNZDVuIEFZ4s5fuYHTni1AHgmgtpZ8MlP
	 HUMx0ZD6qzMZyp8FIhzxgaXTxEh/F7s7q08PGRTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 116/279] netfilter: socket: Lookup orig tuple for IPv6 SNAT
Date: Tue,  8 Apr 2025 12:48:19 +0200
Message-ID: <20250408104829.476978624@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maxim Mikityanskiy <maxtram95@gmail.com>

commit 932b32ffd7604fb00b5c57e239a3cc4d901ccf6e upstream.

nf_sk_lookup_slow_v4 does the conntrack lookup for IPv4 packets to
restore the original 5-tuple in case of SNAT, to be able to find the
right socket (if any). Then socket_match() can correctly check whether
the socket was transparent.

However, the IPv6 counterpart (nf_sk_lookup_slow_v6) lacks this
conntrack lookup, making xt_socket fail to match on the socket when the
packet was SNATed. Add the same logic to nf_sk_lookup_slow_v6.

IPv6 SNAT is used in Kubernetes clusters for pod-to-world packets, as
pods' addresses are in the fd00::/8 ULA subnet and need to be replaced
with the node's external address. Cilium leverages Envoy to enforce L7
policies, and Envoy uses transparent sockets. Cilium inserts an iptables
prerouting rule that matches on `-m socket --transparent` and redirects
the packets to localhost, but it fails to match SNATed IPv6 packets due
to that missing conntrack lookup.

Closes: https://github.com/cilium/cilium/issues/37932
Fixes: eb31628e37a0 ("netfilter: nf_tables: Add support for IPv6 NAT")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/nf_socket_ipv6.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -103,6 +103,10 @@ struct sock *nf_sk_lookup_slow_v6(struct
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn const *ct;
+#endif
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
 	if (tproto < 0) {
@@ -136,6 +140,25 @@ struct sock *nf_sk_lookup_slow_v6(struct
 		return NULL;
 	}
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	/* Do the lookup with the original socket address in
+	 * case this is a reply packet of an established
+	 * SNAT-ted connection.
+	 */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct &&
+	    ((tproto != IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
+	     (tproto == IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_RELATED_REPLY)) &&
+	    (ct->status & IPS_SRC_NAT_DONE)) {
+		daddr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
+		dport = (tproto == IPPROTO_TCP) ?
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port :
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	}
+#endif
+
 	return nf_socket_get_sock_v6(net, data_skb, doff, tproto, saddr, daddr,
 				     sport, dport, indev);
 }


