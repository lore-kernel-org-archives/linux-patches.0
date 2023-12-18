Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA8129EFB;
	Mon, 18 Dec 2023 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFyQfmxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3082BC433C8;
	Mon, 18 Dec 2023 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908160;
	bh=Z4dmaTdmDWsY9nietSOPQXWIoy/ikZKFGdorlM+yUPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFyQfmxJpSwJ2PQSWicb51DcK4T87G2DvmcwmY6YHmIWQBNIpzkYKv9aB1FEyIHRu
	 ZFLfjEOG+sAozDL64yXLjUztYZX4nrI3Wj0PRgYCB5eSCdccbkfR5t3lsZzkFiNJaB
	 YyK47kkGgPiJrIgwit+xRSxXtxWsEaE8xDslvU2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Michael Bottini <michael.a.bottini@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>
Subject: [PATCH 6.6 075/166] PCI/ASPM: Add pci_enable_link_state_locked()
Date: Mon, 18 Dec 2023 14:50:41 +0100
Message-ID: <20231218135108.402889951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 718ab8226636a1a3a7d281f5d6a7ad7c925efe5a upstream.

Add pci_enable_link_state_locked() for enabling link states that can be
used in contexts where a pci_bus_sem read lock is already held (e.g. from
pci_walk_bus()).

This helper will be used to fix a couple of potential deadlocks where
the current helper is called with the lock already held, hence the CC
stable tag.

Fixes: f492edb40b54 ("PCI: vmd: Add quirk to configure PCIe ASPM and LTR")
Link: https://lore.kernel.org/r/20231128081512.19387-2-johan+linaro@kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
[bhelgaas: include helper name in subject, commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org>	# 6.3
Cc: Michael Bottini <michael.a.bottini@linux.intel.com>
Cc: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c |   53 ++++++++++++++++++++++++++++++++++++------------
 include/linux/pci.h     |    3 ++
 2 files changed, 43 insertions(+), 13 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1102,17 +1102,7 @@ int pci_disable_link_state(struct pci_de
 }
 EXPORT_SYMBOL(pci_disable_link_state);
 
-/**
- * pci_enable_link_state - Clear and set the default device link state so that
- * the link may be allowed to enter the specified states. Note that if the
- * BIOS didn't grant ASPM control to the OS, this does nothing because we can't
- * touch the LNKCTL register. Also note that this does not enable states
- * disabled by pci_disable_link_state(). Return 0 or a negative errno.
- *
- * @pdev: PCI device
- * @state: Mask of ASPM link states to enable
- */
-int pci_enable_link_state(struct pci_dev *pdev, int state)
+static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked)
 {
 	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
 
@@ -1129,7 +1119,8 @@ int pci_enable_link_state(struct pci_dev
 		return -EPERM;
 	}
 
-	down_read(&pci_bus_sem);
+	if (!locked)
+		down_read(&pci_bus_sem);
 	mutex_lock(&aspm_lock);
 	link->aspm_default = 0;
 	if (state & PCIE_LINK_STATE_L0S)
@@ -1150,12 +1141,48 @@ int pci_enable_link_state(struct pci_dev
 	link->clkpm_default = (state & PCIE_LINK_STATE_CLKPM) ? 1 : 0;
 	pcie_set_clkpm(link, policy_to_clkpm_state(link));
 	mutex_unlock(&aspm_lock);
-	up_read(&pci_bus_sem);
+	if (!locked)
+		up_read(&pci_bus_sem);
 
 	return 0;
 }
+
+/**
+ * pci_enable_link_state - Clear and set the default device link state so that
+ * the link may be allowed to enter the specified states. Note that if the
+ * BIOS didn't grant ASPM control to the OS, this does nothing because we can't
+ * touch the LNKCTL register. Also note that this does not enable states
+ * disabled by pci_disable_link_state(). Return 0 or a negative errno.
+ *
+ * @pdev: PCI device
+ * @state: Mask of ASPM link states to enable
+ */
+int pci_enable_link_state(struct pci_dev *pdev, int state)
+{
+	return __pci_enable_link_state(pdev, state, false);
+}
 EXPORT_SYMBOL(pci_enable_link_state);
 
+/**
+ * pci_enable_link_state_locked - Clear and set the default device link state
+ * so that the link may be allowed to enter the specified states. Note that if
+ * the BIOS didn't grant ASPM control to the OS, this does nothing because we
+ * can't touch the LNKCTL register. Also note that this does not enable states
+ * disabled by pci_disable_link_state(). Return 0 or a negative errno.
+ *
+ * @pdev: PCI device
+ * @state: Mask of ASPM link states to enable
+ *
+ * Context: Caller holds pci_bus_sem read lock.
+ */
+int pci_enable_link_state_locked(struct pci_dev *pdev, int state)
+{
+	lockdep_assert_held_read(&pci_bus_sem);
+
+	return __pci_enable_link_state(pdev, state, true);
+}
+EXPORT_SYMBOL(pci_enable_link_state_locked);
+
 static int pcie_aspm_set_policy(const char *val,
 				const struct kernel_param *kp)
 {
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1803,6 +1803,7 @@ extern bool pcie_ports_native;
 int pci_disable_link_state(struct pci_dev *pdev, int state);
 int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 int pci_enable_link_state(struct pci_dev *pdev, int state);
+int pci_enable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 bool pcie_aspm_support_enabled(void);
 bool pcie_aspm_enabled(struct pci_dev *pdev);
@@ -1813,6 +1814,8 @@ static inline int pci_disable_link_state
 { return 0; }
 static inline int pci_enable_link_state(struct pci_dev *pdev, int state)
 { return 0; }
+static inline int pci_enable_link_state_locked(struct pci_dev *pdev, int state)
+{ return 0; }
 static inline void pcie_no_aspm(void) { }
 static inline bool pcie_aspm_support_enabled(void) { return false; }
 static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }


