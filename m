Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061BC8487;
	Sat, 30 Dec 2023 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhYKYh98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86317C433C7;
	Sat, 30 Dec 2023 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937841;
	bh=p19dlEJwoPXitJZDVs+6MTSce4kZCU+eI1i/NFB/Asw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhYKYh981AiJIlvtEOXm1AfwN07LgiNsweMM2vf5zFg1qZqzgBc9mgovkvSpySDBq
	 lajHEhpeBn2u6S2jCQX5LNF9+4vHNfnEZW3zes4oy9cNnCTset/QQdl2T6kr0lgrWy
	 lD/p14yEsazm8U6NEhCFpZ3IONEzEkRipIUts7Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 059/156] ice: Fix PF with enabled XDP going no-carrier after reset
Date: Sat, 30 Dec 2023 11:58:33 +0000
Message-ID: <20231230115814.267309866@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

[ Upstream commit f5728a418945ba53e2fdf38a6e5c5a2670965e85 ]

Commit 6624e780a577fc596788 ("ice: split ice_vsi_setup into smaller
functions") has refactored a bunch of code involved in PFR. In this
process, TC queue number adjustment for XDP was lost. Bring it back.

Lack of such adjustment causes interface to go into no-carrier after a
reset, if XDP program is attached, with the following message:

ice 0000:b1:00.0: Failed to set LAN Tx queue context, error: -22
ice 0000:b1:00.0 ens801f0np0: Failed to open VSI 0x0006 on switch 0x0001
ice 0000:b1:00.0: enable VSI failed, err -22, VSI index 0, type ICE_VSI_PF
ice 0000:b1:00.0: PF VSI rebuild failed: -22
ice 0000:b1:00.0: Rebuild failed, unload and reload driver

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8dbf7a381e49b..a66c3b6ccec1e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2384,6 +2384,9 @@ static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
 		} else {
 			max_txqs[i] = vsi->alloc_txq;
 		}
+
+		if (vsi->type == ICE_VSI_PF)
+			max_txqs[i] += vsi->num_xdp_txq;
 	}
 
 	dev_dbg(dev, "vsi->tc_cfg.ena_tc = %d\n", vsi->tc_cfg.ena_tc);
-- 
2.43.0



