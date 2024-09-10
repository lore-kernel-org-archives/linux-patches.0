Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48E19149F;
	Tue, 10 Sep 2024 10:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964347; cv=none; b=hRKgqYJQyy/vKA25Oe/YCH+EdScUo3fLogNpXwv6FHDSyK+D+48kkAoW2WHKX4fdksXNbnBRgrM0+baI69YTwpFua3zBGq23X2eDWPH7/7jKLw5Y3YFLYUHsPcfIVR6uBooBCJm7Co2AIGQNO7RPIPXaqB57JvZ1uMJ3fcvL9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964347; c=relaxed/simple;
	bh=KJTTg2kiH6WLcsIzcIrgA12DOQz/eSEwl8B7F4wBDMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvYN4KcGdrWsReHVpc/M0CY/hBWkTkDUZFJ8GrmuDVlShhfOR/ZiJzOtIbVbWRZsbJGclEsjbhNJReUuZCQj6pUFYsuvYjf7P4b/zBtePpcg6sMfNYU/OS+30Yzxl7b6WmSFeNmRvtk7S3OgtSORczkvG82S0s3IZi+LA86+sMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYS6ijo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYS6ijo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F70C4CEC3;
	Tue, 10 Sep 2024 10:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964347;
	bh=KJTTg2kiH6WLcsIzcIrgA12DOQz/eSEwl8B7F4wBDMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYS6ijo6gJAR0Y5uuTPqOPkue6OjBOYlOdy+xWK4mgNiu/8iwXbLLyZ/R9zsHGVSe
	 1JyDs6QGuMA//mDReJgTkLNXdfqMNK8Zn3hDPKYjwUYMOLVBmLzlAaLFSKBhg79QuL
	 yUaxb1teug/RbregZ2nsT2ZrYF4bHGRq4qG6Tw70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/269] ice: do not bring the VSI up, if it was down before the XDP setup
Date: Tue, 10 Sep 2024 11:31:51 +0200
Message-ID: <20240910092612.596001714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 04c7e14e5b0b6227e7b00d7a96ca2f2426ab9171 ]

After XDP configuration is completed, we bring the interface up
unconditionally, regardless of its state before the call to .ndo_bpf().

Preserve the information whether the interface had to be brought down and
later bring it up only in such case.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3ee92b0e62ff..4d3a9fc79a6c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2931,8 +2931,8 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		   struct netlink_ext_ack *extack)
 {
 	unsigned int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
-	bool if_running = netif_running(vsi->netdev);
 	int ret = 0, xdp_ring_err = 0;
+	bool if_running;
 
 	if (prog && !prog->aux->xdp_has_frags) {
 		if (frame_size > ice_max_xdp_frame_size(vsi)) {
@@ -2949,8 +2949,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		return 0;
 	}
 
+	if_running = netif_running(vsi->netdev) &&
+		     !test_and_set_bit(ICE_VSI_DOWN, vsi->state);
+
 	/* need to stop netdev while setting up the program for Rx rings */
-	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
+	if (if_running) {
 		ret = ice_down(vsi);
 		if (ret) {
 			NL_SET_ERR_MSG_MOD(extack, "Preparing device for XDP attach failed");
-- 
2.43.0



