Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FB01AB6DA;
	Mon, 14 Oct 2024 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916096; cv=none; b=q8BUDS+Ap8uWXcTIiok54MVjbCjXEs6Ygr4Io10tPceAJFQKZ9EChxqoNlkdT5M4tnVBTOhoIQtUdfJmG14ooHbfF+BXkpagBU50Am+yjlYtdz2bKFTLzn6/1n3ynnp04SjeiqgGALGVjx91ZXx3EUxFHwhCvyuwpJklcTY+O4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916096; c=relaxed/simple;
	bh=wqSke9qm6R3V3D41QkReYSh3nRdPCbIirQg93Tqbjyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmQwcB040V2QEKF5R1jHLXoXLZhL9Bi6mKQ8W5ho4cPqkdRMW0ch2A6Ng1dOKNicIoi73NkNOO5aSR+1zQYkp/r60zKjUhRB7tpPZLJzA6h85BuCNQHGKMWQEE9zR0MNjNuq/j+JcTaGX0qiI9pdzE7KpaVoZgGy1FJCQmRgttk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neS8KGuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neS8KGuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6645C4CEC3;
	Mon, 14 Oct 2024 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916096;
	bh=wqSke9qm6R3V3D41QkReYSh3nRdPCbIirQg93Tqbjyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neS8KGuOSmwHImuS3RugAFRanrHD25i3PKApzZThZX+BahNQdMUJ8wVLZpoE9rqCY
	 jy5aq3fwhOp3Ja/6P5nu6a9HkiMCNNCA9wjSuUaxvpRAvWa2kvBJLbTcZaMcO37Otg
	 MqFSPhEoRIM37QqsJPT0pHy1pTxupng08hLIh99o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 083/214] ice: set correct dst VSI in only LAN filters
Date: Mon, 14 Oct 2024 16:19:06 +0200
Message-ID: <20241014141048.230051785@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 839e3f9bee425c90a0423d14b102a42fe6635c73 ]

The filters set that will reproduce the problem:
$ tc filter add dev $VF0_PR ingress protocol arp prio 0 flower \
	skip_sw dst_mac ff:ff:ff:ff:ff:ff action mirred egress \
	redirect dev $PF0
$ tc filter add dev $VF0_PR ingress protocol arp prio 0 flower \
	skip_sw dst_mac ff:ff:ff:ff:ff:ff src_mac 52:54:00:00:00:10 \
	action mirred egress mirror dev $VF1_PR

Expected behaviour is to set all broadcast from VF0 to the LAN. If the
src_mac match the value from filters, send packet to LAN and to VF1.

In this case both LAN_EN and LB_EN flags in switch is set in case of
packet matching both filters. As dst VSI for the only LAN enable bit is
PF VSI, the packet is being seen on PF. To fix this change dst VSI to
the source VSI. It will block receiving any packet even when LB_EN is
set by switch, because local loopback is clear on VF VSI during normal
operation.

Side note: if the second filters action is redirect instead of mirror
LAN_EN is clear, because switch is AND-ing LAN_EN from each matched
filters and OR-ing LB_EN.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Fixes: 73b483b79029 ("ice: Manage act flags for switchdev offloads")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index e6923f8121a99..ea39b999a0d00 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -819,6 +819,17 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
+		/* This is a specific case. The destination VSI index is
+		 * overwritten by the source VSI index. This type of filter
+		 * should allow the packet to go to the LAN, not to the
+		 * VSI passed here. It should set LAN_EN bit only. However,
+		 * the VSI must be a valid one. Setting source VSI index
+		 * here is safe. Even if the result from switch is set LAN_EN
+		 * and LB_EN (which normally will pass the packet to this VSI)
+		 * packet won't be seen on the VSI, because local loopback is
+		 * turned off.
+		 */
+		rule_info.sw_act.vsi_handle = vsi->idx;
 	} else {
 		/* VF to VF */
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
-- 
2.43.0



