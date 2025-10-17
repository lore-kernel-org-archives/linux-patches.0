Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB2C3BB5A;
	Fri, 17 Oct 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714629; cv=none; b=t7hKZy/4wQtRYuB6nIm8q3hkQ9iFhD1V0ap6fa9oiJtTzkFcolb2YLroC95fLJginEt/k9nNO9aPqFy7dFDe62WDxx5P9R3m7Uxaw+962JPRySd5xb/wzq/QQKP3xPZgRqiPwk76UFNWDIH4VbEx5OtxrVz8nCnHlo6T3DcXb9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714629; c=relaxed/simple;
	bh=lRO0xePK6/jYnGQ96tdhHYdI/3mapooaKB4NjaJPqdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYq7HqLFm/tQl3LLqqb7JPUPGZByLPFq/hkWE/Qpvlz5xHlpKBUMmccodcuO5ZHW4vALoZq2Kd7tdKsCiwJD2pje6C/d1/xpDgl2GkVpEHws+dHhUvzUCkpiFLp5gBepllZgSM8glc10HhW4d7jIPepwGULolze/kqy0s92CPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEksOA6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEksOA6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE34C4CEE7;
	Fri, 17 Oct 2025 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714628;
	bh=lRO0xePK6/jYnGQ96tdhHYdI/3mapooaKB4NjaJPqdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEksOA6kNQyA9ecVHohY3o+mu23BcGBFQBiRiX9imd7aj96RXyBsYY4x30cOc2tGs
	 wtjPJlMGjA2H6BG47FBIZz65Z2vdM8g8WMbkn9mG/mUrRILDwDAxW4O4yjUwvlhSn5
	 1Kmk6uIbJ6nO0xTJbbeVIQtF51jhJNWH1pFqLTHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 179/277] PCI/ERR: Fix uevent on failure to recover
Date: Fri, 17 Oct 2025 16:53:06 +0200
Message-ID: <20251017145153.663655982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 1cbc5e25fb70e942a7a735a1f3d6dd391afc9b29 upstream.

Upon failure to recover from a PCIe error through AER, DPC or EDR, a
uevent is sent to inform user space about disconnection of the bridge
whose subordinate devices failed to recover.

However the bridge itself is not disconnected.  Instead, a uevent should
be sent for each of the subordinate devices.

Only if the "bridge" happens to be a Root Complex Event Collector or
Integrated Endpoint does it make sense to send a uevent for it (because
there are no subordinate devices).

Right now if there is a mix of subordinate devices with and without
pci_error_handlers, a BEGIN_RECOVERY event is sent for those with
pci_error_handlers but no FAILED_RECOVERY event is ever sent for them
afterwards.  Fix it.

Fixes: 856e1eb9bdd4 ("PCI/AER: Add uevents in AER and EEH error/resume")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org  # v4.16+
Link: https://patch.msgid.link/68fc527a380821b5d861dd554d2ce42cb739591c.1755008151.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/err.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -108,6 +108,12 @@ static int report_normal_detected(struct
 	return report_error_detected(dev, pci_channel_io_normal, data);
 }
 
+static int report_perm_failure_detected(struct pci_dev *dev, void *data)
+{
+	pci_uevent_ers(dev, PCI_ERS_RESULT_DISCONNECT);
+	return 0;
+}
+
 static int report_mmio_enabled(struct pci_dev *dev, void *data)
 {
 	struct pci_driver *pdrv;
@@ -269,7 +275,7 @@ pci_ers_result_t pcie_do_recovery(struct
 failed:
 	pci_walk_bridge(bridge, pci_pm_runtime_put, NULL);
 
-	pci_uevent_ers(bridge, PCI_ERS_RESULT_DISCONNECT);
+	pci_walk_bridge(bridge, report_perm_failure_detected, NULL);
 
 	/* TODO: Should kernel panic here? */
 	pci_info(bridge, "device recovery failed\n");


