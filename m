Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9697081751;
	Wed,  7 Aug 2024 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043383; cv=none; b=LLo/mSFggwa/q1Sat78YsXQPdB1D3vI76JJOQZYAIUpkVwmdYogNJZGrzwGLwh7qfjJK862leOGyNms6AROzd6N4bPvMmL4ioI/nrrwlIAzTPVjm/cbSj3aCo3q7RkQtRNpOho5g4sZANQkvGswaoltQDqvfuf6gAKWlH4EniYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043383; c=relaxed/simple;
	bh=rPvUTCeJ3gp1NEJ9Gu8to8oo4v2Hw5dmFPtTSD4yoKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW9R0E5q28T2N1QKQBtxyMA0CQBsfceJbUq2oR5nbSgbyp6dAs/rHzlRZoDylkssNMBcLwiksltcs1yOxeOZDmvXAGf+kk/cmUTtxYMMyFXMe7vz16WwXSjymeL92wr/FKsMWiMlz9l8a+xqB/Skno10BrWhK5OpWvVeULsm4KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgD6quDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgD6quDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28225C32781;
	Wed,  7 Aug 2024 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043383;
	bh=rPvUTCeJ3gp1NEJ9Gu8to8oo4v2Hw5dmFPtTSD4yoKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgD6quDnZdcdAtXUIF9BxN29iUguzimpSS0OLI9qAlfT0zv6dA0FVDXTlJKRq7snd
	 uWwMEgyEzwOmRq1/Xy/YSeK8sbUKxO8RK90ejCCcRDOi33XeExLp04bho/H8LNQ0wS
	 b0aJOV5oc8vIGUInWXkG9vDjKH05EOUOaOH6a96E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 070/121] ice: dont busy wait for Rx queue disable in ice_qp_dis()
Date: Wed,  7 Aug 2024 17:00:02 +0200
Message-ID: <20240807150021.689777021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index 248cb02958acd..a8d0cd3d831a0 100644
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



