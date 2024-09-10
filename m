Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308AD18CBE2;
	Tue, 10 Sep 2024 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964244; cv=none; b=TRp7rt609JJF5qAWI9UVVsw7tgLwBmU+hNT/sQHdSafqv+lUa7mgoSgSZMnFU8r7pgNuV5ZIrkR9PAxQercW4Rqi/3KpKj24smQo3BM9IqjcOQxr1hjO1EvGch8MlI8RL5Lz1xVPu1uM1CntLD2Dou7sJRSWBDtJYKuIRcfdayE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964244; c=relaxed/simple;
	bh=oG+QFfNEUs3AeIl8dOcpR9Yn4Nd1uyj0eoTVUnPUnSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO90x3l/MA7JKZVGlxO7nzQASpeu4ZDL9i2d/JSrjbPTVisVqLrNiw8s5yuKQr6P2E42IyXOGwi1ssgUe3+H9LlIomRzZSoG8TDMmvcC/O0k+Sdz6Eysj4d6FSQ+9EBNw0iZ9h/z/rm0YkJ20MNf/QETbDb+CkrqxGH48L4MUXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwQ1km/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwQ1km/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A718FC4CEC3;
	Tue, 10 Sep 2024 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964244;
	bh=oG+QFfNEUs3AeIl8dOcpR9Yn4Nd1uyj0eoTVUnPUnSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwQ1km/gXo2G0GHBwy9XS9uZthhPgOgKWOma8H2Gt+gBZh3kbUqECNU6wTe+U58Tr
	 aZ1k3VQkJfZn4NFEI0avNDQFIWmFzF88a7Wrr/qQSF7QfpQHuJBSl93OyKEWZ60cW+
	 QPPSX4yEnJEVnPbHrGSi9dMmHqFaQdYyHYf7wUQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Eric Joyner <eric.joyner@intel.com>,
	Karen Ostrowska <karen.ostrowska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 089/269] ice: Check all ice_vsi_rebuild() errors in function
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092611.382528218@linuxfoundation.org>
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

From: Eric Joyner <eric.joyner@intel.com>

[ Upstream commit d47bf9a495cf424fad674321d943123dc12b926d ]

Check the return value from ice_vsi_rebuild() and prevent the usage of
incorrectly configured VSI.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Eric Joyner <eric.joyner@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b168a37a5dff..3f254ce0d6db 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3979,13 +3979,17 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
-		ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+		if (err)
+			goto rebuild_err;
 		dev_dbg(ice_pf_to_dev(pf), "Link is down, queue count change happens when link is brought up\n");
 		goto done;
 	}
 
 	ice_vsi_close(vsi);
-	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+	err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
+	if (err)
+		goto rebuild_err;
 
 	ice_for_each_traffic_class(i) {
 		if (vsi->tc_cfg.ena_tc & BIT(i))
@@ -3996,6 +4000,11 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 	}
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
+	goto done;
+
+rebuild_err:
+	dev_err(ice_pf_to_dev(pf), "Error during VSI rebuild: %d. Unload and reload the driver.\n",
+		err);
 done:
 	clear_bit(ICE_CFG_BUSY, pf->state);
 	return err;
-- 
2.43.0



