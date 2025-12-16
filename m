Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1959A3659F4;
	Tue, 16 Dec 2025 12:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887126; cv=none; b=cAZxYNnQeWe/iWzxBK28bfO/48hAD8otTe7Dv84K27lwMEdvS5Pm+SPPzlhXCWqr2tWipssnuzzsHbBWddyhM6QweQWlA9dxmRcgnrziN0o95JmKCavzU9pNiAn0V+hUJtuCcI2wuGEMqDKFSUN47y1lJQglZpYfndUXCQCiTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887126; c=relaxed/simple;
	bh=ZHb2+an0LH7r0o+s9GERZ1NPza06lruRbef+vHS0tw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQsr1kfw7GsTVlgflX9YASSIPRz6W/6C+cIJx/yOkqPJ3DgoAm+UYCF7fi9RQZY542n8g2dCKssOukZ5d8NH6Io+6LuFIOWRYB7V805r77+jvCGhYUSm9dOF1rzK/7WWViXK/0yOfdiVSm7knDSt6UcM3TfQAteSj02yqAmk8V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkHjRt5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkHjRt5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAD9C4CEF1;
	Tue, 16 Dec 2025 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887126;
	bh=ZHb2+an0LH7r0o+s9GERZ1NPza06lruRbef+vHS0tw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkHjRt5c8N5yd0t7KnW1x5ukY4KfFsmVqMSuYs11v5AabH0OYABuaIKXoBUZydD+k
	 I9OJnhuH0gd5qySwThhj5JyTDjeN6aPRvXS7P5N94D24LH8xBnlwkUb0SSTyLNsFXY
	 h215hDtNsXYQbMvT41P5L7qco8Wf2d3cRltP3Uis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 101/614] ice: move udp_tunnel_nic and misc IRQ setup into ice_init_pf()
Date: Tue, 16 Dec 2025 12:07:48 +0100
Message-ID: <20251216111404.984113962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit e3bf1cdde7471bab7fc20dd1a37c2cdb82d3f76b ]

Move udp_tunnel_nic setup and ice_req_irq_msix_misc() call into
ice_init_pf(), remove some redundancy in the former while moving.

Move ice_free_irq_msix_misc() call into ice_deinit_pf(), to mimic
the above in terms of needed cleanup. Guard it via emptiness check,
to keep the allowance of half-initialized pf being cleaned up.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 58 +++++++++++------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 80349aed1f9d6..6773b918daffc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3978,6 +3978,9 @@ static void ice_deinit_pf(struct ice_pf *pf)
 	if (pf->ptp.clock)
 		ptp_clock_unregister(pf->ptp.clock);
 
+	if (!xa_empty(&pf->irq_tracker.entries))
+		ice_free_irq_msix_misc(pf);
+
 	xa_destroy(&pf->dyn_ports);
 	xa_destroy(&pf->sf_nums);
 }
@@ -4045,6 +4048,11 @@ void ice_start_service_task(struct ice_pf *pf)
  */
 static int ice_init_pf(struct ice_pf *pf)
 {
+	struct udp_tunnel_nic_info *udp_tunnel_nic = &pf->hw.udp_tunnel_nic;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	int err = -ENOMEM;
+
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
 	mutex_init(&pf->adev_mutex);
@@ -4075,11 +4083,30 @@ static int ice_init_pf(struct ice_pf *pf)
 	if (!pf->avail_txqs || !pf->avail_rxqs || !pf->txtime_txqs)
 		goto undo_init;
 
+	udp_tunnel_nic->set_port = ice_udp_tunnel_set_port;
+	udp_tunnel_nic->unset_port = ice_udp_tunnel_unset_port;
+	udp_tunnel_nic->shared = &hw->udp_tunnel_shared;
+	udp_tunnel_nic->tables[0].n_entries = hw->tnl.valid_count[TNL_VXLAN];
+	udp_tunnel_nic->tables[0].tunnel_types = UDP_TUNNEL_TYPE_VXLAN;
+	udp_tunnel_nic->tables[1].n_entries = hw->tnl.valid_count[TNL_GENEVE];
+	udp_tunnel_nic->tables[1].tunnel_types = UDP_TUNNEL_TYPE_GENEVE;
+
+	/* In case of MSIX we are going to setup the misc vector right here
+	 * to handle admin queue events etc. In case of legacy and MSI
+	 * the misc functionality and queue processing is combined in
+	 * the same vector and that gets setup at open.
+	 */
+	err = ice_req_irq_msix_misc(pf);
+	if (err) {
+		dev_err(dev, "setup of misc vector failed: %d\n", err);
+		goto undo_init;
+	}
+
 	return 0;
 undo_init:
 	/* deinit handles half-initialized pf just fine */
 	ice_deinit_pf(pf);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -4751,36 +4778,8 @@ int ice_init_dev(struct ice_pf *pf)
 		goto unroll_irq_scheme_init;
 	}
 
-	pf->hw.udp_tunnel_nic.set_port = ice_udp_tunnel_set_port;
-	pf->hw.udp_tunnel_nic.unset_port = ice_udp_tunnel_unset_port;
-	pf->hw.udp_tunnel_nic.shared = &pf->hw.udp_tunnel_shared;
-	if (pf->hw.tnl.valid_count[TNL_VXLAN]) {
-		pf->hw.udp_tunnel_nic.tables[0].n_entries =
-			pf->hw.tnl.valid_count[TNL_VXLAN];
-		pf->hw.udp_tunnel_nic.tables[0].tunnel_types =
-			UDP_TUNNEL_TYPE_VXLAN;
-	}
-	if (pf->hw.tnl.valid_count[TNL_GENEVE]) {
-		pf->hw.udp_tunnel_nic.tables[1].n_entries =
-			pf->hw.tnl.valid_count[TNL_GENEVE];
-		pf->hw.udp_tunnel_nic.tables[1].tunnel_types =
-			UDP_TUNNEL_TYPE_GENEVE;
-	}
-	/* In case of MSIX we are going to setup the misc vector right here
-	 * to handle admin queue events etc. In case of legacy and MSI
-	 * the misc functionality and queue processing is combined in
-	 * the same vector and that gets setup at open.
-	 */
-	err = ice_req_irq_msix_misc(pf);
-	if (err) {
-		dev_err(dev, "setup of misc vector failed: %d\n", err);
-		goto unroll_pf_init;
-	}
-
 	return 0;
 
-unroll_pf_init:
-	ice_deinit_pf(pf);
 unroll_irq_scheme_init:
 	ice_service_task_stop(pf);
 	ice_clear_interrupt_scheme(pf);
@@ -4789,7 +4788,6 @@ int ice_init_dev(struct ice_pf *pf)
 
 void ice_deinit_dev(struct ice_pf *pf)
 {
-	ice_free_irq_msix_misc(pf);
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
 	ice_service_task_stop(pf);
-- 
2.51.0



