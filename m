Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021259;
	b=2jZlkawVdWvEJ9U4dzxGHaHe0w2d9p2NQoryOif6fVbIDMHlengv0aC1t9BvCbgw09p7
	 Pvy3O2LWPhB1lbjsRLMjtp0hmCU1o6PqPkuDx/L/AKEIquWkUMDu9Y4mKK7XQ1ik8fOX/
	 7hXUodLrYru6ThzBIX2SwJ3xJg0WK2FEzyTL617JFa0YOJ/PozdepNg0Bqk83sX3Irt6B
	 izU/tZvQZDC5KZV1hPnO2RPWztV0w4Xx/MMiWiJJLDrEMp2kvE0zpUPSOjl7amFCzbSv4
	 AlUgex5e5N/efhwhqztQVkHFyEoJwYFKBVs1pXHiRmkE96UtKfTkYzZ+O6bJ3hZCl1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utbtSA3KbtgNLamLjgyYRdWSBbxQTvBo4zKtf9bUOL0=;
	b=0jmObFBRcQwvcbIp0/Tw5JtjyyxVPtl7pStL3I8m/plg/nNT8rycqirZbCpniD5F3P0J
	 EMS6+sWm6ZzpkSDTd60KcpP1plD8BOqvNcU3GjMSB4uwuUid5LaPLDdkMW645fnRPS+mm
	 fApzRiyG4BLVAAN8HEIxdZ72HwUCpkFAAiq61myyiDJcihz5H08zdCYNOcwaIIozmQDy6
	 5IPPLjOL2IrFPGz90LtRCH76Ao04UNqI6g5pAK6SR6R8zSNHDIPQN2fYA4crW6EGBoofk
	 xD5eq4ISbmQXeDXscRhgF0NkT728uS47Unnx1gLu/s7r25l95fYhqDjUDNNYVhrv+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdnPFvs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A30606A320;
	Wed, 18 Nov 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdnPFvs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282291F000C4;
	Wed, 18 Nov 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021258;
	bh=utbtSA3KbtgNLamLjgyYRdWSBbxQTvBo4zKtf9bUOL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdnPFvs9e1X8XE/NFwlfWxNV0ZIGrCBd4cbZ5886mK+WXTYJt/0KK9oaCJgg4wQJc
	 Ut0QVCM3tVwSQoStqLNAjE4wMldv37MtuHmsuIw017SEW1s57S1pBjzdzs77k4NHz1
	 T11Gmi11GeZEl+t0DeMBr/kYHBNeWArq5wXxDwB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2244/2651] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150406.254539537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 27152bca8a8ce..4aade471afc45 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -595,6 +595,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -638,6 +641,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



