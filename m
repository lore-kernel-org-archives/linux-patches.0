Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810E71E534;
	Tue, 27 Feb 2024 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040947; cv=none; b=ldItzblhT0ctrOQpKbCK9+QT5iVeiBGrPa3nYqTGc7dY2ZMDQd5aCqbCSq/esEB64KfzjsQSDldMW7pqsY4wD2Ga8R3Vh44YCFXtd73iGv4aeVMI5PP4DlCWtDw7J8KypXvkgTCBdqwQYB90xg6p7/n6torZxKSjdEhTc9AU3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040947; c=relaxed/simple;
	bh=BkcSh+kRncEOSN/PDDgIRhE3fHIQ0RW5IE2W+m5K2q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptsye8AW1TcokbZ6qszScWRmh0NwFPqJgPtudDa2l498rnphfVmqNosVh8ydFEIlsbq4QF4myZbIOxu04SALvCZm6kUpm2zKtE1D5aTUvnPr9Omfh54cUjR4yC6CPtKG1BaFeLnN6jNBEnKmemhjJr7YEIQlb2D7qKiC6brqOmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq71M1N2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq71M1N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA8FC433C7;
	Tue, 27 Feb 2024 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040947;
	bh=BkcSh+kRncEOSN/PDDgIRhE3fHIQ0RW5IE2W+m5K2q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq71M1N2eoKm2fu/HZo8PSLnWOH2yJII62qinuqH1N3H5EI2D5D9aqd22zjPU58jd
	 Cdm3O6hVGbM1ngKN8T3UrgkMjirn9GEH5yHym1yh5Pznz6Az8ExOv+tP7fEPwluw5T
	 TYtjzoryrotxl6aP04tUQFYO2TRXyJ2y8imEqa8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Li Ming <ming4.li@intel.com>
Subject: [PATCH 6.7 165/334] cxl/pci: Skip to handle RAS errors if CXL.mem device is detached
Date: Tue, 27 Feb 2024 14:20:23 +0100
Message-ID: <20240227131635.829001249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming4.li@intel.com>

commit eef5c7b28dbecd6b141987a96db6c54e49828102 upstream.

The PCI AER model is an awkward fit for CXL error handling. While the
expectation is that a PCI device can escalate to link reset to recover
from an AER event, the same reset on CXL amounts to a surprise memory
hotplug of massive amounts of memory.

At present, the CXL error handler attempts some optimistic error
handling to unbind the device from the cxl_mem driver after reaping some
RAS register values. This results in a "hopeful" attempt to unplug the
memory, but there is no guarantee that will succeed.

A subsequent AER notification after the memdev unbind event can no
longer assume the registers are mapped. Check for memdev bind before
reaping status register values to avoid crashes of the form:

 BUG: unable to handle page fault for address: ffa00000195e9100
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 [...]
 RIP: 0010:__cxl_handle_ras+0x30/0x110 [cxl_core]
 [...]
 Call Trace:
  <TASK>
  ? __die+0x24/0x70
  ? page_fault_oops+0x82/0x160
  ? kernelmode_fixup_or_oops+0x84/0x110
  ? exc_page_fault+0x113/0x170
  ? asm_exc_page_fault+0x26/0x30
  ? __pfx_dpc_reset_link+0x10/0x10
  ? __cxl_handle_ras+0x30/0x110 [cxl_core]
  ? find_cxl_port+0x59/0x80 [cxl_core]
  cxl_handle_rp_ras+0xbc/0xd0 [cxl_core]
  cxl_error_detected+0x6c/0xf0 [cxl_core]
  report_error_detected+0xc7/0x1c0
  pci_walk_bus+0x73/0x90
  pcie_do_recovery+0x23f/0x330

Longer term, the unbind and PCI_ERS_RESULT_DISCONNECT behavior might
need to be replaced with a new PCI_ERS_RESULT_PANIC.

Fixes: 6ac07883dbb5 ("cxl/pci: Add RCH downstream port error logging")
Cc: stable@vger.kernel.org
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Li Ming <ming4.li@intel.com>
Link: https://lore.kernel.org/r/20240129131856.2458980-1-ming4.li@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -931,11 +931,21 @@ static void cxl_handle_rdport_errors(str
 void cxl_cor_error_detected(struct pci_dev *pdev)
 {
 	struct cxl_dev_state *cxlds = pci_get_drvdata(pdev);
+	struct device *dev = &cxlds->cxlmd->dev;
 
-	if (cxlds->rcd)
-		cxl_handle_rdport_errors(cxlds);
+	scoped_guard(device, dev) {
+		if (!dev->driver) {
+			dev_warn(&pdev->dev,
+				 "%s: memdev disabled, abort error handling\n",
+				 dev_name(dev));
+			return;
+		}
 
-	cxl_handle_endpoint_cor_ras(cxlds);
+		if (cxlds->rcd)
+			cxl_handle_rdport_errors(cxlds);
+
+		cxl_handle_endpoint_cor_ras(cxlds);
+	}
 }
 EXPORT_SYMBOL_NS_GPL(cxl_cor_error_detected, CXL);
 
@@ -947,16 +957,25 @@ pci_ers_result_t cxl_error_detected(stru
 	struct device *dev = &cxlmd->dev;
 	bool ue;
 
-	if (cxlds->rcd)
-		cxl_handle_rdport_errors(cxlds);
+	scoped_guard(device, dev) {
+		if (!dev->driver) {
+			dev_warn(&pdev->dev,
+				 "%s: memdev disabled, abort error handling\n",
+				 dev_name(dev));
+			return PCI_ERS_RESULT_DISCONNECT;
+		}
+
+		if (cxlds->rcd)
+			cxl_handle_rdport_errors(cxlds);
+		/*
+		 * A frozen channel indicates an impending reset which is fatal to
+		 * CXL.mem operation, and will likely crash the system. On the off
+		 * chance the situation is recoverable dump the status of the RAS
+		 * capability registers and bounce the active state of the memdev.
+		 */
+		ue = cxl_handle_endpoint_ras(cxlds);
+	}
 
-	/*
-	 * A frozen channel indicates an impending reset which is fatal to
-	 * CXL.mem operation, and will likely crash the system. On the off
-	 * chance the situation is recoverable dump the status of the RAS
-	 * capability registers and bounce the active state of the memdev.
-	 */
-	ue = cxl_handle_endpoint_ras(cxlds);
 
 	switch (state) {
 	case pci_channel_io_normal:


