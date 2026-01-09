Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FD23590C4;
	Fri,  9 Jan 2026 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962533; cv=none; b=Oq5aFWZ6TjckgGK8iqKYxTL2XPm/wuD5owNzsfwgnlZjv3dR+eu5A+c82QoDRF+SkQM1niHt7z1M5/CqthPEVyD7xR/0ldAs9RmlulvW06YsMNa3ssUzO2doyF1E/UNq1HvASfNfGZtIz70QDqGEeKfwXYXTbKrikjBZUEOTdpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962533; c=relaxed/simple;
	bh=uGmWO3dyrco1hOcg1uFGTRpTpOmqoSBh/k5F1maRZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2xD0wX30NZZV2ab9zBxZHXA1K+6GFhegpJjFb2imhVBLnTQSwxOPYTfhjvAJFrQ0sorLKTKsITsnOh7qnK4u2oHc2doLNgUvUilkxb7JwRZiDNANCjXpTmBn1OOk2AbAZjKYgdpabKrM0iRdXsG4VYanwkdvLZtg+PXf0rWDPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UudizDSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UudizDSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91141C4CEF1;
	Fri,  9 Jan 2026 12:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962533;
	bh=uGmWO3dyrco1hOcg1uFGTRpTpOmqoSBh/k5F1maRZ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UudizDSiwwKm+4J3422nyTKQuLPirASOEEHb60YhTUbjF95jmi0c3Cn8i+1Kyus3Q
	 iY5/6BiuvRIZBttZn0y6rHTbMcNP2hv409E9SLAE2DT33o0PdJrQTuSUiygM4hiMnr
	 S1f88bePxVluQlZ7lXD2EKrakvkYekZ6WK0qZ7Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/634] i40e: Refactor argument of several client notification functions
Date: Fri,  9 Jan 2026 12:41:17 +0100
Message-ID: <20260109112132.543296337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 54c4664e48eea52f2b296c73ddb8f5629b958678 ]

Commit 0ef2d5afb12d ("i40e: KISS the client interface") simplified
the client interface so in practice it supports only one client
per i40e netdev. But we have still 2 notification functions that
uses as parameter a pointer to VSI of netdevice associated with
the client. After the mentioned commit only possible and used
VSI is the main (LAN) VSI.
So refactor these functions so they are called with PF pointer argument
and the associated VSI (LAN) is taken inside them.

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 699428342153 ("i40e: validate ring_len parameter against hardware-specific values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_client.c | 20 +++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 12 +++++------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 3c9ac53da331..bc2ccb77dbe0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1217,8 +1217,8 @@ static inline void i40e_dbg_exit(void) {}
 int i40e_lan_add_device(struct i40e_pf *pf);
 int i40e_lan_del_device(struct i40e_pf *pf);
 void i40e_client_subtask(struct i40e_pf *pf);
-void i40e_notify_client_of_l2_param_changes(struct i40e_vsi *vsi);
-void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset);
+void i40e_notify_client_of_l2_param_changes(struct i40e_pf *pf);
+void i40e_notify_client_of_netdev_close(struct i40e_pf *pf, bool reset);
 void i40e_notify_client_of_vf_enable(struct i40e_pf *pf, u32 num_vfs);
 void i40e_notify_client_of_vf_reset(struct i40e_pf *pf, u32 vf_id);
 void i40e_client_update_msix_info(struct i40e_pf *pf);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 86fd82412e9e..406cfb9c5ac9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -102,25 +102,26 @@ i40e_notify_client_of_vf_msg(struct i40e_vsi *vsi, u32 vf_id, u8 *msg, u16 len)
 
 /**
  * i40e_notify_client_of_l2_param_changes - call the client notify callback
- * @vsi: the VSI with l2 param changes
+ * @pf: PF device pointer
  *
- * If there is a client to this VSI, call the client
+ * If there is a client, call its callback
  **/
