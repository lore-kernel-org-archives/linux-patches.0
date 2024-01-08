Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0E5102D;
	Mon,  8 Jan 2024 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkaASObE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D83FC433CB;
	Mon,  8 Jan 2024 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728266;
	bh=d16be2KcNeR3BSdXqVDVCrgJbg64Qav1Hbs55+9YjJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkaASObE7nAY/7eumJO6AScSUtm7ykjAkkGtSSJ/X24mVReV8iESJQCFx6f08XNN6
	 5QyjMfBi3Oo5GlsXJzKetBBdw6mK4pHXdXnEi+ImDXsyD34bfBwWbBNjSEOxQ1jKPP
	 YUSPxS8NnopPdYQP5h0f5RoNMrbQ5cNue7XX/EFw=
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
Subject: [PATCH 6.1 022/150] igc: Report VLAN EtherType matching back to user
Date: Mon,  8 Jan 2024 16:34:33 +0100
Message-ID: <20240108153512.305790887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 088464abd48cf3735aee91f9e211b32da9d81117 ]

Currently the driver allows to configure matching by VLAN EtherType.
However, the retrieval function does not report it back to the user. Add
it.

Before:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan-etype 0x8100 action 0
|Added rule with ID 63
|root@host:~# ethtool --show-ntuple enp3s0
|4 RX rings available
|Total 1 rules
|
|Filter: 63
|        Flow Type: Raw Ethernet
|        Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Dest MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Ethertype: 0x0 mask: 0xFFFF
|        Action: Direct to queue 0

After:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan-etype 0x8100 action 0
|Added rule with ID 63
|root@host:~# ethtool --show-ntuple enp3s0
|4 RX rings available
|Total 1 rules
|
|Filter: 63
|        Flow Type: Raw Ethernet
|        Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Dest MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
|        Ethertype: 0x0 mask: 0xFFFF
|        VLAN EtherType: 0x8100 mask: 0x0
|        VLAN: 0x0 mask: 0xffff
|        User-defined: 0x0 mask: 0xffffffffffffffff
|        Action: Direct to queue 0

Fixes: 2b477d057e33 ("igc: Integrate flex filter into ethtool ops")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 81897f7a90a91..51ef18060dbc4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -979,6 +979,12 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 		fsp->m_u.ether_spec.h_proto = ETHER_TYPE_FULL_MASK;
 	}
 
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_ETYPE) {
+		fsp->flow_type |= FLOW_EXT;
+		fsp->h_ext.vlan_etype = rule->filter.vlan_etype;
+		fsp->m_ext.vlan_etype = ETHER_TYPE_FULL_MASK;
+	}
+
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
 		fsp->flow_type |= FLOW_EXT;
 		fsp->h_ext.vlan_tci = htons(rule->filter.vlan_tci);
-- 
2.43.0



