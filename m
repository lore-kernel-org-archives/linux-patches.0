Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5801E4A2;
	Mon,  8 Jan 2024 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHPADQID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDD8C433A9;
	Mon,  8 Jan 2024 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728254;
	bh=d4PM6Z5XiUBiNQEbRGWwVZ6Vx47uCnrcsO1/1pOduq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHPADQIDsh7VPRe8+GeZOX8eBdQPujb1UJN1CQB/2xzxV3uU+ztw0UK0NQAgC3Qp1
	 wyOtja0z/B0jR2uu0m0Y4NeNT4nNDYvflXBtBp2n00KMpBhdnR/bd/ufOBTk4H//gd
	 Aa5qnytjE2Wwl8pkNFRrklJaIUbvT7rKoHOzmtIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Katarzyna Wieczerzycka <katarzyna.wieczerzycka@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 019/150] ice: Fix link_down_on_close message
Date: Mon,  8 Jan 2024 16:34:30 +0100
Message-ID: <20240108153512.166454355@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Katarzyna Wieczerzycka <katarzyna.wieczerzycka@intel.com>

[ Upstream commit 6a8d8bb55e7001de2d50920381cc858f3a3e9fb7 ]

The driver should not report an error message when for a medialess port
the link_down_on_close flag is enabled and the physical link cannot be
set down.

Fixes: 8ac7132704f3 ("ice: Fix interface being down after reset with link-down-on-close flag on")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Katarzyna Wieczerzycka <katarzyna.wieczerzycka@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f0f39364819ac..5eb3b80b293c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2138,7 +2138,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	/* Ensure we have media as we cannot configure a medialess port */
 	if (!(phy->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
-		return -EPERM;
+		return -ENOMEDIUM;
 
 	ice_print_topo_conflict(vsi);
 
@@ -9065,8 +9065,12 @@ int ice_stop(struct net_device *netdev)
 		int link_err = ice_force_phys_link_state(vsi, false);
 
 		if (link_err) {
-			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
-				   vsi->vsi_num, link_err);
+			if (link_err == -ENOMEDIUM)
+				netdev_info(vsi->netdev, "Skipping link reconfig - no media attached, VSI %d\n",
+					    vsi->vsi_num);
+			else
+				netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
+					   vsi->vsi_num, link_err);
 			return -EIO;
 		}
 	}
-- 
2.43.0



