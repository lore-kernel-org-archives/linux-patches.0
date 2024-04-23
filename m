Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B75143C57;
	Tue, 23 Apr 2024 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908610; cv=none; b=q9uSlSeegMesHw8Y21LN+8Arq1jKnc01FA7mSAP2J0bSMwy0fEtn/ROlVeiqL4BvLioMJIO9ZtkTZKfvfbcVpowhDODIFyKfkWWdeYJbe1m8pOv+WjGNDEXMHlfFIPRceN9ryxr9ZUWckYoAXYBCXp44OQCVcEA7It1BRHRj79g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908610; c=relaxed/simple;
	bh=GeyLBrV5fuK0RptIRICI7y063hcv44xSW5YwLjWSbXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT4P1gGYUztirvDhB1u55/g23ivrjrxCnss9RWioVLtyEYrKl4jRXCPfe0+LjO/6342h3wFJcAPFUZ6OkixwDhaHKDS/Giv2IEHjvlX5FFA/rZBwihIHe0jEnsC6qiJazdZalbdCV1Bq9L8K0neUI0z7qweDHKvlVs7NcFeg0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSNbFYeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSNbFYeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C645BC3277B;
	Tue, 23 Apr 2024 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908609;
	bh=GeyLBrV5fuK0RptIRICI7y063hcv44xSW5YwLjWSbXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSNbFYeW9NZDBr6AQs8wKHcnkIs0Q9y3IcNGzBJ885Dy+5SqItj6OckUN7JnweGOD
	 LW1CK18xnfMTd5AryWVKk5HVZXMevghu2RvxhzGofxbnIVmaiaZd1jqgeoA2MeBzDR
	 tKcFhgd+NbEJb0uoX4D7K9WWUJbOmCmsQl9c3mGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/158] ice: Fix checking for unsupported keys on non-tunnel device
Date: Tue, 23 Apr 2024 14:38:08 -0700
Message-ID: <20240423213857.429083896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 2cca35f5dd78b9f8297c879c5db5ab137c5d86c3 ]

Add missing FLOW_DISSECTOR_KEY_ENC_* checks to TC flower filter parsing.
Without these checks, it would be possible to add filters with tunnel
options on non-tunnel devices. enc_* options are only valid for tunnel
devices.

Example:
  devlink dev eswitch set $PF1_PCI mode switchdev
  echo 1 > /sys/class/net/$PF1/device/sriov_numvfs
  tc qdisc add dev $VF1_PR ingress
  ethtool -K $PF1 hw-tc-offload on
  tc filter add dev $VF1_PR ingress flower enc_ttl 12 skip_sw action drop

Fixes: 9e300987d4a8 ("ice: VXLAN and Geneve TC support")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 9c97c99feac3d..76ad5930c0102 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1448,7 +1448,10 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		  (BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
 		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
 		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_KEYID) |
-		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_PORTS))) {
+		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_PORTS) |
+		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IP) |
+		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_OPTS) |
+		   BIT_ULL(FLOW_DISSECTOR_KEY_ENC_CONTROL))) {
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Tunnel key used, but device isn't a tunnel");
 		return -EOPNOTSUPP;
 	} else {
-- 
2.43.0



