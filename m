Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0261149C7D;
	Tue, 25 Jun 2024 09:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308342; cv=none; b=mCG3zAiICXspBPmvIXQJzyb90FVW3rZGeHY5h8wwg9oq2QSWolFg1yJI1ZKzqe+kdC+UHvzx/dNDN+GA+eg7TDHit5RMZsSxdo2Kk0LvgUXBOfIUcZlJWe6LFvZ043ETx9u+whXgUovd4IZpw7g84Rkt6cpZTipiVBcwwdtdIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308342; c=relaxed/simple;
	bh=Ievv4AtykTaWgt24yYep6y1YLku28+PoFC8peYCiVbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcYgh3R+nAR2a8yoNSil15E1zqjbfA38ffy+q7ljPM8qnnrcV/9cd3DWsabuHgDKHvvPRIKlOD6w+ea1WzZhlMDKsWR+0uHVWDLgUtNzq73s6alsgJJ/Ajb7FQk+dxWNBSamIidmZYXI2pl6NTYNynKgp3W1mTE6g+XkaaM2WOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6vJV0UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6vJV0UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67446C32781;
	Tue, 25 Jun 2024 09:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308341;
	bh=Ievv4AtykTaWgt24yYep6y1YLku28+PoFC8peYCiVbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6vJV0UHwoOTQ+p/wxGOABtmkFT8s2Y5O394lt2OciDJKxsDrUtggVhbXhdJlm7ol
	 zd6/BC4/FTBjqfkzZPkMPq42tansJGK/4UkPfVN54Y5EmXgLs/jYch0dj7PVyRoihN
	 24RvmHI8QkogNzQSCPjd8bK7M1Tiax+BZaGH9+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 088/250] cxl: Add post-reset warning if reset results in loss of previously committed HDM decoders
Date: Tue, 25 Jun 2024 11:30:46 +0200
Message-ID: <20240625085551.446241720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 934edcd436dca0447e0d3691a908394ba16d06c3 ]

Secondary Bus Reset (SBR) is equivalent to a device being hot removed and
inserted again. Doing a SBR on a CXL type 3 device is problematic if the
exported device memory is part of system memory that cannot be offlined.
The event is equivalent to violently ripping out that range of memory from
the kernel. While the hardware requires the "Unmask SBR" bit set in the
Port Control Extensions register and the kernel currently does not unmask
it, user can unmask this bit via setpci or similar tool.

The driver does not have a way to detect whether a reset coming from the
PCI subsystem is a Function Level Reset (FLR) or SBR. The only way to
detect is to note if a decoder is marked as enabled in software but the
decoder control register indicates it's not committed.

Add a helper function to find discrepancy between the decoder software
state versus the hardware register state.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20240502165851.1948523-6-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 29 +++++++++++++++++++++++++++++
 drivers/cxl/cxl.h      |  2 ++
 drivers/cxl/pci.c      | 22 ++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 0df09bd794088..2773f05adb7d2 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -1045,3 +1045,32 @@ long cxl_pci_get_latency(struct pci_dev *pdev)
 
 	return cxl_flit_size(pdev) * MEGA / bw;
 }
+
+static int __cxl_endpoint_decoder_reset_detected(struct device *dev, void *data)
+{
+	struct cxl_port *port = data;
+	struct cxl_decoder *cxld;
+	struct cxl_hdm *cxlhdm;
+	void __iomem *hdm;
+	u32 ctrl;
+
+	if (!is_endpoint_decoder(dev))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
+		return 0;
+
+	cxlhdm = dev_get_drvdata(&port->dev);
+	hdm = cxlhdm->regs.hdm_decoder;
+	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+
+	return !FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl);
+}
+
+bool cxl_endpoint_decoder_reset_detected(struct cxl_port *port)
+{
+	return device_for_each_child(&port->dev, port,
+				     __cxl_endpoint_decoder_reset_detected);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_reset_detected, CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 036d17db68e00..72fa477407689 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -891,6 +891,8 @@ void cxl_coordinates_combine(struct access_coordinate *out,
 			     struct access_coordinate *c1,
 			     struct access_coordinate *c2);
 
+bool cxl_endpoint_decoder_reset_detected(struct cxl_port *port);
+
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
  * of these symbols in tools/testing/cxl/.
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 2ff361e756d66..659f9d46b154c 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -957,11 +957,33 @@ static void cxl_error_resume(struct pci_dev *pdev)
 		 dev->driver ? "successful" : "failed");
 }
 
+static void cxl_reset_done(struct pci_dev *pdev)
+{
+	struct cxl_dev_state *cxlds = pci_get_drvdata(pdev);
+	struct cxl_memdev *cxlmd = cxlds->cxlmd;
+	struct device *dev = &pdev->dev;
+
+	/*
+	 * FLR does not expect to touch the HDM decoders and related
+	 * registers.  SBR, however, will wipe all device configurations.
+	 * Issue a warning if there was an active decoder before the reset
+	 * that no longer exists.
+	 */
+	guard(device)(&cxlmd->dev);
+	if (cxlmd->endpoint &&
+	    cxl_endpoint_decoder_reset_detected(cxlmd->endpoint)) {
+		dev_crit(dev, "SBR happened without memory regions removal.\n");
+		dev_crit(dev, "System may be unstable if regions hosted system memory.\n");
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+}
+
 static const struct pci_error_handlers cxl_error_handlers = {
 	.error_detected	= cxl_error_detected,
 	.slot_reset	= cxl_slot_reset,
 	.resume		= cxl_error_resume,
 	.cor_error_detected	= cxl_cor_error_detected,
+	.reset_done	= cxl_reset_done,
 };
 
 static struct pci_driver cxl_pci_driver = {
-- 
2.43.0



