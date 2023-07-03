Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27969101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2057C433C8;
	Mon,  3 Jul 2023 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410547;
	bh=GVzZN79N7pjJQXz1Afx4G3Xqd0Gi6RKetz/SKT5Kiuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKVzWcKklHR/I1aHMcCKMj4GM/0GUSH3fL/ckbe0wNtPF0S23B0rHkG908yhNTgV8
	 3U8OZRr0i8AsGeZ4YUZWocNaRt6Lae/yYbSMu5utTdjKAYeetHJtk+tCp6R1tn7VOC
	 wax2pjR9Ig58Nv1wwi/qkjgaMiPmp88oHrROUXVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.4 07/13] Revert "cxl/port: Enable the HDM decoder capability for switch ports"
Date: Mon,  3 Jul 2023 20:54:08 +0200
Message-ID: <20230703184519.489189191@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.261119397@linuxfoundation.org>
References: <20230703184519.261119397@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit 8f0220af58c3b73e9041377a23708d37600b33c1 upstream.

commit eb0764b822b9 ("cxl/port: Enable the HDM decoder capability for switch ports")

...was added on the observation of CXL memory not being accessible after
setting up a region on a "cold-plugged" device. A "cold-plugged" CXL
device is one that was not present at boot, so platform-firmware/BIOS
has no chance to set it up.

While it is true that the debug found the enable bit clear in the
host-bridge's instance of the global control register (CXL 3.0
8.2.4.19.2 CXL HDM Decoder Global Control Register), that bit is
described as:

"This bit is only applicable to CXL.mem devices and shall
return 0 on CXL Host Bridges and Upstream Switch Ports."

So it is meant to be zero, and further testing confirmed that this "fix"
had no effect on the failure. Revert it, and be more vigilant about
proposed fixes in the future. Since the original copied stable@, flag
this revert for stable@ as well.

Cc: <stable@vger.kernel.org>
Fixes: eb0764b822b9 ("cxl/port: Enable the HDM decoder capability for switch ports")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/168685882012.3475336.16733084892658264991.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c        |   27 ++++-----------------------
 drivers/cxl/cxl.h             |    1 -
 drivers/cxl/port.c            |   14 +++++---------
 tools/testing/cxl/Kbuild      |    1 -
 tools/testing/cxl/test/mock.c |   15 ---------------
 5 files changed, 9 insertions(+), 49 deletions(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -308,36 +308,17 @@ static void disable_hdm(void *_cxlhdm)
 	       hdm + CXL_HDM_DECODER_CTRL_OFFSET);
 }
 
-int devm_cxl_enable_hdm(struct cxl_port *port, struct cxl_hdm *cxlhdm)
+static int devm_cxl_enable_hdm(struct device *host, struct cxl_hdm *cxlhdm)
 {
-	void __iomem *hdm;
+	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	u32 global_ctrl;
 
-	/*
-	 * If the hdm capability was not mapped there is nothing to enable and
-	 * the caller is responsible for what happens next.  For example,
-	 * emulate a passthrough decoder.
-	 */
-	if (IS_ERR(cxlhdm))
-		return 0;
-
-	hdm = cxlhdm->regs.hdm_decoder;
 	global_ctrl = readl(hdm + CXL_HDM_DECODER_CTRL_OFFSET);
-
-	/*
-	 * If the HDM decoder capability was enabled on entry, skip
-	 * registering disable_hdm() since this decode capability may be
-	 * owned by platform firmware.
-	 */
-	if (global_ctrl & CXL_HDM_DECODER_ENABLE)
-		return 0;
-
 	writel(global_ctrl | CXL_HDM_DECODER_ENABLE,
 	       hdm + CXL_HDM_DECODER_CTRL_OFFSET);
 
-	return devm_add_action_or_reset(&port->dev, disable_hdm, cxlhdm);
+	return devm_add_action_or_reset(host, disable_hdm, cxlhdm);
 }
-EXPORT_SYMBOL_NS_GPL(devm_cxl_enable_hdm, CXL);
 
 int cxl_dvsec_rr_decode(struct device *dev, int d,
 			struct cxl_endpoint_dvsec_info *info)
@@ -511,7 +492,7 @@ int cxl_hdm_decode_init(struct cxl_dev_s
 	if (info->mem_enabled)
 		return 0;
 
-	rc = devm_cxl_enable_hdm(port, cxlhdm);
+	rc = devm_cxl_enable_hdm(&port->dev, cxlhdm);
 	if (rc)
 		return rc;
 
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -710,7 +710,6 @@ struct cxl_endpoint_dvsec_info {
 struct cxl_hdm;
 struct cxl_hdm *devm_cxl_setup_hdm(struct cxl_port *port,
 				   struct cxl_endpoint_dvsec_info *info);
-int devm_cxl_enable_hdm(struct cxl_port *port, struct cxl_hdm *cxlhdm);
 int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 				struct cxl_endpoint_dvsec_info *info);
 int devm_cxl_add_passthrough_decoder(struct cxl_port *port);
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -60,17 +60,13 @@ static int discover_region(struct device
 static int cxl_switch_port_probe(struct cxl_port *port)
 {
 	struct cxl_hdm *cxlhdm;
-	int rc, nr_dports;
+	int rc;
 
-	nr_dports = devm_cxl_port_enumerate_dports(port);
-	if (nr_dports < 0)
-		return nr_dports;
-
-	cxlhdm = devm_cxl_setup_hdm(port, NULL);
-	rc = devm_cxl_enable_hdm(port, cxlhdm);
-	if (rc)
+	rc = devm_cxl_port_enumerate_dports(port);
+	if (rc < 0)
 		return rc;
 
+	cxlhdm = devm_cxl_setup_hdm(port, NULL);
 	if (!IS_ERR(cxlhdm))
 		return devm_cxl_enumerate_decoders(cxlhdm, NULL);
 
@@ -79,7 +75,7 @@ static int cxl_switch_port_probe(struct
 		return PTR_ERR(cxlhdm);
 	}
 
-	if (nr_dports == 1) {
+	if (rc == 1) {
 		dev_dbg(&port->dev, "Fallback to passthrough decoder\n");
 		return devm_cxl_add_passthrough_decoder(port);
 	}
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -6,7 +6,6 @@ ldflags-y += --wrap=acpi_pci_find_root
 ldflags-y += --wrap=nvdimm_bus_register
 ldflags-y += --wrap=devm_cxl_port_enumerate_dports
 ldflags-y += --wrap=devm_cxl_setup_hdm
-ldflags-y += --wrap=devm_cxl_enable_hdm
 ldflags-y += --wrap=devm_cxl_add_passthrough_decoder
 ldflags-y += --wrap=devm_cxl_enumerate_decoders
 ldflags-y += --wrap=cxl_await_media_ready
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -149,21 +149,6 @@ struct cxl_hdm *__wrap_devm_cxl_setup_hd
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_devm_cxl_setup_hdm, CXL);
 
-int __wrap_devm_cxl_enable_hdm(struct cxl_port *port, struct cxl_hdm *cxlhdm)
-{
-	int index, rc;
-	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
-
-	if (ops && ops->is_mock_port(port->uport))
-		rc = 0;
-	else
-		rc = devm_cxl_enable_hdm(port, cxlhdm);
-	put_cxl_mock_ops(index);
-
-	return rc;
-}
-EXPORT_SYMBOL_NS_GPL(__wrap_devm_cxl_enable_hdm, CXL);
-
 int __wrap_devm_cxl_add_passthrough_decoder(struct cxl_port *port)
 {
 	int rc, index;


