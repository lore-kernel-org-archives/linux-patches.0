Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0E12C80F;
	Wed,  7 Aug 2024 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042967; cv=none; b=NUnn0tHllmfmWcJ9byTLSfa4C98WAIiQWR+oM2t8ovPLg0iPAuVWnPztg/anGTl+Bk/HZV7E80jTNiz1kWA5XUFCM/X+z/KYpqDuOsM3n6FneeJp/26zgfKCknVtMcAIyR8OmVXO4gQD9gP6OFykJGiq8UHfHDrC5Ko0Ge/gKvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042967; c=relaxed/simple;
	bh=6Jxgdv4Qynw5+hJS+i/9lj9fDcdsonLkz6zSGMXBXcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGIjlDJiFMihgYOrDg7h/k9Ug9AXEAdItwxLagwpK5us4YdRfXIWHz3WZ9H30QoMzWoyvmvtT4zHf5pDwmH5FiA9KQ6E/QuPgsOJK56cZ/1vKqF4nxskdBVWj4zgIPRFMeO+jwgwpbvtQ/o7AH3rGVShWR5LGYZuWM2IvhI44p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcwZf+Pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcwZf+Pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DEAC4AF19;
	Wed,  7 Aug 2024 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042967;
	bh=6Jxgdv4Qynw5+hJS+i/9lj9fDcdsonLkz6zSGMXBXcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcwZf+PwXzv5VvS+JxiZc0ibmw9d49Wr+GOTQ7BNevveTRx/uuS0n377F7x1/4f7P
	 iaaGVOTF4UxXa2uHQnUVzxRPlM7AOeBVCzOCT6ugraiSW93syTW1YCP/+hmPAM78dt
	 yVC+Nw0oonwJJIZRTDPXouq23yOMVWwEngvGoKj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 042/123] ice: dont busy wait for Rx queue disable in ice_qp_dis()
Date: Wed,  7 Aug 2024 16:59:21 +0200
Message-ID: <20240807150022.201086107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 1ff72a2f67791cd4ddad19ed830445f57b30e992 ]

When ice driver is spammed with multiple xdpsock instances and flow
control is enabled, there are cases when Rx queue gets stuck and unable
to reflect the disable state in QRX_CTRL register. Similar issue has
previously been addressed in commit 13a6233b033f ("ice: Add support to
enable/disable all Rx queues before waiting").

To workaround this, let us simply not wait for a disabled state as later
patch will make sure that regardless of the encountered error in the
process of disabling a queue pair, the Rx queue will be enabled.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 72738b8b8a68e..3104a5657b837 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -199,10 +199,8 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
-	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
-	if (err)
-		return err;
 
+	ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, false);
 	ice_qp_clean_rings(vsi, q_idx);
 	ice_qp_reset_stats(vsi, q_idx);
 
-- 
2.43.0



