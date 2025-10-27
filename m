Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FC12868B0;
	Mon, 27 Oct 2025 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591416; cv=none; b=D66xc4WmLzsdwbhd1KgSSDDJB2inhv0JWufoAIoV9PkXLfDjbrgdQ0FD3Et11nefD3ItLNjEVtFMoCueOMDLLhm9JdTpyrYnCfXm6KKVTxpl5Iw+sHtnQRyL1LflIpMAml59FC7ZSBJwql3Qe6c81LicG0aRFZ8jcqCizwrPDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591416; c=relaxed/simple;
	bh=VRHBBkno3yjFhYFTqCgkgvBT+N1cIrtgvMtbxtmJ+0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B191g4tXhdIKsjkswfkeaQ0oy4eE4yGsV9ke13B01gYb59+k+S7fwETLUOaGFCWqgSI/Y2/Z9aR5KLOmW7OEFJFLHbkQojEBsxkm7AMrpQaIq1BPzxbqWkkTbOzbNXTjr6wIe1EXlUNdhoUl5N/Lq+ZZjLJFk5rqrwA2uWuPQnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbSppmCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbSppmCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8FC19424;
	Mon, 27 Oct 2025 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591415;
	bh=VRHBBkno3yjFhYFTqCgkgvBT+N1cIrtgvMtbxtmJ+0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbSppmCJLpZmgRi6uRuPwfhgE4QCdv5EtnYsJEtYM6J3w5JH2EfJmv90brv0yonKJ
	 EEZOO1K+b9v7+aBFKZq6siLmdZdyC5A3nAJey/Rfld60IOdolC6rhDwJVDCvfne44t
	 5ihXfB3fno+RK3NASjw185uVhXrYpw/Za5uin0Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 158/332] PCI/ERR: Fix uevent on failure to recover
Date: Mon, 27 Oct 2025 19:33:31 +0100
Message-ID: <20251027183528.800284362@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


