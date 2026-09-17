Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16075495ADA;
	Thu, 17 Sep 2026 18:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670456; cv=none; b=WdIluBXGNs5mTRR9AYW1EY8cUsXg0sN5gDZnwdkmlTU8NX/j+o4vXvi2Iy8A96onC93PnWw+xqhF4sS79ie+anujY6rbQYAmbGOEwU/rPOEAHVKQf7J7eeP15fc5iSmxPO7Bxd4F7qxT6ire4JG5UQFE8ehOhXPJvrgZKPK4lTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670456; c=relaxed/simple;
	bh=jw8gLr0GyeaWlhQdI0cai0kjYx9p34ehsp9EkA0W8nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDa4uo9I2rq3uSotTbuuw95mFxsJoJETq1vAgv7IyJKgjgxs2fpMaVkhIbk0KAQVITlgC8j5sw8EViG2AiNlbpEOuTUe21o1Ynx6lvcxctfPLjcspWq1Q8goOQ9hfgvGQ1fsh90It0iWKbuEIzNRh5Y6gGufnrwiFHoScEVo8tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5tAegVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5tAegVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6093A1F000FF;
	Thu, 17 Sep 2026 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670452;
	bh=/W8LjabCeoyrt5aI8gvW2XN0WTVutOoDdKO8mJ3qoU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5tAegVLUNrrsF5ZzQP0UDGQttY2Z6C0QGEAgQafpn1bxGk15Z4TjNUQ1VFT8cEUx
	 fZVd8jGs++jJOVe4SumJY/t4QHJ73CjWzFEwfbE/XO30GS2Ao3OPQeJ2eKNLnqWGho
	 W43zrLITxMgZ8gTUiXp1tjduyVVXpB8IGJLeCfKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0665/1102] ethtool: Block setting of symmetric RSS when non-symmetric rx-flow-hash is requested
Date: Thu, 17 Sep 2026 16:10:08 +0100
Message-ID: <20260917151556.898599363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 1b2900db0119c02e6445bb61ec3fba982d10cc8d ]

Symmetric RSS hash requires that:
* No other fields besides IP src/dst and/or L4 src/dst are set
* If src is set, dst must also be set

This restriction was only enforced when RXNFC was configured after
symmetric hash was enabled. In the opposite order of operations (RXNFC
then symmetric enablement) the check was not performed.

Perform the sanity check on set_rxfh as well, by iterating over all flow
types hash fields and making sure they are all symmetric.

Introduce a function that returns whether a flow type is hashable (not
spec only) and needs to be iterated over. To make sure that no one
forgets to update the list of hashable flow types when adding new flow
types, a static assert is added to draw the developer's attention.

The conversion of uapi #defines to enum is not ideal, but as Jakub
mentioned [1], we have precedent for that.

[1] https://lore.kernel.org/netdev/20250324073509.6571ade3@kernel.org/

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250508103034.885536-1-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ethtool.h | 134 ++++++++++++++++++-----------------
 net/ethtool/ioctl.c          |  99 +++++++++++++++++++++++---
 2 files changed, 158 insertions(+), 75 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 1c2d1e353b033..b024d19bb2e06 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -2273,71 +2273,75 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define	RXH_XFRM_SYM_OR_XOR	(1 << 1)
 #define	RXH_XFRM_NO_CHANGE	0xff
 
