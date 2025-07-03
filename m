Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CDC2EF292;
	Thu,  3 Jul 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554960; cv=none; b=ZIkc2DyYQ4ududIqMdZe+ar4WJ9oofv2Y/02mvepff0KJqP51MIeDiFFnZB2o6bfDqpCi0EApL41u0AcjGbup7TLSDWgpkNE4T1SJQBjRrFcIK93MmtMqrlFCk3mpsQRBf4vQD7LvrtStyWn+aW2M82E1r4c1xdrTN4/uk4AS1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554960; c=relaxed/simple;
	bh=ne0c1yIdXBCpJOCc53TXV+N4AzzOYLda0q2ECZfSPKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K44VssapHXTcpIIgs9Mk9jzSU/2uHs3YUPZ2VDSYVrLWFlf9z/TsTC+wGV0CE4ezOHZDcktg9mqVV3JzG/X+6yCBUHPt2wW+91OwL7BKktmHYQ9bK7pkkfD+RXoc40KBULC35ioxDyUJqsfn+02s4/n8uvDeaEQNfAQ56cY3dqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWxc9C/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWxc9C/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE63C4CEED;
	Thu,  3 Jul 2025 15:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554960;
	bh=ne0c1yIdXBCpJOCc53TXV+N4AzzOYLda0q2ECZfSPKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWxc9C/KzN5CSo+YOFiRweeMrvNpocsvROcOWx5Cx5rgEYXN3CUVzTAZsc4JkGrCz
	 4fBeMv67FlXcQnuo8GoZH6Jn+zejDtpafRXouEk04rcDliebvztxPZ+O9n5mvsig/1
	 /ZjZdAG2vkJX/HRmOnjPyxjsQOzHAvHLJG5aVvqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 133/263] cxl/ras: Fix CPER handler device confusion
Date: Thu,  3 Jul 2025 16:40:53 +0200
Message-ID: <20250703144009.697396544@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 3c70ec71abdaf4e4fa48cd8fdfbbd864d78235a8 ]

By inspection, cxl_cper_handle_prot_err() is making a series of fragile
assumptions that can lead to crashes:

1/ It assumes that endpoints identified in the record are a CXL-type-3
   device, nothing guarantees that.

2/ It assumes that the device is bound to the cxl_pci driver, nothing
   guarantees that.

3/ Minor, it holds the device lock over the switch-port tracing for no
   reason as the trace is 100% generated from data in the record.

Correct those by checking that the PCIe endpoint parents a cxl_memdev
before assuming the format of the driver data, and move the lock to where
it is required. Consequently this also makes the implementation ready for
CXL accelerators that are not bound to cxl_pci.

Fixes: 36f257e3b0ba ("acpi/ghes, cxl/pci: Process CXL CPER Protocol Errors")
Cc: Terry Bowman <terry.bowman@amd.com>
Cc: Li Ming <ming.li@zohomail.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Reviewed-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20250612192043.2254617-1-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/ras.c | 47 ++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index 485a831695c70..2731ba3a07993 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -31,40 +31,38 @@ static void cxl_cper_trace_uncorr_port_prot_err(struct pci_dev *pdev,
 					       ras_cap.header_log);
 }
 
-static void cxl_cper_trace_corr_prot_err(struct pci_dev *pdev,
-				  struct cxl_ras_capability_regs ras_cap)
+static void cxl_cper_trace_corr_prot_err(struct cxl_memdev *cxlmd,
+					 struct cxl_ras_capability_regs ras_cap)
 {
 	u32 status = ras_cap.cor_status & ~ras_cap.cor_mask;
-	struct cxl_dev_state *cxlds;
 
-	cxlds = pci_get_drvdata(pdev);
-	if (!cxlds)
-		return;
-
-	trace_cxl_aer_correctable_error(cxlds->cxlmd, status);
+	trace_cxl_aer_correctable_error(cxlmd, status);
 }
 
-static void cxl_cper_trace_uncorr_prot_err(struct pci_dev *pdev,
-				    struct cxl_ras_capability_regs ras_cap)
+static void
+cxl_cper_trace_uncorr_prot_err(struct cxl_memdev *cxlmd,
+			       struct cxl_ras_capability_regs ras_cap)
 {
 	u32 status = ras_cap.uncor_status & ~ras_cap.uncor_mask;
-	struct cxl_dev_state *cxlds;
 	u32 fe;
 
-	cxlds = pci_get_drvdata(pdev);
-	if (!cxlds)
-		return;
-
 	if (hweight32(status) > 1)
 		fe = BIT(FIELD_GET(CXL_RAS_CAP_CONTROL_FE_MASK,
 				   ras_cap.cap_control));
 	else
 		fe = status;
 
-	trace_cxl_aer_uncorrectable_error(cxlds->cxlmd, status, fe,
+	trace_cxl_aer_uncorrectable_error(cxlmd, status, fe,
 					  ras_cap.header_log);
 }
 
+static int match_memdev_by_parent(struct device *dev, const void *uport)
+{
+	if (is_cxl_memdev(dev) && dev->parent == uport)
+		return 1;
+	return 0;
+}
+
 static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 {
 	unsigned int devfn = PCI_DEVFN(data->prot_err.agent_addr.device,
@@ -73,13 +71,12 @@ static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 		pci_get_domain_bus_and_slot(data->prot_err.agent_addr.segment,
 					    data->prot_err.agent_addr.bus,
 					    devfn);
+	struct cxl_memdev *cxlmd;
 	int port_type;
 
 	if (!pdev)
 		return;
 
-	guard(device)(&pdev->dev);
-
 	port_type = pci_pcie_type(pdev);
 	if (port_type == PCI_EXP_TYPE_ROOT_PORT ||
 	    port_type == PCI_EXP_TYPE_DOWNSTREAM ||
@@ -92,10 +89,20 @@ static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 		return;
 	}
 
+	guard(device)(&pdev->dev);
+	if (!pdev->dev.driver)
+		return;
+
+	struct device *mem_dev __free(put_device) = bus_find_device(
+		&cxl_bus_type, NULL, pdev, match_memdev_by_parent);
+	if (!mem_dev)
+		return;
+
+	cxlmd = to_cxl_memdev(mem_dev);
 	if (data->severity == AER_CORRECTABLE)
-		cxl_cper_trace_corr_prot_err(pdev, data->ras_cap);
+		cxl_cper_trace_corr_prot_err(cxlmd, data->ras_cap);
 	else
-		cxl_cper_trace_uncorr_prot_err(pdev, data->ras_cap);
+		cxl_cper_trace_uncorr_prot_err(cxlmd, data->ras_cap);
 }
 
 static void cxl_cper_prot_err_work_fn(struct work_struct *work)
-- 
2.39.5



