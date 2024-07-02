Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079F01BD51C;
	Tue,  2 Jul 2024 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940070; cv=none; b=asvK2FRrTZva69zJNaH3TQBuEZM6bZc4bn+yvAGtmYOyzTXoIQuxr7Jy0RIBrUxdXrFalkWF92opl94+1I50UNm1HcEoOJssQPAyiCJsjk3r5ejWjBzfwiom/b8ZQQczUOnieE2mygu8b9f9j1wXY/bsZsx77HxDxXmXkGwc5XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940070; c=relaxed/simple;
	bh=hWCXbp8WoJR4gAwJEo04VdkaEYsP5W0id0LzbEeXwKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/44GDJSPdJLqMTb1f2m5Q7Vu+tBiWTKFXwVZ2dssb1XK9bsneVAiDQC+ESgpDUw8VR+jnkwVvsUrdWmU6fcCZibgcBylONV2TYQMk2rUw6KWvWDbNa9HIntPiC9p4gChggSx2uoFYWEnoUo3le9wtJffSBFXnldhi/SyCfbPXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWy9mKhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWy9mKhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813E2C116B1;
	Tue,  2 Jul 2024 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940069;
	bh=hWCXbp8WoJR4gAwJEo04VdkaEYsP5W0id0LzbEeXwKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWy9mKhYyYLA3vZeiXhcaPtTUAQC0JFgruMBBUjs7k6qIGkaYgR930FyFG0ZsMEW0
	 8+bs12HJ1oXnyOn5iyMyOcN4I4ag//DUNSPQpwrMyTUYrG0T+qK1S7nvH595PF6gI6
	 NIA6bZTc5Haex0+tagxTgiY059+cdV5ELETSEmKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jan Sokolowski <jan.sokolowski@intel.com>,
	Karen Ostrowska <karen.ostrowska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.9 042/222] ice: Rebuild TC queues on VSI queue reconfiguration
Date: Tue,  2 Jul 2024 19:01:20 +0200
Message-ID: <20240702170245.583475242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Sokolowski <jan.sokolowski@intel.com>

[ Upstream commit f4b91c1d17c676b8ad4c6bd674da874f3f7d5701 ]

TC queues needs to be correctly updated when the number of queues on
a VSI is reconfigured, so netdev's queue and TC settings will be
dynamically adjusted and could accurately represent the underlying
hardware state after changes to the VSI queue counts.

Fixes: 0754d65bd4be ("ice: Add infrastructure for mqprio support via ndo_setup_tc")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 61eef3259cbaa..88d4675cc3428 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4102,7 +4102,7 @@ bool ice_is_wol_supported(struct ice_hw *hw)
 int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 {
 	struct ice_pf *pf = vsi->back;
-	int err = 0, timeout = 50;
+	int i, err = 0, timeout = 50;
 
 	if (!new_rx && !new_tx)
 		return -EINVAL;
@@ -4128,6 +4128,14 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 
 	ice_vsi_close(vsi);
 	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+
+	ice_for_each_traffic_class(i) {
+		if (vsi->tc_cfg.ena_tc & BIT(i))
+			netdev_set_tc_queue(vsi->netdev,
+					    vsi->tc_cfg.tc_info[i].netdev_tc,
+					    vsi->tc_cfg.tc_info[i].qcount_tx,
+					    vsi->tc_cfg.tc_info[i].qoffset);
+	}
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
-- 
2.43.0



