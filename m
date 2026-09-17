Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4954ABBC1;
	Thu, 17 Sep 2026 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659898; cv=none; b=k1q+marl6fBdGXKTYqdma2MU652A5GHmOE2ePldnvVS2kwC57tr1awpXgKqIrdchOyiB1mKZ17o9Q8SXLyYJDqbC7Tytt/JpMOp66JgjixsbWDYwoRN73FWMMp7rFcXmKKHImEN8h8QTOPQjHz3vsrmwp2n87TrHaiocSh6pNvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659898; c=relaxed/simple;
	bh=1d1B3Xt6EDW04sDOUSLFXLHHFvMrqUJQRO3ohd5fOzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vac9q7kacrs9KO4sZp/SxIAr5L0VB2vgUm0VelcFRtJVq9hwf8iA4CUVJWgKPti6BCDIDDNljtEKkW0NXHsA1LUXgS/Nt9XqdoywoP1rmbMErBEOBD12qI5Sba4FAjHVvVeoEpKA2vLhxL+wXwAOJx105srlwBF2Hhh4TqfELPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQIG/Vhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQIG/Vhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350A71F00898;
	Thu, 17 Sep 2026 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659893;
	bh=AMCXKikK8Fb107s9pCh+2+e8xxofWKLBXOu6GznZoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQIG/VhjhheTMlfzInYasVZbLna9CeHWMWMDivIsn8QsY1GFpaOGIoYmJ4CdUptf7
	 R/phUl65VMHI/3FLKpbfn5GLy8a2djrHqrBvvWse++eEd+N2QNYOXzRpkPuNRAns12
	 koijwuZUt4g4lOwyH9QWciFJFmIcCo1MaE1Wy6xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 372/733] idpf: account for VLAN header when parsing RSC packet header
Date: Thu, 17 Sep 2026 16:11:20 +0100
Message-ID: <20260917151400.914012434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit cc6d60ef92278a31ffc2e94966a0921b9646af18 ]

While parsing the header of a Receive Side Coalesced (RSC) packet, check
if a VLAN tag is present and adjust the header parsing accordingly.
Otherwise, Rx TCP traffic is completely broken for any VLAN interface
whose underlying interface has RSC (rx-gro-hw) enabled.

We only need to worry about one VLAN header since Rx packets with
multiple VLAN headers are not candidates for RSC.

Fixes: 3a8845af66edb ("idpf: add RX splitq napi poll support")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 91ca75e454630..0b4e3d075fb05 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3299,6 +3299,7 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 		       struct libeth_rx_pt decoded)
 {
 	u16 rsc_segments, rsc_seg_len;
+	u16 l3_start = 0;
 	bool ipv4, ipv6;
 	int len;
 
@@ -3321,7 +3322,10 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 	NAPI_GRO_CB(skb)->count = rsc_segments;
 	skb_shinfo(skb)->gso_size = rsc_seg_len;
 
-	skb_reset_network_header(skb);
+	if (unlikely(eth_type_vlan(skb->protocol)))
+		l3_start = VLAN_HLEN;
+
+	skb_set_network_header(skb, l3_start);
 
 	if (ipv4) {
 		struct iphdr *ipv4h = ip_hdr(skb);
@@ -3329,7 +3333,7 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 
 		/* Reset and set transport header offset in skb */
-		skb_set_transport_header(skb, sizeof(struct iphdr));
+		skb_set_transport_header(skb, l3_start + sizeof(struct iphdr));
 		len = skb->len - skb_transport_offset(skb);
 
 		/* Compute the TCP pseudo header checksum*/
@@ -3339,7 +3343,7 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
-		skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+		skb_set_transport_header(skb, l3_start + sizeof(struct ipv6hdr));
 		len = skb->len - skb_transport_offset(skb);
 		tcp_hdr(skb)->check =
 			~tcp_v6_check(len, &ipv6h->saddr, &ipv6h->daddr, 0);
-- 
2.53.0