-void i40e_notify_client_of_l2_param_changes(struct i40e_vsi *vsi)
+void i40e_notify_client_of_l2_param_changes(struct i40e_pf *pf)
 {
-	struct i40e_pf *pf = vsi->back;
 	struct i40e_client_instance *cdev = pf->cinst;
+	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_params params;
 
 	if (!cdev || !cdev->client)
 		return;
 	if (!cdev->client->ops || !cdev->client->ops->l2_param_change) {
-		dev_dbg(&vsi->back->pdev->dev,
+		dev_dbg(&pf->pdev->dev,
 			"Cannot locate client instance l2_param_change routine\n");
 		return;
 	}
 	if (!test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
-		dev_dbg(&vsi->back->pdev->dev, "Client is not open, abort l2 param change\n");
+		dev_dbg(&pf->pdev->dev,
+			"Client is not open, abort l2 param change\n");
 		return;
 	}
 	memset(&params, 0, sizeof(params));
@@ -160,20 +161,19 @@ static void i40e_client_release_qvlist(struct i40e_info *ldev)
 
 /**
  * i40e_notify_client_of_netdev_close - call the client close callback
- * @vsi: the VSI with netdev closed
+ * @pf: PF device pointer
  * @reset: true when close called due to a reset pending
  *
  * If there is a client to this netdev, call the client with close
  **/
-void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset)
+void i40e_notify_client_of_netdev_close(struct i40e_pf *pf, bool reset)
 {
-	struct i40e_pf *pf = vsi->back;
 	struct i40e_client_instance *cdev = pf->cinst;
 
 	if (!cdev || !cdev->client)
 		return;
 	if (!cdev->client->ops || !cdev->client->ops->close) {
-		dev_dbg(&vsi->back->pdev->dev,
+		dev_dbg(&pf->pdev->dev,
 			"Cannot locate client instance close routine\n");
 		return;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5823229ae598..fb0dd6f33090 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11313,14 +11313,12 @@ static void i40e_service_task(struct work_struct *work)
 		i40e_fdir_reinit_subtask(pf);
 		if (test_and_clear_bit(__I40E_CLIENT_RESET, pf->state)) {
 			/* Client subtask will reopen next time through. */
-			i40e_notify_client_of_netdev_close(pf->vsi[pf->lan_vsi],
-							   true);
+			i40e_notify_client_of_netdev_close(pf, true);
 		} else {
 			i40e_client_subtask(pf);
 			if (test_and_clear_bit(__I40E_CLIENT_L2_CHANGE,
 					       pf->state))
-				i40e_notify_client_of_l2_param_changes(
-								pf->vsi[pf->lan_vsi]);
+				i40e_notify_client_of_l2_param_changes(pf);
 		}
 		i40e_sync_filters_subtask(pf);
 	} else {
@@ -16307,7 +16305,7 @@ static void i40e_remove(struct pci_dev *pdev)
 	/* Client close must be called explicitly here because the timer
 	 * has been stopped.
 	 */
-	i40e_notify_client_of_netdev_close(pf->vsi[pf->lan_vsi], false);
+	i40e_notify_client_of_netdev_close(pf, false);
 
 	i40e_fdir_teardown(pf);
 
@@ -16573,7 +16571,7 @@ static void i40e_shutdown(struct pci_dev *pdev)
 	/* Client close must be called explicitly here because the timer
 	 * has been stopped.
 	 */
-	i40e_notify_client_of_netdev_close(pf->vsi[pf->lan_vsi], false);
+	i40e_notify_client_of_netdev_close(pf, false);
 
 	if (pf->wol_en && (pf->hw_features & I40E_HW_WOL_MC_MAGIC_PKT_WAKE))
 		i40e_enable_mc_magic_wake(pf);
@@ -16626,7 +16624,7 @@ static int __maybe_unused i40e_suspend(struct device *dev)
 	/* Client close must be called explicitly here because the timer
 	 * has been stopped.
 	 */
-	i40e_notify_client_of_netdev_close(pf->vsi[pf->lan_vsi], false);
+	i40e_notify_client_of_netdev_close(pf, false);
 
 	if (pf->wol_en && (pf->hw_features & I40E_HW_WOL_MC_MAGIC_PKT_WAKE))
 		i40e_enable_mc_magic_wake(pf);
-- 
2.51.0



