Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5D12116E9;
	Wed,  7 May 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644049; cv=none; b=WLL5ZjUL2AtUQJVi7VedDms0NUWkPL+uof5sGXWXrK38wIdo7g1kLFCFoY1PDFRA0978T4recW0qa23C+FB2P4kbklo7QH5oz3YBTzlEeuNLfdFUtNhSBLDmcW1GuN5w8gfrvEmhJhQMKabFxH468ERCVV0RolPtUxpNmraTxPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644049; c=relaxed/simple;
	bh=1b0We9zM3RjB51W6RadciumSjDyniT47LHO8IxcVHRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5GI9RExUlcpJUtnaoEvRu/m4ff4Ur5Z/UBj8IJo82uIFMbH+X14FhCafqOfVsY2IjhCEgsyGix2Ikk00QcLuFpwzsYH8XyJOCFDBQgFcVyZ9jeLLfSQ5ULrTOqhoNdSF2qlg6EV/GlmXmOHKlWagoxPOIF6RG8TwqyFp6l2lqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouWCvbh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouWCvbh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7201DC4CEE2;
	Wed,  7 May 2025 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644048;
	bh=1b0We9zM3RjB51W6RadciumSjDyniT47LHO8IxcVHRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouWCvbh3MIPQHvC0JFA8fLnM7IdkOWMvp4C8GENK2YMELj04ujd+FmtQltbGqZxt1
	 MFKlzO4IaE5oTCp7Ek+0KIpks4l2wV6CdAgFSX2Wm9c2Kro+Qgq92TCbF2R1zb/6JB
	 Sshk3HBEGjQawkLiMT1UMqsdzjboVaLDxb3WftIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 102/183] ice: fix Get Tx Topology AQ command error on E830
Date: Wed,  7 May 2025 20:39:07 +0200
Message-ID: <20250507183828.962652148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 3ffcd7b657c9d96eb3ffe174449b4248dd7fc6a9 ]

The Get Tx Topology AQ command (opcode 0x0418) has different read flag
requirements depending on the hardware/firmware. For E810, E822, and E823
firmware the read flag must be set, and for newer hardware (E825 and E830)
it must not be set.

This results in failure to configure Tx topology and the following warning
message during probe:

  DDP package does not support Tx scheduling layers switching feature -
  please update to the latest DDP package and try again

The current implementation only handles E825-C but not E830. It is
confusing as we first check ice_is_e825c() and then set the flag in the set
case. Finally, we check ice_is_e825c() again and set the flag for all other
hardware in both the set and get case.

Instead, notice that we always need the read flag for set, but only need
the read flag for get on E810, E822, and E823 firmware. Fix the logic to
check the MAC type and set the read flag in get only on the older devices
which require it.

Fixes: ba1124f58afd ("ice: Add E830 device IDs, MAC type and registers")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250425222636.3188441-2-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index 69d5b1a28491d..59323c019544f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -2345,15 +2345,15 @@ ice_get_set_tx_topo(struct ice_hw *hw, u8 *buf, u16 buf_size,
 			cmd->set_flags |= ICE_AQC_TX_TOPO_FLAGS_SRC_RAM |
 					  ICE_AQC_TX_TOPO_FLAGS_LOAD_NEW;
 
-		if (hw->mac_type == ICE_MAC_GENERIC_3K_E825)
-			desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 	} else {
 		ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_tx_topo);
 		cmd->get_flags = ICE_AQC_TX_TOPO_GET_RAM;
-	}
 
-	if (hw->mac_type != ICE_MAC_GENERIC_3K_E825)
-		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+		if (hw->mac_type == ICE_MAC_E810 ||
+		    hw->mac_type == ICE_MAC_GENERIC)
+			desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	}
 
 	status = ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
 	if (status)
-- 
2.39.5



