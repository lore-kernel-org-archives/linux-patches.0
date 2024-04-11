Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9214C5A0;
	Thu, 11 Apr 2024 10:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831653; cv=none; b=JaOksIRsFJXPkTByx0KHuStJdM09V7B77jPEjzAaY9wXuIDF5eI9amtT4kbOl5zAdAmS86elVlborK4ou4y+NbzbGPif0Xj9P2oDjNUvJ+Sx7oLmPrvInjSr80fyNeck+K+3WydQ6MzMy5cJqyDmcquwNCnROjbCW3oltSdHz/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831653; c=relaxed/simple;
	bh=EUrMJZMVbFAgZX8vudpMJECPtbSnSEPY4sl2L4DjVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ/VScI4GfRepZG2rHUsHxWfP9SmoPObzvf9u6linFG8aLhbrrJYHrrLY/i9KBe4EMsp2ibFEBcNFBCP6/HKCkKE8lYSPmNY5giANrRmOCPDQVYAD4ON68fdXlZLknebH786TC3xJ47GeoSk/RSDPYbx8wfasmMjj4uyRshhYJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+cTfHTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+cTfHTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D3C433F1;
	Thu, 11 Apr 2024 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831653;
	bh=EUrMJZMVbFAgZX8vudpMJECPtbSnSEPY4sl2L4DjVpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+cTfHTKqELyIk/AoGt0dPQ/y3G+/RZcnmQobQ3cfnLkcHNceDfnLOjjg2FXaYvOS
	 IlPNVzdZhvA/fzE4XuKHz9c8xh4LU3qOxAXAen+qfsRh85SImI8rW63YHB7aluUtq7
	 cGAtIh0cPFQDq2H6H1+34fLEz7zYRVOJWjg4ZFIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean V Kelley <sean.v.kelley@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/294] PCI/ERR: Clear AER status only when we control AER
Date: Thu, 11 Apr 2024 11:54:04 +0200
Message-ID: <20240411095438.124369801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit aa344bc8b727b47b4350b59d8166216a3f351e55 ]

In some cases a bridge may not exist as the hardware controlling may be
handled only by firmware and so is not visible to the OS. This scenario is
also possible in future use cases involving non-native use of RCECs by
firmware. In this scenario, we expect the platform to retain control of the
bridge and to clear error status itself.

Clear error status only when the OS has native control of AER.

Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 002bf2fbc00e ("PCI/AER: Block runtime suspend when handling errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 984aa023c753f..a806dfd94586c 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -176,6 +176,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	int type = pci_pcie_type(dev);
 	struct pci_dev *bridge;
 	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
+	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
 
 	/*
 	 * If the error was detected by a Root Port, Downstream Port, or
@@ -227,9 +228,17 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	pci_dbg(bridge, "broadcast resume message\n");
 	pci_walk_bridge(bridge, report_resume, &status);
 
-	if (pcie_aer_is_native(bridge))
+	/*
+	 * If we have native control of AER, clear error status in the Root
+	 * Port or Downstream Port that signaled the error.  If the
+	 * platform retained control of AER, it is responsible for clearing
+	 * this status.  In that case, the signaling device may not even be
+	 * visible to the OS.
+	 */
+	if (host->native_aer || pcie_ports_native) {
 		pcie_clear_device_status(bridge);
-	pci_aer_clear_nonfatal_status(bridge);
+		pci_aer_clear_nonfatal_status(bridge);
+	}
 	pci_info(bridge, "device recovery successful\n");
 	return status;
 
-- 
2.43.0



