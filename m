Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8914751C5C;
	Mon,  8 Jan 2024 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LCQslfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB01C43391;
	Mon,  8 Jan 2024 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728295;
	bh=vnOXTRwEIEHKXhGQGvT8a21htuQ5x8Z6r9APtgcF7BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LCQslfpLZz894986RvZF7Zln/P3uJMhd0/VXrZjAijd5AGEDdL5Ib6d2DZ0sx1l3
	 eDwZUPwYkGAMolYuerl1XKI3CMMHMp4/xg4OISEXUxTzIltMUbErCPrBV2U+1e/wvq
	 dHJi88oqk20vsL2YWFOfpMjzSh8fQW47yvcS+yAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Simon Horman <horms@kernel.org>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/150] igc: Check VLAN EtherType mask
Date: Mon,  8 Jan 2024 16:34:35 +0100
Message-ID: <20240108153512.405496117@linuxfoundation.org>
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

[ Upstream commit 7afd49a38e73afd57ff62c8d1cf5af760c4d49c0 ]

Currently the driver accepts VLAN EtherType steering rules regardless of
the configured mask. And things might fail silently or with confusing error
messages to the user. The VLAN EtherType can only be matched by full
mask. Therefore, add a check for that.

For instance the following rule is invalid, but the driver accepts it and
ignores the user specified mask:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan-etype 0x8100 \
|             m 0x00ff action 0
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

After:
|root@host:~# ethtool -N enp3s0 flow-type ether vlan-etype 0x8100 \
|             m 0x00ff action 0
|rmgr: Cannot insert RX class rule: Operation not supported

Fixes: 2b477d057e33 ("igc: Integrate flex filter into ethtool ops")
Suggested-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index e146357d61a8a..2bee9cace5983 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1356,6 +1356,14 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 		return -EOPNOTSUPP;
 	}
 
+	/* VLAN EtherType can only be matched by full mask. */
+	if ((fsp->flow_type & FLOW_EXT) &&
+	    fsp->m_ext.vlan_etype &&
+	    fsp->m_ext.vlan_etype != ETHER_TYPE_FULL_MASK) {
+		netdev_dbg(netdev, "VLAN EtherType mask not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (fsp->location >= IGC_MAX_RXNFC_RULES) {
 		netdev_dbg(netdev, "Invalid location\n");
 		return -EINVAL;
-- 
2.43.0



