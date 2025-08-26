Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211234166E;
	Tue, 26 Aug 2025 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214016; cv=none; b=PK086rZcNqsEsl/egQtmhYxdn6c5h/S6P43G3mfpc3tthts/9/Nx+Js/eLX4sj9ENR+5PIOJEuiRISS6gA5wEZlVMKFpxIZA41wu6l0fFMgeUXNsZTFWZFgzfsHtrxr2vBBiw96jPO5DVqcSov1EOjC1HTGy9pO6TGyc+xh9po4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214016; c=relaxed/simple;
	bh=fHxzT1dwOSyDASW13Jq0SqKoe5E5oDyIAfu5yWrpjvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ5qI9GLdgEkdPOTvqV3jW3YBagGuXWiQ3Q0R9SXZzDt2rPeGrEPCROyloqJ5HQIJ+C5cvBhqcY3qpndTSLc6M5tyciXEd7/XCilKXmMatEx2iGVT5yj8mgPRXhfrPL81f528UHKkV3plA72IE1JqqpxrQsTbAWU6hUbzusWwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4yBQcoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4yBQcoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8022FC4CEF1;
	Tue, 26 Aug 2025 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214015;
	bh=fHxzT1dwOSyDASW13Jq0SqKoe5E5oDyIAfu5yWrpjvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4yBQcoKlATgWwZjoQNPkGUbekEdu/cdf2kvmRgeqJseba/T7tKEBffSejvw7ogmy
	 ICgLK1glkNKuBtotJsFAiKQQ8lilG6FxvZ4crqfif365BZWjQ6oL5FQDh7r7y7zkYM
	 uCGe+1KvujIW14Ty3DtPEo0eztLZB6wY9epjTYbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianhao Zhao <tizhao@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jakub Ramaseuski <jramaseu@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 565/587] net: gso: Forbid IPv6 TSO with extensions on devices with only IPV6_CSUM
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826111007.400566778@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Ramaseuski <jramaseu@redhat.com>

[ Upstream commit 864e3396976ef41de6cc7bc366276bf4e084fff2 ]

When performing Generic Segmentation Offload (GSO) on an IPv6 packet that
contains extension headers, the kernel incorrectly requests checksum offload
if the egress device only advertises NETIF_F_IPV6_CSUM feature, which has
a strict contract: it supports checksum offload only for plain TCP or UDP
over IPv6 and explicitly does not support packets with extension headers.
The current GSO logic violates this contract by failing to disable the feature
for packets with extension headers, such as those used in GREoIPv6 tunnels.

This violation results in the device being asked to perform an operation
it cannot support, leading to a `skb_warn_bad_offload` warning and a collapse
of network throughput. While device TSO/USO is correctly bypassed in favor
of software GSO for these packets, the GSO stack must be explicitly told not
to request checksum offload.

Mask NETIF_F_IPV6_CSUM, NETIF_F_TSO6 and NETIF_F_GSO_UDP_L4
in gso_features_check if the IPv6 header contains extension headers to compute
checksum in software.

The exception is a BIG TCP extension, which, as stated in commit
68e068cabd2c6c53 ("net: reenable NETIF_F_IPV6_CSUM offload for BIG TCP packets"):
"The feature is only enabled on devices that support BIG TCP TSO.
The header is only present for PF_PACKET taps like tcpdump,
and not transmitted by physical devices."

kernel log output (truncated):
WARNING: CPU: 1 PID: 5273 at net/core/dev.c:3535 skb_warn_bad_offload+0x81/0x140
...
Call Trace:
 <TASK>
 skb_checksum_help+0x12a/0x1f0
 validate_xmit_skb+0x1a3/0x2d0
 validate_xmit_skb_list+0x4f/0x80
 sch_direct_xmit+0x1a2/0x380
 __dev_xmit_skb+0x242/0x670
 __dev_queue_xmit+0x3fc/0x7f0
 ip6_finish_output2+0x25e/0x5d0
 ip6_finish_output+0x1fc/0x3f0
 ip6_tnl_xmit+0x608/0xc00 [ip6_tunnel]
 ip6gre_tunnel_xmit+0x1c0/0x390 [ip6_gre]
 dev_hard_start_xmit+0x63/0x1c0
 __dev_queue_xmit+0x6d0/0x7f0
 ip6_finish_output2+0x214/0x5d0
 ip6_finish_output+0x1fc/0x3f0
 ip6_xmit+0x2ca/0x6f0
 ip6_finish_output+0x1fc/0x3f0
 ip6_xmit+0x2ca/0x6f0
 inet6_csk_xmit+0xeb/0x150
 __tcp_transmit_skb+0x555/0xa80
 tcp_write_xmit+0x32a/0xe90
 tcp_sendmsg_locked+0x437/0x1110
 tcp_sendmsg+0x2f/0x50
...
skb linear:   00000000: e4 3d 1a 7d ec 30 e4 3d 1a 7e 5d 90 86 dd 60 0e
skb linear:   00000010: 00 0a 1b 34 3c 40 20 11 00 00 00 00 00 00 00 00
skb linear:   00000020: 00 00 00 00 00 12 20 11 00 00 00 00 00 00 00 00
skb linear:   00000030: 00 00 00 00 00 11 2f 00 04 01 04 01 01 00 00 00
skb linear:   00000040: 86 dd 60 0e 00 0a 1b 00 06 40 20 23 00 00 00 00
skb linear:   00000050: 00 00 00 00 00 00 00 00 00 12 20 23 00 00 00 00
skb linear:   00000060: 00 00 00 00 00 00 00 00 00 11 bf 96 14 51 13 f9
skb linear:   00000070: ae 27 a0 a8 2b e3 80 18 00 40 5b 6f 00 00 01 01
skb linear:   00000080: 08 0a 42 d4 50 d5 4b 70 f8 1a

Fixes: 04c20a9356f283da ("net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Suggested-by: Michal Schmidt <mschmidt@redhat.com>
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Jakub Ramaseuski <jramaseu@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250814105119.1525687-1-jramaseu@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4006fd164b7b..2d3e0e4130c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3559,6 +3559,18 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 			features &= ~NETIF_F_TSO_MANGLEID;
 	}
 
+	/* NETIF_F_IPV6_CSUM does not support IPv6 extension headers,
+	 * so neither does TSO that depends on it.
+	 */
+	if (features & NETIF_F_IPV6_CSUM &&
+	    (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
+	     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
+	      vlan_get_protocol(skb) == htons(ETH_P_IPV6))) &&
+	    skb_transport_header_was_set(skb) &&
+	    skb_network_header_len(skb) != sizeof(struct ipv6hdr) &&
+	    !ipv6_has_hopopt_jumbo(skb))
+		features &= ~(NETIF_F_IPV6_CSUM | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4);
+
 	return features;
 }
 
-- 
2.50.1



