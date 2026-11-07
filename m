Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062283;
	b=xL0U5Mbto1Hx1nMsldwo19AyZlLKYN4yE7uQElH0l9eF4FM7on4r5FZJNF0WyYDiTsbY
	 zN0k8yQ14hN8mM7pnj6EeYYbd3SRnKgnD8UQZj2fMq6z19b/50kw0te1oBSNCgoBWQWJO
	 r1+vNYrGfZ7/4CIu3fqdfDxkTMI0M7EDzZ2shy2sGXubTccoVmf8C9jonJ9aF8YzcKv2Z
	 AIhepnW6MFq2eRKovELGR6O/Kip5IWz+KxDG5TCiwmkjXVLikMWWkuAC00jwMXnY5DbgZ
	 4o8mbNajKBL6tXJNpLtyYqUSzAg6Z/ldqXXZKjxBsPDeQlJ9WsaPzgIkwugz70BPVFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlXUztag5g26ehDXoTVhFVbBketuVEqwxIWM8n4GX0o=;
	b=FjE+tw27xyJTNVuVOhxkmfAMXKcgwV0KprP3qSkXH90UwW/oVqSlRlWRtQgCVANhTZhV
	 U0f8W8D/+OM9jYIerrqgv4gSG+P+VUJmwwAjp0Swl3d6ARn5yMFaIpk80HO3arfuTQG90
	 RKzNavH2pc8utJNPbdiTHAHSt/UXEPLEA4LUSz3lnMZttL5vrqHxCdOBPXN8hdanObeq1
	 eXX6gqsPsENIA6vsJuQz2yOIBLrtsXqJ/UTVK5pvYoqJxZW5I3Mc4BXUTBNO5nD7FHkPm
	 /VEGwtUnUMwlw9rwnpD/T75ZO6JHzEG4flloDFKzusbqS7+OzJe80QGsofqrdDa/RvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mc222UD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E867606A335;
	Sat,  7 Nov 2026 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mc222UD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02421F0089F;
	Sat,  7 Nov 2026 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062283;
	bh=tlXUztag5g26ehDXoTVhFVbBketuVEqwxIWM8n4GX0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mc222UD4DU+gOedc0x+0KxwcDJ3bO0khWt3KffFC3aIO4es6CQR099Fc5NehfKWhu
	 TEjWVIs26ec6194yyrLd3n36t9rDc/8UIH/DVvgqN0Bdcn1HGGPHF2soUTf4n5q8jj
	 uXUCtKy51stoQ8z/8iPY0Cwee1A68nx2GSAowhuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 1222/1536] cxl: Account for link width in latency calculation
Date: Sat,  7 Nov 2026 08:53:58 -0500
Message-ID: <20261107135032.075159747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit db4503d4575cdd2fad7e8a13a8a8ffcbc86d152d ]

cxl_pci_get_latency() derives bandwidth from the per-lane speed returned
by pcie_link_speed_mbps(), ignoring the negotiated link width. This
overestimates the FlitLatency contribution for multi-lane links.
Sections 2.11.3 and 2.11.4 of the Intel CXL Memory Device Software Guide
describe the link bandwidth as the product of the negotiated speed and
width.

Replace pcie_link_speed_mbps() with pcie_link_bandwidth_mbps() and
migrate both CXL callers (the only users of the API). The new helper
obtains speed and width from a single Link Status read. The CXL
bandwidth calculation no longer needs a separate width read and
multiplication.

While at it, make error handling more robust by converting PCI config
read errors to negative errno values and checking for zero bandwidth
before calculating latency.

Fixes: 4d07a05397c8 ("cxl: Calculate and store PCI link latency for the downstream ports")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# pci/pci.c
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261009045452.1107921-3-den@valinux.co.jp
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 22 ++++++++--------------
 drivers/pci/pci.c      | 23 ++++++++++++++++++-----
 include/linux/pci.h    |  2 +-
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index caecc07665057..6a3f2fe772bef 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -677,8 +677,8 @@ long cxl_pci_get_latency(struct pci_dev *pdev)
 {
 	long bw;
 
-	bw = pcie_link_speed_mbps(pdev);
-	if (bw < 0)
+	bw = pcie_link_bandwidth_mbps(pdev);
+	if (bw <= 0)
 		return 0;
 	bw /= BITS_PER_BYTE;
 
@@ -716,18 +716,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_reset_detected, CXL);
 
 int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c)
 {
-	int speed, bw;
-	u16 lnksta;
-	u32 width;
-
-	speed = pcie_link_speed_mbps(pdev);
-	if (speed < 0)
-		return speed;
-	speed /= BITS_PER_BYTE;
-
-	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
-	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
-	bw = speed * width;
+	int bw;
+
+	bw = pcie_link_bandwidth_mbps(pdev);
+	if (bw < 0)
+		return bw;
+	bw /= BITS_PER_BYTE;
 
 	for (int i = 0; i < ACCESS_COORDINATE_MAX; i++) {
 		c[i].read_bandwidth = bw;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 296f28073ec56..2f575af94e094 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6077,18 +6077,31 @@ static enum pci_bus_speed to_pcie_link_speed(u16 lnksta)
 	return pcie_link_speed[FIELD_GET(PCI_EXP_LNKSTA_CLS, lnksta)];
 }
 
-int pcie_link_speed_mbps(struct pci_dev *pdev)
+/**
+ * pcie_link_bandwidth_mbps - get the current bandwidth of a single PCIe link
+ * @pdev: PCI device to query
+ *
+ * The bandwidth includes all negotiated lanes and does not account for
+ * encoding overhead. A negotiated width of zero gives zero bandwidth.
+ *
+ * Return: Bandwidth in Mb/s, or a negative errno on failure.
+ */
+int pcie_link_bandwidth_mbps(struct pci_dev *pdev)
 {
 	u16 lnksta;
-	int err;
+	int speed, err;
 
 	err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
 	if (err)
-		return err;
+		return pcibios_err_to_errno(err);
+
+	speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
+	if (speed < 0)
+		return speed;
 
-	return pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
+	return speed * FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
 }
-EXPORT_SYMBOL(pcie_link_speed_mbps);
+EXPORT_SYMBOL(pcie_link_bandwidth_mbps);
 
 /**
  * pcie_bandwidth_available - determine minimum link settings of a PCIe
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f3051fb5a5e84..c65de9e8aa8af 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1407,7 +1407,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
 u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
 			     enum pci_bus_speed *speed,
 			     enum pcie_link_width *width);
-int pcie_link_speed_mbps(struct pci_dev *pdev);
+int pcie_link_bandwidth_mbps(struct pci_dev *pdev);
 void pcie_print_link_status(struct pci_dev *dev);
 int pcie_reset_flr(struct pci_dev *dev, bool probe);
 int pcie_flr(struct pci_dev *dev);
-- 
2.53.0