-/* L2-L4 network traffic flow types */
-#define	TCP_V4_FLOW	0x01	/* hash or spec (tcp_ip4_spec) */
-#define	UDP_V4_FLOW	0x02	/* hash or spec (udp_ip4_spec) */
-#define	SCTP_V4_FLOW	0x03	/* hash or spec (sctp_ip4_spec) */
-#define	AH_ESP_V4_FLOW	0x04	/* hash only */
-#define	TCP_V6_FLOW	0x05	/* hash or spec (tcp_ip6_spec; nfc only) */
-#define	UDP_V6_FLOW	0x06	/* hash or spec (udp_ip6_spec; nfc only) */
-#define	SCTP_V6_FLOW	0x07	/* hash or spec (sctp_ip6_spec; nfc only) */
-#define	AH_ESP_V6_FLOW	0x08	/* hash only */
-#define	AH_V4_FLOW	0x09	/* hash or spec (ah_ip4_spec) */
-#define	ESP_V4_FLOW	0x0a	/* hash or spec (esp_ip4_spec) */
-#define	AH_V6_FLOW	0x0b	/* hash or spec (ah_ip6_spec; nfc only) */
-#define	ESP_V6_FLOW	0x0c	/* hash or spec (esp_ip6_spec; nfc only) */
-#define	IPV4_USER_FLOW	0x0d	/* spec only (usr_ip4_spec) */
-#define	IP_USER_FLOW	IPV4_USER_FLOW
-#define	IPV6_USER_FLOW	0x0e	/* spec only (usr_ip6_spec; nfc only) */
-#define	IPV4_FLOW	0x10	/* hash only */
-#define	IPV6_FLOW	0x11	/* hash only */
-#define	ETHER_FLOW	0x12	/* spec only (ether_spec) */
-
-/* Used for GTP-U IPv4 and IPv6.
- * The format of GTP packets only includes
- * elements such as TEID and GTP version.
- * It is primarily intended for data communication of the UE.
- */
-#define GTPU_V4_FLOW 0x13	/* hash only */
-#define GTPU_V6_FLOW 0x14	/* hash only */
-
-/* Use for GTP-C IPv4 and v6.
- * The format of these GTP packets does not include TEID.
- * Primarily expected to be used for communication
- * to create sessions for UE data communication,
- * commonly referred to as CSR (Create Session Request).
- */
-#define GTPC_V4_FLOW 0x15	/* hash only */
-#define GTPC_V6_FLOW 0x16	/* hash only */
-
-/* Use for GTP-C IPv4 and v6.
- * Unlike GTPC_V4_FLOW, the format of these GTP packets includes TEID.
- * After session creation, it becomes this packet.
- * This is mainly used for requests to realize UE handover.
- */
-#define GTPC_TEID_V4_FLOW 0x17	/* hash only */
-#define GTPC_TEID_V6_FLOW 0x18	/* hash only */
-
-/* Use for GTP-U and extended headers for the PSC (PDU Session Container).
- * The format of these GTP packets includes TEID and QFI.
- * In 5G communication using UPF (User Plane Function),
- * data communication with this extended header is performed.
- */
-#define GTPU_EH_V4_FLOW 0x19	/* hash only */
-#define GTPU_EH_V6_FLOW 0x1a	/* hash only */
-
-/* Use for GTP-U IPv4 and v6 PSC (PDU Session Container) extended headers.
- * This differs from GTPU_EH_V(4|6)_FLOW in that it is distinguished by
- * UL/DL included in the PSC.
- * There are differences in the data included based on Downlink/Uplink,
- * and can be used to distinguish packets.
- * The functions described so far are useful when you want to
- * handle communication from the mobile network in UPF, PGW, etc.
- */
-#define GTPU_UL_V4_FLOW 0x1b	/* hash only */
-#define GTPU_UL_V6_FLOW 0x1c	/* hash only */
-#define GTPU_DL_V4_FLOW 0x1d	/* hash only */
-#define GTPU_DL_V6_FLOW 0x1e	/* hash only */
+enum {
+	/* L2-L4 network traffic flow types */
+	TCP_V4_FLOW	= 0x01,	/* hash or spec (tcp_ip4_spec) */
+	UDP_V4_FLOW	= 0x02,	/* hash or spec (udp_ip4_spec) */
+	SCTP_V4_FLOW	= 0x03,	/* hash or spec (sctp_ip4_spec) */
+	AH_ESP_V4_FLOW	= 0x04,	/* hash only */
+	TCP_V6_FLOW	= 0x05,	/* hash or spec (tcp_ip6_spec; nfc only) */
+	UDP_V6_FLOW	= 0x06,	/* hash or spec (udp_ip6_spec; nfc only) */
+	SCTP_V6_FLOW	= 0x07,	/* hash or spec (sctp_ip6_spec; nfc only) */
+	AH_ESP_V6_FLOW	= 0x08,	/* hash only */
+	AH_V4_FLOW	= 0x09,	/* hash or spec (ah_ip4_spec) */
+	ESP_V4_FLOW	= 0x0a,	/* hash or spec (esp_ip4_spec) */
+	AH_V6_FLOW	= 0x0b,	/* hash or spec (ah_ip6_spec; nfc only) */
+	ESP_V6_FLOW	= 0x0c,	/* hash or spec (esp_ip6_spec; nfc only) */
+	IPV4_USER_FLOW	= 0x0d,	/* spec only (usr_ip4_spec) */
+	IP_USER_FLOW	= IPV4_USER_FLOW,
+	IPV6_USER_FLOW	= 0x0e, /* spec only (usr_ip6_spec; nfc only) */
+	IPV4_FLOW	= 0x10, /* hash only */
+	IPV6_FLOW	= 0x11, /* hash only */
+	ETHER_FLOW	= 0x12, /* spec only (ether_spec) */
+
+	/* Used for GTP-U IPv4 and IPv6.
+	 * The format of GTP packets only includes
+	 * elements such as TEID and GTP version.
+	 * It is primarily intended for data communication of the UE.
+	 */
+	GTPU_V4_FLOW	= 0x13,	/* hash only */
+	GTPU_V6_FLOW	= 0x14,	/* hash only */
+
+	/* Use for GTP-C IPv4 and v6.
+	 * The format of these GTP packets does not include TEID.
+	 * Primarily expected to be used for communication
+	 * to create sessions for UE data communication,
+	 * commonly referred to as CSR (Create Session Request).
+	 */
+	GTPC_V4_FLOW	= 0x15,	/* hash only */
+	GTPC_V6_FLOW	= 0x16,	/* hash only */
+
+	/* Use for GTP-C IPv4 and v6.
+	 * Unlike GTPC_V4_FLOW, the format of these GTP packets includes TEID.
+	 * After session creation, it becomes this packet.
+	 * This is mainly used for requests to realize UE handover.
+	 */
+	GTPC_TEID_V4_FLOW	= 0x17,	/* hash only */
+	GTPC_TEID_V6_FLOW	= 0x18,	/* hash only */
+
+	/* Use for GTP-U and extended headers for the PSC (PDU Session Container).
+	 * The format of these GTP packets includes TEID and QFI.
+	 * In 5G communication using UPF (User Plane Function),
+	 * data communication with this extended header is performed.
+	 */
+	GTPU_EH_V4_FLOW	= 0x19,	/* hash only */
+	GTPU_EH_V6_FLOW	= 0x1a,	/* hash only */
+
+	/* Use for GTP-U IPv4 and v6 PSC (PDU Session Container) extended headers.
+	 * This differs from GTPU_EH_V(4|6)_FLOW in that it is distinguished by
+	 * UL/DL included in the PSC.
+	 * There are differences in the data included based on Downlink/Uplink,
+	 * and can be used to distinguish packets.
+	 * The functions described so far are useful when you want to
+	 * handle communication from the mobile network in UPF, PGW, etc.
+	 */
+	GTPU_UL_V4_FLOW	= 0x1b,	/* hash only */
+	GTPU_UL_V6_FLOW	= 0x1c,	/* hash only */
+	GTPU_DL_V4_FLOW	= 0x1d,	/* hash only */
+	GTPU_DL_V6_FLOW	= 0x1e,	/* hash only */
+
+	__FLOW_TYPE_COUNT,
+};
 
 /* Flag to enable additional fields in struct ethtool_rx_flow_spec */
 #define	FLOW_EXT	0x80000000
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 46fd809283bcb..18dfb4fdf1f03 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -977,6 +977,88 @@ static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
 	return 0;
 }
 
