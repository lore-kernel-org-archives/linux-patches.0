Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5D4C3C9;
	Mon,  8 Jan 2024 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TukCBiy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C91FC433C8;
	Mon,  8 Jan 2024 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726634;
	bh=FXoiB3MB2Zg5r7WYC9O3/U7f864WpgAEoRpgig8ImpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TukCBiy68bkRwT5jplV/8yHUGUkFROe3rHQo9kPbP3eFpkuLD+fDd28IbwooodrXP
	 dsoFmmXvhS+U0+XSYAVml7KPuB37eZx7j6mzSok0dzJ3IvtUt9UMa/CDytFIPy6zFf
	 j/JyGTZCYkaz4NEiMx50dXED40PvgJVgIHiQ1tac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Simon Horman <horms@kernel.org>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/124] igc: Check VLAN TCI mask
Date: Mon,  8 Jan 2024 16:07:36 +0100
Message-ID: <20240108150604.352708035@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit b5063cbe148b829e8eb97672c2cbccc058835476 ]

Currently the driver accepts VLAN TCI steering rules regardless of the
configured mask. And things might fail silently or with confusing error
messages to the user.

There are two ways to handle the VLAN TCI mask:

 1. Match on the PCP field using a VLAN prio filter
 2. Match on complete TCI field using a flex filter

Therefore, add checks and code for that.

For instance the following rule is invalid and will be converted into a
VLAN prio rule which is not correct:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan 0x0001 m 0xf000 \
|             action 1
|Added rule with ID 61
|root@host:~# ethtool --show-ntuple enp3s0
|4 RX rings available
|Total 1 rules
|
|Filter: 61
|        Flow Type: Raw Ethernet
|        Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Dest MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Ethertype: 0x0 mask: 0xFFFF
|        VLAN EtherType: 0x0 mask: 0xffff
|        VLAN: 0x1 mask: 0x1fff
|        User-defined: 0x0 mask: 0xffffffffffffffff
|        Action: Direct to queue 1

After:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan 0x0001 m 0xf000 \
|             action 1
|rmgr: Cannot insert RX class rule: Operation not supported

Fixes: 7991487ecb2d ("igc: Allow for Flex Filters to be installed")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 28 +++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index f48f82d5e274b..85cc163965062 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -568,6 +568,7 @@ struct igc_nfc_filter {
 	u16 etype;
 	__be16 vlan_etype;
 	u16 vlan_tci;
+	u16 vlan_tci_mask;
 	u8 src_addr[ETH_ALEN];
 	u8 dst_addr[ETH_ALEN];
 	u8 user_data[8];
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index fa71bfb753b6d..a044e4a3a39a4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -957,6 +957,7 @@ static int igc_ethtool_set_coalesce(struct net_device *netdev,
 }
 
 #define ETHER_TYPE_FULL_MASK ((__force __be16)~0)
+#define VLAN_TCI_FULL_MASK ((__force __be16)~0)
 static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 				    struct ethtool_rxnfc *cmd)
 {
@@ -988,7 +989,7 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
 		fsp->flow_type |= FLOW_EXT;
 		fsp->h_ext.vlan_tci = htons(rule->filter.vlan_tci);
-		fsp->m_ext.vlan_tci = htons(VLAN_PRIO_MASK);
+		fsp->m_ext.vlan_tci = htons(rule->filter.vlan_tci_mask);
 	}
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
@@ -1223,6 +1224,7 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
 
 	if ((fsp->flow_type & FLOW_EXT) && fsp->m_ext.vlan_tci) {
 		rule->filter.vlan_tci = ntohs(fsp->h_ext.vlan_tci);
+		rule->filter.vlan_tci_mask = ntohs(fsp->m_ext.vlan_tci);
 		rule->filter.match_flags |= IGC_FILTER_FLAG_VLAN_TCI;
 	}
 
@@ -1260,11 +1262,19 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
 		memcpy(rule->filter.user_mask, fsp->m_ext.data, sizeof(fsp->m_ext.data));
 	}
 
-	/* When multiple filter options or user data or vlan etype is set, use a
-	 * flex filter.
+	/* The i225/i226 has various different filters. Flex filters provide a
+	 * way to match up to the first 128 bytes of a packet. Use them for:
+	 *   a) For specific user data
+	 *   b) For VLAN EtherType
+	 *   c) For full TCI match
+	 *   d) Or in case multiple filter criteria are set
+	 *
+	 * Otherwise, use the simple MAC, VLAN PRIO or EtherType filters.
 	 */
 	if ((rule->filter.match_flags & IGC_FILTER_FLAG_USER_DATA) ||
 	    (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_ETYPE) ||
+	    ((rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) &&
+	     rule->filter.vlan_tci_mask == ntohs(VLAN_TCI_FULL_MASK)) ||
 	    (rule->filter.match_flags & (rule->filter.match_flags - 1)))
 		rule->flex = true;
 	else
@@ -1334,6 +1344,18 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 		return -EINVAL;
 	}
 
+	/* There are two ways to match the VLAN TCI:
+	 *  1. Match on PCP field and use vlan prio filter for it
+	 *  2. Match on complete TCI field and use flex filter for it
+	 */
+	if ((fsp->flow_type & FLOW_EXT) &&
+	    fsp->m_ext.vlan_tci &&
+	    fsp->m_ext.vlan_tci != htons(VLAN_PRIO_MASK) &&
+	    fsp->m_ext.vlan_tci != VLAN_TCI_FULL_MASK) {
+		netdev_dbg(netdev, "VLAN mask not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (fsp->location >= IGC_MAX_RXNFC_RULES) {
 		netdev_dbg(netdev, "Invalid location\n");
 		return -EINVAL;
-- 
2.43.0



