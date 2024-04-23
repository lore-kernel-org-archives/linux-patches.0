Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA83143C47;
	Tue, 23 Apr 2024 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908472; cv=none; b=D4Bso8zwuiVFcbNZCGVeeB9TGDzS6uxvvVrJ70Q3WLC7WY2zSv9fm1J8/z5q9cs0JFvTVYOPJ0JFxuNxZmNn7lUummPeIXSZQUZDGNGBk+NOutX9gZ3/lOdUhUTCm9snhoLRMv61MmUyypRIB7TUvpAUEoMwWr2Blw06LjEuGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908472; c=relaxed/simple;
	bh=u3XzlOJpkHPy0QSjNfl3ac2uPANi0KxVNaaT7jmzb5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxIkzA4U10Oh8k/WMfdxAhxuTfpF1W0bUH+Eaa3V5/zTixi0q7mdxzAmN/1QA4+JCvpoZrIKjcg0+xhdJhJ/zRsLWyfUM/tVTsAJ1BbNWfFsZUkm4Cksb+5mOabl5wu2SIbQHeQetlTmNmLGI96dDFPpqe+Ow6lnpEM4tgjEmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kjnIIrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kjnIIrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9AEC32783;
	Tue, 23 Apr 2024 21:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908472;
	bh=u3XzlOJpkHPy0QSjNfl3ac2uPANi0KxVNaaT7jmzb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kjnIIrgmNJQjt2RtqBIL625mEwpXlNXnAOSG2HP9/rptK7WHN30HF7IUkbjfZcOl
	 1n8Q9BxCzc0FplwoYVo4CltBwW4q1DeGcRr8kY0HBVKFjyWVM9V2GzFV1P3J61qr0k
	 pssKyFS0wfB1s+OFpOnu0DwJ9glRoBt4LoLDZt7M=
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
Subject: [PATCH 6.8 039/158] ice: Fix checking for unsupported keys on non-tunnel device
Date: Tue, 23 Apr 2024 14:37:41 -0700
Message-ID: <20240423213857.176123107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bcbcfc67e5606..688ccb0615ab9 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1489,7 +1489,10 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
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