+static bool flow_type_hashable(u32 flow_type)
+{
+	switch (flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+	case AH_ESP_V4_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case SCTP_V6_FLOW:
+	case AH_ESP_V6_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+	case IPV4_FLOW:
+	case IPV6_FLOW:
+	case GTPU_V4_FLOW:
+	case GTPU_V6_FLOW:
+	case GTPC_V4_FLOW:
+	case GTPC_V6_FLOW:
+	case GTPC_TEID_V4_FLOW:
+	case GTPC_TEID_V6_FLOW:
+	case GTPU_EH_V4_FLOW:
+	case GTPU_EH_V6_FLOW:
+	case GTPU_UL_V4_FLOW:
+	case GTPU_UL_V6_FLOW:
+	case GTPU_DL_V4_FLOW:
+	case GTPU_DL_V6_FLOW:
+		return true;
+	}
+
+	return false;
+}
+
+/* When adding a new type, update the assert and, if it's hashable, add it to
+ * the flow_type_hashable switch case.
+ */
+static_assert(GTPU_DL_V6_FLOW + 1 == __FLOW_TYPE_COUNT);
+
+static int ethtool_check_xfrm_rxfh(u32 input_xfrm, u64 rxfh)
+{
+	/* Sanity check: if symmetric-xor/symmetric-or-xor is set, then:
+	 * 1 - no other fields besides IP src/dst and/or L4 src/dst are set
+	 * 2 - If src is set, dst must also be set
+	 */
+	if ((input_xfrm != RXH_XFRM_NO_CHANGE &&
+	     input_xfrm & (RXH_XFRM_SYM_XOR | RXH_XFRM_SYM_OR_XOR)) &&
+	    ((rxfh & ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3)) ||
+	     (!!(rxfh & RXH_IP_SRC) ^ !!(rxfh & RXH_IP_DST)) ||
+	     (!!(rxfh & RXH_L4_B_0_1) ^ !!(rxfh & RXH_L4_B_2_3))))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ethtool_check_flow_types(struct net_device *dev, u32 input_xfrm)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxnfc info = {
+		.cmd = ETHTOOL_GRXFH,
+	};
+	int err;
+	u32 i;
+
+	for (i = 0; i < __FLOW_TYPE_COUNT; i++) {
+		if (!flow_type_hashable(i))
+			continue;
+
+		info.flow_type = i;
+		err = ops->get_rxnfc(dev, &info, NULL);
+		if (err)
+			continue;
+
+		err = ethtool_check_xfrm_rxfh(input_xfrm, info.data);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 						u32 cmd, void __user *useraddr)
 {
@@ -1005,16 +1087,9 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		if (rc)
 			return rc;
 
-		/* Sanity check: if symmetric-xor/symmetric-or-xor is set, then:
-		 * 1 - no other fields besides IP src/dst and/or L4 src/dst
-		 * 2 - If src is set, dst must also be set
-		 */
-		if ((rxfh.input_xfrm & (RXH_XFRM_SYM_XOR | RXH_XFRM_SYM_OR_XOR)) &&
-		    ((info.data & ~(RXH_IP_SRC | RXH_IP_DST |
-				    RXH_L4_B_0_1 | RXH_L4_B_2_3)) ||
-		     (!!(info.data & RXH_IP_SRC) ^ !!(info.data & RXH_IP_DST)) ||
-		     (!!(info.data & RXH_L4_B_0_1) ^ !!(info.data & RXH_L4_B_2_3))))
-			return -EINVAL;
+		rc = ethtool_check_xfrm_rxfh(rxfh.input_xfrm, info.data);
+		if (rc)
+			return rc;
 	}
 
 	rc = ops->set_rxnfc(dev, &info);
@@ -1406,6 +1481,10 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	     rxfh.input_xfrm == RXH_XFRM_NO_CHANGE))
 		return -EINVAL;
 
+	ret = ethtool_check_flow_types(dev, rxfh.input_xfrm);
+	if (ret)
+		return ret;
+
 	indir_bytes = dev_indir_size * sizeof(rxfh_dev.indir[0]);
 
 	/* Check settings which may be global rather than per RSS-context */
-- 
2.53.0



