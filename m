Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBE6250C14;
	Wed,  5 Mar 2025 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198103; cv=none; b=mGfeQTvTeEktlMCtOgklrUTljPTy4ktPssdKb+akTYmO9lUDGTc+oAbEh6FkuOfXxvlsCwGLD39aAqSf4VvKDYkmSKT4fQriDDpZQwZzx4SLTUqGLZRzEMzqOeln56pLEAMRMwSVpknC9fAeRRBWI+NEzbbf9go8QDnYQ2hIc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198103; c=relaxed/simple;
	bh=slrw86S9Bj0njc3BD8tXF0dfhkI3eRAtghacwKON8y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrXsTHx4Allj1QQyrfURsJ4KIdi0CjK5rV5MYdlqSspAbsR2lZywWeqwpBESMm+czrea09z6JHc9Cfb59wLFvQXqgyBJFb8hlouDSQTB778Q7Cv+SydyRrD1PAjIt2JflepHXxExnx9TLn7kQKXIQeQtRWGsnB7HhXsSux59L9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npfUX6OE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npfUX6OE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD40C4CEE9;
	Wed,  5 Mar 2025 18:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198103;
	bh=slrw86S9Bj0njc3BD8tXF0dfhkI3eRAtghacwKON8y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npfUX6OE8Ijp4rLCZpijcYqI3C4sIWfVmTv1Svx3R5JIDdQV6GE6A7+WnC/1i0Udt
	 yJp8AdtxlaNN+NNoylhE0n8FsnfKaFTg5Eql2oSoWjVwv+q49RqaJDId6LnCV2If4H
	 duLd/Thjq/NkGvobhyRPO+ZFoB/5sVdPngmucDDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Alan Brady <alan.brady@intel.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Willem de Bruijn <willemb@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/150] idpf: fix checksums set in idpf_rx_rsc()
Date: Wed,  5 Mar 2025 18:48:14 +0100
Message-ID: <20250305174506.431656897@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 674fcb4f4a7e3e277417a01788cc6daae47c3804 ]

idpf_rx_rsc() uses skb_transport_offset(skb) while the transport header
is not set yet.

This triggers the following warning for CONFIG_DEBUG_NET=y builds.

DEBUG_NET_WARN_ON_ONCE(!skb_transport_header_was_set(skb))

[   69.261620] WARNING: CPU: 7 PID: 0 at ./include/linux/skbuff.h:3020 idpf_vport_splitq_napi_poll (include/linux/skbuff.h:3020) idpf
[   69.261629] Modules linked in: vfat fat dummy bridge intel_uncore_frequency_tpmi intel_uncore_frequency_common intel_vsec_tpmi idpf intel_vsec cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd libeth
[   69.261644] CPU: 7 UID: 0 PID: 0 Comm: swapper/7 Tainted: G S      W          6.14.0-smp-DEV #1697
[   69.261648] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
[   69.261650] RIP: 0010:idpf_vport_splitq_napi_poll (include/linux/skbuff.h:3020) idpf
[   69.261677] ? __warn (kernel/panic.c:242 kernel/panic.c:748)
[   69.261682] ? idpf_vport_splitq_napi_poll (include/linux/skbuff.h:3020) idpf
[   69.261687] ? report_bug (lib/bug.c:?)
[   69.261690] ? handle_bug (arch/x86/kernel/traps.c:285)
[   69.261694] ? exc_invalid_op (arch/x86/kernel/traps.c:309)
[   69.261697] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621)
[   69.261700] ? __pfx_idpf_vport_splitq_napi_poll (drivers/net/ethernet/intel/idpf/idpf_txrx.c:4011) idpf
[   69.261704] ? idpf_vport_splitq_napi_poll (include/linux/skbuff.h:3020) idpf
[   69.261708] ? idpf_vport_splitq_napi_poll (drivers/net/ethernet/intel/idpf/idpf_txrx.c:3072) idpf
[   69.261712] __napi_poll (net/core/dev.c:7194)
[   69.261716] net_rx_action (net/core/dev.c:7265)
[   69.261718] ? __qdisc_run (net/sched/sch_generic.c:293)
[   69.261721] ? sched_clock (arch/x86/include/asm/preempt.h:84 arch/x86/kernel/tsc.c:288)
[   69.261726] handle_softirqs (kernel/softirq.c:561)

Fixes: 3a8845af66edb ("idpf: add RX splitq napi poll support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alan Brady <alan.brady@intel.com>
Cc: Joshua Hay <joshua.a.hay@intel.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20250226221253.1927782-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 1e0d1f9b07fbc..afc902ae4763e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3013,7 +3013,6 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 	skb_shinfo(skb)->gso_size = rsc_seg_len;
 
 	skb_reset_network_header(skb);
-	len = skb->len - skb_transport_offset(skb);
 
 	if (ipv4) {
 		struct iphdr *ipv4h = ip_hdr(skb);
@@ -3022,6 +3021,7 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 
 		/* Reset and set transport header offset in skb */
 		skb_set_transport_header(skb, sizeof(struct iphdr));
+		len = skb->len - skb_transport_offset(skb);
 
 		/* Compute the TCP pseudo header checksum*/
 		tcp_hdr(skb)->check =
@@ -3031,6 +3031,7 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
 		skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+		len = skb->len - skb_transport_offset(skb);
 		tcp_hdr(skb)->check =
 			~tcp_v6_check(len, &ipv6h->saddr, &ipv6h->daddr, 0);
 	}
-- 
2.39.5



