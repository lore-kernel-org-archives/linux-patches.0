Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA061A701;
	Sat,  3 Feb 2024 04:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933701; cv=none; b=fGD3lPZq5N2+WlC3lYmRSvIsctIFV6Z3nA446lWX3YZQs7G7u4x6Jb94OdrP57nBJUb7MgT0vY/w5CZdHuMAsNZ8rUKu6HAVxeS5qFfui0ISgQfe30r7SCaOzLnHKqjExNk7d9EIrae47MTK8F3jYawhghVp4lnwZhMX58GRt+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933701; c=relaxed/simple;
	bh=S5LIB0XVS8An4XpmJd0qxMzqzdtcHjJI3qO2nWXbUkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1+J1E+FhlqNH/fFcLzupihhGUSl5PQRpWPMOy6NSxHsuS9Yqkg74zFSejNtWOnckXyP6C9XocrD2tf+BBvgTcK2fEJ0wG7lJrTKVgLov5soW1UuK98/oX/BqqfBR7/A6VajYKk8Q4GyApA+1E9Et6umlX4JaH8CpO3ji5yzLSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6fKjaUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6fKjaUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EFC433C7;
	Sat,  3 Feb 2024 04:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933701;
	bh=S5LIB0XVS8An4XpmJd0qxMzqzdtcHjJI3qO2nWXbUkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6fKjaUmghRQxur54Qm7WklnnNR0ms+L3aHRSoH5rzpbqM09feLP2d9mJxd9zM2+J
	 SqVXsskNS2Ligd2dzwGK8amvDYvJDFSEuP7lqA4CJQAFw7qbdDPnLgg9lBSHarGK0s
	 hi8GXwhOvY27K2qHM9vVE0ziPPEcrobnoRWs2/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/322] pds_core: implement pci reset handlers
Date: Fri,  2 Feb 2024 20:06:39 -0800
Message-ID: <20240203035408.814433831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit ffa55858330f267beec995fc4f68098c91311c64 ]

Implement the callbacks for a nice PCI reset.  These get called
when a user is nice enough to use the sysfs PCI reset entry, e.g.
    echo 1 > /sys/bus/pci/devices/0000:2b:00.0/reset

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7e82a8745b95 ("pds_core: Prevent race issues involving the adminq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 14 +++++--
 drivers/net/ethernet/amd/pds_core/core.h |  4 ++
 drivers/net/ethernet/amd/pds_core/main.c | 50 ++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index dfb43ed60e27..cc5e3d1fe652 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -514,7 +514,7 @@ void pdsc_stop(struct pdsc *pdsc)
 					   PDS_CORE_INTR_MASK_SET);
 }
 
-static void pdsc_fw_down(struct pdsc *pdsc)
+void pdsc_fw_down(struct pdsc *pdsc)
 {
 	union pds_core_notifyq_comp reset_event = {
 		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
@@ -522,10 +522,13 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 	};
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
-		dev_err(pdsc->dev, "%s: already happening\n", __func__);
+		dev_warn(pdsc->dev, "%s: already happening\n", __func__);
 		return;
 	}
 
+	if (pdsc->pdev->is_virtfn)
+		return;
+
 	/* Notify clients of fw_down */
 	if (pdsc->fw_reporter)
 		devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
@@ -535,7 +538,7 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 }
 
-static void pdsc_fw_up(struct pdsc *pdsc)
+void pdsc_fw_up(struct pdsc *pdsc)
 {
 	union pds_core_notifyq_comp reset_event = {
 		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
@@ -548,6 +551,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 		return;
 	}
 
+	if (pdsc->pdev->is_virtfn) {
+		clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
+		return;
+	}
+
 	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index b1c1f1007b06..860bce1731c7 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -309,4 +309,8 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
+
+void pdsc_fw_down(struct pdsc *pdsc);
+void pdsc_fw_up(struct pdsc *pdsc);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 3a45bf474a19..4c7f982c12a1 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -445,12 +445,62 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devlink_free(dl);
 }
 
+static void pdsc_reset_prepare(struct pci_dev *pdev)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+
+	pdsc_fw_down(pdsc);
+
+	pci_free_irq_vectors(pdev);
+	pdsc_unmap_bars(pdsc);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static void pdsc_reset_done(struct pci_dev *pdev)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct device *dev = pdsc->dev;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Cannot enable PCI device: %pe\n", ERR_PTR(err));
+		return;
+	}
+	pci_set_master(pdev);
+
+	if (!pdev->is_virtfn) {
+		pcie_print_link_status(pdsc->pdev);
+
+		err = pci_request_regions(pdsc->pdev, PDS_CORE_DRV_NAME);
+		if (err) {
+			dev_err(pdsc->dev, "Cannot request PCI regions: %pe\n",
+				ERR_PTR(err));
+			return;
+		}
+
+		err = pdsc_map_bars(pdsc);
+		if (err)
+			return;
+	}
+
+	pdsc_fw_up(pdsc);
+}
+
+static const struct pci_error_handlers pdsc_err_handler = {
+	/* FLR handling */
+	.reset_prepare      = pdsc_reset_prepare,
+	.reset_done         = pdsc_reset_done,
+};
+
 static struct pci_driver pdsc_driver = {
 	.name = PDS_CORE_DRV_NAME,
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
 	.sriov_configure = pdsc_sriov_configure,
+	.err_handler = &pdsc_err_handler,
 };
 
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
-- 
2.43.0



