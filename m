Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2F143895;
	Tue, 23 Apr 2024 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908626; cv=none; b=BAFSOIjgtWzM3UhgN11tLwVesUVdnpe5Mw99n7Jz+5DeGKFuyZZi2jt7gOQmKeBd+J3z+CheMZS5Y4TAKgLidjg9r9D+HvP1PRe9P2gXXQ9i5dgcB6JPyHd5NKNQ1p0Eb5CUGlZifQYJlAJrM8T/H9z7/Mp1nFDcSwBaDfE3JB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908626; c=relaxed/simple;
	bh=DHZ6taESmviAUZ3bPhMfWxneDSdFZcpHPfz5Hgge6/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juep2MhTDn2rP4nNhSiTcc1iXE2SW5LKtBmanQAFoy9cKoQHPXiwct3deHHu7HgQoYAeAcN3iOHEzghf4cuVjvLB8uuO+R/LGh51/1ff1bkstvLF15WLnWw4ML5H2Xq/j/cVjha1eqyNqa6p0OLrdwbWmiE9GhXNEphLaoaQONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu1Y2nD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu1Y2nD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD1C32782;
	Tue, 23 Apr 2024 21:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908626;
	bh=DHZ6taESmviAUZ3bPhMfWxneDSdFZcpHPfz5Hgge6/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu1Y2nD0rFLLOz6NtnQFY6Q5LIT9ml3MgtVkG27N0aQzX1OUzybU/YFJCfk6MW3ZH
	 OJtDNyKuhvUU0D6ixe6tycM3OnY6Q+Kti+J8Se892+Az18MyHnXG5p3TDuVeO8xTt+
	 4sqzcP4cl89SnQB+Ls/wg5SpOwIJQ6+j3tsJYgHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sanath S <Sanath.S@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 078/158] thunderbolt: Reset topology created by the boot firmware
Date: Tue, 23 Apr 2024 14:38:35 -0700
Message-ID: <20240423213858.303029885@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Sanath S <Sanath.S@amd.com>

commit 59a54c5f3dbde00b8ad30aef27fe35b1fe07bf5c upstream.

Boot firmware (typically BIOS) might have created tunnels of its own.
The tunnel configuration that it does might be sub-optimal. For instance
it may only support HBR2 monitors so the DisplayPort tunnels it created
may limit Linux graphics drivers. In addition there is an issue on some
AMD based systems where the BIOS does not allocate enough PCIe resources
for future topology extension. By resetting the USB4 topology the PCIe
links will be reset as well allowing Linux to re-allocate.

This aligns the behavior with Windows Connection Manager.

