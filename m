Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5206A330B2D;
	Fri, 17 Oct 2025 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716489; cv=none; b=HFycLsTF57s9SWbtOzeUu3ztvfvUnFEsXsdA2Ccyv6IWpqM5iLUK+eF8yDHWK5D4vtt4THrRDIaG1x6ZEORHTvKUhdVDbdmwXGG7R3ehM89ZRpK0NIX+el8e+uTbsSoHdferZ/9lakJW49EQyuW7pVKxBx9rLf/akRJaxYg8gd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716489; c=relaxed/simple;
	bh=1kbba0VuBbsbjzZVnHjEwfu6fozR4O4laXdYvzoJDXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ+8g3236gBnyy8EQub/BS9+92KamQH2zFSrWIAM77KZ8ZAMpyDtjVxPvavWX7RWOW0m3S4JDYtg0n1/la5W23AECa4aCMcQ9rbkoTtCeQSPi3BWW6EwMuuINfH+UVpk0MHYAXiAekDSl33rfnu2Htr0lmlgS9BYE3zGPXW9yh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEIGDoAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEIGDoAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1069C4CEE7;
	Fri, 17 Oct 2025 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716489;
	bh=1kbba0VuBbsbjzZVnHjEwfu6fozR4O4laXdYvzoJDXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEIGDoAhzNdW480o3ULlD+o5xLERELYqi0zk/33LPcU2ZVNyxaMW+YwHArr14Rxdn
	 NxFrgI02ow0FG+BBxaE8jeCb0gtqXRM17CPXzSZuLZhX7cBUoWgJK++4jMuyiwt0+a
	 02VBtLzATK2UGMZjPF1anTY39plpJ/fLbKIo0HO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 207/276] PCI/ERR: Fix uevent on failure to recover
Date: Fri, 17 Oct 2025 16:55:00 +0200
Message-ID: <20251017145150.022359810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,6 +102,12 @@ static int report_normal_detected(struct
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
 	pci_ers_result_t vote, *result = data;
@@ -263,7 +269,7 @@ pci_ers_result_t pcie_do_recovery(struct
 failed:
 	pci_walk_bridge(bridge, pci_pm_runtime_put, NULL);
 
-	pci_uevent_ers(bridge, PCI_ERS_RESULT_DISCONNECT);
+	pci_walk_bridge(bridge, report_perm_failure_detected, NULL);
 
 	/* TODO: Should kernel panic here? */
 	pci_info(bridge, "device recovery failed\n");


