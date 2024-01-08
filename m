Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728847791;
	Mon,  8 Jan 2024 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYMdifsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DABC433B6;
	Mon,  8 Jan 2024 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726716;
	bh=j4BmsJECk8uGFEkaYdc6AR7O7ANTVmzQG1yrVl6dUCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYMdifsTYX5MqlAq6iJl0dzmvEtpJ7TxxnQGV70tKduY6HpkpkUkqqCdhJRJ8qKEH
	 xoPEp+EXbe89OFhv9/6f7a3jsepWf9t64NdU4hEDtq/Q/XYxL4ANmTJiYSfVXmTIuG
	 LthGTK4X8G5tkpEtCCQQtAX6RQU4rFkZ0V8OK6K8=
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
Subject: [PATCH 6.6 026/124] ice: Fix link_down_on_close message
Date: Mon,  8 Jan 2024 16:07:32 +0100
Message-ID: <20240108150604.169934495@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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
index 7784135160fd2..66f4c54d8aa5a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2146,7 +2146,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	/* Ensure we have media as we cannot configure a medialess port */
 	if (!(phy->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
-		return -EPERM;
+		return -ENOMEDIUM;
 
 	ice_print_topo_conflict(vsi);
 
@@ -9173,8 +9173,12 @@ int ice_stop(struct net_device *netdev)
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