We already issued host router reset for USB4 v2 routers, now extend it
to USB4 v1 routers as well. For pre-USB4 (that's Apple systems) we leave
it as is and continue to discover the existing tunnels.

Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c |    5 +++--
 drivers/thunderbolt/icm.c    |    2 +-
 drivers/thunderbolt/nhi.c    |   19 +++++++++++++------
 drivers/thunderbolt/tb.c     |   26 +++++++++++++++++++-------
 drivers/thunderbolt/tb.h     |    4 ++--
 5 files changed, 38 insertions(+), 18 deletions(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -423,6 +423,7 @@ err_free:
 /**
  * tb_domain_add() - Add domain to the system
  * @tb: Domain to add
+ * @reset: Issue reset to the host router
  *
  * Starts the domain and adds it to the system. Hotplugging devices will
  * work after this has been returned successfully. In order to remove
@@ -431,7 +432,7 @@ err_free:
  *
  * Return: %0 in case of success and negative errno in case of error
  */
-int tb_domain_add(struct tb *tb)
+int tb_domain_add(struct tb *tb, bool reset)
 {
 	int ret;
 
@@ -460,7 +461,7 @@ int tb_domain_add(struct tb *tb)
 
 	/* Start the domain */
 	if (tb->cm_ops->start) {
-		ret = tb->cm_ops->start(tb);
+		ret = tb->cm_ops->start(tb, reset);
 		if (ret)
 			goto err_domain_del;
 	}
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2144,7 +2144,7 @@ static int icm_runtime_resume(struct tb
 	return 0;
 }
 
-static int icm_start(struct tb *tb)
+static int icm_start(struct tb *tb, bool not_used)
 {
 	struct icm *icm = tb_priv(tb);
 	int ret;
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1221,7 +1221,7 @@ static void nhi_check_iommu(struct tb_nh
 		str_enabled_disabled(port_ok));
 }
 
-static void nhi_reset(struct tb_nhi *nhi)
+static bool nhi_reset(struct tb_nhi *nhi)
 {
 	ktime_t timeout;
 	u32 val;
@@ -1229,11 +1229,11 @@ static void nhi_reset(struct tb_nhi *nhi
 	val = ioread32(nhi->iobase + REG_CAPS);
 	/* Reset only v2 and later routers */
 	if (FIELD_GET(REG_CAPS_VERSION_MASK, val) < REG_CAPS_VERSION_2)
-		return;
+		return false;
 
 	if (!host_reset) {
 		dev_dbg(&nhi->pdev->dev, "skipping host router reset\n");
-		return;
+		return false;
 	}
 
 	iowrite32(REG_RESET_HRR, nhi->iobase + REG_RESET);
@@ -1244,12 +1244,14 @@ static void nhi_reset(struct tb_nhi *nhi
 		val = ioread32(nhi->iobase + REG_RESET);
 		if (!(val & REG_RESET_HRR)) {
 			dev_warn(&nhi->pdev->dev, "host router reset successful\n");
-			return;
+			return true;
 		}
 		usleep_range(10, 20);
 	} while (ktime_before(ktime_get(), timeout));
 
 	dev_warn(&nhi->pdev->dev, "timeout resetting host router\n");
+
+	return false;
 }
 
 static int nhi_init_msi(struct tb_nhi *nhi)
@@ -1331,6 +1333,7 @@ static int nhi_probe(struct pci_dev *pde
 	struct device *dev = &pdev->dev;
 	struct tb_nhi *nhi;
 	struct tb *tb;
+	bool reset;
 	int res;
 
 	if (!nhi_imr_valid(pdev))
@@ -1365,7 +1368,11 @@ static int nhi_probe(struct pci_dev *pde
 	nhi_check_quirks(nhi);
 	nhi_check_iommu(nhi);
 
-	nhi_reset(nhi);
+	/*
+	 * Only USB4 v2 hosts support host reset so if we already did
+	 * that then don't do it again when the domain is initialized.
+	 */
+	reset = nhi_reset(nhi) ? false : host_reset;
 
 	res = nhi_init_msi(nhi);
 	if (res)
@@ -1392,7 +1399,7 @@ static int nhi_probe(struct pci_dev *pde
 
 	dev_dbg(dev, "NHI initialized, starting thunderbolt\n");
 
-	res = tb_domain_add(tb);
+	res = tb_domain_add(tb, reset);
 	if (res) {
 		/*
 		 * At this point the RX/TX rings might already have been
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2131,7 +2131,7 @@ static int tb_scan_finalize_switch(struc
 	return 0;
 }
 
-static int tb_start(struct tb *tb)
+static int tb_start(struct tb *tb, bool reset)
 {
 	struct tb_cm *tcm = tb_priv(tb);
 	int ret;
@@ -2172,12 +2172,24 @@ static int tb_start(struct tb *tb)
 	tb_switch_tmu_configure(tb->root_switch, TB_SWITCH_TMU_MODE_LOWRES);
 	/* Enable TMU if it is off */
 	tb_switch_tmu_enable(tb->root_switch);
-	/* Full scan to discover devices added before the driver was loaded. */
-	tb_scan_switch(tb->root_switch);
-	/* Find out tunnels created by the boot firmware */
-	tb_discover_tunnels(tb);
-	/* Add DP resources from the DP tunnels created by the boot firmware */
-	tb_discover_dp_resources(tb);
+
+	/*
+	 * Boot firmware might have created tunnels of its own. Since we
+	 * cannot be sure they are usable for us, tear them down and
+	 * reset the ports to handle it as new hotplug for USB4 v1
+	 * routers (for USB4 v2 and beyond we already do host reset).
+	 */
+	if (reset && usb4_switch_version(tb->root_switch) == 1) {
+		tb_switch_reset(tb->root_switch);
+	} else {
+		/* Full scan to discover devices added before the driver was loaded. */
+		tb_scan_switch(tb->root_switch);
+		/* Find out tunnels created by the boot firmware */
+		tb_discover_tunnels(tb);
+		/* Add DP resources from the DP tunnels created by the boot firmware */
+		tb_discover_dp_resources(tb);
+	}
+
 	/*
 	 * If the boot firmware did not create USB 3.x tunnels create them
 	 * now for the whole topology.
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -488,7 +488,7 @@ struct tb_path {
  */
 struct tb_cm_ops {
 	int (*driver_ready)(struct tb *tb);
-	int (*start)(struct tb *tb);
+	int (*start)(struct tb *tb, bool reset);
 	void (*stop)(struct tb *tb);
 	int (*suspend_noirq)(struct tb *tb);
 	int (*resume_noirq)(struct tb *tb);
@@ -735,7 +735,7 @@ int tb_xdomain_init(void);
 void tb_xdomain_exit(void);
 
 struct tb *tb_domain_alloc(struct tb_nhi *nhi, int timeout_msec, size_t privsize);
-int tb_domain_add(struct tb *tb);
+int tb_domain_add(struct tb *tb, bool reset);
 void tb_domain_remove(struct tb *tb);
 int tb_domain_suspend_noirq(struct tb *tb);
 int tb_domain_resume_noirq(struct tb *tb);


