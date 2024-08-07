Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0213EA9A;
	Wed,  7 Aug 2024 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042981; cv=none; b=U6Fc2jiEnj1mYSdfl3BHSz8cHK5Q92Wr43nQgqjFs6UIQllAbR+eQsZCWz7wckGhmSDjq8plMuG9RYcVLVWMm5N4CdTZuTZV7QtIfvrzgsElSfOVhTPzroaocAkrEfVdVcfJyAOloZW3b/9x2fW0m/kOKBZtH/V34GEV+IDW3mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042981; c=relaxed/simple;
	bh=bX0Pa/vGOAOqKWvDU87QAarnFSN7Pq0cOv6uuBceSfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0w7lqPIx76vfzfEa9RF6CvlkCjD7yOT5qacowskujlWwiOQa0MLPqBqmijuQnTXVyWV3czTHAPNiqLbdYivRc2CTSu7o7CzqQEFxJ/zI8aFjGtijDtVlsru/vaR7x2xX3mbjBKUibfCj0lFdjvtznSALkaZJ2LDzzQvy9dsY54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvbVAi5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvbVAi5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DB9C32781;
	Wed,  7 Aug 2024 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042980;
	bh=bX0Pa/vGOAOqKWvDU87QAarnFSN7Pq0cOv6uuBceSfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvbVAi5BT3+TgV6lIZuCI2uM3G6gceujzJTyKc81rT8kn7hF/5J4L6sGgpscp7ucQ
	 4kHZHlBIZll4gKqFapAlNZWyhOkKnrRJNhjsadagWvYUzKQzLTBFXOLmnJqHQdh+Sc
	 c8t8kK9gy76HsqVw4LGrtRkEmNOomdMKaILWJmYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 047/123] ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog
Date: Wed,  7 Aug 2024 16:59:26 +0200
Message-ID: <20240807150022.360100628@linuxfoundation.org>
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

[ Upstream commit 6044ca26210ba72b3dcc649fae1cbedd9e6ab018 ]

It is read by data path and modified from process context on remote cpu
so it is needed to use WRITE_ONCE to clear the pointer.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 0f91e91674277..8d25b69812698 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -456,7 +456,7 @@ void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 	if (rx_ring->vsi->type == ICE_VSI_PF)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-	rx_ring->xdp_prog = NULL;
+	WRITE_ONCE(rx_ring->xdp_prog, NULL);
 	if (rx_ring->xsk_pool) {
 		kfree(rx_ring->xdp_buf);
 		rx_ring->xdp_buf = NULL;
-- 
2.43.0



